package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewAssignedComplaints")
public class ViewAssignedComplaintsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ViewAssignedComplaintsServlet.class.getName());
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> complaints = new ArrayList<>();
        try (Connection con = DriverManager.getConnection(
                configProps.getProperty("db.url"),
                configProps.getProperty("db.username"),
                configProps.getProperty("db.password"));
             PreparedStatement pstmt = createPreparedStatement(con, request)) {

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> complaint = new HashMap<>();
                complaint.put("id", rs.getInt("complaint_id"));
                complaint.put("refId", rs.getString("ref_id"));
                complaint.put("title", rs.getString("complaint_title"));
                complaint.put("departmentName", rs.getString("department_name"));
                complaint.put("type", rs.getString("complaint_type"));
                complaint.put("description", rs.getString("complaint_text"));
                complaint.put("location", rs.getString("location"));
                complaint.put("status", rs.getString("status"));
                complaint.put("dateCreated", rs.getTimestamp("date_created"));
                complaint.put("dateAssigned", rs.getTimestamp("date_assigned"));
                complaint.put("dateResolved", rs.getTimestamp("date_resolved"));
                complaint.put("hodRemarks", rs.getString("hod_remarks"));
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "An error occurred while retrieving the complaints data.", e);
        }

        request.setAttribute("complaints", complaints);
        request.getRequestDispatcher("ViewAssignedComplaints.jsp").forward(request, response);
    }

    private PreparedStatement createPreparedStatement(Connection con, HttpServletRequest request) throws SQLException {
        Integer engineerId = (Integer) request.getSession().getAttribute("engineerId");
        if (engineerId == null) {
            throw new SQLException("Engineer ID is null. User not logged in.");
        }

        String searchRefId = request.getParameter("searchRefId");
        String sql = configProps.getProperty("sql.select_assigned_complaints");
        if (searchRefId != null && !searchRefId.isEmpty()) {
            sql += " AND ref_id LIKE ?";
        }

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, engineerId);
        if (searchRefId != null && !searchRefId.isEmpty()) {
            pstmt.setString(2, "%" + searchRefId + "%");
        }

        LOGGER.info("Executing SQL: " + pstmt.toString());  // Debug statement
        return pstmt;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
