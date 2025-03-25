import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL JDBC Driver
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/venzura_db", "root", "");

            // Check if the user exists with the correct password
            PreparedStatement checkUser = conn.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?");
            checkUser.setString(1, email);
            checkUser.setString(2, password);
            ResultSet rs = checkUser.executeQuery();

            HttpSession session = request.getSession(); // Create session

            if (rs.next()) {
                // User exists, start session
                session.setAttribute("email", email);
                response.sendRedirect("User/Home.jsp");
            } else {
                // Invalid credentials
                session.setAttribute("errorMessage", "Invalid Email or Password!");
                response.sendRedirect("Login.jsp");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Database Connection Error!");
            response.sendRedirect("Login.jsp");
        }
    }
}
