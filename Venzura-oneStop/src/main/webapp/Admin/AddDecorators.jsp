<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Decoration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function validateForm() {
            const form = document.forms[0];
            const name = form["name"].value.trim();
            const description = form["description"].value.trim();
            const price = form["price"].value;
            const location = form["location"].value.trim();
            const phone = form["phone"].value.trim();
            const category = form["category"].value.trim();
            const files = form["images"].files;

            if (name.length < 3 || name.length > 50) {
                alert("Decoration name must be between 3 and 50 characters.");
                return false;
            }

            if (description.length < 10 || description.length > 300) {
                alert("Description must be between 10 and 300 characters.");
                return false;
            }

            if (price <= 0) {
                alert("Please enter a valid positive price.");
                return false;
            }

            if (location.length < 3) {
                alert("Location must be at least 3 characters.");
                return false;
            }

            const phoneRegex = /^[0-9]{10}$/;
            if (!phoneRegex.test(phone)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            if (category.length === 0) {
                alert("Please enter a category.");
                return false;
            }

            if (files.length === 0) {
                alert("Please upload at least one image.");
                return false;
            }

            for (let i = 0; i < files.length; i++) {
                if (!files[i].type.startsWith("image/")) {
                    alert("Only image files are allowed.");
                    return false;
                }
            }

            return true;
        }
    </script>
</head>

<body class="bg-gray-100 p-8">
    <div class="max-w-xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-center">Add Decoration</h1>
        <form action="../SaveDec" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
            <div class="mb-4">
                <label for="name" class="block font-medium mb-1">Name</label>
                <input type="text" id="name" name="name" class="w-full border rounded p-2" required>
            </div>

            <div class="mb-4">
                <label for="description" class="block font-medium mb-1">Description</label>
                <textarea id="description" name="description" rows="4" class="w-full border rounded p-2" required></textarea>
            </div>

            <div class="mb-4">
                <label for="price" class="block font-medium mb-1">Price</label>
                <input type="number" id="price" name="price" class="w-full border rounded p-2" min="0" required>
            </div>

            <div class="mb-4">
                <label for="location" class="block font-medium mb-1">Location</label>
                <input type="text" id="location" name="location" class="w-full border rounded p-2" required>
            </div>

            <div class="mb-4">
                <label for="phone" class="block font-medium mb-1">Phone Number</label>
                <input type="text" id="phone" name="phone" class="w-full border rounded p-2" required>
            </div>

            <div class="mb-4">
    <label for="category" class="block font-medium mb-1">Category</label>
    <select id="category" name="category" class="w-full border rounded p-2" required>
        <option value="">Select Category</option>
        <option value="wedding">Wedding</option>
        <option value="birthday">Birthday</option>
        <option value="babyshower">Baby Shower</option>
        <option value="bacherolette">Bachelorette</option>
        <option value="all">All</option>
    </select>
</div>


            <div class="mb-6">
                <label for="images" class="block font-medium mb-1">Upload Images</label>
                <input type="file" id="images" name="images" accept="image/*" multiple class="w-full" required>
            </div>

            <button type="submit" class="bg-black text-white py-2 px-4 rounded hover:bg-gray-800 w-full">Add Decoration</button>
        </form>
    </div>
</body>
</html>
