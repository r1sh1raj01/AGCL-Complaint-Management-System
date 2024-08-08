package servlets;

import java.io.IOException;
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

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private Properties configProperties = new Properties();

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            configProperties.load(getServletContext().getResourceAsStream("/WEB-INF/config.properties"));
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to load config.properties", e);
            throw new ServletException("Failed to load config.properties", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

            String departmentName = (String) request.getSession().getAttribute("departmentName");

            if (departmentName == null) {
                response.sendRedirect("AdminLogin.jsp");
                return;
            }

            // Fetch total complaints
            pstmt = con.prepareStatement(configProperties.getProperty("sql.total_complaints"));
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            int totalComplaints = 0;
            if (rs.next()) {
                totalComplaints = rs.getInt("total");
            }
            rs.close();
            pstmt.close();
            LOGGER.info("Total complaints: " + totalComplaints);

            // Fetch resolved complaints
            pstmt = con.prepareStatement(configProperties.getProperty("sql.resolved_complaints"));
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            int resolvedComplaints = 0;
            if (rs.next()) {
                resolvedComplaints = rs.getInt("resolved");
            }
            rs.close();
            pstmt.close();
            LOGGER.info("Resolved complaints: " + resolvedComplaints);

            // Fetch pending complaints
            pstmt = con.prepareStatement(configProperties.getProperty("sql.pending_complaints"));
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            int pendingComplaints = 0;
            if (rs.next()) {
                pendingComplaints = rs.getInt("pending");
            }
            rs.close();
            pstmt.close();
            LOGGER.info("Pending complaints: " + pendingComplaints);

            // Fetch assigned complaints
            pstmt = con.prepareStatement(configProperties.getProperty("sql.assigned_complaints"));
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            int assignedComplaints = 0;
            if (rs.next()) {
                assignedComplaints = rs.getInt("assigned");
            }
            rs.close();
            pstmt.close();
            LOGGER.info("Assigned complaints: " + assignedComplaints);

            // Fetch average resolution time
            pstmt = con.prepareStatement(configProperties.getProperty("sql.avg_resolution_time"));
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            double avgResolutionTime = 0;
            if (rs.next()) {
                avgResolutionTime = rs.getDouble("avg_resolution_time");
            }
            rs.close();
            pstmt.close();
            LOGGER.info("Average resolution time: " + avgResolutionTime);

            // Set attributes for the JSP
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("resolvedComplaints", resolvedComplaints);
            request.setAttribute("pendingComplaints", pendingComplaints);
            request.setAttribute("assignedComplaints", assignedComplaints);
            request.setAttribute("avgResolutionTime", avgResolutionTime);

            // Forward to the JSP page
            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "An error occurred while retrieving the dashboard data.", e);
            request.setAttribute("errorMessage", "An error occurred while retrieving the dashboard data.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
    }
}
