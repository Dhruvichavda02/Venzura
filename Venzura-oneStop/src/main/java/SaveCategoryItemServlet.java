import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject; // Make sure this library is available
import com.venzura.utils.DBConnection;

@WebServlet("/SaveCategoryItemServlet")
public class SaveCategoryItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SaveCategoryItemServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Fetch dynamic field names
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

            String itemName = request.getParameter("item_name");

            // Build JSON string for field values
            JSONObject fieldJson = new JSONObject();
            for (String field : fieldNames) {
                String value = request.getParameter(field);
                fieldJson.put(field, value != null ? value : "");
            }
            int Price = Integer.parseInt(request.getParameter("price"));
            // Insert into category_items
            String insertQuery = "INSERT INTO category_items (category_id, item_name, field_values,price) VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(insertQuery);
            pst.setInt(1, categoryId);
            pst.setString(2, itemName);
            pst.setString(3, fieldJson.toString());
            pst.setInt(4, Price);
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
