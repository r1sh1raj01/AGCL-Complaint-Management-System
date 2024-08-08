package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterEngineer")
public class RegisterEngineerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Properties configProperties;

    @Override
    public void init() throws ServletException {
        super.init();
        configProperties = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            configProperties.load(input);
        } catch (IOException e) {
            throw new ServletException("Failed to load configuration properties", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phoneNumber = request.getParameter("phone_number");
        String dobStr = request.getParameter("dob");
        String department = request.getParameter("department");
        String gender = request.getParameter("gender");

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("RegisterEngineer.jsp").forward(request, response);
            return;
        }

        // Convert dob to SQL Date
        Date dob = Date.valueOf(dobStr);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load PostgreSQL driver
            Class.forName("org.postgresql.Driver");

            // Establish connection to the database
            conn = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
            );

            // SQL statement to insert a new engineer
            String sql = configProperties.getProperty("sql.insert_engineer");
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, password);  // Use plain text password
            pstmt.setString(4, phoneNumber);
            pstmt.setDate(5, dob);
            pstmt.setString(6, department);
            pstmt.setString(7, gender);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                // Registration successful
                request.setAttribute("engineerRegistrationSuccess", true);
                request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response); // Forward to AdminDashboard after successful registration
            } else {
                // Registration failed
                request.setAttribute("status", "failed");
                request.getRequestDispatcher("RegisterEngineer.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException | SQLException e) {
            // Log the error and forward to the registration page with an error message
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.getRequestDispatcher("RegisterEngineer.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
