<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*, com.venzura.utils.DBConnection" %>
<%@ page session="true" %>

<%
// Handle logout logic first
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("logout") != null) {
    session.invalidate(); // End the session
    response.sendRedirect("../Login.jsp"); // Redirect to login
    return;
}

// Check login
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect("../Login.jsp");
    return;
}

String name = "", email = "", mobile = "";
try {
    Connection conn = DBConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE user_id = ?");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        name = rs.getString("name");
        email = rs.getString("email");
        mobile = rs.getString("mobile");
    }

    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Same CSS styles as before */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .profile-page {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: black;
        }
        .profile-container {
            background-color: white;
            width: 90%;
            max-width: 600px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .profile-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .profile-header h2 {
            margin: 0;
            font-size: 24px;
        }
        .profile-header i {
            font-size: 20px;
            cursor: pointer;
        }
        .logout-form {
            display: inline;
        }
        .logout-button {
            background-color: red;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .profile-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .profile-info img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }
        .profile-info div {
            text-align: left;
        }
        .profile-info p {
            margin: 3px 0;
            font-size: 14px;
        }
        .profile-details {
            text-align: left;
            font-size: 16px;
        }
        .profile-details div {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        .save-button {
            background-color: black;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<%@ include file="Navbar.jsp" %>

<div class="profile-page">
    <div class="profile-container">
        <div class="profile-header">
            <h2>Edit Profile</h2>

            <!-- Logout form -->
            <form method="post" class="logout-form">
                <input type="hidden" name="logout" value="true" />
                <button type="submit" class="logout-button">Logout</button>
            </form>
        </div>

        <div class="profile-info">
            <img src="../images/joey.jpg" alt="Profile Picture">
            <div>
                <p><%= name %></p>
                <p><%= email %></p>
            </div>
        </div>
        <div class="profile-details">
            <div>
                <span>Name</span>
                <span><%= name %></span>
            </div>
            <div>
                <span>Email account</span>
                <span><%= email %></span>
            </div>
            <div>
                <span>Mobile number</span>
                <span><%= mobile %></span>
            </div>
        </div>
        <button class="save-button">Save Change</button>
    </div>
</div>

<%@ include file="Footer.jsp" %>
</body>
</html>
