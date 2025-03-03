<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Silver Sand</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700" rel="stylesheet">



    <style>
   
   * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Playfair Display', serif;
        }
   
        body {
            font-family: 'Playfair Display', serif !important;
     background-color: #ffffff;;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
        }
        .container {
                      width: 80%;
            margin: 0 auto;
            padding: 20px;
      
        }
        .venue-image {
            width: 900px;
            height: 355px;
            border-radius: 7px;
            display: block;
            margin: 20px auto;
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
            font-style: normal;
            font-weight: 400;
            line-height: 1.4;
            margin-top:20px;
            margin-left:30px;
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
        }
        .detail-item {
            flex: 1;
            text-align: center;
        }
        .book-button {
            width: 125px;
            height: 42px;
            background: black;
            color: white;
            font-size: 18px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: block;
            margin: 30px auto;
            border-radius: 5px;
        }
        .detail-item{
        font-size:12px;
        }
        .charges{
        font-size:18px;
        }
        
    </style>
</head>
<body>
<%@ include file="Navbar.jsp" %>
    <div class="container">
        <img class="venue-image" src="../images/image3.jpg" alt="Venue Image">
        <h1 class="venue-name">The Silver Sand</h1>
        <p class="venue-address">14, Millpara, Road, Millpara, Bhakti Nagar, Rajkot</p>
        
        <h2 class="section-title">Amenities</h2>
        <p class="amenities">Spacious indoor and outdoor areas  Ideal for all types of event.
            Elegant decor and customizable layouts  Tailored to your theme
            Highquality lighting and sound system  Enhancing the ambiance.
            Airconditioned halls  Ensuring guest comfort
            Onsite parking and valet services  Hasslefree parking experience.
            Dedicated restrooms  Clean and well maintained facilities
            Fully equipped kitchen and catering services For seamless dining experiences.
            Dance floor and stage  Perfect for entertainment and performances
            Bridal suite and changing rooms  Private spaces for preparation
            Power backup and WiFi  Uninterrupted event experience.
            Security services  Ensuring a safe and secure environment
        </p>
        
        <h2 class="section-title">Capacity</h2>
        <p class="capacity">Our venue can accommodate up to 200 guests in a banquetstyle setup, while the floating capacity allows for up to Y guests. For conferences or presentations, the theater-style arrangement can seat up to [Z] guests. Additionally, the outdoor space is perfect for open-air events, hosting up to [A] guests comfortably.</p>
        
        <div class="separator"></div>
        
        <div class="details">
            <div class="detail-item"><strong>Room Count:</strong><br> 45 Rooms</div>
            <div class="detail-item"><strong>Catering Policy:</strong><br> Inhouse catering only</div>
            <div class="detail-item"><strong>Decor Policy:</strong> <br>No inhouse available</div>
        </div>
        
        <div class="separator"></div>
        
        <h2 class="section-title">Charges</h2>
        <p class="charges">20K for a day</p>
        
        <button class="book-button" onclick= "window.location.href='Booking.jsp'">Book</button>
        
    </div>
      <div class="separator"></div>
      <%@ include file="Footer.jsp" %>
      
</body>
</html>