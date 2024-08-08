package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EngineerDashboard")
public class EngineerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(EngineerDashboardServlet.class.getName());
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("EngineerLogin.jsp");
            return;
        }

        String engineerEmail = (String) session.getAttribute("email");

        try (Connection con = DriverManager.getConnection(
                configProps.getProperty("db.url"),
                configProps.getProperty("db.username"),
                configProps.getProperty("db.password"))) {

            // Fetch engineer details
            try (PreparedStatement pstmt = con.prepareStatement(configProps.getProperty("sql.select_engineer"))) {
                pstmt.setString(1, engineerEmail);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        session.setAttribute("engineer_id", rs.getInt("engineer_id"));
                        session.setAttribute("fullName", rs.getString("full_name"));
                        session.setAttribute("phone_number", rs.getString("phone_number"));
                        session.setAttribute("dob", rs.getString("dob")); // Assuming dob is stored as String
                        session.setAttribute("department_name", rs.getString("department_name"));
                        session.setAttribute("gender", rs.getString("gender"));
                        LOGGER.info("Engineer ID: " + rs.getInt("engineer_id"));
                    } else {
                        LOGGER.warning("No engineer found with email: " + engineerEmail);
                    }
                }
            }

            // Fetch assigned complaints count
            try (PreparedStatement pstmt = con.prepareStatement(configProps.getProperty("sql.assigned_complaints"))) {
                pstmt.setInt(1, (Integer) session.getAttribute("engineer_id"));
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        int assignedComplaints = rs.getInt("assigned");
                        request.setAttribute("assignedComplaints", assignedComplaints);
                        LOGGER.info("Assigned complaints: " + assignedComplaints);
                    } else {
                        LOGGER.warning("No assigned complaints found for engineer ID: " + session.getAttribute("engineer_id"));
                    }
                }
            }

            // Fetch resolved complaints count
            try (PreparedStatement pstmt = con.prepareStatement(configProps.getProperty("sql.resolved_complaints"))) {
                pstmt.setInt(1, (Integer) session.getAttribute("engineer_id"));
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        int resolvedComplaints = rs.getInt("resolved");
                        request.setAttribute("resolvedComplaints", resolvedComplaints);
                        LOGGER.info("Resolved complaints: " + resolvedComplaints);
                    } else {
                        LOGGER.warning("No resolved complaints found for engineer ID: " + session.getAttribute("engineer_id"));
                    }
                }
            }

            request.getRequestDispatcher("EngineerDashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "An error occurred while retrieving the dashboard data.", e);
            request.setAttribute("errorMessage", "Database error occurred. Please try again.");
            request.getRequestDispatcher("EngineerDashboard.jsp").forward(request, response);
        }
    }
}
