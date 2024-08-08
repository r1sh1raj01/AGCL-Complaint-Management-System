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
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EmployeeLogin")
public class EmployeeLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int COOKIE_EXPIRY = 60 * 60 * 24 * 7; // 7 days

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
        String userEmail = request.getParameter("user");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
            );

            String employeeSql = configProperties.getProperty("sql.select_employee");
            pstmt = con.prepareStatement(employeeSql);
            pstmt.setString(1, userEmail);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userType", "employee");
                    session.setAttribute("email", userEmail);
                    session.setAttribute("employeeId", rs.getInt("employee_id"));
                    session.setAttribute("fullName", rs.getString("full_name"));
                    session.setAttribute("phoneNumber", rs.getString("phone_number"));
                    session.setAttribute("departmentName", rs.getString("department_name"));
                    session.setAttribute("dateJoined", rs.getDate("date_joined"));

                    if ("on".equals(rememberMe)) {
                        Cookie emailCookie = new Cookie("savedEmail", userEmail);
                        emailCookie.setMaxAge(COOKIE_EXPIRY);
                        response.addCookie(emailCookie);

                        Cookie passwordCookie = new Cookie("savedPassword", password);
                        passwordCookie.setMaxAge(COOKIE_EXPIRY);
                        response.addCookie(passwordCookie);

                        Cookie rememberCookie = new Cookie("savedRemember", "true");
                        rememberCookie.setMaxAge(COOKIE_EXPIRY);
                        response.addCookie(rememberCookie);
                    } else {
                        Cookie emailCookie = new Cookie("savedEmail", "");
                        emailCookie.setMaxAge(0);
                        response.addCookie(emailCookie);

                        Cookie passwordCookie = new Cookie("savedPassword", "");
                        passwordCookie.setMaxAge(0);
                        response.addCookie(passwordCookie);

                        Cookie rememberCookie = new Cookie("savedRemember", "");
                        rememberCookie.setMaxAge(0);
                        response.addCookie(rememberCookie);
                    }

                    response.sendRedirect("EmployeeDashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
                    request.getRequestDispatcher("EmployeeLogin.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "User not found. Invalid Login details. Please try again.");
                request.getRequestDispatcher("EmployeeLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("EmployeeLogin.jsp").forward(request, response);
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("savedEmail".equals(cookie.getName())) {
                    request.setAttribute("savedEmail", cookie.getValue());
                } else if ("savedPassword".equals(cookie.getName())) {
                    request.setAttribute("savedPassword", cookie.getValue());
                } else if ("savedRemember".equals(cookie.getName())) {
                    request.setAttribute("savedRemember", "true");
                }
            }
        }
        request.getRequestDispatcher("EmployeeLogin.jsp").forward(request, response);
    }
}
