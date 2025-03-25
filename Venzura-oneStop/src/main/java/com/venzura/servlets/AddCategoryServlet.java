package com.venzura.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.json.JSONArray;
import org.json.JSONObject;
import com.venzura.utils.DBConnection;  // Import DBConnection utility

@WebServlet("/addCategory")
public class AddCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        request.setCharacterEncoding("UTF-8");

        // Read JSON data from request body
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonData = sb.toString();

        try (Connection connection = DBConnection.getConnection()) {  // Use DBConnection utility
            JSONObject jsonObject = new JSONObject(jsonData);
            String categoryName = jsonObject.getString("categoryName");
            JSONArray fieldsArray = jsonObject.getJSONArray("fields");

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

            // Insert Fields
            String fieldQuery = "INSERT INTO category_fields (category_id, field_name, field_type) VALUES (?, ?, ?)";
            try (PreparedStatement fieldStmt = connection.prepareStatement(fieldQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                for (int i = 0; i < fieldsArray.length(); i++) {
                    JSONObject field = fieldsArray.getJSONObject(i);
                    String fieldName = field.getString("name");
                    String fieldType = field.getString("type");
                    fieldStmt.setInt(1, categoryId);
                    fieldStmt.setString(2, fieldName);
                    fieldStmt.setString(3, fieldType);
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
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    }
}
