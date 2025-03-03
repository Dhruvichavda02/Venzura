<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura </title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display&family=Poppins:wght@300;400&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Playfair Display', serif;
        }
        body {
            background-color: ##ffffff;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 50px;
            background-color: white;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        .logo {
            font-size: 24px;
            font-family: 'Playfair Display', serif;
            font-weight: normal; /* Removed bold */
        }
        .nav-links {
            list-style: none;
            display: flex;
            gap: 30px;
        }
        .nav-links li {
            display: inline;
        }
        .nav-links a {
            text-decoration: none;
            color: black;
            font-size: 16px;
            font-weight: normal; /* Removed bold */
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
        .profile-icon {
            width: 35px;
            height: 35px;
            background-color: black;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .profile-icon img {
            width: 20px;
            height: 20px;
            filter: invert(100%);
        }
        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                text-align: center;
            }
            .nav-links {
                flex-direction: column;
                padding: 10px 0;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">Venzura</div>
        <ul class="nav-links">
            <li><a href="Home.jsp">Home</a></li>
            <li><a href="Venue.jsp">Venue</a></li>
            <li><a href="Decorator.jsp">Decorator</a></li>
            <li><a href="Music.jsp">Musician/Host</a></li>
            <li><a href="About.jsp">About</a></li>
        </ul>
      <div class="profile-icon" onclick="redirectToAccount()">
    <img src="https://img.icons8.com/ios-filled/50/user.png" alt="Profile">
</div>

<script>
    function redirectToAccount() {
        window.location.href = "Account.jsp";
    }
</script>


    </nav>

</body>
</html>
