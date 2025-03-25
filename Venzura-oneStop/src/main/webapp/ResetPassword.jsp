<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Playfair Display', serif;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            width: 100vw;
            background: #f5f5f5;
        }
        .container {
            width: 100%;
            max-width: 400px;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin: 10px 0 5px;
            text-align: left;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .error {
            color: red;
            font-size: 14px;
            display: none;
            text-align: left;
        }
        button {
            width: 100%;
            background: black;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
        button:hover {
            background: #333;
        }
        .back-link {
            display: block;
            margin-top: 15px;
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Reset Password</h2>
        <form action="ResetPasswordServlet" method="post" onsubmit="return validate()">
            <label for="otp">Enter OTP:</label>
            <input type="text" name="otp" id="otp" required>

            <label for="newPassword">New Password:</label>
            <input type="password" id="newpassword" placeholder="Password" name="newpassword">
            
            <!-- Error Messages -->
            <div id="lengthError" class="error">Password must be at least 8 characters.</div>
            <div id="uppercaseError" class="error">Password must contain at least one uppercase letter.</div>
            <div id="lowercaseError" class="error">Password must contain at least one lowercase letter.</div>
            <div id="digitError" class="error">Password must contain at least one number.</div>

            <button type="submit">Reset Password</button>
        </form>
        <a href="Login.jsp" class="back-link">Back to Login</a>
    </div>

    <script>
        function validate() {
            let password = document.getElementById('password').value.trim();
            let isValid = true;

            // Regular expressions for validation
            let hasUppercase = /[A-Z]/.test(password);
            let hasLowercase = /[a-z]/.test(password);
            let hasDigit = /\d/.test(password);
            let isCorrectLength = password.length >= 8;

            // Show/hide errors based on validation
            document.getElementById('lengthError').style.display = isCorrectLength ? "none" : "block";
            document.getElementById('uppercaseError').style.display = hasUppercase ? "none" : "block";
            document.getElementById('lowercaseError').style.display = hasLowercase ? "none" : "block";
            document.getElementById('digitError').style.display = hasDigit ? "none" : "block";

            // If any validation fails, return false to prevent form submission
            if (!isCorrectLength || !hasUppercase || !hasLowercase || !hasDigit) {
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
