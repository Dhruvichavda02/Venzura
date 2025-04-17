<%@ page import="java.sql.*, com.venzura.utils.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Music Host Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Playfair Display', serif;
        }

        body {
            background-color: #ffffff;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }

        .venue-image {
            width: 900px;
            height: 355px;
            border-radius: 7px;
            display: block;
            margin: 20px auto;
            object-fit: cover;
        }

        .venue-name {
            font-size: 30px;
            font-weight: 400;
            text-align: center;
        }

        .venue-address {
            font-size: 18px;
            font-weight: 300;
            text-align: center;
        }

        .section-title {
            font-size: 20px;
            font-weight: 500;
            margin-top: 50px;
        }

        .amenities, .capacity, .charges, .genres, .contact {
            font-size: 14px;
            font-weight: 400;
            margin-top: 20px;
            margin-left: 30px;
        }

        .separator {
            width: 100%;
            height: 1px;
            background: black;
            margin: 60px 0;
        }

        .details {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: 400;
        }

        .detail-item {
            flex: 1;
            text-align: center;
            font-size: 12px;
        }

        .charges {
            font-size: 18px;
        }

        .book-button {
            width: 125px;
            height: 42px;
            background: black;
            color: white;
            font-size: 18px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: block;
            margin: 30px auto;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="Navbar.jsp" %>

    <div class="container">
        <%
            String hostId = request.getParameter("id");
            if (hostId == null || hostId.trim().isEmpty()) {
                response.sendRedirect("error.jsp?message=Music host ID not provided");
                return;
            }

            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                con = DBConnection.getConnection();
                String sql = "SELECT * FROM music_hosts WHERE id = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(hostId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String name = rs.getString("name");
                    String type = rs.getString("type");
                    int price = rs.getInt("price");
                    int experienceYears = rs.getInt("experience_years");
                    String genres = rs.getString("genres");
                    String contactPhone = rs.getString("contact_phone");
                    String imagePaths = rs.getString("image_paths");
                    String description = rs.getString("description");
                    String location = rs.getString("location");

                    // Handle image path
                    String primaryImage = "../images/joey.jpg";
                    if (imagePaths != null && !imagePaths.trim().isEmpty()) {
                        String[] images = imagePaths.split(",");
                        primaryImage = images[0].trim();
                        if (primaryImage.startsWith("../")) {
                            primaryImage = primaryImage.substring(3);
                        }
                    }

                    Integer userId = (Integer) session.getAttribute("user_id");
        %>

        <img class="venue-image" 
             src="<%= request.getContextPath() %>/<%= primaryImage %>" 
             alt="<%= name %>" 
             onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">

        <h1 class="venue-name"><%= name %></h1>
        <p class="venue-address"><%= location %></p>

        <h2 class="section-title">Type</h2>
        <p class="amenities"><%= type %></p>

        <h2 class="section-title">Experience</h2>
        <p class="capacity"><%= experienceYears %> years of professional experience</p>

        <h2 class="section-title">Genres</h2>
        <p class="genres"><%= genres != null ? genres : "Various genres" %></p>

        <h2 class="section-title">Description</h2>
        <p class="amenities"><%= description != null ? description : "Professional music service" %></p>

        <h2 class="section-title">Charges</h2>
        <p class="charges">₹<%= price %> per event</p>

        <h2 class="section-title">Contact</h2>
        <p class="contact"><%= contactPhone %></p>

        <% if (userId != null) { %>
            <button class="book-button" onclick="window.location.href='Booking.jsp?musicHostId=<%= hostId %>'">Book</button>
        <% } else { %>
            <button class="book-button" onclick="window.location.href='../Login.jsp'">Login to Book</button>
        <% } %>

        <%
                } else {
                    response.sendRedirect("error.jsp?message=Music host not found");
                }
            } catch (Exception e) {
                out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        %>
    </div>

    <div class="separator"></div>
    <%@ include file="Footer.jsp" %>
</body>
</html>
