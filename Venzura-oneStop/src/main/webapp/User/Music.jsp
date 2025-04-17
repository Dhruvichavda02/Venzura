<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Music Hosts List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
    .venue-list-container {
        font-family: Arial, sans-serif;
        background-color: #ffffff;
        padding: 20px;
        padding-bottom: 100px; 
    }

    .search-container {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-bottom: 20px;
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
        margin-left: 10px;
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
        align-items: center;
        background: #f0f3f5;
        border-radius: 10px;
        padding: 15px;
        width: 80%;
        max-width: 800px;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
        margin-top: 50px;
    }

    .venue-card img {
        width: 150px;
        height: 100px;
        border-radius: 10px;
        object-fit: cover;
        margin-right: 20px;
    }

    .venue-details {
        flex-grow: 1;
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
    }

    .view-btn:hover {
        background-color: #444;
    }

    .separator {
        width: 100%;
        height: 1px;
        background: #00000059;
        margin: 30px 0;
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

    .filter-content {
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

    .loading-spinner {
        display: flex;
        justify-content: center;
        padding: 30px;
    }

    .spinner {
        border: 4px solid rgba(0, 0, 0, 0.1);
        border-radius: 50%;
        border-top: 4px solid #000;
        width: 30px;
        height: 30px;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .no-results {
        text-align: center;
        padding: 50px;
        color: #777;
    }
    </style>
</head>
<body>
    <%@ include file="Navbar.jsp" %>
    <%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>

    <div class="venue-list-container">
        <!-- Filter Popup -->
        <div id="filter-popup" class="filter-popup">
            <div class="filter-content">
                <span class="close-btn">&times;</span>
                <label>Price</label>
                <input type="range" min="0" max="100000" class="price-slider" id="price-range">
                <span id="price-value">All Prices</span>
                
                <label>City</label>
                <input type="text" class="filter-input" id="city-filter" placeholder="Enter city">

                <label>Filter By</label>
                <select id="filter-category" class="filter-input">
                    <option value="">Select</option>
                    <option value="music">Music</option>
                    <option value="host">Host</option>
                </select>

                <div class="filter-options" id="music-options" style="display: none;">
                    <input type="radio" id="classical-music" name="music-type" value="classical">
                    <label for="classical-music">Classical Music</label>
                    <input type="radio" id="dj" name="music-type" value="dj">
                    <label for="dj">DJ</label>
                </div>

                <div class="filter-options" id="host-options" style="display: none;">
                    <input type="radio" id="male-host" name="host-type" value="male">
                    <label for="male-host">Male</label>
                    <input type="radio" id="female-host" name="host-type" value="female">
                    <label for="female-host">Female</label>
                </div>

                <button class="filter-btn-apply" id="apply-filters">Filter</button>
            </div>
        </div>
    
        <!-- Search Bar -->
        <div class="search-container">
            <input type="text" class="search-bar" id="search-input" placeholder="Search music hosts...">
            <button class="filter-btn"><i class="fas fa-filter"></i></button>
        </div>

        <!-- Loading Spinner -->
        <div class="loading-spinner" id="loading-spinner">
            <div class="spinner"></div>
        </div>

        <!-- Venue List Container -->
       <div class="venue-container" id="venue-container">
    <% 
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM music_hosts";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String name = rs.getString("name");
                String location = rs.getString("location");
                String description = rs.getString("description");
                int price = rs.getInt("price");
                String imagePaths = rs.getString("image_paths"); // Changed to match your column name
                int id = rs.getInt("id");
                
                // Handle multiple images (take first image if multiple)
                String[] imageArray = {};
                if (imagePaths != null && !imagePaths.trim().isEmpty()) {
                    imageArray = imagePaths.split(",");
                }
                String primaryImage = imageArray.length > 0 ? imageArray[0].trim() : "images/default-music-host.jpg";
                
                // Fix image path if it starts with ../
                if (primaryImage.startsWith("../")) {
                    primaryImage = primaryImage.substring(3);
                }
    %>
    <div class="venue-card">
        <img src="<%= request.getContextPath() %>/<%= primaryImage %>" 
             alt="<%= name %>"
             onerror="this.src='<%= request.getContextPath() %>/images/default-music-host.jpg'">
        <div class="venue-details">
            <h3><%= name %></h3>
            <p><i class="fas fa-map-marker-alt"></i> <%= location %></p>
            <div class="venue-meta">
                <span class="category"><%= description != null ? description : "Professional music service" %></span>
            </div>
            <p><strong>Price:</strong> <%= price %></p>
        </div>
        <button class="view-btn" onclick="window.location.href='MusicDetail.jsp?id=<%= id %>'">View</button>
    </div>
    <%
            }
        } catch(Exception e) {
            out.println("<div class='no-results'>Error loading music hosts: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    %>
</div>

        <div class="no-results" id="no-results" style="display: none;">
            No music hosts found matching your criteria.
        </div>
    </div>
     
    <div class="separator"></div>
    <%@ include file="Footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const filterPopup = document.getElementById("filter-popup");
    const filterButton = document.querySelector(".filter-btn");
    const closeButton = document.querySelector(".close-btn");
    const priceSlider = document.getElementById("price-range");
    const priceValue = document.getElementById("price-value");
    const searchInput = document.getElementById("search-input");
    const loadingSpinner = document.getElementById("loading-spinner");
    const noResults = document.getElementById("no-results");
    const venueContainer = document.getElementById("venue-container");
    const applyFiltersBtn = document.getElementById("apply-filters");

    // Hide spinner after page loads
    loadingSpinner.style.display = "none";

    // Price slider update
    priceSlider.addEventListener("input", function() {
        if(this.value === this.max) {
            priceValue.textContent = "All Prices";
        } else {
            priceValue.textContent = "₹" + this.value;
        }
    });

    // Show/hide filter popup
    filterButton.addEventListener("click", function() {
        filterPopup.style.display = "block";
    });
    
    closeButton.addEventListener("click", function() {
        filterPopup.style.display = "none";
    });
    
    window.addEventListener("click", function(event) {
        if (event.target === filterPopup) {
            filterPopup.style.display = "none";
        }
    });

    // Filter category selection
    const filterCategory = document.getElementById("filter-category");
    const musicOptions = document.getElementById("music-options");
    const hostOptions = document.getElementById("host-options");

    filterCategory.addEventListener("change", function() {
        if (this.value === "music") {
            musicOptions.style.display = "flex";
            hostOptions.style.display = "none";
        } else if (this.value === "host") {
            musicOptions.style.display = "none";
            hostOptions.style.display = "flex";
        } else {
            musicOptions.style.display = "none";
            hostOptions.style.display = "none";
        }
    });

    // Search functionality
    searchInput.addEventListener("input", function() {
        const searchTerm = this.value.toLowerCase();
        const venueCards = document.querySelectorAll(".venue-card");
        let visibleCount = 0;

        venueCards.forEach(card => {
            const name = card.querySelector("h3").textContent.toLowerCase();
            const location = card.querySelector(".venue-details p").textContent.toLowerCase();
            const description = card.querySelector(".category").textContent.toLowerCase();
            
            if (name.includes(searchTerm) || location.includes(searchTerm) || description.includes(searchTerm)) {
                card.style.display = "flex";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });

        noResults.style.display = visibleCount === 0 ? "block" : "none";
    });

    // Apply filters button
    applyFiltersBtn.addEventListener("click", function() {
        filterPopup.style.display = "none";
        const priceFilter = parseInt(priceSlider.value);
        const cityFilter = document.getElementById("city-filter").value.toLowerCase();
        const categoryFilter = filterCategory.value;
        const musicTypeFilter = document.querySelector('input[name="music-type"]:checked')?.value;
        const hostTypeFilter = document.querySelector('input[name="host-type"]:checked')?.value;

        const venueCards = document.querySelectorAll(".venue-card");
        let visibleCount = 0;

        venueCards.forEach(card => {
            const price = parseInt(card.querySelector(".venue-details p:last-child").textContent.replace(/[^\d]/g, ''));
            const location = card.querySelector(".venue-details p").textContent.toLowerCase();
            const category = card.dataset.category || '';
            const type = card.dataset.type || '';

            const priceMatch = priceSlider.value === priceSlider.max || price <= priceFilter;
            const cityMatch = cityFilter === '' || location.includes(cityFilter);
            const categoryMatch = categoryFilter === '' || category === categoryFilter;
            const typeMatch = (categoryFilter !== 'music' && categoryFilter !== 'host') || 
                             (categoryFilter === 'music' && (!musicTypeFilter || type === musicTypeFilter)) ||
                             (categoryFilter === 'host' && (!hostTypeFilter || type === hostTypeFilter));

            if (priceMatch && cityMatch && categoryMatch && typeMatch) {
                card.style.display = "flex";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });

        noResults.style.display = visibleCount === 0 ? "block" : "none";
    });
});
</script>
</body>
</html>