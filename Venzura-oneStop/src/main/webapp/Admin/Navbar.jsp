<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display&family=Poppins:wght@300;400&display=swap" rel="stylesheet">
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Playfair Display', serif;
        }
.logo{
font-size: 30px;
}
        body {
            display: flex;
            min-height: 100vh;
            background-color: #ffffff;
            height: 1500px;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 207px;
            height: 100vh;
            background-color: #181818;
            color: white;
            padding-top: 10px;
            position: fixed;
            left: 0;
            top: 0;
            transition: width 0.3s ease;
            overflow-x: hidden;
        }

        .sidebar.collapsed {
            width: 60px; /* Collapse sidebar */
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin-top: 50px;
        }

        .sidebar ul li {
            padding: 15px 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 20px;
            color: white;
            cursor: pointer;
            transition: 0.3s;
            white-space: nowrap;
            position: relative;
        }

        .sidebar ul li:hover {
            background-color: #333;
        }

        .sidebar ul li i {
            font-size: 20px;
        }

        /* Hide text when collapsed */
        .sidebar.collapsed ul li span {
            display: none;
        }

        /* Modifications Dropdown */
        .dropdown {
            display: none;
            flex-direction: column;
            background-color: #222;
            padding-left: 40px;
        }

        .dropdown.show {
            display: flex;
        }

        .dropdown li {
            padding: 7px 0;
            font-size: 14px;
            color: white;
            cursor: pointer;
        }

        .dropdown li:hover {
            background-color: #333;
        }

        /* Navbar Styling */
        .navbar {
            width: 100%;
            height: 60px;
            background-color: white;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 50px;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
        }

        .menu-icon {
            font-size: 25px;
            cursor: pointer;
            color: black;
            margin-right: 20px;
        }

        .profile-icon {
            width: 35px;
            height: 35px;
            background-color: black;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        .profile-icon img {
            width: 20px;
            height: 20px;
            filter: invert(100%);
        }

        /* Content Area */
        .content {
            margin-left: 250px;
            padding: 80px 20px;
            transition: margin-left 0.3s ease;
            width: 100%;
        }

        .content.shifted {
            margin-left: 80px; /* Adjust content margin when sidebar collapses */
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <ul>
        <li onclick="redirectToDas()"><i class="fas fa-home"></i> <span>Dashboard</span></li>
        <li onclick="redirectToDec()"><i class="fas fa-star"></i> <span>Decorator</span></li>
        <li onclick="redirectToVenue()"><i class="fas fa-file-alt"></i> <span>Venue</span></li>
        <li onclick="redirectToM()"><i class="fas fa-circle"></i> <span>Music/Host</span></li>
        <li onclick="redirectToPay()"><i class="fas fa-credit-card"></i> <span>Payments</span></li>
        <li onclick="redirectToRole()"><i class="fas fa-user"></i> <span>Roles</span></li>
         <li onclick="redirectToCategory()"><i class="fas fa-user"></i> <span>Category</span></li>

        <!-- Modifications Dropdown -->
        <li onclick="toggleModificationsDropdown()">
            <i class="fas fa-pencil-alt"></i> <span>Modifications</span>
        </li>
        <ul class='dropdown' id='modificationsDropdown'>
            <li onclick="redirectToChangeHome()">Home</li>
            <li onclick="redirectToChangeAbout()">About</li>
        </ul>
    </ul>
</div>

<!-- Navbar -->
<nav class="navbar">
    <i class="fas fa-bars menu-icon" onclick="toggleSidebar()"></i>
    <div class="logo">Venzura</div>
    <div class="profile-icon" onclick="redirectToAccount()">
        <img src="https://img.icons8.com/ios-filled/50/user.png" alt="Profile">
    </div>
</nav>

<!-- JavaScript -->
<script>
function toggleModificationsDropdown() {
    let dropdown = document.getElementById("modificationsDropdown");
    dropdown.classList.toggle("show");
}

function toggleSidebar() {
    let sidebar = document.getElementById("sidebar");
    let content = document.querySelector(".content");

    sidebar.classList.toggle("collapsed");
    content.classList.toggle("shifted");
}

// Redirect Functions
function redirectToVenue() { window.location.href = "Venue.jsp"; }
function redirectToDec() { window.location.href = "Decorators.jsp"; }
function redirectToPay() { window.location.href = "Payment.jsp"; }
function redirectToRole() { window.location.href = "Role.jsp"; }
function redirectToChangeHome() { window.location.href = "ChangeHome.jsp"; }
function redirectToChangeAbout() { window.location.href = "ChangeAbout.jsp"; }
function redirectToM() { window.location.href = "Musician.jsp"; }
function redirectToAccount() { window.location.href = "Account.jsp"; }
function redirectToDas() { window.location.href = "Home.jsp"; }
function redirectToCategory() {window.location.href = "Category.jsp;"}
</script>

</body>
</html>



