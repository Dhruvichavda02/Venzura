<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.venzura.utils.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            margin: auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        textarea {
            height: 100px;
            resize: none;
        }
        .btn {
            background-color: black;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<%
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    int categoryId = Integer.parseInt(request.getParameter("category_id"));
    List<Map<String, String>> fields = new ArrayList<>();

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT field_name, field_type FROM category_fields WHERE category_id = ?";
        pst = conn.prepareStatement(query);
        pst.setInt(1, categoryId);
        rs = pst.executeQuery();

        while (rs.next()) {
            Map<String, String> field = new HashMap<>();
            field.put("name", rs.getString("field_name"));
            field.put("type", rs.getString("field_type"));
            fields.add(field);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pst != null) try { pst.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<div class="container">
    <h2>Add Item to Category <%= categoryId %></h2>
    <form action="../SaveCategoryItemServlet" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="category_id" value="<%= categoryId %>">
        <div class="form-group">
            <label>Name of Organization:</label>
            <input type="text" name="item_name" required>
        </div>

        <% for (Map<String, String> field : fields) { %>
            <div class="form-group">
                <label><%= field.get("name") %>:</label>
                <% if ("textarea".equalsIgnoreCase(field.get("type"))) { %>
                    <textarea name="<%= field.get("name") %>"></textarea>
                <% } else { %>
                    <input type="<%= field.get("type") %>" name="<%= field.get("name") %>">
                <% } %>
            </div>
            
        <% } %>
        

        <button type="submit" class="btn">Save Item</button>
    </form>
</div>

</body>
</html>
