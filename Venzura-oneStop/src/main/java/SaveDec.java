import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

import com.venzura.utils.DBConnection;
import org.json.JSONArray;
@WebServlet("/SaveDec")
@MultipartConfig
public class SaveDec extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String name = getFormFieldValue(request.getPart("name"));
        String description = getFormFieldValue(request.getPart("description"));
        String priceStr = getFormFieldValue(request.getPart("price"));
        String location = getFormFieldValue(request.getPart("location"));
        String category = getFormFieldValue(request.getPart("category"));
        String phone = getFormFieldValue(request.getPart("phone"));

        double price;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            out.println("Invalid price format.");
            return;
        }

        // Process multiple images
        Collection<Part> parts = request.getParts();
        JSONArray imageArray = new JSONArray();
        String uploadPath = getServletContext().getRealPath("/uploads");
        Files.createDirectories(Paths.get(uploadPath));

        for (Part part : parts) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String originalName = part.getSubmittedFileName();
                String extension = originalName.substring(originalName.lastIndexOf("."));
                String fileName = UUID.randomUUID() + extension;
                Path filePath = Paths.get(uploadPath, fileName);
                part.write(filePath.toString());

                imageArray.put(fileName);
            }
        }

        // Save to database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO decorations (name, category, price, description, phone, location, image_paths) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, category);
            stmt.setDouble(3, price);
            stmt.setString(4, description);
            stmt.setString(5, phone);
            stmt.setString(6, location);
            stmt.setString(7, imageArray.toString()); // Save images as JSON array string

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                out.println("<html>");
                out.println("<body>");
                out.println("<script>");
                out.println("alert('Decoration saved successfully!');");
                out.println("window.location.href = 'Admin/Decorators.jsp';"); // Redirect to Decorators.jsp after pop-up
                out.println("</script>");
                out.println("</body>");
                out.println("</html>");
            } else {
                out.println("Failed to save decoration.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Database error: " + e.getMessage());
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
        }
    }

    private String getFormFieldValue(Part part) throws IOException {
        if (part == null) return null;
        BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
        return reader.lines().collect(Collectors.joining()).trim();
    }
}
