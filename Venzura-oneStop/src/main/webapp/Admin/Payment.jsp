<%@ page import="java.sql.*,com.venzura.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .content {
            margin: 50px auto;
            width: 90%;
            max-width: 1200px;
        }
        .table-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        table th {
            background-color: #343a40;
            color: white;
        }
        .go-back-btn {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .go-back-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<%@ include file="Navbar.jsp" %>

<div class="content" id="content">
    <div class="table-container">
        <h2>Payment Report</h2>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Booking ID</th>
                    <th>Amount Paid</th>
                    <th>Payment Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                int count = 1;
                try {
                    Connection conn = DBConnection.getConnection();
                    String sql = "SELECT p.payment_id, p.amount_paid, p.payment_date, " +
                                 "b.id AS booking_id, u.name, u.email " +
                                 "FROM payment p " +
                                 "JOIN vbookings b ON p.booking_id = b.id " +
                                 "JOIN users u ON b.user_id = u.user_id";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getInt("booking_id") %></td>
                    <td><%= rs.getDouble("amount_paid") %></td>
                    <td><%= rs.getDate("payment_date") %></td>
                </tr>
                <%
                    }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                }
                %>
            </tbody>
        </table>

        <!-- Go Back Button -->
        
    </div>
</div>

</body>
</html>
