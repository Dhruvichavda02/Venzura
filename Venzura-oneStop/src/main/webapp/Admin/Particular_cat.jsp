<%@ page import="java.sql.*" %>
<%@ page import="com.venzura.utils.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Venzura</title>
</head>
<body>

<%@ include file="Navbar.jsp" %>

<%
    String categoryId = request.getParameter("category_id");
    String categoryName = "Category";



    try {
        conn = DBConnection.getConnection();

        // Get category name
        String getCategoryQuery = "SELECT name FROM categories WHERE category_id = ?";
        pstmt = conn.prepareStatement(getCategoryQuery);
        pstmt.setInt(1, Integer.parseInt(categoryId));
        rs = pstmt.executeQuery();
        if (rs.next()) {
            categoryName = rs.getString("name");
        }
        rs.close();
        pstmt.close();

        // Get all field names for this category from category_fields table
        List<String> fieldKeys = new ArrayList<>();
        String getFieldNamesQuery = "SELECT field_name FROM category_fields WHERE category_id = ? ORDER BY field_id ASC";
        pstmt = conn.prepareStatement(getFieldNamesQuery);
        pstmt.setInt(1, Integer.parseInt(categoryId));
        rs = pstmt.executeQuery();
        while (rs.next()) {
            fieldKeys.add(rs.getString("field_name"));
        }
        rs.close();
        pstmt.close();
%>

<div class="content">
    <button class="btn add-role-btn" onclick="window.location.href='AddDec.jsp?category_id=<%= categoryId %>'">
        Add <%= categoryName %>
    </button>

    <div class="table-container">
        <table border="1" cellpadding="8" cellspacing="0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Item Name</th>
                    <% for (String a : fieldKeys) { %>
                        <th><%= a %></th>
                    <% } %>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
<%
        // Fetch item details
        String getItemsQuery = "SELECT item_id, item_name, price, field_values FROM category_items WHERE category_id = ?";
        pstmt = conn.prepareStatement(getItemsQuery);
        pstmt.setInt(1, Integer.parseInt(categoryId));
        rs = pstmt.executeQuery();

        int count = 1;
        while (rs.next()) {
            int itemId = rs.getInt("item_id");
            String itemName = rs.getString("item_name");
            String price = rs.getString("price");
            String json = rs.getString("field_values");

            JSONObject obj = new JSONObject(json);
%>
                <tr>
                    <td><%= count++ %></td>
                    <td><strong><%= itemName %></strong></td>
                    <% for (String key : fieldKeys) { %>
                        <td><%= obj.optString(key, "-") %></td>
                    <% } %>
                    <td><%= price %></td>
                    <td>
                        <a href="EditDec.jsp?item_id=<%= itemId %>&category_id=<%= categoryId %>">Edit</a> |
                        <a href="DeleteDec.jsp?item_id=<%= itemId %>&category_id=<%= categoryId %>" onclick="return confirm('Are you sure you want to delete this item?');">Delete</a>
                    </td>
                </tr>
<%
        }

        rs.close();
        pstmt.close();
        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException ignore) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException ignore) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
    }
%>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
