import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;
import com.venzura.utils.DBConnection;

@WebServlet("/SaveCategoryItemServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,    // 2MB
                 maxFileSize = 1024 * 1024 * 10,         // 10MB
                 maxRequestSize = 1024 * 1024 * 50)      // 50MB
public class SaveCategoryItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Step 1: Read category_id and item_name
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            String itemName = request.getParameter("item_name");

            conn = DBConnection.getConnection();

            // Step 2: Fetch dynamic field names
            String fieldQuery = "SELECT field_name FROM category_fields WHERE category_id = ?";
            pst = conn.prepareStatement(fieldQuery);
            pst.setInt(1, categoryId);
            rs = pst.executeQuery();

            List<String> fieldNames = new ArrayList<>();
            while (rs.next()) {
                fieldNames.add(rs.getString("field_name"));
            }
            rs.close();
            pst.close();

            // Step 3: Build JSON from field values
            JSONObject fieldJson = new JSONObject();
            for (String field : fieldNames) {
                String value = request.getParameter(field);
                fieldJson.put(field, value != null ? value : "");
            }

            // Step 4: Handle file uploads
            List<String> uploadedFileNames = new ArrayList<>();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            for (Part part : request.getParts()) {
                if ("files".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String fullPath = uploadPath + File.separator + fileName;
                    part.write(fullPath);
                    uploadedFileNames.add(fileName);
                }
            }

            // Optionally store file names in JSON too
            fieldJson.put("uploaded_files", uploadedFileNames);

            // Step 5: Insert into database
            String insertQuery = "INSERT INTO category_items (category_id, item_name, field_values) VALUES (?, ?, ?)";
            pst = conn.prepareStatement(insertQuery);
            pst.setInt(1, categoryId);
            pst.setString(2, itemName);
            pst.setString(3, fieldJson.toString());

            int rowsInserted = pst.executeUpdate();

            if (rowsInserted > 0) {
                response.setContentType("text/html");
                response.getWriter().println("<script>alert('Item added successfully'); window.location.href='AddDec.jsp?category_id=" + categoryId + "';</script>");
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<script>alert('Failed to add item'); window.history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<script>alert('Exception: " + e.getMessage().replace("'", "\\'") + "'); window.history.back();</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pst != null) pst.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
