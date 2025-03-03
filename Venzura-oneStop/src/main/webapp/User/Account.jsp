<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
      /* Reset global styles to prevent interference */
body {
    margin: 0;
    font-family: Arial, sans-serif;
}

/* Apply styles only within .profile-page */
.profile-page {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: black;
}

/* Ensure styles apply only inside .profile-container */
.profile-page .profile-container {
    background-color: white;
    width: 90%;
    max-width: 600px;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    text-align: center;
}

.profile-page .profile-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
}

.profile-page .profile-header h2 {
    margin: 0;
    font-size: 24px;
}

.profile-page .profile-header i {
    font-size: 20px;
    cursor: pointer;
}

.profile-page .profile-info {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 15px;
    margin-bottom: 20px;
}

.profile-page .profile-info img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
}

.profile-page .profile-info div {
    text-align: left;
}

.profile-page .profile-info p {
    margin: 3px 0;
    font-size: 14px;
}

.profile-page .profile-details {
    text-align: left;
    font-size: 16px;
}

.profile-page .profile-details div {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid #ddd;
}

.profile-page .save-button {
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
    <%@ include file="Navbar.jsp" %>
    
    <div class="profile-page">
        <div class="profile-container">
            <div class="profile-header">
                <h2>Edit Profile</h2>
            <i class="fas fa-save" onclick="navigateToBooking()"></i>

<script>
    function navigateToBooking() {
        window.location.href = 'UserBooking.jsp';
    }
</script>

            </div>
            <div class="profile-info">
                <img src="../images/joey.jpg" alt="Profile Picture">
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
            <button class="save-button">Save Change</button>
        </div>
    </div>

    <%@ include file="Footer.jsp" %>
</body>

</html>
