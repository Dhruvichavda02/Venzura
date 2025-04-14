<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.venzura.utils.DBConnection" %>
<%@ page import="java.util.*" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String itemId = request.getParameter("item_id");
    JSONObject fieldValues = new JSONObject();
    Map<String, String> fieldTypes = new HashMap<>();
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if (isPost && itemId != null) {
        JSONObject updatedJson = new JSONObject();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String key = paramNames.nextElement();
            if (!key.equals("submit")) {
                updatedJson.put(key, request.getParameter(key));
            }
        }

        try {
            conn = DBConnection.getConnection();
            String updateQuery = "UPDATE category_items SET field_values = ? WHERE item_id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, updatedJson.toString());
            pstmt.setInt(2, Integer.parseInt(itemId));
            pstmt.executeUpdate();
            fieldValues = updatedJson;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException ignore) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
        }
    } else if (itemId != null) {
        try {
            conn = DBConnection.getConnection();

            // Step 1: Get field_values + category_id
            String itemQuery = "SELECT category_id, field_values FROM category_items WHERE item_id = ?";
            pstmt = conn.prepareStatement(itemQuery);
            pstmt.setInt(1, Integer.parseInt(itemId));
            rs = pstmt.executeQuery();

            int categoryId = 0;
            if (rs.next()) {
                fieldValues = new JSONObject(rs.getString("field_values"));
                categoryId = rs.getInt("category_id");
            }
            rs.close();
            pstmt.close();

            // Step 2: Get field types for that category
            String fieldTypeQuery = "SELECT field_name, field_type FROM category_fields WHERE category_id = ?";
            pstmt = conn.prepareStatement(fieldTypeQuery);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                fieldTypes.put(rs.getString("field_name"), rs.getString("field_type"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignore) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException ignore) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Fields</title>
    <style>
        body { font-family: Arial; background-color: #f4f4f4; padding: 30px; }
        .form-container { background: white; max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; }
        .form-group { margin-bottom: 15px; }
        label { font-weight: bold; display: block; margin-bottom: 5px; }
        input, textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        textarea { resize: none; height: 100px; }
        button { background: black; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        img { max-width: 100%; height: auto; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Edit Fields</h2>
   <form method="post" enctype="multipart/form-data">

        <%
            Iterator<String> keys = fieldValues.keys();
            while (keys.hasNext()) {
                String key = keys.next();

                if (key.equalsIgnoreCase("category_id") || key.equalsIgnoreCase("item_id")) {
                    continue;
                }

                String value = fieldValues.optString(key);
                String fieldType = fieldTypes.getOrDefault(key, "");

        %>
        <div class="form-group">
            <label><%= key %>:</label>

            <% if ("file".equalsIgnoreCase(fieldType)) { %>
                <img src="<%= value %>" alt="Image for <%= key %>">
                <input type="text" name="<%= key %>" value="<%= value %>">
            <% } else if (key.equalsIgnoreCase("policy") || key.equalsIgnoreCase("experience")) { %>
                <textarea name="<%= key %>"><%= value %></textarea>
            <% } else { %>
                <input type="text" name="<%= key %>" value="<%= value %>">
            <% } %>
        </div>
        <% } %>

        <button type="submit" name="submit">Update</button>
    </form>
</div>

</body>
</html>
