<%@ page import="java.sql.*" %>
<%
    int userId = (Integer) session.getAttribute("user_id");

    String venueIdStr = request.getParameter("venue_id");
    String decorIdStr = request.getParameter("decoration_id");
    String musicIdStr = request.getParameter("music_host_id");
    String guestsStr = request.getParameter("guests");
    String eventDate = request.getParameter("event_date");
    String amountStr = request.getParameter("amount");
    String email = request.getParameter("email");

    Connection con = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_db", "root", "");

        String sql = "INSERT INTO booking (user_id, venue_id, decoration_id, music_host_id, event_date, booking_date, no_of_guests, amount, email) " +
                     "VALUES (?, ?, ?, ?, ?, NOW(), ?, ?, ?)";
        pst = con.prepareStatement(sql);
        pst.setInt(1, userId);
        pst.setObject(2, (venueIdStr != null && !venueIdStr.isEmpty()) ? Integer.parseInt(venueIdStr) : null);
        pst.setObject(3, (decorIdStr != null && !decorIdStr.isEmpty()) ? Integer.parseInt(decorIdStr) : null);
        pst.setObject(4, (musicIdStr != null && !musicIdStr.isEmpty()) ? Integer.parseInt(musicIdStr) : null);
        pst.setString(5, eventDate);
        pst.setInt(6, Integer.parseInt(guestsStr));
        pst.setInt(7, Integer.parseInt(amountStr));
        pst.setString(8, email);

        int row = pst.executeUpdate();

        if (row > 0) {
%>
            <script>
                alert("Booking successful!");
                window.location.href = "Home.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("Booking failed.");
                history.back();
            </script>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
    <script>alert("Error: <%= e.getMessage() %>");</script>
<%
    } finally {
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>
