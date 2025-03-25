<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
        }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .field-container {
            margin-top: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
        }
        .remove-btn {
            background: red;
            color: white;
            border: none;
            cursor: pointer;
            padding: 5px;
            margin-top: 5px;
            width: auto;
        }
        .dropdown-options {
            display: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Category</h2>
    
    <label>Category Name:</label>
    <input type="text" id="categoryName" placeholder="Enter category name">

    <h3>Add Fields</h3>
    <div id="fieldsContainer"></div>

    <button onclick="addField()">+ Add Field</button>
    <button onclick="saveCategory()">Save Category</button>
     
</div>

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

        // Prepare JSON payload
        const categoryData = {
            categoryName: categoryName,
            fields: fields
        };

        // Send data to the servlet
        fetch("/Venzura-oneStop/addCategory", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(categoryData)
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
