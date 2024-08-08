package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Base64;
import java.util.Properties;

@WebServlet("/ForgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Properties configProps;

    @Override
    public void init() throws ServletException {
        configProps = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (input == null) {
                throw new ServletException("Unable to find config.properties");
            }
            configProps.load(input);
        } catch (IOException e) {
            throw new ServletException("Error loading config.properties", e);
        }

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("PostgreSQL Driver not found", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String userType = request.getParameter("userType");

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = DriverManager.getConnection(
                    configProps.getProperty("db.url"),
                    configProps.getProperty("db.username"),
                    configProps.getProperty("db.password"));

            String token = generateToken();
            String updateTokenSql = getUpdateTokenSql(userType);

            if (updateTokenSql == null) {
                request.setAttribute("errorMessage", "Invalid user type.");
                request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                return;
            }

            pstmt = con.prepareStatement(updateTokenSql);
            pstmt.setString(1, token);
            pstmt.setString(2, email);
            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                sendResetEmail(email, token);
                request.setAttribute("message", "A reset link has been sent to your email.");
            } else {
                request.setAttribute("errorMessage", "Email not found. Please try again.");
            }

            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private String getUpdateTokenSql(String userType) {
        switch (userType) {
            case "employee":
                return configProps.getProperty("sql.update_employee_token");
            case "engineer":
                return configProps.getProperty("sql.update_engineer_token");
            case "admin":
                return configProps.getProperty("sql.update_admin_token");
            default:
                return null;
        }
    }

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private void sendResetEmail(String email, String token) throws MessagingException {
        String resetLink = "http://localhost:8080/AGCL-Complaint_Management_System/ResetPassword.jsp?token=" + token;

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", configProps.getProperty("email.host"));
        properties.put("mail.smtp.port", configProps.getProperty("email.port"));

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        configProps.getProperty("email.from"),
                        configProps.getProperty("email.password"));
            }
        });

        Message message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(configProps.getProperty("email.from"), "Assam Gas Company Ltd"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new MessagingException("Error setting the sender address.", e);
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
        message.setSubject("Password Reset Request");
        message.setText("To reset your password, click the link below:\n" + resetLink);

        Transport.send(message);
    }
}
