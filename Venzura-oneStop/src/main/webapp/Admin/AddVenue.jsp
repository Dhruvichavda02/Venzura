<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Venue</title>
    <script>
        // JavaScript validation function
        function validateForm() {
            var venueName = document.getElementById("venueName").value;
            var venueLocation = document.getElementById("venueLocation").value;
            var venueCapacity = document.getElementById("venueCapacity").value;
            var venuePrice = document.getElementById("venuePrice").value;
            var venueAmenities = document.getElementById("venueAmenities").value;
            var venueContactPhone = document.getElementById("venueContactPhone").value;
            var venueImages = document.getElementById("venueImages").files;
            var venueDescription = document.getElementById("venueDescription").value;

            // Validate Venue Name
            if (venueName.trim() === "") {
                alert("Venue Name is required.");
                return false;
            }

            // Validate Venue Location
            if (venueLocation.trim() === "") {
                alert("Venue Location is required.");
                return false;
            }

            // Validate Venue Capacity
            if (venueCapacity.trim() === "" || isNaN(venueCapacity) || venueCapacity <= 0) {
                alert("Please enter a valid Venue Capacity.");
                return false;
            }

            // Validate Venue Price
            if (venuePrice.trim() === "" || isNaN(venuePrice) || venuePrice <= 0) {
                alert("Please enter a valid Venue Price.");
                return false;
            }

            // Validate Venue Amenities
            if (venueAmenities.trim() === "") {
                alert("Venue Amenities are required.");
                return false;
            }

            // Validate Contact Phone
            if (venueContactPhone.trim() === "") {
                alert("Contact Phone is required.");
                return false;
            }
            // Validate phone number (simple validation, you can adjust as needed)
            var phoneRegex = /^[0-9]{10}$/;
            if (!phoneRegex.test(venueContactPhone)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            // Validate Venue Images
            if (venueImages.length === 0) {
                alert("Please upload at least one image.");
                return false;
            }

            // Validate Venue Description
            if (venueDescription.trim() === "") {
                alert("Venue Description is required.");
                return false;
            }

            // If all validations pass, return true to submit the form
            return true;
        }
    </script>
</head>
<body>
    <h2>Add Venue</h2>

    <form action="../Addven" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <label for="venueName">Venue Name:</label><br>
        <input type="text" id="venueName" name="venueName" required><br><br>

        <label for="venueLocation">Venue Location:</label><br>
        <input type="text" id="venueLocation" name="venueLocation" required><br><br>

        <label for="venueCapacity">Venue Capacity:</label><br>
        <input type="number" id="venueCapacity" name="venueCapacity" required><br><br>

        <label for="venuePrice">Venue Price:</label><br>
        <input type="number" id="venuePrice" name="venuePrice" required><br><br>

        <label for="venueAmenities">Venue Amenities:</label><br>
        <textarea id="venueAmenities" name="venueAmenities" required></textarea><br><br>

        <label for="venueContactPhone">Contact Phone:</label><br>
        <input type="text" id="venueContactPhone" name="venueContactPhone" required><br><br>

        <label for="venueImages">Venue Images:</label><br>
        <input type="file" id="venueImages" name="venueImages" multiple><br><br>

        <label for="venueDescription">Venue Description:</label><br>
        <textarea id="venueDescription" name="venueDescription" required></textarea><br><br>

        <input type="submit" value="Add Venue">
    </form>

</body>
</html>
 