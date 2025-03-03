<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
 			font-family: 'Playfair Display', serif;        }
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
        .left-panel h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .left-panel p {
            font-size: 14px;
            max-width: 300px;
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
    <div class="container">
        <div class="left-panel">
            <h1>Venzura</h1>
            <p>Your One-Stop Destination for Venues, Vibes and Visions</p>
        </div>
        <div class="right-panel">
            <h2>Sign in to Venzura</h2>
            <img src="https://img.icons8.com/color/48/000000/google-logo.png" alt="Google Sign In" width="30">
            <p>or use your email account</p>
            <input type="email" placeholder="Email" class="input-box">
            <input type="password" placeholder="Password" class="input-box">
            <p class="forgot-password">Forgot your password?</p>
            <button onclick="window.location.href='Home.jsp'">Sign In</button>
        </div>
    </div>
</body>
</html>