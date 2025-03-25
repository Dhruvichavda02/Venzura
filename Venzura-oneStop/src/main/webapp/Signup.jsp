	<%@ page language="java" contentType="text/html; charset=UTF-8"
	    pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>Venzura</title>
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
	            overflow: hidden;
	        }
	        .container {
	            display: flex;
	            width: 100vw;
	            height: 100vh;
	            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	            border-radius: 0;
	            overflow: hidden;
	            background: #fff;
	        }
	        .left-panel {
	            background: #1e1e1e;
	            color: #fff;
	            padding: 50px;
	            flex: 1;
	            display: flex;
	            flex-direction: column;
	            justify-content: center;
	            align-items: center;
	            text-align: center;
	        }
	        .left-panel h2 {
	            margin-bottom: 20px;
	        }
	        .left-panel button {
	            background: #fff;
	            color: #000;
	            padding: 10px 20px;
	            border: none;
	            cursor: pointer;
	            border-radius: 5px;
	            margin-top: 10px;
	        }
	        .left-panel button:hover {
	            background: #ccc;
	        }
	        .right-panel {
	            flex: 1;
	            padding: 50px;
	            display: flex;
	            flex-direction: column;
	            justify-content: center;
	            align-items: center;
	            text-align: center;
	        }
	        .input-box {
	            width: 100%;
	            max-width: 300px;
	            margin: 10px 0;
	            padding: 10px;
	            border: none;
	            background: #ddd;
	            border-radius: 5px;
	        }
	        .right-panel button {
	            background: black;
	            color: white;
	            padding: 10px 20px;
	            border: none;
	            cursor: pointer;
	            border-radius: 5px;
	            margin-top: 10px;
	        }
	        .forgot-password {
	            font-size: 12px;
	            margin-top: 5px;
	        }
	        @media (max-width: 768px) {
	            .container {
	                flex-direction: column;
	            }
	            .left-panel, .right-panel {
	                width: 100%;
	                padding: 30px;
	            }
	        }
	    </style>
	</head>
	<body>
	<form action="/Venzura-oneStop/SignupServlet" method="post" onsubmit="return validateForm()">
    <div class="container">
        <div class="left-panel">
            <h2>Start New Journey!</h2>
            <p>Already have an account?</p>
            <button type="button" onclick="window.location.href='Login.jsp'">Sign In</button>
        </div>
        <div class="right-panel">
            <h2>Create Account</h2>

            <input type="text" id="name" placeholder="Name" class="input-box" name="name">
            <div id="nameError" class="error" style="display:none; color:red;">Name is required</div>

            <input type="email" id="email" placeholder="Email" class="input-box" name="email">
            <div id="emailError" class="error" style="display:none; color:red;">Enter a valid email</div>

            <input type="password" id="password" placeholder="Password" class="input-box" name="pass">
            <div id="passwordError" class="error" style="display:none; color:red;">Password must be at least 6 characters</div>

            <input type="text" id="phone" placeholder="Phone Number" class="input-box" name="num">
            <div id="phoneError" class="error" style="display:none; color:red;">Phone number must be exactly 10 digits</div>

   

            <!-- THIS BUTTON SUBMITS THE FORM, AND VALIDATION WILL PREVENT SUBMISSION -->
            <button type="submit">Sign Up</button>
        </div>
    </div>
</form>
	
	    <% 
	    String message = (String) request.getAttribute("message");
	    String successMessage = (String) request.getAttribute("successMessage");
	%>
	
	<script>
	    window.onload = function() {
	        <% if (message != null) { %>
	            alert("<%= message %>");
	        <% } %>
	        <% if (successMessage != null) { %>
	            alert("<%= successMessage %>");
	        <% } %>
	    };
	    
	    function validateForm() {
	        let isValid = true;

	        // Name validation
	        let name = document.getElementById("name").value.trim();
	        if (name === "") {
	            document.getElementById('nameError').style.display = "block";
	            isValid = false;
	        } else {
	            document.getElementById('nameError').style.display = "none";
	        }

	        // Email validation
	        let email = document.getElementById('email').value.trim();
	        let emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
	        if (!email.match(emailPattern)) {
	            document.getElementById('emailError').style.display = "block";
	            isValid = false;
	        } else {
	            document.getElementById('emailError').style.display = "none";
	        }

	        // Password validation
	        let password = document.getElementById('password').value.trim();
	        if (password.length < 6) {
	            document.getElementById('passwordError').style.display = "block";
	            isValid = false;
	        } else {
	            document.getElementById('passwordError').style.display = "none";
	        }

	        // Phone number validation
	        let num = document.getElementById('phone').value.trim();
	        let numPattern = /^[0-9]{10}$/;
	        if (!num.match(numPattern)) {
	            document.getElementById('phoneError').style.display = "block";
	            isValid = false;
	        } else {
	            document.getElementById('phoneError').style.display = "none";
	        }

	        // If isValid is false, prevent form submission
	        return isValid;
	    }


	</script>
	
	   
	</body>
	
	</html>