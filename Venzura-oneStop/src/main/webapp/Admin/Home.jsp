<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600&display=swap" rel="stylesheet">
   
<style>
/* Ensure body takes full screen height and removes scrolling */
html, body {
    font-family: 'Playfair Display', serif;
    background-color: white;
    text-align: center;
    height: 100vh;
    margin: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    overflow: hidden; /* Prevent scrolling */
    width: 1460px;
}

h1 {
    font-size: 32px;
    margin-bottom: 37px;
    text-align: center;
}

.dashboard {
    display: grid;
    grid-template-columns: repeat(3, minmax(200px, 1fr)); /* 3 cards per row */
    gap: 110px; /* Space between cards */
    max-width: 800px; /* Adjusted width to prevent excessive stretching */
    padding: 20px;
}

.card {
    width: 200px; /* Reduced width */
    background-color: #e3eaea;
    padding: 15px; /* Adjust padding for better proportion */
    border-radius: 10px;
    box-shadow: 2px 4px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    transition: transform 0.3s ease-in-out;
}

.card:hover {
    transform: scale(1.05);
}


.card i {
    font-size: 30px;
    color: black;
}

.card span {
    display: block;
    font-size: 24px;
    font-weight: bold;
    margin: 10px 0;
}

.card p {
    font-size: 16px;
    color: black;
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .dashboard {
        grid-template-columns: repeat(2, minmax(250px, 1fr)); /* 2 cards per row */
    }
}

@media screen and (max-width: 480px) {
    .dashboard {
        grid-template-columns: repeat(1, minmax(250px, 1fr)); /* 1 card per row */
    }

    h1 {
        font-size: 24px;
    }

    .card span {
        font-size: 20px;
    }

    .card p {
        font-size: 14px;
    }
}
</style>
</head>
<body>
<%@ include file="Navbar.jsp" %>

    <h1>Welcome Admin</h1> 

    <div class="dashboard">
        <div class="card" onclick="window.location.href='Role.jsp'" style="cursor: pointer;">
    <i class="fas fa-user-tie"></i>
    <span>2</span>
    <p>Admin</p>
</div>
        <div class="card">
            <i class="fas fa-user" onclick="window.location.href='Role.jsp'" style="cursor: pointer;"></i>
            <span>222</span>
            <p>Users</p>
        </div>
        <div class="card">
            <i class="fas fa-dollar-sign" onclick="window.location.href='Payment.jsp'" style="cursor: pointer;"></i>
            <span>222K</span>
            <p>Payment</p>
        </div>
        <div class="card">
            <i class="fas fa-music"  onclick="window.location.href='MusicBooked.jsp'"></i>
            <span>12</span>
            <p>Musician/Host</p>
        </div>
        <div class="card">
            <i class="fas fa-landmark" onclick="window.location.href='VenueBooked.jsp'"></i>
            <span>222</span>
            <p>Booked Venue</p>
        </div>
        <div class="card">
            <i class="fas fa-palette"  onclick="window.location.href='DecBooked.jsp'"></i>
            <span>12</span>
            <p>Decorators</p>
        </div>
    </div>

</body>
</html>
