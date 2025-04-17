<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%

Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    con = DBConnection.getConnection();
    String sql = "SELECT * FROM venues WHERE id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
    rs = pstmt.executeQuery();
    
    if (!rs.next()) {
        response.sendRedirect("error.jsp?message=Venue not found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Playfair Display', serif;
    }
    body {
        background-color: #ffffff;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
    }
    .venue-image {
        width: 100%;
        height: 400px;
        object-fit: cover;
        border-radius: 7px;
        margin: 20px 0;
    }
    .venue-name {
        font-size: 30px;
        font-weight: 400;
        text-align: center;
    }
    .venue-address {
        font-size: 18px;
        font-weight: 300;
        text-align: center;
    }
    .section-title {
        font-size: 20px;
        font-weight: 500;
        margin-top: 50px;
    }
    .amenities, .capacity, .charges {
        font-size: 14px;
        font-weight: 400;
        line-height: 1.6;
        margin-top: 10px;
    }
    .separator {
        width: 100%;
        height: 1px;
        background: black;
        margin: 60px 0;
    }
    .details {
        display: flex;
        justify-content: space-between;
        font-size: 20px;
        font-weight: 400;
        margin-top: 20px;
    }
    .detail-item {
        flex: 1;
        text-align: center;
        font-size: 12px;
    }
    .book-button {
        width: 125px;
        height: 42px;
        background-color: black;
        color: white;
        font-size: 18px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        display: block;
        margin: 30px auto;
        border-radius: 5px;
        transition: background 0.3s ease;
    }
    .book-button:hover {
        background-color: #333;
    }
    .login-prompt {
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: #ffeb3b;
        padding: 15px 25px;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        z-index: 1000;
        display: none;
        animation: slideIn 0.5s forwards;
    }
    @keyframes slideIn {
        from { top: -50px; opacity: 0; }
        to { top: 20px; opacity: 1; }
    }
</style>
</head>
<body>
<%@ include file="Navbar.jsp" %>



<div class="container">
    <img class="venue-image" src="<%= request.getContextPath() %>/<%= rs.getString("image_paths").split(",")[0].trim() %>" 
         onerror="this.src='<%= request.getContextPath() %>/images/default-venue.jpg'"
         alt="<%= rs.getString("name") %>">
    
    <h1 class="venue-name"><%= rs.getString("name") %></h1>
    <p class="venue-address"><%= rs.getString("location") %></p>
    
    <h2 class="section-title">Amenities</h2>
    <p class="amenities"><%= rs.getString("amenities") %></p>
    
    <h2 class="section-title">Capacity</h2>
    <p class="capacity"><%= rs.getString("capacity") %></p>
    
    <div class="separator"></div>
    
    <div class="details">
        <div class="detail-item"><strong>Room Count:</strong><br> <%= rs.getString("Roomcount") %> Rooms</div>
        <div class="detail-item"><strong>Catering Policy:</strong><br> <%= rs.getString("CateringPolicy") %></div>
        <div class="detail-item"><strong>Decor Policy:</strong><br> <%= rs.getString("DecorPolicy") %></div>
    </div>
    
    <div class="separator"></div>
    
    <h2 class="section-title">Charges</h2>
    <p class="charges">₹<%= rs.getInt("price") %> per event</p>
    
    <a href="Booking.jsp?venueId=<%= rs.getInt("id") %>" class="book-button">Book Now</a>
</div>

<div class="separator"></div>
<%@ include file="Footer.jsp" %>

<script>

</script>
</body>
</html>
<%
} catch(Exception e) {
    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (con != null) try { con.close(); } catch (Exception e) {}
}
%>