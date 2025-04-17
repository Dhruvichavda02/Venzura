<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venue List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .venue-list-container {
            font-family: Arial, sans-serif;
            background-color: #fffff;
            padding: 20px;
            padding-bottom: 100px; 
        }

        .venue-list-container .search-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 20px;
        }

        .venue-list-container .search-bar {
            padding: 10px;
            border: none;
            border-radius: 20px;
            width: 250px;
            background-color: #eee;
        }

        .venue-list-container .filter-btn {
            background-color: #ddd;
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            margin-left: 10px;
            cursor: pointer;
        }

        .venue-list-container .venue-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .venue-list-container .venue-card {
            display: flex;
            align-items: center;
            background: #f0f3f5;
            border-radius: 10px;
            padding: 15px;
            width: 80%;
            max-width: 800px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        .venue-list-container .venue-card img {
            width: 150px;
            height: 100px;
            border-radius: 10px;
            object-fit: cover;
            margin-right: 20px;
        }

        .venue-list-container .venue-details {
            flex-grow: 1;
        }

        .venue-list-container .venue-details h3 {
            margin: 0;
        }

        .venue-list-container .venue-details p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
        }

        .venue-list-container .view-btn {
            background-color: black;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        .venue-list-container .view-btn:hover {
            background-color: #444;
        }

        .separator {
            width: 100%;
            height: 1px;
            background: #00000059;
            margin: 30px 0;
            opacity:30;
        }

        .filter-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            width: 300px;
            z-index: 1000;
        }

        .filter-popup .filter-content {
            display: flex;
            flex-direction: column;
            gap: 10px;
            position: relative;
        }

        .filter-input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        .price-slider {
            width: 100%;
        }

        .filter-options {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .filter-options input[type="radio"] {
            margin-right: 5px;
        }

        .filter-btn-apply {
            background-color: black;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }

        .filter-btn-apply:hover {
            background-color: #444;
        }

        .close-btn {
            position: absolute;
            top: -15px;
            right: 1px;
            font-size: 20px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%@ include file="Navbar.jsp" %>

    <div class="venue-list-container">
       <div id="filter-popup" class="filter-popup">
            <div class="filter-content">
                <span class="close-btn">&times;</span>
                <label>Price</label>
                <input type="range" min="0" max="100" class="price-slider">
                
                <label>City</label>
                <input type="text" class="filter-input">

                <label>Capacity</label>
                <input type="text" class="filter-input">

                <div class="filter-options">
                    <input type="radio" id="non-ac1" name="ac-type">
                    <label for="non-ac1">Non-Ac</label>
                    <input type="radio" id="non-ac2" name="ac-type">
                    <label for="non-ac2">Ac</label>
                </div>

                <button class="filter-btn-apply">Filter</button>
            </div>
        </div>
        
        <!-- Search Bar -->
        <div class="search-container">
            <input type="text" class="search-bar" placeholder="Search venues...">
            <button class="filter-btn"><i class="fas fa-filter"></i></button>
        </div>


        <!-- Venue List -->
        <div class="venue-container">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT id, name, location, capacity, price, amenities, description, image_paths FROM venues";
                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        String id = rs.getString("id");
                        String name = rs.getString("name");
                        String location = rs.getString("location");
                        int capacity = rs.getInt("capacity");
                        double price = rs.getDouble("price");
                        String imagePaths = rs.getString("image_paths");
                        
                        // Get first image for thumbnail
                        String thumbnail = "images/default-venue.jpg"; // default image
                        if (imagePaths != null && !imagePaths.isEmpty()) {
                            String[] images = imagePaths.split(",");
                            if (images.length > 0 && !images[0].trim().isEmpty()) {
                                thumbnail = images[0].trim();
                                // Remove leading "../" if present
                                if (thumbnail.startsWith("../")) {
                                    thumbnail = thumbnail.substring(3);
                                }
                            }
                        }
            %>
                        <div class="venue-card">
                            <img src="${pageContext.request.contextPath}/<%= thumbnail %>" alt="<%= name %>" 
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-venue.jpg'">
                            
                            <div class="venue-details">
                                <h3><%= name %></h3>
                                <p><i class="fas fa-map-marker-alt"></i> <%= location %></p>
                                <p><i class="fas fa-users"></i> <%= capacity %> max capacity</p>
                                <p><i class="fas fa-rupee-sign"></i> ₹<%= price %> per event</p>
                            </div>
                            <button class="view-btn" onclick="window.location.href='VenueDetail.jsp?id=<%= id %>'">View</button>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Error loading venues. Please try again later.</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>
     
    <div class="separator"></div>
    <%@ include file="Footer.jsp" %>

    <!-- JavaScript remains the same -->
</body>
</html>