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

@WebServlet("/EngineerLogin")
public class EngineerLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String dbUrl;
    private String dbUsername;
    private String dbPassword;

    @Override
    public void init() throws ServletException {
        super.init();
        Properties properties = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (input == null) {
                throw new ServletException("Sorry, unable to find config.properties");
            }
            properties.load(input);
            dbUrl = properties.getProperty("db.url");
            dbUsername = properties.getProperty("db.username");
            dbPassword = properties.getProperty("db.password");
        } catch (IOException ex) {
            throw new ServletException("Error loading config.properties file", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userEmail = request.getParameter("user");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String engineerSql = "SELECT engineer_id, password, full_name, phone_number, department_name, dob, gender FROM engineers WHERE email = ?";
            pstmt = con.prepareStatement(engineerSql);
            pstmt.setString(1, userEmail);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {  // Compare the plain text password directly
                    HttpSession session = request.getSession();
                    session.setAttribute("userType", "engineer");
                    session.setAttribute("email", userEmail);
                    session.setAttribute("engineerId", rs.getInt("engineer_id"));
                    session.setAttribute("fullName", rs.getString("full_name"));
                    session.setAttribute("phoneNumber", rs.getString("phone_number"));
                    session.setAttribute("departmentName", rs.getString("department_name"));
                    session.setAttribute("dob", rs.getDate("dob"));
                    session.setAttribute("gender", rs.getString("gender"));

                    response.sendRedirect("EngineerDashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
                    request.getRequestDispatcher("EngineerLogin.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "User not found. Invalid Login details. Please try again.");
                request.getRequestDispatcher("EngineerLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("EngineerLogin.jsp").forward(request, response);
        } finally {
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
