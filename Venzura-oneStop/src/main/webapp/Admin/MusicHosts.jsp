<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Music Hosts</title>
    <style>
        /* Use similar styles as your Venue.jsp */
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
        .add-btn{
          border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 14px;
            color: white;
             background-color: black;
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
    </style>
</head>
<body>
    <%@ include file="Navbar.jsp" %>

    <div class="content" id="content">
        <button class="add-btn" onclick="window.location.href='AddMusic.jsp'">Add Music Host</button>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th>Experience</th>
                        <th>Genres</th>
                        <th>Contact</th>
                        <th>Location</th>
                        <th>Edit</th>
                         <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        // Handle delete if deleteId parameter exists
                        String deleteId = request.getParameter("deleteId");
                        if (deleteId != null) {
                            Connection deleteConn = null;
                            PreparedStatement deleteStmt = null;
                            try {
                                deleteConn = DBConnection.getConnection();
                                String deleteQuery = "DELETE FROM music_hosts WHERE id = ?";
                                deleteStmt = deleteConn.prepareStatement(deleteQuery);
                                deleteStmt.setInt(1, Integer.parseInt(deleteId));
                                deleteStmt.executeUpdate();
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                try { if (deleteStmt != null) deleteStmt.close(); } catch (Exception e) {}
                                try { if (deleteConn != null) deleteConn.close(); } catch (Exception e) {}
                            }
                        }

                        try {
                            conn = DBConnection.getConnection();
                            stmt = conn.createStatement();
                            String query = "SELECT * FROM music_hosts";
                            rs = stmt.executeQuery(query);

                            int index = 1;
                            while (rs.next()) {
                    %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td><strong><%= rs.getString("name") %></strong></td>
                                    <td><%= rs.getString("type") %></td>
                                    <td><%= rs.getDouble("price") %></td>
                                    <td><%= rs.getInt("experience_years") %> years</td>
                                    <td><%= rs.getString("genres") %></td>
                                    <td><%= rs.getString("contact_phone") %></td>
                                    <td><%= rs.getString("location") %></td>
                                    <td>
                                        <button class="edit-btn" onclick="window.location.href='EditMusicHost.jsp?id=<%= rs.getInt("id") %>'">Edit</button>
                                        
                                    </td>
                                    <td>
                                    <form method="post" action="MusicHosts.jsp" style="display:inline;">
                                            <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>">
                                            <button type="submit" class="del-btn" onclick="return confirm('Are you sure?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
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
</body>
</html>