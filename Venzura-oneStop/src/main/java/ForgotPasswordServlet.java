import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String email = request.getParameter("email");
    	System.out.println("Received email: " + email); // Debugging


        // Validate email input
        if (email == null || email.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Please enter a valid email address.");
            response.sendRedirect("ForgotPassword.jsp");
            return;
        }

        // Generate 6-digit OTP
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);

        // Store OTP and email in session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);

        // Email sender details
        final String fromEmail = "dhruvichavda02@gmail.com"; // Replace with your email
        final String password = "nsfn rzpo qyqd onfx"; // Use an app password instead of your real email password

        // Email properties
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true");

        // Authenticate & send email
        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email)); // Error occurs here if email is null
            message.setSubject("Venzura Password Reset OTP");
            message.setText("Your OTP for password reset is: " + otp);

            Transport.send(message);
            response.sendRedirect("ResetPassword.jsp"); // Redirect to OTP page
        } catch (MessagingException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to send email! Please try again.");
            response.sendRedirect("ForgotPassword.jsp");
        }
    }
}