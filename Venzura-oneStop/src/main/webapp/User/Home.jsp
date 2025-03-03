<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <style>
        body {
            background: #ecf0f1;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        /* Carousel Container */
        .carousel-container {
            position: relative;
            margin: 40px auto;
            overflow: hidden;
            height: 500px;
            max-width: 1000px; /* Increased width */
            border-radius: 10px;
        }

        .carousel-container .imgList {
            position: absolute;
            display: flex;
            margin: 0;
            padding: 0;
            width: 500%;
            transition: transform 1s ease-in-out;
        }

        .carousel-container li {
            list-style: none;
            height: 500px;
            width: 1000px; /* Adjusted width */
            flex: 0 0 auto;
        }

        .carousel-container li img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        /* Static Overlay Text */
        .carousel-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            text-align: center;
            font-family: Arial, sans-serif;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.7);
            z-index: 10;
        }

        .carousel-text h1 {
            font-size: 50px;
            margin: 0;
        }

        .carousel-text p {
            font-size: 20px;
            margin-top: 10px;
        }

        /* Navigation Buttons */
        .carousel-container .glyphicon-menu-left,
        .carousel-container .glyphicon-menu-right {
            cursor: pointer;
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            padding: 15px;
            background: rgba(0, 0, 0, 0.5);
            color: #fff;
            font-size: 24px;
            border-radius: 50%;
            user-select: none;
            z-index: 20;
        }

        .carousel-container .glyphicon-menu-left {
            left: 15px;
        }

        .carousel-container .glyphicon-menu-right {
            right: 15px;
        }

    </style>
</head>
<body>

    <%@ include file="Navbar.jsp" %>

    <div class="carousel-container">
        <div class="carousel-text">
            <h1>We are Venzura</h1>
            <p>Venzura  Curating Venues for Unforgettable Celebrations.</p>
        </div>

        <ul class="imgList">
            <li><img src="../images/image3.jpg" alt="Image 1"></li>
            <li><img src="../images/image2.jpg" alt="Image 2"></li>
            <li><img src="../images/image1.jpg" alt="Image 3"></li>
             <li><img src="../images/img8.jpeg" alt="Image 3"></li>
              <li><img src="../images/img10.jpg" alt="Image 3"></li>
        </ul>

        <div id="leftBtn" class="left">
            <span class="glyphicon glyphicon-menu-left" aria-hidden="true">&#10094;</span>
        </div>
        <div id="rightBtn" class="right">
            <span class="glyphicon glyphicon-menu-right" aria-hidden="true">&#10095;</span>
        </div>
    </div>

    <script>
        var carousel = document.querySelector('.imgList');
        var slides = document.querySelectorAll('.imgList li');
        var currentSlide = 0;
        var totalSlides = slides.length;

        function updateCarousel() {
            carousel.style.transform = "translateX(-" + (currentSlide * 1000) + "px)"; // Adjusted width
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateCarousel();
        }

        function prevSlide() {
            currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
            updateCarousel();
        }

        document.getElementById("rightBtn").addEventListener("click", nextSlide);
        document.getElementById("leftBtn").addEventListener("click", prevSlide);

        // Auto-rotate every 3 seconds
        setInterval(nextSlide, 4000);
    </script>

    <%@ include file="Footer.jsp" %>
</body>
</html>
