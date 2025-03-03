<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 0;
            margin: 0;
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
            transition: 0.3s;
            padding-top: 60px;
        }

        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            display: block;
            color: white;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        /* Content Wrapper */
        .content {
            margin-left: 250px; /* Default margin for visible sidebar */
            transition: margin-left 0.3s;
            padding: 20px;
            width: 100%;
        }

        .table-container {
            width: 100%;
            max-width: 1200px;
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #f1f1f1;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            font-weight: bold;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

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

        /* Hide Sidebar */
        .sidebar.hidden {
            width: 0;
            overflow: hidden;
        }

        .content.full-width {
            margin-left: 0;
        }

        /* Responsive */
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
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Location</th>
                        <th>Experience</th>
                        <th>Price</th>
                        <th>Policy</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td data-label="#">1</td>
                        <td data-label="Name"><strong>Ann Culhane</strong><br><small>5684236526</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn" onclick = "window.location.href='EditVenue.jsp'">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn" onclick="confirmDelete(this)">Del</button></td>

                    </tr>
                    <tr>
                        <td data-label="#">2</td>
                        <td data-label="Name"><strong>Ahmad Rosser</strong><br><small>5684236527</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn">Del</button></td>
                    </tr>
                    
                     <tr>
                        <td data-label="#">3</td>
                        <td data-label="Name"><strong>Ahmad Rosser</strong><br><small>5684236527</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn">Del</button></td>
                    </tr>
                     <tr>
                        <td data-label="#">4</td>
                        <td data-label="Name"><strong>Ahmad Rosser</strong><br><small>5684236527</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn">Del</button></td>
                    </tr>
                     <tr>
                        <td data-label="#">5</td>
                        <td data-label="Name"><strong>Ahmad Rosser</strong><br><small>5684236527</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn">Del</button></td>
                    </tr>
                     <tr>
                        <td data-label="#">6</td>
                        <td data-label="Name"><strong>Ahmad Rosser</strong><br><small>5684236527</small></td>
                        <td data-label="Location">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Experience">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Price">10k</td>
                        <td data-label="Policy">Lorem ipsum dolor sit amet...</td>
                        <td data-label="Edit"><button class="edit-btn">Edit</button></td>
                        <td data-label="Delete"><button class="del-btn">Del</button></td>
                    </tr>
                </tbody>
            </table>
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
        
    
        function confirmDelete(button) {
            if (confirm("Are you sure you want to delete this entry?")) {
                alert("Deleted");
                let row = button.closest("tr");
                row.remove(); // Remove the row from the table
            }
        }


    </script>

</body>
</html>
