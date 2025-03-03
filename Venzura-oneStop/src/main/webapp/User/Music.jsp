<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venue List</title>
    <link rel="stylesheet" href="styles.css">
    <!-- FontAwesome CDN for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
    /* Apply styles only inside .venue-list-container */
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
    display: none; /* Initially hidden */
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
    gap: 15px; /* Adds space between elements */
}

.filter-options input[type="radio"] {
    margin-right: 5px; /* Adds a little space between radio button and label */
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

/* Close Button */
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
    <!-- Filter Popup -->
<!-- Filter Popup -->
<div id="filter-popup" class="filter-popup">
    <div class="filter-content">
        <span class="close-btn">&times;</span> <!-- Close Button -->
        
        <label>Price</label>
        <input type="range" min="0" max="100" class="price-slider">
        
        <label>City</label>
        <input type="text" class="filter-input">

       

        <!-- New Filter Category -->
        <label>Filter By</label>
        <select id="filter-category" class="filter-input">
            <option value="">Select</option>
            <option value="music">Music</option>
            <option value="host">Host</option>
        </select>

        <!-- Music Options -->
        <div class="filter-options" id="music-options" style="display: none;">
            <input type="radio" id="classical-music" name="music-type">
            <label for="classical-music">Classical Music</label>
            <input type="radio" id="dj" name="music-type">
            <label for="dj">DJ</label>
        </div>

        <!-- Host Options -->
        <div class="filter-options" id="host-options" style="display: none;">
            <input type="radio" id="dl" name="host-type">
            <label for="dl">Male</label>
             <input type="radio" id="dl" name="host-type">
            <label for="dl">Female</label>
        </div>

        <button class="filter-btn-apply">Filter</button>
    </div>
</div>


    
        <!-- Search Bar -->
        <div class="search-container">
            <input type="text" class="search-bar" placeholder="Hinted search text">
            <button class="filter-btn"><i class="fas fa-filter"></i></button>
        </div>

        <!-- Venue List -->
        <div class="venue-container">
            <div class="venue-card">
    <img src="../images/images.jpg" alt="The DJ Club">
    <div class="venue-details">
        <h3>The DJ Club</h3>
        <p><i class="fas fa-map-marker-alt"></i> Rajkot</p>
        <div class="venue-meta">
            <span class="capacity"><i class="fas fa-users"></i> 8 Members</span>
            <span class="category">Ready to host various events</span>
        </div>
        <p><strong>Price:</strong> 40k</p>
    </div>
    <button class="view-btn" onclick="window.location.href='MusicDetail.jsp'">View</button>
</div> <!-- Closing the missing div -->

           <div class="venue-card">
    <img src="../images/images.jpg" alt="The DJ Club">
    <div class="venue-details">
        <h3>The DJ Club</h3>
        <p><i class="fas fa-map-marker-alt"></i> Rajkot</p>
        <div class="venue-meta">
            <span class="capacity"><i class="fas fa-users"></i> 8 Members</span>
            <span class="category">Ready to host various events</span>
        </div>
        <p><strong>Price:</strong> 40k</p>
    </div>
    <button class="view-btn" onclick="window.location.href='MusicDetail.jsp'">View</button>
</div> <!-- Closing the missing div -->

        </div>
    </div>
     
      <div class="separator"></div>
 <%@ include file="Footer.jsp" %>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const filterPopup = document.getElementById("filter-popup");
    const filterButton = document.querySelector(".filter-btn");
    const closeButton = document.querySelector(".close-btn");

    // Show the filter popup when filter button is clicked
    filterButton.addEventListener("click", function() {
        filterPopup.style.display = "block";
    });

    // Hide the filter popup when close button is clicked
    closeButton.addEventListener("click", function() {
        filterPopup.style.display = "none";
    });

    // Hide the filter popup when clicking outside of it
    window.addEventListener("click", function(event) {
        if (event.target === filterPopup) {
            filterPopup.style.display = "none";
        }
    });

    // Handling category selection inside the filter
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
});


</script>




</body>
</html>
 