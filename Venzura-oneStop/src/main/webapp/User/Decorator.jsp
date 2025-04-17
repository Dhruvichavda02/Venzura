<%@ page import="java.sql.*,com.venzura.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Decoration Venues</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        .venue-list-container {
            font-family: Arial, sans-serif;
            background-color: #fdfdfd;
            padding: 20px;
            padding-bottom: 100px;
            min-height: 70vh;
        }

        .search-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 20px;
            gap: 10px;
        }

        .search-bar {
            padding: 10px;
            border: none;
            border-radius: 20px;
            width: 250px;
            background-color: #eee;
        }

        .filter-btn {
            background-color: #ddd;
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            cursor: pointer;
        }

        .venue-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .venue-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f0f3f5;
            border-radius: 10px;
            padding: 15px;
            width: 80%;
            max-width: 800px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
        }

        .venue-info {
            display: flex;
            align-items: center;
            flex-grow: 1;
        }

        .venue-card img {
            width: 150px;
            height: 100px;
            border-radius: 10px;
            object-fit: cover;
            margin-right: 20px;
        }

        .venue-details h3 {
            margin: 0;
        }

        .venue-details p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
        }

        .view-btn {
            background-color: black;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 20px;
            white-space: nowrap;
        }

        .filter-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 25px;
            border-radius: 10px;
            width: 320px;
            z-index: 1000;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }

        .filter-popup .filter-content {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .filter-popup input[type="text"],
        .filter-popup input[type="number"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        .price-range {
            display: flex;
            gap: 10px;
        }

        .filter-options label {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .filter-options {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .filter-btn-apply {
            background-color: black;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .close-btn {
            position: absolute;
            top: 5px;
            right: 10px;
            font-size: 18px;
            cursor: pointer;
        }

        .hidden {
            display: none;
        }
    </style>
</head>

<body>

<%@ include file="Navbar.jsp" %>

<div class="venue-list-container">

    <!-- Filter Popup -->
    <div id="filter-popup" class="filter-popup">
        <div class="filter-content">
            <span class="close-btn">&times;</span>

            <label>City</label>
            <input type="text" id="filterCity">

            <label>Capacity</label>
            <input type="text" id="filterCapacity">

            <label>Price Range</label>
            <div class="price-range">
                <input type="number" id="minPrice" placeholder="Min" min="0">
                <input type="number" id="maxPrice" placeholder="Max" min="0">
            </div>

            <label>Type</label>
            <div class="filter-options">
                <label><input type="radio" name="type" value="wedding"> Wedding</label>
                <label><input type="radio" name="type" value="baby shower"> Baby Shower</label>
                <label><input type="radio" name="type" value="birthday"> Birthday</label>
                <label><input type="radio" name="type" value="bachelorette"> Bachelorette</label>
                <label><input type="radio" name="type" value="" checked> Any</label>
            </div>

            <button class="filter-btn-apply">Apply Filter</button>
        </div>
    </div>

    <!-- Search -->
    <div class="search-container">
        <input type="text" id="searchInput" class="search-bar" placeholder="Search by name">
        <button class="filter-btn"><i class="fas fa-filter"></i></button>
    </div>

    <!-- Venue Cards -->
    <div id="venueList" class="venue-container">
        <%
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                con = DBConnection.getConnection();
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT * FROM decorations");

                while (rs.next()) {
                    String id = rs.getString("id");
                    String venueName = rs.getString("name");
                    String venueCity = rs.getString("location");
                    String venuePrice = rs.getString("price");
                    String venueImage = rs.getString("image_paths");
                    String venueCategory = rs.getString("category"); // Added category
        %>
        <div class="venue-card" 
             data-name="<%=venueName.toLowerCase()%>" 
             data-city="<%=venueCity.toLowerCase()%>" 
             data-price="<%=venuePrice%>"
             data-category="<%=venueCategory != null ? venueCategory.toLowerCase() : ""%>">
            <div class="venue-info">
                <img src="<%= venueImage != null && !venueImage.isEmpty() ? request.getContextPath() + "/uploads/" + venueImage : request.getContextPath() + "/images/default-venue.jpg" %>" alt="Venue">
                <div class="venue-details">
                    <h3><%= venueName %></h3>
                    <p><i class="fas fa-map-marker-alt"></i> <%= venueCity %></p>
                    <p><i class="fa-solid fa-indian-rupee-sign"></i> Price: <%= venuePrice %></p>
                    <p><i class="fas fa-tag"></i> Category: <%= venueCategory != null ? venueCategory : "Not specified" %></p>
                </div>
            </div>
            <button class="view-btn" onclick="window.location.href='Decdetail.jsp?id=<%= id %>'">View</button>
        </div>
        <% 
                }
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
    </div>
</div>

<%@ include file="Footer.jsp" %>

<script>
    // Open filter popup
    document.querySelector(".filter-btn").addEventListener("click", () => {
        document.getElementById("filter-popup").style.display = "block";
    });

    // Close popup
    document.querySelector(".close-btn").addEventListener("click", () => {
        document.getElementById("filter-popup").style.display = "none";
    });

    // Close popup when clicking outside
    window.addEventListener('click', (e) => {
        if (e.target === document.getElementById('filter-popup')) {
            document.getElementById('filter-popup').style.display = 'none';
        }
    });

    // Filter logic
    document.querySelector(".filter-btn-apply").addEventListener("click", () => {
        const city = document.getElementById("filterCity").value.toLowerCase();
        const capacity = document.getElementById("filterCapacity").value;
        const minPrice = parseInt(document.getElementById("minPrice").value) || 0;
        const maxPrice = parseInt(document.getElementById("maxPrice").value) || Infinity;
        const type = document.querySelector('input[name="type"]:checked')?.value.toLowerCase();

        document.querySelectorAll(".venue-card").forEach(card => {
            const venueCity = card.dataset.city;
            const venuePrice = parseInt(card.dataset.price);
            const venueCategory = card.dataset.category;

            let matches = true;
            
            // City filter
            if (city && !venueCity.includes(city)) matches = false;
            
            // Price filter
            if (venuePrice < minPrice || venuePrice > maxPrice) matches = false;
            
            // Type filter
            if (type && type !== "" && venueCategory !== type) matches = false;

            card.style.display = matches ? "flex" : "none";
        });

        document.getElementById("filter-popup").style.display = "none";
    });

    // Search logic
    document.getElementById("searchInput").addEventListener("input", function () {
        const searchTerm = this.value.toLowerCase();
        document.querySelectorAll(".venue-card").forEach(card => {
            const name = card.dataset.name;
            if (name.includes(searchTerm)) {
                card.style.display = "flex";
            } else {
                card.style.display = "none";
            }
        });
    });
</script>

</body>
</html>