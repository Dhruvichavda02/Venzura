<%@ page import="java.sql.*" %>
<%@ page import="com.venzura.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("../Login.jsp?redirect=ListBookings.jsp");
        return;
    }

    // Handle DELETE request before rendering
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete_id") != null) {
        int bookingId = Integer.parseInt(request.getParameter("delete_id"));
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM vbookings WHERE booking_id=?")) {
            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            out.print(rows > 0 ? "Booking deleted successfully!" : "Booking not found or could not be deleted.");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error: " + e.getMessage());
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venzura - Bookings</title>
 <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
        }
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
        .content {
            margin-left: 250px;
            padding: 20px;
            width: 100%;
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
            min-width: 800px;
        }
        thead {
            background-color: #f1f1f1;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
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
    </style>

</head>
<body>
    <%@ include file="Navbar.jsp" %>
    <div class="content">
        <div class="top-buttons">
            <button class="btn" onclick="toggleFilterPopup()">Filter</button>
            
        </div>
        
        <!-- Filter Popup -->
       <div class="overlay" id="overlay" onclick="toggleFilterPopup()"></div>
        <div class="filter-popup" id="filterPopup">
            <h3>Filter Bookings</h3>
            <label><input type="radio" name="bookingFilter" value="all" checked> All Bookings</label>
            <label><input type="radio" name="bookingFilter" value="venue"> Venue Bookings</label>
            <label><input type="radio" name="bookingFilter" value="decoration"> Decoration Bookings</label>
            <label><input type="radio" name="bookingFilter" value="music"> Music Bookings</label>
            <div class="popup-buttons">
                <button onclick="applyBookingFilter()">Filter</button>
                <button onclick="toggleFilterPopup()">Close</button>
            </div>
        </div>

        <div class="table-container">
            <table id="bookingTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Booking Date</th>
                        <th>Amount</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Type</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement ps = con.prepareStatement(
                                "SELECT b.id, b.booking_date, b.amount, b.email, b.phone, b.start_date, b.end_date, " +
                                "u.name AS customer_name, v.name AS venue_name, d.name AS decoration_name, m.name AS music_host_name " +
                                "FROM vbookings b " +
                                "LEFT JOIN users u ON b.user_id = u.user_id " +
                                "LEFT JOIN venues v ON b.venue_id = v.id " +
                                "LEFT JOIN decorations d ON b.decoration_id = d.id " +
                                "LEFT JOIN music_hosts m ON b.music_host_id = m.id " +
                                "ORDER BY b.booking_date DESC");
                             ResultSet rs = ps.executeQuery()) {
                            int count = 1;
                            while (rs.next()) {
                                // Build a single "Type" cell with non-null services
                                StringBuilder typeInfo = new StringBuilder();
                                if (rs.getString("venue_name") != null) {
                                    typeInfo.append("Venue: ").append(rs.getString("venue_name"));
                                }
                                if (rs.getString("decoration_name") != null) {
                                    if (typeInfo.length() > 0) typeInfo.append(", ");
                                    typeInfo.append("Decoration: ").append(rs.getString("decoration_name"));
                                }
                                if (rs.getString("music_host_name") != null) {
                                    if (typeInfo.length() > 0) typeInfo.append(", ");
                                    typeInfo.append("Music Host: ").append(rs.getString("music_host_name"));
                                }
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        <td><%= rs.getDate("booking_date") %></td>
                        <td>₹<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                        <td><%= rs.getString("customer_name") %></td>
                        <td><%= rs.getString("phone") %></td>
                        <td><%= rs.getDate("start_date") %></td>
                        <td><%= rs.getDate("end_date") %></td>
                        <td><%= typeInfo.toString().isEmpty() ? "-" : typeInfo.toString() %></td>
                        
                    </tr>
                    <%  }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
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

    function applyBookingFilter() {
        let selectedFilter = document.querySelector('input[name="bookingFilter"]:checked'); 
        if (!selectedFilter) return;

        let filterType = selectedFilter.value;

        document.querySelectorAll("#bookingTable tbody tr").forEach(row => {
            let typeCell = row.querySelector("td:last-child");
            let typeText = typeCell ? typeCell.textContent.toLowerCase() : "";

            let showRow = false;

            switch (filterType) {
                case 'all':
                    showRow = true;
                    break;
                case 'venue':
                    showRow = typeText.includes("venue");
                    break;
                case 'decoration':
                    showRow = typeText.includes("decoration");
                    break;
                case 'music':
                    showRow = typeText.includes("music host");
                    break;
            }

            row.style.display = showRow ? "" : "none";
        });

        toggleFilterPopup();
    }



        function confirmDelete(bookingId) {
            if (confirm("Are you sure you want to delete this booking?")) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", window.location.href, true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        alert(xhr.responseText.trim());
                        location.reload();
                    } else {
                        alert("Error deleting booking. Try again.");
                    }
                };
                xhr.send("delete_id=" + bookingId);
            }
        }
    </script>
</body>
</html>
