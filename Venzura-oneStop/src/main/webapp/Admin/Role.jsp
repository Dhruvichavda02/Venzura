<%@ page import="java.sql.*" %>
<%@ page import="com.venzura.utils.DBConnection" %> <!-- Adjust package as needed -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Handle DELETE request at the top of the page before HTML
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String deleteId = request.getParameter("delete_id");

        if (deleteId != null && !deleteId.isEmpty()) {
            Connection con = null;
            PreparedStatement ps = null;
            try {
                int userId = Integer.parseInt(deleteId);
                con = DBConnection.getConnection();
                String query = "DELETE FROM users WHERE user_id=?";
                ps = con.prepareStatement(query);
                ps.setInt(1, userId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    out.print("User deleted successfully!");
                } else {
                    out.print("User not found or could not be deleted.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("Error: " + e.getMessage());
            } finally {
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        } else {
            out.print("Invalid delete request.");
        }
        return; // Prevents further page execution after delete request
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #343a40;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 60px;
        }
        .sidebar a {
            padding: 10px 15px;
            display: block;
            color: white;
            text-decoration: none;
        }
        .sidebar a:hover {
            background-color: #495057;
        }
        .content {
            margin-left: 250px;
            padding: 20px;
            width: 100%;
        }
        .btn {
            background-color: black;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn:hover {
            background-color: #333;
        }
        .table-container {
            width: 100%;
            max-width: 1000px;
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }
        thead {
            background-color: #f1f1f1;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
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
        .del-btn:hover {
            background-color: #c9302c;
        }
          /* Filter Popup */
        .filter-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            z-index: 10;
        }

        .filter-popup h3 {
            margin-top: 0;
        }

        .filter-popup label {
            display: block;
            margin: 5px 0;
        }

        .popup-buttons {
            margin-top: 10px;
            text-align: right;
        }

        .popup-buttons button {
            background-color: black;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        .popup-buttons button:hover {
            background-color: #333;
        }

        /* Overlay */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: 5;
        }
    </style>
    
</head>
<body>

    <%@ include file="Navbar.jsp" %>

    <div class="content">
        
        <div class="top-buttons">
              <button class="btn" onclick="toggleFilterPopup()">Filter</button>
            <button class="btn" onclick="window.location.href='AddRole.jsp'">Add Role</button>
        </div>
           <!-- Filter Popup -->
        <div class="overlay" id="overlay" onclick="toggleFilterPopup()"></div>
        <div class="filter-popup" id="filterPopup">
            <h3>Filter by Role</h3>
            <label><input type="radio" name="roleFilter" value="user"> User</label>
            <label><input type="radio" name="roleFilter" value="admin"> Admin</label>
            <label><input type="radio" name="roleFilter" value="both"> Display All</label>
            <div class="popup-buttons">
                <button onclick="applyFilter()">Filter</button>
                <button onclick="toggleFilterPopup()">Close</button>
            </div>
        </div>

        <div class="table-container">
            <table id="userTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Password</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            con = DBConnection.getConnection();
                            String query = "SELECT user_id, name, email, phone, password, role FROM users";
                            ps = con.prepareStatement(query);
                            rs = ps.executeQuery();
                            int count = 1;
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("password") %></td>
                        <td><%= rs.getString("phone") %></td>
                        <td><%= rs.getString("role") %></td>
                        <td><button class="edit-btn" onclick="window.location.href='EditRole.jsp?user_id=<%= rs.getInt("user_id") %>'">Edit</button></td>
                        <td><button class="del-btn" onclick="confirmDelete(<%= rs.getInt("user_id") %>)">Del</button></td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
    function toggleFilterPopup() {
        let popup = document.getElementById("filterPopup");
        let overlay = document.getElementById("overlay");
        popup.style.display = popup.style.display === "block" ? "none" : "block";
        overlay.style.display = overlay.style.display === "block" ? "none" : "block";
    }

    function applyFilter() {
        let selectedRole = document.querySelector('input[name="roleFilter"]:checked'); 
        if (!selectedRole) return;
        
        let role = selectedRole.value; // Get the selected role ("admin", "user", or "both")
        
        document.querySelectorAll("#userTable tbody tr").forEach(row => {
            let rowRole = row.children[5].textContent.trim(); // Get the role in the table row

            // Show all rows if "both" is selected, otherwise filter by role
            row.style.display = (role === "both" || rowRole === role) ? "" : "none";
        });
        
        
      

        toggleFilterPopup(); // Close the filter popup if needed
    }


    
        function confirmDelete(userId) {
            if (confirm("Are you sure you want to delete this entry?")) {
                let xhr = new XMLHttpRequest();
                xhr.open("POST", window.location.href, true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {
                        if (xhr.status == 200) {
                            alert(xhr.responseText.trim()); // Show success or error message
                            location.reload(); // Reload table after deletion
                        } else {
                            alert("Error deleting user. Try again.");
                        }
                    }
                };

                // Ensure delete_id is sent properly
                let params = "delete_id=" + encodeURIComponent(userId);
                xhr.send(params);
            }
        }
    </script>

</body>
</html>
