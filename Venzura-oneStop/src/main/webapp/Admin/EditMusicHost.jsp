<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Music Host</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="number"],
        input[type="tel"],
        textarea,
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .upload-box {
            border: 1px dashed #ccc;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        .upload-box img {
            max-width: 200px;
            max-height: 200px;
            display: block;
            margin-top: 10px;
        }
        .submit-btn {
            background-color: #6c8c7d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .submit-btn:hover {
            background-color: #5a7b6c;
        }
        .error {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }
        .image-container {
            position: relative;
            display: inline-block;
        }
        .remove-image {
            position: absolute;
            top: -10px;
            right: -10px;
            background: red;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Edit Music Host</h1>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String musicHostId = request.getParameter("id");
            
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT * FROM music_hosts WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, musicHostId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
        %>
        <form action="../UpdateMusicHostServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="<%= rs.getString("name") %>" required>
                <div id="nameError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="type">Type:</label>
                <select id="type" name="type" required>
                    <option value="DJ" <%= "DJ".equals(rs.getString("type")) ? "selected" : "" %>>DJ</option>
                    <option value="Band" <%= "Band".equals(rs.getString("type")) ? "selected" : "" %>>Band</option>
                    <option value="Solo Artist" <%= "Solo Artist".equals(rs.getString("type")) ? "selected" : "" %>>Solo Artist</option>
                    <option value="Orchestra" <%= "Orchestra".equals(rs.getString("type")) ? "selected" : "" %>>Orchestra</option>
                </select>
                <div id="typeError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" min="100" step="0.01" 
                       value="<%= rs.getDouble("price") %>" required>
                <div id="priceError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="experience_years">Experience (Years):</label>
                <input type="number" id="experience_years" name="experience_years" min="0" 
                       value="<%= rs.getInt("experience_years") %>" required>
                <div id="experienceError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="genres">Genres (comma separated):</label>
                <input type="text" id="genres" name="genres" value="<%= rs.getString("genres") %>" required>
                <div id="genresError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="contact_phone">Contact Phone:</label>
                <input type="tel" id="contact_phone" name="contact_phone" pattern="[0-9]{10,15}" 
                       value="<%= rs.getString("contact_phone") %>" required>
                <div id="phoneError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" value="<%= rs.getString("location") %>" required>
                <div id="locationError" class="error"></div>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" required 
                          minlength="20" maxlength="1000"><%= rs.getString("description") %></textarea>
                <div id="descriptionError" class="error"></div>
            </div>

            <div class="form-group">
                <label>Current Image:</label>
                <div class="upload-box">
                    <% if (rs.getString("image_paths") != null && !rs.getString("image_paths").isEmpty()) { %>
                        <div class="image-container">
                            <img src="../<%= rs.getString("image_paths") %>" alt="Current Image" style="max-width: 200px;">
                            <button type="button" class="remove-image" onclick="markImageForRemoval(this)">×</button>
                        </div>
                        <input type="hidden" id="currentImage" name="currentImage" value="<%= rs.getString("image_paths") %>">
                        <input type="hidden" id="removeImage" name="removeImage" value="false">
                    <% } else { %>
                        <p>No image currently set</p>
                    <% } %>
                </div>
            </div>

            <div class="form-group">
                <label>Update Image:</label>
                <div class="upload-box">
                    <input type="file" id="image" name="image" accept="image/*" onchange="previewImage(this)">
                    <img id="imagePreview" src="" alt="Image Preview" style="display: none;">
                    <small>Upload new image (JPEG/PNG), max 2MB. Leave blank to keep current image.</small>
                    <div id="imageError" class="error"></div>
                </div>
            </div>

            <button type="submit" class="submit-btn">Update Music Host</button>
        </form>
        <%
                } else {
                    out.println("<p>Music host not found</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error retrieving music host data: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const errorDiv = document.getElementById('imageError');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Validate file type
                if (!file.type.match('image.*')) {
                    errorDiv.textContent = 'Please select an image file';
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }
                
                // Validate file size (2MB)
                if (file.size > 2 * 1024 * 1024) {
                    errorDiv.textContent = 'Image must be less than 2MB';
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    errorDiv.textContent = '';
                }
                reader.readAsDataURL(file);
            }
        }

        function markImageForRemoval(button) {
            if (confirm('Remove current image?')) {
                const container = button.parentElement;
                container.style.display = 'none';
                document.getElementById('removeImage').value = 'true';
            }
        }

        function validateForm() {
            let isValid = true;
            document.querySelectorAll('.error').forEach(el => el.textContent = '');
            
            // Validate phone number
            const phone = document.getElementById('contact_phone');
            if (!phone.checkValidity()) {
                document.getElementById('phoneError').textContent = 'Phone must be 10-15 digits';
                isValid = false;
            }
            
            // Add more validations as needed
            
            return isValid;
        }
    </script>
</body>
</html>