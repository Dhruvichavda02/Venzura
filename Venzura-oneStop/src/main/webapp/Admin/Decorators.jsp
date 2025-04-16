<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 0;
            margin: 0;
            display: flex;
        }

        .add-role-btn {
            background-color: black;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #343a40;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            transition: 0.3s;
            padding-top: 60px;
        }

        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            display: block;
            color: white;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        /* Content Wrapper */
        .content {
            margin-left: 250px; /* Default margin for visible sidebar */
            transition: margin-left 0.3s;
            padding: 20px;
            width: 100%;
        }

        .table-container {
            width: 100%;
            max-width: 1200px;
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #f1f1f1;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            font-weight: bold;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .edit-btn, .del-btn {
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 14px;
            color: white;
        }

        .edit-btn {
            background-color: #6c8c7d;
        }

        .del-btn {
            background-color: #d9534f;
        }

        .edit-btn:hover {
            background-color: #5a7b6c;
        }

        .del-btn:hover {
            background-color: #c9302c;
        }

        /* Hide Sidebar */
        .sidebar.hidden {
            width: 0;
            overflow: hidden;
        }

        .content.full-width {
            margin-left: 0;
        }

        /* Responsive */
        @media screen and (max-width: 768px) {
            .sidebar {
                width: 0;
                overflow: hidden;
            }

            .content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<%@ include file="Navbar.jsp" %>

<div class="content" id="content">
    <button class="btn add-role-btn" onclick="window.location.href='AddDecorators.jsp'">Add Decorator</button>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Location</th>
                    <th>Price</th>
                    <th>Phone</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Fetching data from the database and displaying it dynamically
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();
                        String query = "SELECT * FROM decorations"; // Your table name here
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();

                        int count = 1;
                        while (rs.next()) {
                            String name = rs.getString("name");
                            String location = rs.getString("location");
                            String price = rs.getString("price");
                            String phone = rs.getString("phone");
                            int id = rs.getInt("id");  // Assuming 'id' is the primary key
                %>
                    <tr>
                        <td data-label="#"> <%= count++ %> </td>
                        <td data-label="Name"><strong><%= name %></strong><br></td>
                        <td data-label="Location"><%= location %></td>
                        <td data-label="Price"><%= price %></td>
                        <td data-label="Phone"><%= phone %></td>
                        <td data-label="Edit"><button class="edit-btn" onclick="window.location.href='EditDecorators.jsp?id=<%= id %>'">Edit</button></td>
                        <td data-label="Delete">
                            <!-- Form for Delete button -->
                            <form action="Decorators.jsp" method="POST" onsubmit="return confirm('Are you sure you want to delete this decorator?')">
                                <input type="hidden" name="deleteId" value="<%= id %>" />
                                <button type="submit" class="del-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<% 
    // Deletion logic: Check if the deleteId parameter is available (from the form submission)
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null && !deleteId.isEmpty()) {
       
        
        try {
            conn = DBConnection.getConnection();
            String deleteQuery = "DELETE FROM decorations WHERE id = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(deleteId));

            // Execute the delete operation
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                out.println("<script>alert('Record deleted successfully');</script>");
                response.sendRedirect("Decorators.jsp");  // Redirect to the same page after deletion
            } else {
                out.println("<script>alert('Error deleting record.');</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
