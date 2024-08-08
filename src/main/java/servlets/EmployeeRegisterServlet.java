package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EmployeeRegister")
public class EmployeeRegisterServlet extends HttpServlet {
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
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("number");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String department = request.getParameter("department");
        String dateJoined = request.getParameter("date_joined");

        // Validate input and passwords
        if (!isInputValid(name, email, phone, password, confirmPassword, dob, dateJoined, request, response)) {
            return;
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = prepareInsertStatement(conn, name, email, phone, password, gender, dob, department, dateJoined)) {

            int rows = pstmt.executeUpdate();
            handleRegistrationOutcome(rows, request, response);

        } catch (Exception e) {
            logError(e, request);
            forwardWithError("An error occurred: " + e.getMessage(), "EmployeeRegister.jsp", request, response);
        }
    }

    private boolean isInputValid(String name, String email, String phone, String password, String confirmPassword,
                                 String dob, String dateJoined, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!password.equals(confirmPassword)) {
            forwardWithError("Passwords do not match.", "EmployeeRegister.jsp", request, response);
            return false;
        }

        if (!isValidDateFormat(dob) || !isValidDateFormat(dateJoined)) {
            forwardWithError("Invalid date format for DOB or Date Joined.", "EmployeeRegister.jsp", request, response);
            return false;
        }

        return true;
    }

    private boolean isValidDateFormat(String date) {
        try {
            new SimpleDateFormat("yyyy-MM-dd").parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }

    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("org.postgresql.Driver");
        String url = configProperties.getProperty("db.url");
        String username = configProperties.getProperty("db.username");
        String password = configProperties.getProperty("db.password");
        return DriverManager.getConnection(url, username, password);
    }

    private PreparedStatement prepareInsertStatement(Connection conn, String name, String email, String phone, String password,
                                                     String gender, String dob, String department, String dateJoined) throws SQLException {
        String sql = configProperties.getProperty("sql.insert_employee");
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, phone);
        pstmt.setString(4, password); // Store the plain text password directly
        pstmt.setString(5, gender);
        pstmt.setDate(6, Date.valueOf(dob));
        pstmt.setString(7, department);
        pstmt.setDate(8, Date.valueOf(dateJoined));
        return pstmt;
    }

    private void handleRegistrationOutcome(int rows, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (rows > 0) {
            forwardWithSuccess("Registration successful. You can now log in.", "EmployeeLogin.jsp", request, response);
        } else {
            forwardWithError("Registration failed. Please try again.", "EmployeeRegister.jsp", request, response);
        }
    }

    private void forwardWithSuccess(String message, String target, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("successMessage", message);
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void forwardWithError(String message, String target, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void logError(Exception e, HttpServletRequest request) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
    }
}
