<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Table</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
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
            padding-top: 60px;
        }

        .sidebar a {
            padding: 10px 15px;
            display: block;
            color: white;
            text-decoration: none;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        /* Content Area */
        .content {
            margin-left: 250px;
            padding: 20px;
            width: 100%;
        }

        /* Button Styles */
        .top-buttons {
            margin-bottom: 10px;
        }

        .btn {
            background-color: black;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn:hover {
            background-color: #333;
        }

        /* Table Styles */
        .table-container {
            width: 100%;
            max-width: 1000px;
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        thead {
            background-color: #f1f1f1;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        /* Buttons */
        .edit-btn, .del-btn {
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 14px;
            color: white;
        }

        .edit-btn {
            background-color: #6c8c7d;
        }

        .del-btn {
            background-color: #d9534f;
        }

        .edit-btn:hover {
            background-color: #5a7b6c;
        }

        .del-btn:hover {
            background-color: #c9302c;
        }

        /* Filter Popup */
        .filter-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            z-index: 10;
        }

        .filter-popup h3 {
            margin-top: 0;
        }

        .filter-popup label {
            display: block;
            margin: 5px 0;
        }

        .popup-buttons {
            margin-top: 10px;
            text-align: right;
        }

        .popup-buttons button {
            background-color: black;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        .popup-buttons button:hover {
            background-color: #333;
        }

        /* Overlay */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: 5;
        }

        /* Responsive Table */
        @media screen and (max-width: 768px) {
            .table-container {
                overflow-x: auto;
            }

            .content {
                margin-left: 0;
                padding: 10px;
            }

            .sidebar {
                width: 0;
                overflow: hidden;
            }

            .table-container table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>

    <%@ include file="Navbar.jsp" %>

    <div class="content">
        
        <!-- Top Buttons -->
        <div class="top-buttons">
            <button class="btn" onclick="toggleFilterPopup()">Filter</button>
            <button class="btn" onclick="window.location.href='AddRole.jsp'">Add Role</button>
        </div>

        <!-- Filter Popup -->
        <div class="overlay" id="overlay" onclick="toggleFilterPopup()"></div>
        <div class="filter-popup" id="filterPopup">
            <h3>Filter by Role</h3>
            <label><input type="radio" name="roleFilter" value="User"> User</label>
            <label><input type="radio" name="roleFilter" value="Admin"> Admin</label>
            <div class="popup-buttons">
                <button onclick="applyFilter()">Filter</button>
                <button onclick="toggleFilterPopup()">Close</button>
            </div>
        </div>

        <!-- Table -->
        <div class="table-container">
            <table id="userTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Password</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Ann Culhane</td>
                        <td>abc@gmail.com</td>
                        <td>1234567890</td>
                        <td>1234567890</td>
                        <td>User</td>
                        <td><button class="edit-btn"  onclick = "window.location.href='EditRole.jsp'">Edit</button></td>
                        <td><button class="del-btn" onclick="confirmDelete(this)">Del</button></td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Ahmad Rosser</td>
                        <td>abc@gmail.com</td>
                        <td>1234567890</td>
                        <td>1234567890</td>
                        <td>Admin</td>
                        <td><button class="edit-btn">Edit</button></td>
                        <td><button class="del-btn" onclick="confirmDelete(this)">Del</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function toggleFilterPopup() {
            let popup = document.getElementById("filterPopup");
            let overlay = document.getElementById("overlay");
            popup.style.display = popup.style.display === "block" ? "none" : "block";
            overlay.style.display = overlay.style.display === "block" ? "none" : "block";
        }

        function applyFilter() {
            let selectedRole = document.querySelector('input[name="roleFilter"]:checked');
            if (!selectedRole) return;
            let role = selectedRole.value;
            
            document.querySelectorAll("#userTable tbody tr").forEach(row => {
                row.style.display = row.children[5].textContent.trim() === role ? "" : "none";
            });

            toggleFilterPopup();
        }

        function confirmDelete(button) {
            if (confirm("Are you sure you want to delete this entry?")) {
                let row = button.closest("tr");
                row.remove();
            }
        }
    </script>

</body>
</html>
