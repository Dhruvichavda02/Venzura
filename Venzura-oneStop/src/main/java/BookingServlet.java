import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import com.venzura.utils.DBConnection;
import java.util.logging.Logger;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(BookingServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Connection con = null;
        
        try {
            // 1. Validate session and get user ID
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId == null) {
                session.setAttribute("errorMessage", "Please login to make a booking");
                response.sendRedirect("../Login.jsp");
                return;
            }

            // 2. Get and validate all form parameters
            String name = validateParameter(request, "name", "Name is required");
            String email = validateParameter(request, "email", "Email is required");
            String phone = validateParameter(request, "phone", "Phone number is required");
            String startDateStr = validateParameter(request, "eventDate", "Start date is required");
            String endDateStr = validateParameter(request, "endDate", "End date is required");
            int noOfGuests = Integer.parseInt(validateParameter(request, "guests", "Number of guests is required"));
            
            // Optional parameters
            String venueIdParam = request.getParameter("venueId");
            String decorationIdParam = request.getParameter("decorationId");
            String musicHostIdParam = request.getParameter("musicHostId");

            // 3. Parse and validate dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);
            
            if (startDate.after(endDate)) {
                session.setAttribute("errorMessage", "End date must be after start date");
                response.sendRedirect("User/Booking.jsp");
                return;
            }

            // 4. Calculate number of days
            long diffInMillis = endDate.getTime() - startDate.getTime();
            int numberOfDays = (int) TimeUnit.DAYS.convert(diffInMillis, TimeUnit.MILLISECONDS) + 1;

            // 5. Database operations
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            try {
                // 6. Check availability if venue is selected
                if (venueIdParam != null && !venueIdParam.isEmpty()) {
                    int venueId = Integer.parseInt(venueIdParam);
                    if (!isAvailable(con, "venue_id", venueId, startDate, endDate)) {
                        session.setAttribute("errorMessage", "Venue is not available for the selected dates");
                        response.sendRedirect("User/VenueDetail.jsp?id=" + venueId);
                        return;
                    }
                }

                // 7. Calculate total amount
                double totalAmount = calculateTotalAmount(con, venueIdParam, decorationIdParam, musicHostIdParam, numberOfDays);

                // 8. Prepare and execute SQL insert
                String sql = "INSERT INTO vbookings (user_id, venue_id, decoration_id, music_host_id, "
                           + "start_date, end_date, booking_date, no_of_guests, amount, email, phone) "
                           + "VALUES (?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)";
                
                try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    // Set parameters
                    int paramIndex = 1;
                    pstmt.setInt(paramIndex++, userId);
                    setOptionalInt(pstmt, paramIndex++, venueIdParam);
                    setOptionalInt(pstmt, paramIndex++, decorationIdParam);
                    setOptionalInt(pstmt, paramIndex++, musicHostIdParam);
                    pstmt.setDate(paramIndex++, new java.sql.Date(startDate.getTime()));
                    pstmt.setDate(paramIndex++, new java.sql.Date(endDate.getTime()));
                    pstmt.setInt(paramIndex++, noOfGuests);
                    pstmt.setDouble(paramIndex++, totalAmount);
                    pstmt.setString(paramIndex++, email);
                    pstmt.setString(paramIndex++, phone);

                    // Execute insert
                    int affectedRows = pstmt.executeUpdate();
                    
                    if (affectedRows > 0) {
                        // Get generated booking ID
                        try (ResultSet rs = pstmt.getGeneratedKeys()) {
                            if (rs.next()) {
                                int bookingId = rs.getInt(1);
                                
                                // Set success attributes
                                session.setAttribute("bookingId", bookingId);
                                session.setAttribute("totalAmount", totalAmount);
                                session.setAttribute("startDate", startDateStr);
                                session.setAttribute("endDate", endDateStr);
                                session.setAttribute("successMessage", 
                                    "Booking successful! Your booking ID is: " + bookingId);
                                
                                logger.info("Booking created - ID: " + bookingId + " for user: " + userId);
                            }
                            response.sendRedirect("User/Payment.jsp");
                        }
                        con.commit(); // Commit transaction
                        
                        return;
                    }
                }
            } catch (SQLException e) {
                if (con != null) con.rollback(); // Rollback on error
                logger.severe("Database error during booking: " + e.getMessage());
                session.setAttribute("errorMessage", "Database error occurred. Please try again.");
                response.sendRedirect("User/Booking.jsp");
                return;
            }
        } catch (NumberFormatException e) {
            handleError(session, response, "Invalid number format: " + e.getMessage());
        } catch (ParseException e) {
            handleError(session, response, "Invalid date format: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            handleError(session, response, e.getMessage());
        } catch (Exception e) {
            handleError(session, response, "An unexpected error occurred. Please try again.");
            logger.severe("Unexpected error: " + e.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    logger.warning("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    // Helper method to validate required parameters
    private String validateParameter(HttpServletRequest request, String paramName, String errorMessage) 
            throws IllegalArgumentException {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(errorMessage);
        }
        return value.trim();
    }

    // Helper method to handle errors consistently
    private void handleError(HttpSession session, HttpServletResponse response, String errorMessage) 
            throws IOException {
        session.setAttribute("errorMessage", errorMessage);
        response.sendRedirect("User/Booking.jsp");
    }

    // Calculate total booking amount
    private double calculateTotalAmount(Connection con, String venueIdParam, 
            String decorationIdParam, String musicHostIdParam, int numberOfDays) throws SQLException {
        double totalAmount = 0.0;
        
        if (venueIdParam != null && !venueIdParam.isEmpty()) {
            totalAmount += getDailyPrice(con, "venues", Integer.parseInt(venueIdParam)) * numberOfDays;
        }
        if (decorationIdParam != null && !decorationIdParam.isEmpty()) {
            totalAmount += getDailyPrice(con, "decorations", Integer.parseInt(decorationIdParam)) * numberOfDays;
        }
        if (musicHostIdParam != null && !musicHostIdParam.isEmpty()) {
            totalAmount += getDailyPrice(con, "music_hosts", Integer.parseInt(musicHostIdParam)) * numberOfDays;
        }
        
        return totalAmount;
    }
    
    // Get daily price from database
    private double getDailyPrice(Connection con, String table, int id) throws SQLException {
        String sql = "SELECT price FROM " + table + " WHERE id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("price");
                }
            }
        }
        throw new SQLException("No price found for ID " + id + " in table " + table);
    }

    // Check availability of a resource
    private boolean isAvailable(Connection con, String column, int id, Date startDate, Date endDate) 
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM vbookings WHERE " + column + " = ? " +
                   "AND ((start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?) " +
                   "OR (? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date))";
        
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setDate(2, new java.sql.Date(startDate.getTime()));
            pstmt.setDate(3, new java.sql.Date(endDate.getTime()));
            pstmt.setDate(4, new java.sql.Date(startDate.getTime()));
            pstmt.setDate(5, new java.sql.Date(endDate.getTime()));
            pstmt.setDate(6, new java.sql.Date(startDate.getTime()));
            pstmt.setDate(7, new java.sql.Date(endDate.getTime()));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) == 0;
            }
        }
    }
    
    // Helper method to set optional integer parameters
    private void setOptionalInt(PreparedStatement pstmt, int index, String value) throws SQLException {
        if (value != null && !value.isEmpty()) {
            pstmt.setInt(index, Integer.parseInt(value));
        } else {
            pstmt.setNull(index, Types.INTEGER);
        }
    }
}