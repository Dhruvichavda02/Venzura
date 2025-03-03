<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Booking</title>
   <style>
   body {
    background-color: black;
    margin: 0;
    font-family: 'Playfair Display', serif;
}

/* Ensuring styles are only applied inside booking-container */
.booking-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    width: 90%;
    max-width: 600px;
    margin: 50px auto; /* Ensures spacing and centering */
}

.booking-container h2 {
    text-align: left;
    font-size: 24px;
    margin-bottom: 20px;
}

.booking-info {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.booking-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.booking-row .label {
    font-size: 16px;
    font-weight: bold;
}

.booking-row input {
    width: 60%;
    padding: 8px;
    border: none;
    background-color: #eaf6e9;
    border-radius: 5px;
    font-size: 16px;
    text-align: right;
}

/* Ensuring the navbar and footer remain unaffected */
.navbar, .footer {
    all: unset;  /* Resets all inherited styles */
}
   
   </style> 
</head>
<body>
    <%@ include file="Navbar.jsp" %>
    
    <div class="booking-container">
        <h2>Your Booking</h2>
        <div class="booking-info">
            <div class="booking-row">
                <span class="label">Venue Name:</span>
                <input type="text" value="The Silver Palace" readonly>
            </div>
            <div class="booking-row">
                <span class="label">Venue Address:</span>
                <input type="text" value="Yagnik Road, Rajkot" readonly>
            </div>
            <div class="booking-row">
                <span class="label">Booking date:</span>
                <input type="text" value="12/01/25" readonly>
            </div>
            <div class="booking-row">
                <span class="label">Amount Paid:</span>
                <input type="text" value="10,000" readonly>
            </div>
        </div>
    </div>

    <%@ include file="Footer.jsp" %>
</body>
</html>
