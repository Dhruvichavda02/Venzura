<%@ page import="java.sql.*" %>
<%@ page import="com.venzura.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* Your styles here */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .content {
            padding: 40px;
            max-width: 800px;
            margin: auto;
        }

        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group input[type="file"],
        .form-group textarea {
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fafafa;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #0066ff;
            background-color: #fff;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .edit-btn {
            background-color: black;
            color: white;
            padding: 12px 20px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
            width: 100%;
        }

        .edit-btn:hover {
            background-color: #0052cc;
        }

        .upload-box {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
            padding: 10px;
            border: 2px dashed #ccc;
            border-radius: 8px;
            margin-bottom: 10px;
            background-color: #f0f0f0;
        }

        .upload-box img {
            max-width: 180px;
            max-height: 180px;
            object-fit: cover;
            border: 1px solid #ccc;
            border-radius: 6px;
            padding: 5px;
        }

        .error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
        }

        input:invalid,
        textarea:invalid {
            border-color: #e74c3c;
        }

        input:valid,
        textarea:valid {
            border-color: #2ecc71;
        }

        small {
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>

    <div class="content" id="content">
        <div class="form-container">
            <form id="venueForm" action="../UpdateVenueServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <%
                    // Database connection and data retrieval
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        // Get venue ID from request parameter
                        String venueId = request.getParameter("id");
                        
                        con = DBConnection.getConnection();
                        
                        // Prepare SQL query
                        String sql = "SELECT * FROM venues WHERE id = ?";
                        pstmt = con.prepareStatement(sql);
                        pstmt.setString(1, venueId);
                        
                        // Execute query
                        rs = pstmt.executeQuery();
                        
                        if (rs.next()) {
                %>
                <input type="hidden" name="venue_id" value="<%= rs.getString("id") %>">
                
                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= rs.getString("name") %>" required 
                           pattern="[A-Za-z0-9 ]{3,50}" title="Name should be 3-50 characters (letters, numbers, spaces)">
                    <div id="nameError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Capacity:</label>
                    <input type="number" name="capacity" value="<%= rs.getString("capacity") %>" required 
                           min="10" max="10000">
                    <div id="capacityError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Location:</label>
                    <input type="text" name="location" value="<%= rs.getString("location") %>" required
                           pattern="[A-Za-z0-9 ,.-]{5,100}" title="Location should be 5-100 characters">
                    <div id="locationError" class="error"></div>
                </div>
                
                <div class="form-group">
                    <label>Contact Number:</label>
                    <input type="text" name="contact_phone" value="<%= rs.getString("contact_phone") %>" required
                           pattern="[0-9]{10,15}" title="Phone number should be 10-15 digits">
                    <div id="phoneError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Amenities:</label>
                    <textarea name="amenities" required minlength="10" maxlength="500"><%= rs.getString("amenities") %></textarea>
                    <div id="amenitiesError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Amount:</label>
                    <input type="number" name="price" value="<%= rs.getString("price") %>" required 
                           min="100" step="0.01">
                    <div id="priceError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Description:</label>
                    <textarea name="description" required minlength="20" maxlength="1000"><%= rs.getString("description") %></textarea>
                    <div id="descriptionError" class="error"></div>
                </div>

                <div class="form-group">
                    <label>Upload Image:</label>
                    <div class="upload-box">
                        <% if (rs.getString("image_paths") != null && !rs.getString("image_paths").isEmpty()) { %>
                            <img id="venueImage" src="../<%= rs.getString("image_paths") %>" alt="Venue Image" style="max-width: 200px; max-height: 200px; display: block;">
                        <% } else { %>
                            <img id="venueImage" src="" alt="No Image" style="max-width: 200px; max-height: 200px; display: none;">
                        <% } %>
                        <input type="file" name="image" id="imageUpload" accept="image/*" onchange="previewImage(this)">
                    </div>
                    <small>Please upload square image, size less than 100KB</small>
                    <div id="imageError" class="error"></div>
                </div>

                <button type="submit" class="edit-btn">Update</button>
                <%
                        } else {
                            out.println("<p>Venue not found</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Error retrieving venue data: " + e.getMessage() + "</p>");
                    } finally {
                        // Close resources
                        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </form>
        </div>
    </div>

    <script>
        // Your JavaScript logic for form validation and image preview goes here
        function previewImage(input) {
            const imagePreview = document.getElementById('venueImage');
            const file = input.files[0];
            
            if (file) {
                // Check file size (100KB limit)
                if (file.size > 100000) {
                    document.getElementById('imageError').textContent = 'Image must be less than 100KB';
                    input.value = ''; // Clear the file input
                    return;
                }
                
                // Check if it's an image
                if (!file.type.match('image.*')) {
                    document.getElementById('imageError').textContent = 'Please select an image file';
                    input.value = ''; // Clear the file input
                    return;
                }
                
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                    document.getElementById('imageError').textContent = '';
                }
                
                reader.readAsDataURL(file);
            }
        }

        function validateForm() {
            let isValid = true;
            
            // Clear previous errors
            document.querySelectorAll('.error').forEach(el => el.textContent = '');
            
            // Validate Name
            const name = document.querySelector('input[name="name"]');
            if (!name.checkValidity()) {
                document.getElementById('nameError').textContent = 'Name must be 3-50 characters (letters, numbers, spaces)';
                isValid = false;
           
        // Validate Capacity
        const capacity = document.querySelector('input[name="capacity"]');
        if (!capacity.checkValidity()) {
            document.getElementById('capacityError').textContent = 'Capacity should be between 10 and 10000';
            isValid = false;
        }

        // Validate Location
        const location = document.querySelector('input[name="location"]');
        if (!location.checkValidity()) {
            document.getElementById('locationError').textContent = 'Location should be 5-100 characters';
            isValid = false;
        }

        // Validate Contact Phone
        const contactPhone = document.querySelector('input[name="contact_phone"]');
        if (!contactPhone.checkValidity()) {
            document.getElementById('phoneError').textContent = 'Phone number should be 10-15 digits';
            isValid = false;
        }

        // Validate Amenities
        const amenities = document.querySelector('textarea[name="amenities"]');
        if (!amenities.checkValidity()) {
            document.getElementById('amenitiesError').textContent = 'Amenities should be between 10 and 500 characters';
            isValid = false;
        }

        // Validate Price
        const price = document.querySelector('input[name="price"]');
        if (!price.checkValidity()) {
            document.getElementById('priceError').textContent = 'Price should be at least 100';
            isValid = false;
        }

        // Validate Description
        const description = document.querySelector('textarea[name="description"]');
        if (!description.checkValidity()) {
            document.getElementById('descriptionError').textContent = 'Description should be between 20 and 1000 characters';
            isValid = false;
        }

        return isValid;
    }
</script>
           </body>
           </html>