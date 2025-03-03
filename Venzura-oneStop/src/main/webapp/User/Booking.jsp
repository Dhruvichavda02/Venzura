<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venue Booking</title>
    <style>
    /* Apply styles only to booking container to avoid affecting Navbar and Footer */
    .booking-container {
        font-family: 'Playfair Display', serif;
        background-color: white;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .booking-container .booking-form {
        background: #D7E3E2;
        width: 400px;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0px 12px 25px rgba(13, 16, 45, 0.1);
        text-align: center;
    }

    .booking-container h2 {
        color: #2A2A2A;
        font-size: 22px;
        margin-bottom: 20px;
    }

    .booking-container label {
        display: block;
        text-align: left;
        font-size: 16px;
        opacity: 0.8;
        color: black;
        margin: 10px 0 5px;
    }

    .booking-container input {
        width: 100%;
        height: 35px;
        border: none;
        background: #F9F9F9;
        border-radius: 8px;
        padding-left: 10px;
        font-size: 14px;
    }

    .booking-container .book-btn {
        width: 121px;
        height: 52px;
        background: #73A9A5;
        border: none;
        border-radius: 7px;
        color: white;
        font-size: 15px;
        font-weight: 600;
        margin-top: 20px;
        cursor: pointer;
    }

    .booking-container .book-btn:hover {
        background: #5c8c8a;
    }
       .separator {
            width: 100%;
            height: 1px;
            background: black;
            margin: 60px 0;
        }

    </style>
</head>

<body>
    <%@ include file="Navbar.jsp" %>

    <div class="booking-container">
        <div class="booking-form">
            <h2>Book a Venue</h2>
            <label for="name">Name</label>
            <input type="text" id="name" placeholder="Enter your name">

            <label for="email">Email</label>
            <input type="email" id="email" placeholder="Enter your email">

            <label for="guests">No. of Guests</label>
            <input type="number" id="guests" placeholder="Enter number of guests">

            <label for="date">Date to book venue:</label>
            <input type="date" id="date">

            <button class="book-btn" onclick="window.location.href='Home.jsp'">Book</button>
        </div>
    </div>
<div class="separator"></div>
    <%@ include file="Footer.jsp" %>
</body>
</html>
