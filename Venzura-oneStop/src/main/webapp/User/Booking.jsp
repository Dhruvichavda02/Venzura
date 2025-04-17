<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection, java.text.SimpleDateFormat, java.util.Date" %>

<%
// Check if user is logged in
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) {
    response.sendRedirect("../Login.jsp?redirect=Booking.jsp");
    return;
}

// Get booking parameters
String venueId = request.getParameter("venueId");
String decorationId = request.getParameter("decorationId");
String musicHostId = request.getParameter("musicHostId");

// Fetch details for selected items
String venueName = "", decorationName = "", musicHostName = "";
double venuePrice = 0, decorationPrice = 0, musicHostPrice = 0;

Connection con = null;
try {
    con = DBConnection.getConnection();
    
    // Get venue details
    if (venueId != null && !venueId.isEmpty()) {
        PreparedStatement pstmt = con.prepareStatement("SELECT name, price FROM venues WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(venueId));
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            venueName = rs.getString("name");
            venuePrice = rs.getDouble("price");
        }
        rs.close();
        pstmt.close();
    }
    
    // Get decoration details
    if (decorationId != null && !decorationId.isEmpty()) {
        PreparedStatement pstmt = con.prepareStatement("SELECT name, price FROM decorations WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(decorationId));
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            decorationName = rs.getString("name");
            decorationPrice = rs.getDouble("price");
        }
        rs.close();
        pstmt.close();
    }
    
    // Get music host details
    if (musicHostId != null && !musicHostId.isEmpty()) {
        PreparedStatement pstmt = con.prepareStatement("SELECT name, price FROM music_hosts WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(musicHostId));
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            musicHostName = rs.getString("name");
            musicHostPrice = rs.getDouble("price");
        }
        rs.close();
        pstmt.close();
    }
} catch(Exception e) {
    e.printStackTrace();
} finally {
    if (con != null) con.close();
}

// Calculate total amount
double totalAmount = venuePrice + decorationPrice + musicHostPrice;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venue Booking</title>
    <style>
    .booking-container {
        font-family: 'Playfair Display', serif;
        background-color: white;
        margin: 0;
        padding: 20px 0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: calc(100vh - 120px);
    }

    .booking-form {
        background: #D7E3E2;
        width: 90%;
        max-width: 500px;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0px 12px 25px rgba(13, 16, 45, 0.1);
    }

    .booking-form h2 {
        color: #2A2A2A;
        font-size: 24px;
        margin-bottom: 25px;
        text-align: center;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-size: 16px;
        color: #2A2A2A;
        margin-bottom: 8px;
        font-weight: 500;
    }

    .form-group input, .form-group select {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
        background: #F9F9F9;
    }

    .item-info {
        background: #f0f7f6;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
    }

    .item-info p {
        margin: 5px 0;
        color: #2A2A2A;
    }

    .book-btn {
        width: 100%;
        padding: 15px;
        background: #73A9A5;
        border: none;
        border-radius: 8px;
        color: white;
        font-size: 16px;
        font-weight: 600;
        margin-top: 20px;
        cursor: pointer;
        transition: background 0.3s;
    }

    .book-btn:hover {
        background: #5c8c8a;
    }

    .separator {
        width: 100%;
        height: 1px;
        background: #ddd;
        margin: 40px 0;
    }

    @media (max-width: 768px) {
        .booking-container {
            padding: 20px;
        }
        
        .booking-form {
            width: 100%;
            padding: 20px;
        }
    }
    </style>
</head>

<body>
    <%@ include file="Navbar.jsp" %>
<%
String userName = "", userEmail = "";
try {
    con = DBConnection.getConnection();
    PreparedStatement userStmt = con.prepareStatement("SELECT name, email FROM users WHERE user_id = ?");
    userStmt.setInt(1, userId);
    ResultSet userRs = userStmt.executeQuery();
    if (userRs.next()) {
        userName = userRs.getString("name");
        userEmail = userRs.getString("email");
    }
    userRs.close();
    userStmt.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

    <div class="booking-container">
        <form class="booking-form" id="bookingForm" method="post" action="../BookingServlet">
            <h2>Complete Your Booking</h2>
            
            <!-- Hidden fields for item IDs -->
            <input type="hidden" name="userId" value="<%= userId %>">
            <% if (venueId != null) { %>
                <input type="hidden" name="venueId" value="<%= venueId %>">
            <% } %>
            <% if (decorationId != null) { %>
                <input type="hidden" name="decorationId" value="<%= decorationId %>">
            <% } %>
            <% if (musicHostId != null) { %>
                <input type="hidden" name="musicHostId" value="<%= musicHostId %>">
            <% } %>
            
            <!-- Display selected items -->
            <% if (!venueName.isEmpty()) { %>
                <div class="item-info">
                    <p><strong>Venue:</strong> <%= venueName %></p>
                    <p><strong>Price:</strong> ₹<%= String.format("%.2f", venuePrice) %></p>
                </div>
            <% } %>
            
            <% if (!decorationName.isEmpty()) { %>
                <div class="item-info">
                    <p><strong>Decoration:</strong> <%= decorationName %></p>
                    <p><strong>Price:</strong> ₹<%= String.format("%.2f", decorationPrice) %></p>
                </div>
            <% } %>
            
            <% if (!musicHostName.isEmpty()) { %>
                <div class="item-info">
                    <p><strong>Music Host:</strong> <%= musicHostName %></p>
                    <p><strong>Price:</strong> ₹<%= String.format("%.2f", musicHostPrice) %></p>
                </div>
            <% } %>
            
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" value="<%= userName%>" readonly>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= userEmail%>" readonly> 
            </div>
            
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" required>
            </div>
            
           <div class="form-group">
    <label for="eventDate">Start Date</label>
    <input type="date" id="eventDate" name="eventDate" required>
</div>

<div class="form-group">
    <label for="endDate">End Date</label>
    <input type="date" id="endDate" name="endDate" required>
</div>

            
            <div class="form-group">
                <label for="guests">Number of Guests</label>
                <input type="number" id="guests" name="guests" min="1" required>
            </div>
            
            <div class="form-group">
                <label for="totalAmount">Total Amount</label>
                <input type="text" id="totalAmount" name="totalAmount" value="₹<%= String.format("%.2f", totalAmount) %>" readonly>
            </div>
            
            <button type="submit" class="book-btn">Confirm Booking</button>
        </form>
    </div>

    <div class="separator"></div>
    <%@ include file="Footer.jsp" %>

    <script>
    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        const eventDate = new Date(document.getElementById('eventDate').value);
        const today = new Date();
        
        if (eventDate < today) {
            alert('Please select a future date for your event.');
            e.preventDefault();
            return false;
        }
        
        const guests = parseInt(document.getElementById('guests').value);
        if (guests < 1) {
            alert('Number of guests must be at least 1');
            e.preventDefault();
            return false;
        }
        
        // Check availability via AJAX
        checkAvailability(e);
    });
    
    function checkAvailability(formEvent) {
        const eventDate = document.getElementById('eventDate').value;
        const venueId = '<%= venueId != null ? venueId : "" %>';
        const decorationId = '<%= decorationId != null ? decorationId : "" %>';
        const musicHostId = '<%= musicHostId != null ? musicHostId : "" %>';
        
        if (!eventDate) {
            alert('Please select an event date');
            formEvent.preventDefault();
            return;
        }
        
        // Show loading indicator
        const btn = document.querySelector('.book-btn');
        btn.disabled = true;
        btn.textContent = 'Checking Availability...';
        
        // AJAX call to check availability
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'CheckAvailability.jsp', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            btn.disabled = false;
            btn.textContent = 'Confirm Booking';
            
            if (this.status === 200) {
                const response = JSON.parse(this.responseText);
                if (response.available) {
                    // Submit form if available
                    document.getElementById('bookingForm').submit();
                } else {
                    alert(response.message || 'Selected items are not available on this date');
                }
            } else {
                alert('Error checking availability. Please try again.');
            }
        };
        
        xhr.send('eventDate=' + encodeURIComponent(eventDate) + 
                '&venueId=' + encodeURIComponent(venueId) + 
                '&decorationId=' + encodeURIComponent(decorationId) + 
                '&musicHostId=' + encodeURIComponent(musicHostId));
    }
    
    // Auto-fill user details if available
    window.onload = function() {
        // You can add AJAX call here to fetch user details from database
        // and auto-fill the name, email and phone fields
    };
    </script>
</body>
</html>
