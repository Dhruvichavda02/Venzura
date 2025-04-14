<%@ page import="java.sql.*" %>
<%@ page import="com.venzura.utils.DBConnection" %>

<%
    // Retrieve user_id from request or session
    String userId = request.getParameter("user_id");
    if (userId == null) {
        userId = (String) session.getAttribute("user_id");
    }

    // Debugging: Check if user_id is null
    if (userId == null || userId.isEmpty()) {
        request.setAttribute("error", "User ID is missing.");
    } else {
        // Handle form submission for profile update
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String city = request.getParameter("city");
            String role = request.getParameter("role");

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                         "UPDATE users SET name=?, email=?, phone=?, city=?, role=? WHERE user_id=?")) {

                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, city);
                pstmt.setString(5, role);
                pstmt.setString(6, userId);

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    request.setAttribute("message", "Profile updated successfully!");
                } else {
                    request.setAttribute("error", "Profile update failed.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred.");
            }
        }

        // Fetch user details
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT name, email, phone, city, role FROM users WHERE user_id = ?")) {

            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("userName", rs.getString("name"));
                    request.setAttribute("userEmail", rs.getString("email"));
                    request.setAttribute("userPhone", rs.getString("phone"));
                    request.setAttribute("userCity", rs.getString("city"));
                    request.setAttribute("userRole", rs.getString("role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Form Container */
        .form-container {
            max-width: 600px;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            margin-top: 100px;
            width: 90%;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            background-color: black;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn:hover {
            background-color: #333;
        }
    </style>
</head>
<body>

<%@ include file="Navbar.jsp" %>

<div class="form-container">
    <h2>Edit Profile</h2>

    <!-- Display Success/Error Message -->
    <% if (request.getAttribute("message") != null) { %>
        <script>
            Swal.fire("Success!", "<%= request.getAttribute("message") %>", "success")
                .then(() => window.location.href = "Role.jsp");
        </script>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        <script>
            Swal.fire("Error!", "<%= request.getAttribute("error") %>", "error");
        </script>
    <% } %>

    <!-- Update Profile Form -->
    <form action="EditRole.jsp" method="post" onsubmit="return validateForm(event)">
        <input type="hidden" name="user_id" value="<%= userId %>">

        <div class="form-group">
            <label>User Name:</label>
            <input type="text" name="name" value="<%= request.getAttribute("userName") %>" required>
        </div>

        <div class="form-group">
            <label>User Email:</label>
            <input type="email" name="email" value="<%= request.getAttribute("userEmail") %>" required>
        </div>

        <div class="form-group">
            <label>Phone Number:</label>
            <input type="number" name="phone" value="<%= request.getAttribute("userPhone") %>" required>
        </div>

        <div class="form-group">
            <label>City:</label>
            <input type="text" name="city" value="<%= request.getAttribute("userCity") %>" required>
        </div>

        <div class="form-group">
            <label>Role:</label>
            <select name="role">
                <option value="user" <%= "user".equals(request.getAttribute("userRole")) ? "selected" : "" %>>User</option>
                <option value="admin" <%= "admin".equals(request.getAttribute("userRole")) ? "selected" : "" %>>Admin</option>
            </select>
        </div>

        <button type="submit" class="btn">Update Profile</button>
    </form>
</div>

<script>
    function validateForm(event) {
        event.preventDefault(); // Prevent form submission

        let name = document.querySelector("input[name='name']").value.trim();
        let email = document.querySelector("input[name='email']").value.trim();
        let phone = document.querySelector("input[name='phone']").value.trim();
        let city = document.querySelector("input[name='city']").value.trim();
        let role = document.querySelector("select[name='role']").value;

        let nameRegex = /^[A-Za-z\s]{3,}$/;
        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        let phoneRegex = /^[0-9]{10}$/;
        let cityRegex = /^[A-Za-z\s]{2,}$/;

        if (!nameRegex.test(name)) return showAlert("Invalid Name!", "Name must be at least 3 letters long.");
        if (!emailRegex.test(email)) return showAlert("Invalid Email!", "Enter a valid email address.");
        if (!phoneRegex.test(phone)) return showAlert("Invalid Phone!", "Phone number must be exactly 10 digits.");
        if (!cityRegex.test(city)) return showAlert("Invalid City!", "City name must be at least 2 letters long.");

        event.target.submit();
    }

    function showAlert(title, text) {
        Swal.fire({ title, text, icon: "error", confirmButtonText: "OK" });
        return false;
    }
</script>

</body>
</html>
