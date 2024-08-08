package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
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

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@WebServlet("/ComplaintForm")
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Map<String, Integer> departmentHodMap = new HashMap<>();
    private Map<Integer, String> hodEmailMap = new HashMap<>();
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

        // Initialize the maps with department and HOD mappings
        try (Connection con = DriverManager.getConnection(
                configProperties.getProperty("db.url"),
                configProperties.getProperty("db.username"),
                configProperties.getProperty("db.password")
        )) {
            String sql = configProperties.getProperty("sql.select_departments");
            try (PreparedStatement pstmt = con.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    departmentHodMap.put(rs.getString("department_name"), rs.getInt("hod_id"));
                }
            }

            // Load HOD emails
            sql = configProperties.getProperty("sql.select_hod_emails");
            try (PreparedStatement pstmt = con.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    hodEmailMap.put(rs.getInt("hod_id"), rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to load department-HOD mappings", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch form data
        String fullName = request.getParameter("fullName");
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String departmentName = request.getParameter("department");
        Integer empId = null;

        // Retrieve employeeId from session
        Object empIdObj = request.getSession().getAttribute("employeeId");
        if (empIdObj != null && empIdObj instanceof Integer) {
            empId = (Integer) empIdObj;
        } else {
            sendErrorRedirect(response, "Employee ID not found or invalid in session.");
            return;
        }

        // Validate form data (basic validation, add more if required)
        if (fullName == null || fullName.isEmpty() || title == null || title.isEmpty() ||
                type == null || type.isEmpty() || description == null || description.isEmpty() ||
                location == null || location.isEmpty() || departmentName == null || departmentName.isEmpty()) {
            sendErrorRedirect(response, "Please fill out all required fields.");
            return;
        }

        // Get HOD ID from the map based on the selected department
        Integer hodId = departmentHodMap.get(departmentName);
        if (hodId == null) {
            sendErrorRedirect(response, "Invalid department selected.");
            return;
        }

        // Get HOD email from the map
        String hodEmail = hodEmailMap.get(hodId);
        if (hodEmail == null) {
            sendErrorRedirect(response, "No email found for the selected department's HOD.");
            return;
        }

        // Generate a unique reference ID using the short form
        String refId = ReferenceIdGenerator.generateReferenceId(departmentName);

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Complaint> complaints = new ArrayList<>();

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(
                    configProperties.getProperty("db.url"),
                    configProperties.getProperty("db.username"),
                    configProperties.getProperty("db.password")
            );

            // Insert complaint into database
            String sql = configProperties.getProperty("sql.insert_complaint");
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, refId);
            pstmt.setInt(2, empId);
            pstmt.setString(3, fullName);
            pstmt.setString(4, title);
            pstmt.setString(5, departmentName);
            pstmt.setInt(6, hodId);
            pstmt.setString(7, type);
            pstmt.setString(8, description);
            pstmt.setString(9, location);

            int rowCount = pstmt.executeUpdate();

            if (rowCount > 0) {
                // Send email to HOD
                sendEmailToHod(hodEmail, fullName, title, description);

                // Retrieve all complaints for the employee
                sql = configProperties.getProperty("sql.select_complaints_by_employee");
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, empId);
                rs = pstmt.executeQuery();

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

                // Set complaints list in request attribute
                request.setAttribute("successMessage", "Complaint Successfully Raised!");
                request.setAttribute("complaints", complaints);
                request.getRequestDispatcher("/ViewComplaints.jsp").forward(request, response);
            } else {
                sendErrorRedirect(response, "Failed to submit complaint. Please try again.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            sendErrorRedirect(response, "An error occurred while processing your request. Please try again later.");
        } finally {
            // Close resources
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void sendErrorRedirect(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<script type=\"text/javascript\">");
        out.println("alert('Error: " + message + "');");
        out.println("window.location='ComplaintForm.jsp';");
        out.println("</script>");
    }

    private void sendEmailToHod(String hodEmail, String fullName, String title, String description) {
        String host = configProperties.getProperty("email.host");
        String from = configProperties.getProperty("email.from");
        String password = configProperties.getProperty("email.password");

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", configProperties.getProperty("email.port"));
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(hodEmail));
            message.setSubject("New Complaint Raised");
            message.setText("A new complaint has been raised by " + fullName + "\n\n" +
                    "Complaint Title: " + title + "\n" +
                    "Complaint Description: " + description + "\n\n" +
                    "Please take the necessary action.");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
