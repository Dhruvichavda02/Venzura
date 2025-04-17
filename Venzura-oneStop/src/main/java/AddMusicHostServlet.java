import com.venzura.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AddMusicHost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize = 1024 * 1024 * 2,       // 2MB
    maxRequestSize = 1024 * 1024 * 5     // 5MB
)
public class AddMusicHostServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/music_hosts";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        double price = Double.parseDouble(request.getParameter("price"));
        int experienceYears = Integer.parseInt(request.getParameter("experience_years"));
        String genres = request.getParameter("genres");
        String contactPhone = request.getParameter("contact_phone");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        
        // Handle file upload
        String imagePath = null;
        Part filePart = request.getPart("image");
        
        if (filePart != null && filePart.getSize() > 0) {
            // Get application path
            String appPath = request.getServletContext().getRealPath("");
            
            // Create upload folder if not exists
            String uploadPath = appPath + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generate unique file name
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            
            // Save file
            filePart.write(uploadPath + File.separator + fileName);
            
            // Set relative path for database
            imagePath = UPLOAD_DIR + "/" + fileName;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO music_hosts (name, type, price, experience_years, genres, contact_phone, location, description, image_paths) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, type);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, experienceYears);
            pstmt.setString(5, genres);
            pstmt.setString(6, contactPhone);
            pstmt.setString(7, location);
            pstmt.setString(8, description);
            pstmt.setString(9, imagePath);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("Admin/MusicHosts.jsp?success=true");
            } else {
                request.setAttribute("error", "Failed to add music host");
                request.getRequestDispatcher("Admin/MusicHosts.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding music host: " + e.getMessage());
            request.getRequestDispatcher("Admin/MusicHosts.jsp").forward(request, response);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}