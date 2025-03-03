<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* Reset styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #f8f9fa;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #343a40;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            transition: 0.3s;
            padding-top: 60px;
        }

        /* Sidebar Links */
        .sidebar a {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: white;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        /* Sidebar Hidden */
        .sidebar.hidden {
            width: 0;
            overflow: hidden;
        }

        /* Content */
        .content {
            margin-left: 250px;
            padding: 20px;
            width: 100%;
            transition: margin-left 0.3s;
        }

        .content.full-width {
            margin-left: 0;
        }

        /* Form Container */
        .form-container {
            max-width: 600px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            margin: auto;
            margin-top: 20px;
        }

        /* Form Layout */
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* Form Group */
        .form-group {
            display: flex;
            flex-direction: column;
            padding:10px;
        }

        /* Labels */
        label {
            font-weight: bold;
            margin-bottom: 5px;
        }

        /* Inputs */
        input, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        /* Readonly Styling */
        input[readonly], textarea[readonly] {
            color: gray;
            background-color: #f1f1f1;
            border: 1px solid #ddd;
        }

        /* Textarea */
        textarea {
            height: 100px;
            resize: none;
        }

        /* File Upload */
        .upload-box {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f1f1f1;
            padding: 10px;
            border-radius: 5px;
            border: 1px dashed #ccc;
        }

        .upload-box img {
            width: 50px;
            height: 50px;
            object-fit: cover;
        }

        small {
            color: gray;
        }

        /* Button */
        .edit-btn {
            background-color: black;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-align: center;
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .sidebar {
                width: 0;
                overflow: hidden;
            }

            .content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

    <%@ include file="Navbar.jsp" %>

    <div class="content" id="content">
        <div class="form-container">
            <form>
                <div class="form-group">
                    <label> Name:</label>
                    <input type="text" value="Silver Sand" >
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" value="Silver@gmail.com" >
                </div>

                <div class="form-group">
                    <label> Location:</label>
                    <input type="text" value="Rajkot" >
                </div>


                <div class="form-group">
                    <label>Venue's Amount:</label>
                    <input type="text" value="5K per day" >
                </div>

                <div class="form-group">
                    <label>Policy:</label>
                    <textarea >Amazing Place</textarea>
                </div>
  <div class="form-group">
                    <label>Experience:</label>
                    <textarea >Amazing Place</textarea>
                </div>
                
                <div class="form-group">
                    <label>Upload Image:</label>
                    <div class="upload-box">
                    
                        <input type="file">
                    </div>
                    <small>Please upload square image, size less than 100KB</small>
                </div>

                <button type="button" class="edit-btn" onclick = "window.location.href='Musician.jsp'">Edit</button>
            </form>
        </div>
    </div>

    <script>
        function toggleSidebar() {
            let sidebar = document.querySelector('.sidebar');
            let content = document.getElementById('content');
            if (sidebar.classList.contains('hidden')) {
                sidebar.classList.remove('hidden');
                content.classList.remove('full-width');
            } else {
                sidebar.classList.add('hidden');
                content.classList.add('full-width');
            }
        }
    </script>

</body>
</html>
