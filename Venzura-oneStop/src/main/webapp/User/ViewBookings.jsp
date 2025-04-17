<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.util.*, com.venzura.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    
    Integer userId = (session != null) ? (Integer) session.getAttribute("user_id") : null;

    if (userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT id, start_date, end_date, amount FROM vbookings WHERE user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }
        th {
            background-color: black;
            color: white;
        }
        .go-back {
            display: block;
            width: 150px;
            margin: 30px auto;
            text-align: center;
            padding: 10px 20px;
            background-color: black;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .go-back:hover {
            background-color: black;
        }
    </style>
</head>
<body>
    <h2>My Bookings</h2>

    <table>
        <tr>
            <th>Booking ID</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Amount</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= rs.getDouble("amount") %></td>
        </tr>
        <%
            }
        %>
    </table>

    <a href="Account.jsp" class="go-back">Go Back</a>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
