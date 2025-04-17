<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookingId = request.getParameter("bookingId");
    String paymentId = request.getParameter("payment_id");
    
    if (bookingId == null || paymentId == null) {
        response.sendRedirect("Home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thank You</title>
</head>
<body>
    <h2>Thank You for Your Booking!</h2>
    <p>Booking ID: <%= bookingId %></p>
    <p>Payment ID: <%= paymentId %></p>
    <p>Your payment has been successfully processed.</p>
    <a href="ViewBookings.jsp">View Your Bookings</a>
</body>
</html>