<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Decoration Details</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Swiper CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"/>

    <style>
    :root {
        --pure-white: #ffffff;
        --pure-black: #000000;
        --light-gray: #f5f5f5;
        --dark-gray: #333333;
        --medium-gray: #777777;
        --accent-color: #000000; /* Black as accent */
        --shadow-color: rgba(0, 0, 0, 0.08);
        --hover-shadow: rgba(0, 0, 0, 0.15);
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Playfair Display', serif;
    }

    body {
        background-color: var(--pure-white);
        color: var(--pure-black);
        line-height: 1.6;
    }

    .container {
        max-width: 1100px;
        margin: 0 auto;
        padding: 40px 20px;
    }

    .swiper {
        width: 100%;
        height: 500px;
        border-radius: 0;
        overflow: hidden;
        box-shadow: 0 15px 30px var(--shadow-color);
        border: 1px solid rgba(0,0,0,0.05);
    }

    .swiper-slide {
        display: flex;
        justify-content: center;
        align-items: center;
        background: var(--pure-black);
    }

    .gallery-image {
        width: 100%;
        height: 100%;
        object-fit: contain;
        transition: opacity 0.3s ease;
    }

    .swiper-slide:hover .gallery-image {
        opacity: 0.9;
    }

    .swiper-button-next,
    .swiper-button-prev {
        color: var(--pure-white);
        background: rgba(0,0,0,0.5);
        width: 50px;
        height: 50px;
        border-radius: 50%;
        backdrop-filter: blur(5px);
        transition: all 0.3s ease;
    }

    .swiper-button-next:hover,
    .swiper-button-prev:hover {
        background: rgba(0,0,0,0.8);
        transform: scale(1.1);
    }

    .swiper-pagination-bullet {
        background-color: var(--pure-white);
        opacity: 0.8;
        width: 10px;
        height: 10px;
    }

    .swiper-pagination-bullet-active {
        background-color: var(--pure-white);
        opacity: 1;
        transform: scale(1.2);
    }

    .decoration-name {
        font-size: 42px;
        font-weight: 700;
        text-align: center;
        margin-top: 40px;
        color: var(--pure-black);
        letter-spacing: -0.5px;
        text-transform: uppercase;
    }

    .decoration-category,
    .decoration-location {
        font-size: 16px;
        text-align: center;
        color: var(--medium-gray);
        margin-top: 8px;
        letter-spacing: 1px;
        font-weight: 400;
    }

    .decoration-location i {
        color: var(--pure-black);
        margin-right: 8px;
    }

    .section-title {
        font-size: 28px;
        margin-top: 60px;
        color: var(--pure-black);
        border-bottom: 2px solid var(--pure-black);
        padding-bottom: 10px;
        font-weight: 600;
        letter-spacing: -0.5px;
    }

    .description,
    .contact-info {
        font-size: 17px;
        line-height: 1.8;
        margin-top: 25px;
        color: var(--dark-gray);
    }

    .price-section {
        font-size: 26px;
        font-weight: 700;
        color: var(--pure-black);
        margin-top: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .price-section i {
        font-size: 22px;
    }

    .separator {
        width: 100%;
        height: 1px;
        background-color: rgba(0,0,0,0.1);
        margin: 50px 0;
    }

    .details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 30px;
        margin-top: 30px;
    }

    .detail-card {
        background-color: var(--pure-white);
        padding: 30px;
        border-radius: 0;
        box-shadow: 0 5px 20px var(--shadow-color);
        transition: all 0.3s ease;
        border: 1px solid rgba(0,0,0,0.05);
    }

    .detail-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px var(--hover-shadow);
        border-color: rgba(0,0,0,0.1);
    }

    .detail-label {
        font-size: 13px;
        color: var(--medium-gray);
        margin-bottom: 12px;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        font-weight: 600;
    }

    .detail-value {
        font-size: 20px;
        font-weight: 600;
        color: var(--pure-black);
    }

    .contact-info .phone-number {
        margin-top: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 20px;
        color: var(--pure-black);
        font-weight: 600;
    }

    .contact-info .phone-number i {
        color: var(--pure-black);
        margin-right: 12px;
        font-size: 18px;
    }

    .book-button {
        width: 200px;
        height: 50px;
        background-color: var(--pure-black);
        color: var(--pure-white);
        font-size: 16px;
        font-weight: 600;
        border: 2px solid var(--pure-black);
        cursor: pointer;
        display: block;
        margin: 40px auto;
        border-radius: 0;
        transition: all 0.3s ease;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    .book-button:hover {
        background-color: var(--pure-white);
        color: var(--pure-black);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px var(--shadow-color);
    }

    @media (max-width: 768px) {
        .swiper {
            height: 350px;
        }

        .decoration-name {
            font-size: 32px;
        }

        .section-title {
            font-size: 24px;
        }

        .price-section {
            font-size: 22px;
        }

        .details-grid {
            grid-template-columns: 1fr;
        }

        .book-button {
            width: 100%;
            max-width: 300px;
        }
    }

    /* Animation for section entrance */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .section-title, .details-grid, .description, .price-section, .contact-info {
        animation: fadeInUp 0.6s ease-out forwards;
    }

    .section-title {
        animation-delay: 0.1s;
    }

    .description {
        animation-delay: 0.2s;
    }

    .price-section {
        animation-delay: 0.3s;
    }

    .details-grid {
        animation-delay: 0.4s;
    }

    .contact-info {
        animation-delay: 0.5s;
    }
</style>

</head>
<body>
<%@ include file="Navbar.jsp" %>
<%
    String decId = request.getParameter("id");
    if (decId == null || decId.trim().isEmpty()) {
        response.sendRedirect("error.jsp?message=Decoration ID not provided");
        return;
    }

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        String sql = "SELECT * FROM decorations WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(decId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String name = rs.getString("name");
            String category = rs.getString("category");
            String price = rs.getString("price");
            String description = rs.getString("description");
            String phone = rs.getString("phone");
            String location = rs.getString("location");
            String imagePaths = rs.getString("image_paths");

            String[] imageArray = {};
            if (imagePaths != null && !imagePaths.trim().isEmpty()) {
                imageArray = imagePaths.split(",");
            }
%>
    <div class="container">
        <!-- Swiper Carousel -->
        <div class="swiper mySwiper">
            <div class="swiper-wrapper">
                <% for (String imgPath : imageArray) {
                    imgPath = imgPath.trim();
                    if (imgPath.startsWith("../")) {
                        imgPath = imgPath.substring(3);
                    }
                %>
                <div class="swiper-slide">
                    <img class="gallery-image" 
                         src="<%= request.getContextPath() %>/<%= imgPath %>" 
                         onerror="this.src='<%= request.getContextPath() %>/images/default-decoration.jpg'" 
                         alt="Decoration Image">
                </div>
                <% } %>
            </div>
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-pagination"></div>
        </div>

        <h1 class="decoration-name"><%= name %></h1>
        <div class="decoration-category"><%= category %></div>
        <div class="decoration-location">
            <i class="fas fa-map-marker-alt"></i> <%= location %>
        </div>

        <h2 class="section-title">About This Decoration</h2>
        <div class="description">
            <%= description != null ? description : "No description available." %>
        </div>

        <div class="separator"></div>

        <h2 class="section-title">Pricing</h2>
        <div class="price-section">
            <i class="fas fa-tag"></i> Price: ₹<%= price %>
        </div>

        <div class="separator"></div>

        <h2 class="section-title">Details</h2>
        <div class="details-grid">
            <div class="detail-card">
                <div class="detail-label">Category</div>
                <div class="detail-value"><%= category %></div>
            </div>
            <div class="detail-card">
                <div class="detail-label">Location</div>
                <div class="detail-value"><%= location %></div>
            </div>
        </div>

        <div class="separator"></div>

        <h2 class="section-title">Contact Information</h2>
        <div class="contact-info">
            <div class="phone-number">
                <i class="fas fa-phone"></i>
                <span><%= phone != null ? phone : "Contact number not available" %></span>
            </div>
        </div>

         <button class="book-button" onclick="window.location.href='Booking.jsp?decorationId=<%= rs.getInt("id") %>'">Book</button>
    </div>
<%
        } else {
            response.sendRedirect("Decorator.jsp?message=Decoration not found");
        }
    } catch(Exception e) {
        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>

<!-- Swiper JS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<script>
    const swiper = new Swiper('.mySwiper', {
        loop: true,
        spaceBetween: 20,
        slidesPerView: 1,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        },
    });
</script>
</body>
</html>
