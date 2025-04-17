<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.venzura.utils.DBConnection, java.util.Arrays" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String itemId = request.getParameter("id");
    String name = "", category = "", price = "", description = "", phone = "", location = "";
    String[] imagePaths = new String[0];

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT name, category, price, description, phone, location, image_paths FROM decorations WHERE id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, itemId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            category = rs.getString("category");
            price = rs.getString("price");
            description = rs.getString("description");
            phone = rs.getString("phone");
            location = rs.getString("location");
            String images = rs.getString("image_paths");
            if (images != null && !images.trim().isEmpty()) {
                imagePaths = images.split(",");
            }
        } else {
            out.println("<p class='text-red-500'>Decoration not found.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p class='text-red-500'>Error fetching decoration data.</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Decoration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .image-container {
            position: relative;
            display: inline-block;
            margin: 0 10px 10px 0;
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
            font-size: 12px;
            cursor: pointer;
        }
        #imagePreviews, #currentImages {
            display: flex;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .upload-box {
            border: 2px dashed #ddd;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-3xl mx-auto bg-white rounded-lg shadow p-6">
        <h1 class="text-2xl font-bold mb-6">Edit Decoration</h1>
        
        <form action="../UpdateDecServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= itemId %>">
            
            <!-- Basic Information -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                    <input type="text" name="name" value="<%= name %>" 
                           class="w-full p-2 border rounded" required>
                </div>
            <div>
    <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
    <select name="category" class="w-full p-2 border rounded" required>
        <option value="Birthday" <%= "Birthday".equals(category) ? "selected" : "" %>>Birthday</option>
        <option value="Wedding" <%= "Wedding".equals(category) ? "selected" : "" %>>Wedding</option>
        <option value="Baby Shower" <%= "Baby Shower".equals(category) ? "selected" : "" %>>Baby Shower</option>
        <option value="Bachelorette" <%= "Bachelorette".equals(category) ? "selected" : "" %>>Bachelorette</option>
    </select>
</div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Price</label>
                    <input type="number" name="price" value="<%= price %>" min="0" step="0.01"
                           class="w-full p-2 border rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                    <input type="tel" name="phone" value="<%= phone %>" pattern="[0-9]{10,15}"
                           class="w-full p-2 border rounded" required>
                </div>
            </div>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-1">Location</label>
                <input type="text" name="location" value="<%= location %>"
                       class="w-full p-2 border rounded" required>
            </div>
            
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea name="description" class="w-full p-2 border rounded" rows="4" required><%= description %></textarea>
            </div>
            
            <!-- Current Images -->
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">Current Images</label>
                <div class="upload-box">
                    <div id="currentImages">
                        <% if (imagePaths.length > 0) { %>
                            <% for (String imagePath : imagePaths) { %>
                                <% if (!imagePath.trim().isEmpty()) { %>
                                    <div class="image-container" data-image-path="<%= imagePath.trim() %>">
                                        <img src="../<%= imagePath.trim() %>" alt="Decoration Image" class="h-32 rounded">
                                        <button type="button" class="remove-image" onclick="removeExistingImage(this)">×</button>
                                    </div>
                                <% } %>
                            <% } %>
                        <% } else { %>
                            <p class="text-gray-500">No images currently set</p>
                        <% } %>
                    </div>
                    <input type="hidden" name="removedImages" id="removedImages" value="">
                </div>
            </div>
            
            <!-- New Images -->
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">Add New Images</label>
                <div class="upload-box">
                    <div id="imagePreviews"></div>
                    <input type="file" id="imageUpload" name="images" multiple accept="image/*" 
                           class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                           onchange="previewImages(this)">
                   
                </div>
            </div>
            
            <div class="flex justify-end">
                <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white py-2 px-6 rounded">
                    Update Decoration
                </button>
            </div>
        </form>
    </div>

    <script>
        // Track removed images
        const removedImages = [];
        
        // Remove existing image
        function removeExistingImage(button) {
            if (confirm('Remove this image?')) {
                const container = button.closest('.image-container');
                const imagePath = container.dataset.imagePath;
                removedImages.push(imagePath);
                document.getElementById('removedImages').value = removedImages.join(',');
                container.remove();
            }
        }
        
        // Preview new images
        function previewImages(input) {
            const previewContainer = document.getElementById('imagePreviews');
            previewContainer.innerHTML = '';
            
            if (input.files && input.files.length > 0) {
                Array.from(input.files).forEach((file, index) => {
                    // Validate file type
                    if (!file.type.match('image.*')) {
                        alert('Only image files are allowed');
                        input.value = '';
                        return;
                    }
                    
                   
                    
                    const reader = new FileReader();
                    const previewDiv = document.createElement('div');
                    previewDiv.className = 'image-container';
                    previewDiv.dataset.fileIndex = index;
                    
                    reader.onload = function(e) {
                        previewDiv.innerHTML = `
                            <img src="${e.target.result}" class="h-32 rounded">
                            <button type="button" class="remove-image" onclick="removeNewImage(this)">×</button>
                        `;
                        previewContainer.appendChild(previewDiv);
                    };
                    
                    reader.readAsDataURL(file);
                });
            }
        }
        
        // Remove new image
        function removeNewImage(button) {
            const container = button.closest('.image-container');
            container.remove();
            updateFileInput();
        }
        
        // Update file input after removing new images
        function updateFileInput() {
            const input = document.getElementById('imageUpload');
            const dataTransfer = new DataTransfer();
            
            // Get all remaining preview containers
            const containers = document.querySelectorAll('#imagePreviews .image-container');
            
            Array.from(input.files).forEach((file, index) => {
                // Check if this file is still being previewed
                let found = false;
                containers.forEach(container => {
                    if (container.dataset.fileIndex == index) {
                        found = true;
                    }
                });
                
                if (found) {
                    dataTransfer.items.add(file);
                }
            });
            
            input.files = dataTransfer.files;
        }
    </script>
</body>
</html>