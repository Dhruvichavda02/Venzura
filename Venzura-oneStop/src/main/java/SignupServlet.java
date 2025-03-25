import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import com.venzura.utils.DBConnection;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignupServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String numStr = request.getParameter("num"); // Handle null values safely
        int num = 0;

        if (numStr != null && !numStr.isEmpty()) {
            try {
                num = Integer.parseInt(numStr);
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Invalid phone number. Please enter a valid number.");
                request.getRequestDispatcher("Signup.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("message", "Phone number is required.");
            request.getRequestDispatcher("Signup.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check if email or phone number already exists
            String checkSql = "SELECT * FROM users WHERE email = ? OR phone = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            checkStmt.setInt(2, num);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                if (rs.getString("email").equals(email)) {
                    request.setAttribute("message", "This email is already registered. Please use another email.");
                } else {
                    request.setAttribute("message", "This phone number is already registered. Please use another phone number.");
                }
                request.getRequestDispatcher("Signup.jsp").forward(request, response);
                return;
            }

            // Insert Query
            String sql = "INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(sql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, pass);
            insertStmt.setInt(4, num);

            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                request.setAttribute("successMessage", "Account created successfully! Please login.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Signup failed. Please try again.");
                request.getRequestDispatcher("Signup.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error. Please try again later.");
            request.getRequestDispatcher("Signup.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
