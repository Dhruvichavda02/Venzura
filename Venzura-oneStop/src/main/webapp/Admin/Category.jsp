<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category</title>
    <style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 20px;
    background-color: #f8f9fa;
}

.container {
    max-width: 600px;
    margin: auto;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h2, h3 {
    text-align: center;
    color: #333;
    margin-bottom: 15px;
}

label {
    font-weight: bold;
    display: block;
    margin: 10px 0 5px;
    color: #555;
}

input, select, button {
    width: 100%;
    padding: 12px;
    margin: 8px 0;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 16px;
    transition: 0.3s ease-in-out;
}

input:focus, select:focus {
    border-color: #007bff;
    outline: none;
    box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
}

button {
    background: #007bff;
    color: white;
    border: none;
    cursor: pointer;
    font-weight: bold;
    padding: 12px;
    border-radius: 6px;
    transition: background 0.3s ease-in-out;
}

button:hover {
    background: #0056b3;
}

/* Field Container */
.field-container {
    margin-top: 15px;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f1f1f1;
    position: relative;
}

/* Remove Button */
.remove-btn {
    background: red;
    color: white;
    border: none;
    cursor: pointer;
    padding: 8px;
    margin-top: 8px;
    width: auto;
    display: block;
    text-align: center;
    border-radius: 5px;
    font-size: 14px;
    transition: background 0.3s;
}

.remove-btn:hover {
    background: darkred;
}

/* Dropdown Options */
.dropdown-options {
    display: none;
    margin-top: 10px;
}

#categoryImages {
    border: 2px dashed #ccc;
    padding: 10px;
    text-align: center;
    background-color: #fafafa;
}

#categoryImages:hover {
    border-color: #007bff;
}

@media (max-width: 600px) {
    .container {
        width: 90%;
        padding: 15px;
    }

    input, select, button {
        font-size: 14px;
        padding: 10px;
    }
}


    </style>
</head>
<body>

<form id="categoryForm" enctype="multipart/form-data">
    <label>Category Name:</label>
    <input type="text" id="categoryName" placeholder="Enter category name">

    <h3>Add Fields</h3>
    <div id="fieldsContainer"></div>

    <button type="button" onclick="addField()">+ Add Field</button>

    
    <button type="button" onclick="saveCategory()">Save Category</button>
</form>


<script>
    function addField() {
        const container = document.getElementById('fieldsContainer');

        const fieldDiv = document.createElement('div');
        fieldDiv.classList.add('field-container');

        fieldDiv.innerHTML = `
            <label>Field Name:</label>
            <input type="text" class="field-name" placeholder="Enter field name">

            <label>Field Type:</label>
            <select class="field-type" onchange="toggleDropdownOptions(this)">
                <option value="text">Text</option>
                <option value="number">Number</option>
                <option value="file">Images</option>
                <option value="dropdown">Dropdown</option>
            </select>

            <div class="dropdown-options">
                <label>Dropdown Options (comma-separated):</label>
                <input type="text" class="dropdown-values" placeholder="e.g. Option1, Option2, Option3">
            </div>

            <button class="remove-btn" onclick="removeField(this)">Remove</button>
        `;

        container.appendChild(fieldDiv);
    }

    function removeField(button) {
        button.parentElement.remove();
    }

    function toggleDropdownOptions(select) {
        const dropdownContainer = select.parentElement.querySelector('.dropdown-options');
        dropdownContainer.style.display = select.value === 'dropdown' ? 'block' : 'none';
    }
    function saveCategory() {
        const categoryName = document.getElementById('categoryName').value.trim();
        if (categoryName === "") {
            alert("Category name is required.");
            return;
        }

        const fields = [];
        document.querySelectorAll('.field-container').forEach(fieldDiv => {
            const name = fieldDiv.querySelector('.field-name').value.trim();
            const type = fieldDiv.querySelector('.field-type').value;
            let options = [];

            if (type === 'dropdown') {
                const optionsText = fieldDiv.querySelector('.dropdown-values').value.trim();
                if (optionsText) {
                    options = optionsText.split(',').map(opt => opt.trim());
                }
            }

            if (name !== "") {
                fields.push({ name, type, options });
            }
        });

        if (fields.length === 0) {
            alert("Please add at least one field.");
            return;
        }

        // Prepare FormData to send JSON + images
        const formData = new FormData();
        formData.append("categoryName", categoryName);
        formData.append("fields", JSON.stringify(fields));

        // Append images to FormData
     //   const imagesInput = document.getElementById("categoryImages");
       // for (const file of imagesInput.files) {
         //   formData.append("images", file);
        //}

        // Send data to the servlet
        fetch("/Venzura-oneStop/addCategory", {
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                location.reload(); // Refresh page after successful submission
            } else {
                alert("Error: " + data.message);
            }
        })
        .catch(error => console.error("Error:", error));
    }

   
</script>

</body>
</html>