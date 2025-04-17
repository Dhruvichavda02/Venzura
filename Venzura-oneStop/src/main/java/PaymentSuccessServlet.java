import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.venzura.utils.DBConnection;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            out.println("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }
        System.out.println("PaymentSuccessServlet invoked");

        String bookingIdStr = request.getParameter("bookingId");
        String paymentId = request.getParameter("paymentId");
        String amountStr = request.getParameter("amount");
        
        if (bookingIdStr == null || paymentId == null || amountStr == null) {
            out.println("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        Connection con = null;
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int amount = Integer.parseInt(amountStr);
            double amountInRupees = amount / 100.0;
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String paymentDate = sdf.format(new Date());
            
            con = DBConnection.getConnection();
            
            // Start transaction
            con.setAutoCommit(false);
            
            try {
                // Insert payment record - matches your column names
                String sql = "INSERT INTO payment (booking_id, user_id, amount_paid, payment_date) " +
                           "VALUES (?, ?, ?, ?)";
                
                try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, bookingId);
                    pstmt.setInt(2, userId);
                    pstmt.setDouble(3, amountInRupees);
                    pstmt.setString(4, paymentDate);
                    
                    
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected == 0) {
                        con.rollback();
                        out.println("{\"success\": false, \"message\": \"Failed to record payment\"}");
                        return;
                    }
                    
                    
                }
                
                
                // Commit transaction
                con.commit();
                out.println("{\"success\": true, \"message\": \"Payment recorded successfully\"}");
                
            } catch (SQLException e) {
                con.rollback();
                out.println("{\"success\": false, \"message\": \"Database error: " + e.getMessage().replace("\"", "'") + "\"}");
            }
            
        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"Invalid number format\"}");
        } catch (SQLException e) {
            out.println("{\"success\": false, \"message\": \"Database connection error: " + e.getMessage().replace("\"", "'") + "\"}");
        } catch (ClassNotFoundException e) {
            out.println("{\"success\": false, \"message\": \"System configuration error\"}");
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // Reset auto-commit
                    con.close();
                } catch (SQLException e) {
                    // Log error
                }
            }
            out.close();
        }
    }
}