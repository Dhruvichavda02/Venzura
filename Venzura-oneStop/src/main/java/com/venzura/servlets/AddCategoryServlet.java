package com.venzura.servlets;
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
import org.json.JSONArray;
import org.json.JSONObject;
import com.venzura.utils.DBConnection;

@WebServlet("/addCategory")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "category_images"; // Folder name for uploaded images

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        request.setCharacterEncoding("UTF-8");

        // Get upload folder path
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        try (Connection connection = DBConnection.getConnection()) {
            String categoryName = request.getParameter("categoryName");
            JSONArray fieldsArray = new JSONArray(request.getParameter("fields"));

            // Insert Category
            int categoryId = -1;
            String categoryQuery = "INSERT INTO categories (name) VALUES (?)";
            try (PreparedStatement categoryStmt = connection.prepareStatement(categoryQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                categoryStmt.setString(1, categoryName);
                categoryStmt.executeUpdate();
                ResultSet generatedKeys = categoryStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    categoryId = generatedKeys.getInt(1);
                }
            }

            // Handle image uploads before inserting fields
            String imagePath = "";
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    imagePath = UPLOAD_DIR + File.separator + fileName; // Store file path
                    part.write(uploadPath + File.separator + fileName); // Save image
                }
            }

            // Insert Fields
            String fieldQuery = "INSERT INTO category_fields (category_id, field_name, field_type, Image_url) VALUES (?, ?, ?, ?)";
            try (PreparedStatement fieldStmt = connection.prepareStatement(fieldQuery)) {
                for (int i = 0; i < fieldsArray.length(); i++) {
                    JSONObject field = fieldsArray.getJSONObject(i);
                    String fieldName = field.getString("name");
                    String fieldType = field.getString("type");

                    fieldStmt.setInt(1, categoryId);
                    fieldStmt.setString(2, fieldName);
                    fieldStmt.setString(3, fieldType);
                    fieldStmt.setString(4, imagePath); // Save image path
                    fieldStmt.executeUpdate();

                    // If field is a dropdown, insert dropdown values
                    if (fieldType.equals("dropdown")) {
                        ResultSet fieldKeys = fieldStmt.getGeneratedKeys();
                        if (fieldKeys.next()) {
                            int fieldId = fieldKeys.getInt(1);
                            JSONArray options = field.getJSONArray("options");
                            String itemQuery = "INSERT INTO category_items (field_id, option_value) VALUES (?, ?)";
                            try (PreparedStatement itemStmt = connection.prepareStatement(itemQuery)) {
                                for (int j = 0; j < options.length(); j++) {
                                    itemStmt.setInt(1, fieldId);
                                    itemStmt.setString(2, options.getString(j));
                                    itemStmt.executeUpdate();
                                }
                            }
                        }
                    }
                }
            }

            response.getWriter().write("{\"success\": true, \"message\": \"Category added successfully\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Database error\"}");
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Database connection error\"}");
        }
    }
}
