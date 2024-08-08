package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLogin")
public class AdminLoginServlet extends HttpServlet {
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
        String adminEmail = request.getParameter("user");
        String password = request.getParameter("password");
        String department = request.getParameter("department");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Connect to the complaint_management_system database
            con = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
            );

            // Check the credentials in hods table
            String adminSql = configProperties.getProperty("sql.select_admin");
            pstmt = con.prepareStatement(adminSql);
            pstmt.setString(1, adminEmail);
            pstmt.setString(2, department);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // If email and department are found in hods and departments tables
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {
                    // Retrieve HoD details
                    String fullName = rs.getString("full_name");
                    String email = rs.getString("email");
                    String phoneNumber = rs.getString("phone_number");

                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("fullName", fullName);
                    session.setAttribute("phoneNumber", phoneNumber);
                    session.setAttribute("departmentName", department);
                    session.setAttribute("userType", "admin");

                    response.sendRedirect("AdminDashboard.jsp");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
                    request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("errorMessage", "Admin not found.");
                request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
        } finally {
            // Close all resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
