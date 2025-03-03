<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Reset styles */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
            background-color: black;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: #333;
            color: white;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }

        .sidebar li {
            padding: 15px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 18px;
            transition: background 0.3s;
        }

        .sidebar li:hover {
            background-color: #575757;
        }

        /* Logout Button */
        .logout-section {
            text-align: center;
            margin-bottom: 20px;
        }

        .logout-section li {
            list-style: none;
            padding: 15px 20px;
            font-size: 18px;
            color: white;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
            background-color: black;
            border-radius: 5px;
        }

        .logout-section li:hover {
            background-color: #d9534f;
        }

        /* Profile Page Styles */
        .profile-page {
            margin-left: 250px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            width: calc(100% - 250px);
        }

        .profile-container {
            background-color: white;
            width: 90%;
            max-width: 600px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .profile-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .profile-header h2 {
            margin: 0;
            font-size: 24px;
        }

        .profile-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .profile-info img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }

        .profile-info div {
            text-align: left;
        }

        .profile-info p {
            margin: 3px 0;
            font-size: 14px;
        }

        .profile-details {
            text-align: left;
            font-size: 16px;
        }

        .profile-details div {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }

        .save-button {
            background-color: black;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
     <%@ include file="Navbar.jsp" %>

    <!-- Profile Page -->
    <div class="profile-page">
        <div class="profile-container">
            <div class="profile-header">
                <h2>Edit Profile</h2>
            </div>
            <div class="profile-info">
                <img src="profile.jpg" alt="Profile Picture">
                <div>
                    <p>Your Name</p>
                    <p>yourname@gmail.com</p>
                </div>
            </div>
            <div class="profile-details">
                <div>
                    <span>Name</span>
                    <span>Your Name</span>
                </div>
                <div>
                    <span>Email account</span>
                    <span>yourname@gmail.com</span>
                </div>
                <div>
                    <span>Mobile number</span>
                    <span>1234567890</span>
                </div>
            </div>
            <button class="save-button">Save Changes</button>
        </div>
    </div>

    <!-- Logout Section -->
    <div class="logout-section">
        <li onclick="logout()">
            <i class="fas fa-sign-out-alt"></i> Logout
        </li>
    </div>

    <!-- JavaScript -->
    <script>
        function redirectToDec() {
            window.location.href = "Decorator.jsp";
        }

        function redirectToVenue() {
            window.location.href = "Venue.jsp";
        }

        function redirectToM() {
            window.location.href = "MusicHost.jsp";
        }

        function redirectToPay() {
            window.location.href = "Payments.jsp";
        }

        function redirectToRole() {
            window.location.href = "Roles.jsp";
        }

        function redirectToProfile() {
            window.location.href = "Profile.jsp";
        }

        function logout() {
            if (confirm("Are you sure you want to log out?")) {
                window.location.href = "Logout.jsp"; // Change to your logout page
            }
        }
    </script>
</body>
</html>
