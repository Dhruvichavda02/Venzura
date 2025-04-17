import com.venzura.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateDecServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize = 1024 * 1024 * 2,       // 2MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class UpdateDecServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/decorations";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String removedImages = request.getParameter("removedImages");
        
        // Process images
        List<String> imagePaths = processImages(request, removedImages);
        String imagePathsString = String.join(",", imagePaths);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE decorations SET name=?, category=?, price=?, description=?, phone=?, location=?, image_paths=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, category);
            pstmt.setString(3, price);
            pstmt.setString(4, description);
            pstmt.setString(5, phone);
            pstmt.setString(6, location);
            pstmt.setString(7, imagePathsString.isEmpty() ? null : imagePathsString);
            pstmt.setInt(8, id);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("Admin/Decorators.jsp?success=true");
            } else {
                request.setAttribute("error", "Failed to update decoration");
                request.getRequestDispatcher("EditDecoration.jsp?id=" + id).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating decoration: " + e.getMessage());
            request.getRequestDispatcher("EditDecoration.jsp?id=" + id).forward(request, response);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    private List<String> processImages(HttpServletRequest request, String removedImages) 
            throws IOException, ServletException {
        
        // Get existing images from database (passed as hidden input)
        String[] currentImages = request.getParameterValues("currentImages");
        List<String> existingImages = new ArrayList<>();
        if (currentImages != null && currentImages.length > 0 && !currentImages[0].isEmpty()) {
            existingImages.addAll(Arrays.asList(currentImages[0].split(",")));
        }
        
        // Remove images marked for deletion
        if (removedImages != null && !removedImages.isEmpty()) {
            List<String> toRemove = Arrays.asList(removedImages.split(","));
            existingImages.removeIf(img -> toRemove.contains(img.trim()));
            
            // Delete the actual image files
            String appPath = request.getServletContext().getRealPath("");
            for (String imgPath : toRemove) {
                if (!imgPath.trim().isEmpty()) {
                    File imageFile = new File(appPath + File.separator + imgPath.trim());
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }
            }
        }
        
        // Handle new image uploads
        List<String> newImagePaths = new ArrayList<>();
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        for (Part filePart : request.getParts()) {
            if (filePart.getName().equals("images") && filePart.getSize() > 0) {
                // Validate file type
                if (!filePart.getContentType().startsWith("image/")) {
                    continue; // Skip non-image files
                }
                
                // Generate unique filename
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                
                // Save file
                filePart.write(uploadPath + File.separator + fileName);
                
                // Add to new image paths
                newImagePaths.add(UPLOAD_DIR + "/" + fileName);
            }
        }
        
        // Combine existing and new images
        List<String> allImages = new ArrayList<>();
        allImages.addAll(existingImages);
        allImages.addAll(newImagePaths);
        
        return allImages;
    }
}