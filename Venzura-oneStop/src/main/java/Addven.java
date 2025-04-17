import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

//import com.mysql.cj.x.protobuf.MysqlxCrud.Collection;
import com.venzura.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig
@WebServlet("/Addven")
public class Addven extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String venueName = request.getParameter("venueName");
        String venueLocation = request.getParameter("venueLocation");
        String venueCapacity = request.getParameter("venueCapacity");
        String venuePrice = request.getParameter("venuePrice");
        String venueAmenities = request.getParameter("venueAmenities");
        String venueContactPhone = request.getParameter("venueContactPhone");
        String venueDescription = request.getParameter("venueDescription");

        // Handle file uploads
        Collection<Part> parts = request.getParts();
        List<String> imagePaths = new ArrayList<>();

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        for (Part part : parts) {
            if (part.getName().equals("venueImages") && part.getSize() > 0) {
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);
                imagePaths.add("uploads/" + fileName);
            }
        }

        // Insert into database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO venues (name, location, capacity, price, amenities, contact_phone, description, image_paths) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, venueName);
            stmt.setString(2, venueLocation);
            stmt.setString(3, venueCapacity);
            stmt.setString(4, venuePrice);
            stmt.setString(5, venueAmenities);
            stmt.setString(6, venueContactPhone);
            stmt.setString(7, venueDescription);
            stmt.setString(8, String.join(",", imagePaths));

            int rowsInserted = stmt.executeUpdate();

            // Response with popup script
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            if (rowsInserted > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Venue added successfully!');");
                out.println("window.location = 'addVenue.jsp';"); // redirect if needed
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Failed to add venue.');");
                out.println("window.location = 'Admin/Venue.jsp';");
                out.println("</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        } catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    }
}
