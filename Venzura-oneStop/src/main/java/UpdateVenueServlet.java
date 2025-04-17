import com.venzura.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateVenueServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 2,    // 2MB
    maxRequestSize = 1024 * 1024 * 5  // 5MB
)
public class UpdateVenueServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";
    private static final int MAX_IMAGE_SIZE = 2 * 1024 * 1024; // 2MB

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Initialize database objects
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Get form data with validation
            String venueId = validateRequiredField(request, "venue_id", "Venue ID is required");
            String name = validateRequiredField(request, "name", "Name is required");
            String capacity = validateRequiredField(request, "capacity", "Capacity is required");
            String location = validateRequiredField(request, "location", "Location is required");
            String contactPhone = validateRequiredField(request, "contact_phone", "Contact phone is required");
            String amenities = validateRequiredField(request, "amenities", "Amenities are required");
            String price = validateRequiredField(request, "price", "Price is required");
            String description = validateRequiredField(request, "description", "Description is required");
            
            // Validate numeric fields
            validateInteger(capacity, "Capacity must be a number between 10 and 10000", 10, 10000);
            validateDecimal(price, "Price must be at least 100", 100, null);
            
            // Validate phone format
            if (!contactPhone.matches("\\d{10,15}")) {
                throw new ServletException("Phone number must be 10-15 digits");
            }
            
            // Get database connection
            con = DBConnection.getConnection();
            
            // First verify venue exists
            String checkSql = "SELECT id, image_paths FROM venues WHERE id = ?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setString(1, venueId);
            rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                throw new ServletException("Venue not found with ID: " + venueId);
            }
            
            // Handle file upload if present
            String imagePath = rs.getString("image_paths"); // Keep existing if no new upload
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                // Validate image
                if (!filePart.getContentType().startsWith("image/")) {
                    throw new ServletException("Only image files are allowed");
                }
                
                if (filePart.getSize() > MAX_IMAGE_SIZE) {
                    throw new ServletException("Image size exceeds 2MB limit");
                }
                
                // Create upload directory if needed
                String appPath = request.getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                // Generate unique filename
                String fileName = System.currentTimeMillis() + "_" + 
                    filePart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9.-]", "_");
                
                // Save file
                filePart.write(uploadPath + File.separator + fileName);
                
                // Set new image path
                imagePath = UPLOAD_DIR + "/" + fileName;
            }
            
            // Prepare update statement
            String updateSql;
            if (imagePath != null) {
                updateSql = "UPDATE venues SET name=?, capacity=?, location=?, contact_phone=?, " +
                           "amenities=?, price=?, description=?, image_paths=? WHERE id=?";
                pstmt = con.prepareStatement(updateSql);
                pstmt.setString(1, name);
                pstmt.setInt(2, Integer.parseInt(capacity));
                pstmt.setString(3, location);
                pstmt.setString(4, contactPhone);
                pstmt.setString(5, amenities);
                pstmt.setDouble(6, Double.parseDouble(price));
                pstmt.setString(7, description);
                pstmt.setString(8, imagePath);
                pstmt.setString(9, venueId);
            } else {
                updateSql = "UPDATE venues SET name=?, capacity=?, location=?, contact_phone=?, " +
                          "amenities=?, price=?, description=? WHERE id=?";
                pstmt = con.prepareStatement(updateSql);
                pstmt.setString(1, name);
                pstmt.setInt(2, Integer.parseInt(capacity));
                pstmt.setString(3, location);
                pstmt.setString(4, contactPhone);
                pstmt.setString(5, amenities);
                pstmt.setDouble(6, Double.parseDouble(price));
                pstmt.setString(7, description);
                pstmt.setString(8, venueId);
            }
            
            // Execute update
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected <= 0) {
                throw new ServletException("No changes were made to the venue");
            }
            
            // Redirect to view page with success
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<html><head><script>");
            out.println("alert('Venue updated successfully!');");
            out.println("window.location.href='Admin/Venue.jsp?id=" + venueId + "';");
            out.println("</script></head><body></body></html>");

            
            
        } catch (Exception e) {
            // Forward back to edit page with error
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("EditVenue.jsp?id=" + request.getParameter("venue_id"))
                   .forward(request, response);
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
    
    private String validateRequiredField(HttpServletRequest request, String fieldName, String errorMessage) 
            throws ServletException {
        String value = request.getParameter(fieldName);
        if (value == null || value.trim().isEmpty()) {
            throw new ServletException(errorMessage);
        }
        return value.trim();
    }
    
    private void validateInteger(String value, String errorMessage, Integer min, Integer max) 
            throws ServletException {
        try {
            int num = Integer.parseInt(value);
            if (min != null && num < min) throw new ServletException(errorMessage);
            if (max != null && num > max) throw new ServletException(errorMessage);
        } catch (NumberFormatException e) {
            throw new ServletException(errorMessage);
        }
    }
    
    private void validateDecimal(String value, String errorMessage, double min, Double max) 
            throws ServletException {
        try {
            double num = Double.parseDouble(value);
            if (num < min) throw new ServletException(errorMessage);
            if (max != null && num > max) throw new ServletException(errorMessage);
        } catch (NumberFormatException e) {
            throw new ServletException(errorMessage);
        }
    }
}