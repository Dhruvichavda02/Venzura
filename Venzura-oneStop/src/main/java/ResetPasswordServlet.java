import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import com.venzura.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ResetPasswordServlet: Request received");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String otpSession = String.valueOf(session.getAttribute("otp"));
        String enteredOtp = request.getParameter("otp");
        String newPassword = request.getParameter("newpassword");

        System.out.println("Session Email: " + email);
        System.out.println("Session OTP: " + otpSession);
        System.out.println("Entered OTP: " + enteredOtp);

        if (email == null || otpSession == null || !otpSession.equals(enteredOtp)) {
            System.out.println("OTP Validation Failed!");
            session.setAttribute("error", "Invalid OTP. Try again.");
            response.sendRedirect("ResetPassword.jsp");
            return;
        }
        System.out.println("OTP Validation Passed! Proceeding with password reset...");

        try {
            System.out.println("Attempting to connect to database...");
            Connection con = DBConnection.getConnection();
            System.out.println("Database Connection Established");

         

            System.out.println("Password Validation Passed! Proceeding with password reset...");

            String sql = "UPDATE users SET password = ? WHERE email = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            int updated = pstmt.executeUpdate();
            con.close();

            if (updated > 0) {
                System.out.println("Password updated successfully for: " + email);
                session.removeAttribute("otp");
                session.setAttribute("message", "Password reset successful! Please log in.");
                response.sendRedirect("Login.jsp");
            } else {
                System.out.println("Password reset failed for: " + email);
                session.setAttribute("error", "Error resetting password. Try again.");
                response.sendRedirect("ResetPassword.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error. Try again.");
            response.sendRedirect("ResetPassword.jsp");
        }
    }

   
}
