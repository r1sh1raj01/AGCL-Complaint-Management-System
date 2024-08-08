package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

@WebServlet("/ResetPassword")
public class ResetPasswordServlet extends HttpServlet {
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
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
            return;
        }

        try (Connection con = DriverManager.getConnection(
                configProps.getProperty("db.url"),
                configProps.getProperty("db.username"),
                configProps.getProperty("db.password"))) {

            String userType = getUserTypeByToken(con, token);

            if (userType != null) {
                String updatePasswordSql = getUpdatePasswordSql(userType);

                try (PreparedStatement pstmt = con.prepareStatement(updatePasswordSql)) {
                    pstmt.setString(1, newPassword);  // Use plain text password
                    pstmt.setString(2, token);
                    int rows = pstmt.executeUpdate();

                    if (rows > 0) {
                        response.sendRedirect("index.jsp?message=Password changed successfully! You can now log in.");
                    } else {
                        request.setAttribute("errorMessage", "Failed to reset the password. Please try again.");
                        request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
                    }
                }
            } else {
                request.setAttribute("errorMessage", "Invalid or expired token. Please try again.");
                request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("ResetPassword.jsp?token=" + token).forward(request, response);
        } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }



    private String getUserTypeByToken(Connection con, String token) throws Exception {
        String userType = null;
        String[] userTables = {"employees", "engineers", "admins"}; // Correct table names

        for (String table : userTables) {
            String sql = String.format(configProps.getProperty("sql.select_user_token"), table);
            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setString(1, token);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        userType = table; // Set user type to the correct table name
                        break;
                    }
                }
            }
        }
        return userType;
    }
    
    private String getUpdatePasswordSql(String userType) {
        switch (userType) {
            case "employee":
                return configProps.getProperty("sql.update_employee_password");
            case "engineer":
                return configProps.getProperty("sql.update_engineer_password");
            case "admin":
                return configProps.getProperty("sql.update_admin_password");
            default:
                return null;
        }
    }
}
