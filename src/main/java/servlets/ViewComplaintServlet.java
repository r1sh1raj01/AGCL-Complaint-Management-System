package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewComplaints")
public class ViewComplaintServlet extends HttpServlet {
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer empId = (Integer) request.getSession().getAttribute("employeeId");

        if (empId == null) {
            response.sendRedirect("EmployeeLogin.jsp"); // Redirect to login page if not logged in
            return;
        }

        List<Complaint> complaints = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
        )) {

            String sql = "SELECT * FROM complaints WHERE employee_id = ?";
            
            String searchRefId = request.getParameter("searchRefId");
            String filter = request.getParameter("filter");

            if (searchRefId != null && !searchRefId.isEmpty()) {
                sql += " AND ref_id LIKE ?";
            }
            
            if (filter != null && !filter.equals("All")) {
                sql += " AND status = ?";
            }

            sql += " ORDER BY date_created ASC";

            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setInt(1, empId);
                
                int paramIndex = 2;
                
                if (searchRefId != null && !searchRefId.isEmpty()) {
                    pstmt.setString(paramIndex++, "%" + searchRefId + "%");
                }

                if (filter != null && !filter.equals("All")) {
                    pstmt.setString(paramIndex++, filter);
                }

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Complaint complaint = new Complaint();
                        complaint.setId(rs.getInt("complaint_id"));
                        complaint.setRefId(rs.getString("ref_id"));
                        complaint.setTitle(rs.getString("complaint_title"));
                        complaint.setDepartmentName(rs.getString("department_name"));
                        complaint.setType(rs.getString("complaint_type"));
                        complaint.setDescription(rs.getString("complaint_text"));
                        complaint.setLocation(rs.getString("location"));
                        complaint.setStatus(rs.getString("status"));
                        complaint.setDateCreated(rs.getTimestamp("date_created"));
                        complaint.setDateAssigned(rs.getTimestamp("date_assigned"));
                        complaint.setDateResolved(rs.getTimestamp("date_resolved"));
                        complaints.add(complaint);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to error page on exception
            return;
        }

        request.setAttribute("complaints", complaints);
        request.getRequestDispatcher("ViewComplaints.jsp").forward(request, response);
    }
}
