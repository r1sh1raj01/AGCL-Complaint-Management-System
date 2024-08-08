package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterHoD")
public class RegisterHoDServlet extends HttpServlet {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just forward to RegisterHoD.jsp
        request.getRequestDispatcher("RegisterHoD.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phoneNo = request.getParameter("phone_no");
        String departmentName = request.getParameter("department");

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("RegisterHoD.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Connect to the complaint_management_system database
            con = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
            );

            // Insert HoD data into hods table
            String sql = configProperties.getProperty("sql.insert_hod");
            pstmt = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, password);  // Use plain text password
            pstmt.setString(4, phoneNo);
            pstmt.executeUpdate();

            // Get the generated hod_id
            int hodId = -1;
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    hodId = rs.getInt(1);
                }
            }

            if (hodId != -1 && departmentName != null && !departmentName.isEmpty()) {
                // Update department with the new hod_id
                String deptSql = configProperties.getProperty("sql.update_department");
                pstmt = con.prepareStatement(deptSql);
                pstmt.setInt(1, hodId);
                pstmt.setString(2, departmentName);
                pstmt.executeUpdate();
            }

            // Redirect to AdminLogin.jsp with success message
            request.setAttribute("successMessage", "HoD Registered Successfully. You can now login.");
            request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while registering. Please try again.");
            request.getRequestDispatcher("RegisterHoD.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
