<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
   
    <style>
     .separator {
            width: 100%;
            height: 1px;
            background: #00000059;
           margin-top:0px;
            opacity:30;
            
        }
        body {
            margin: 0;
            padding: 0;
            background: #D7E3E2;
            font-family: 'Playfair Display', serif;
            overflow-x: hidden;
        }

        .container {
            width: 1440px;
            height: 2300px;
            position: relative;
            margin: auto;
        }

        .aboutsection {
            width:644px;
            height: 401px;
            position: absolute;
            top: 177px;
            left: 265px;
        }

        .abouttext {
            font-size: 124px;
            color: black;
            font-weight: 400;
            text-align: center;
            margin-left: 268px;

        }

        .aboutsubtext {
            position: absolute;
            top: 54px;
            left: 77px;
        }

        .thetext {
            font-size: 116px;
            font-family: 'Times New Roman', serif;
            font-style: italic;
            font-weight: 400;
            color: black;
        }

        .venzuratext {
            font-size: 110px;
            color: black;
            font-weight: 400;
            margin-top:68px;
             margin-left: 119px;
             width: 601px;
             
        }

        .description {
            position: absolute;
            top: 553px;
            left: 51px;
            font-size: 27px;
            color: black;
            line-height: 35px;
        }

        .section {
            width: 1440px;
            height: 700px;
            position: absolute;
        }

        .blackbackground {
            top: 841px;
            background: black;
        }

        .whitebackground {
            top: 1541px;
            background: white;
            height: 700px;
        }

        .howitworks {
            position: absolute;
            top: 1704px;
            left: 55px;
            font-size: 28px;
            color: black;
            padding: 26px;
            width:762px;
            height:308px;
        }

        .whychooseus {
            position: absolute;
            top: 860px;
            left: 569px;
            font-size: 87px;
            color: white;
        }

        .howitworkstitle {
            position: absolute;
            top: 1580px;
            left: 85px;
            font-size: 87px;
            color: black;
        }

        .leftimage {
            position: absolute;
            width: 513px;
            height: 700px;
            top: 841px;
            left: 0px;
        }

        .whychooseusdescription {
            position: absolute;
            top: 997px;
            left: 549px;
            font-size:28px;
            color: white;
            padding:26px;
        }

        .rightimage {
            position: absolute;
            width: 513px;
            height: 700px;
            top: 1541px;
            left: 927px;
        }
    </style>
</head>
<body>
<%@ include file="Navbar.jsp" %>
    <div class="container">
        <div class="aboutsection">
            <div class="abouttext">ABOUT</div>
            <div class="aboutsubtext">
                
                <div class="venzuratext"><span style="font-style: italic;font-family: Times">the</span>
 Venzura</div>
            </div>
        </div>

        <div class="description">
            Welcome to Venzura Your one stop destination for discovering and booking the perfect party plots and 
            banquet halls for weddings, birthdays,and special celebrations. We go beyond just venues Venzura
            also connects you with top decorators and musicians, ensuring your event is not just memorable but 
            truly extraordinary.
        </div>

        <div class="section blackbackground"></div>
        <div class="section whitebackground"></div>

        <div class="howitworks">
            With Venzura, event planning is effortless. Browse and explore venues, decorators, and musicians, 
            compare options, and book seamlessly with instant confirmation. From securing the perfect venue to 
            arranging stunning decor and live music, we handle the details so you can relax and enjoy a 
            stress free, unforgettable celebration
        </div>

        <div class="whychooseus">Why Choose Us</div>
        <div class="howitworkstitle">How It Works</div>

        <img class="leftimage" src="../images/image 6.png" alt="Placeholder Image">
        
        <div class="whychooseusdescription">
            At Venzura, we take pride in offering a wide selection of venues,<br> ensuring that you find the perfect 
            party plot or banquet hall for any occasion, whether it's a wedding, birthday celebration, or a 
            corporate event. Our user friendly platform makes the booking process seamless, allowing you to explore 
            venues, compare options, and reserve your preferred location with just a few clicks. We collaborate 
            with verified vendors and organizers, ensuring that every listing on our platform meets high standards 
            of quality and reliability.
        </div>

        <img class="rightimage" src="../images/image 7.png" alt="Placeholder Image">
    </div>
     
    <%@ include file="Footer.jsp" %>
</body>
</html>
