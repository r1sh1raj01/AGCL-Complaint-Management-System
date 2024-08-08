package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminAssignComplaints")
public class AdminAssignComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Email configuration
    private final String smtpHost = "smtp.office365.com";
    private final String smtpPort = "587";
    private final String smtpUser = "test@agclgas.com";
    private final String smtpPassword = "newPass@150724!";

    // Database configuration
    private String dbUrl;
    private String dbUsername;
    private String dbPassword;

    @Override
    public void init() throws ServletException {
        super.init();

        Properties config = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (input == null) {
                throw new ServletException("Config file not found");
            }
            config.load(input);

            // Load properties
            this.dbUrl = config.getProperty("db.url");
            this.dbUsername = config.getProperty("db.username");
            this.dbPassword = config.getProperty("db.password");

        } catch (IOException e) {
            throw new ServletException("Error loading config properties", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("assignComplaint".equals(action)) {
            String refId = request.getParameter("refId");
            int engineerId = Integer.parseInt(request.getParameter("engineerId"));
            String hodRemarks = request.getParameter("hodRemarks");

            try {
                // Fetch the engineer's details
                String engineerName = getEngineerName(engineerId);
                String engineerEmail = getEngineerEmail(engineerId);

                // Fetch the complaint details
                ComplaintDetails complaintDetails = getComplaintDetails(refId);

                if (complaintDetails == null) {
                    throw new ServletException("No complaint details found for refId: " + refId);
                }

                // Assign engineer to complaint
                assignEngineerToComplaint(engineerId, refId, hodRemarks);

                // Debug message
                System.out.println("About to send assignment email...");
                // Send an email to the engineer
                sendAssignmentEmail(engineerName, engineerEmail, complaintDetails);
                System.out.println("Assignment email sent.");

                // Redirect back with a success message
                response.sendRedirect("AdminAssignComplaints.jsp?success=1&engineerName=" + engineerName);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("AdminAssignComplaints.jsp?success=0");
            }
        }
    }

    // Fetch the engineer's details
    private String getEngineerName(int engineerId) throws ServletException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engineerName = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String sql = "SELECT full_name FROM engineers WHERE engineer_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, engineerId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                engineerName = rs.getString("full_name");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error fetching engineer name", e);
        } finally {
            closeResources(con, pstmt, rs);
        }
        return engineerName;
    }

    private String getEngineerEmail(int engineerId) throws ServletException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String email = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String sql = "SELECT email FROM engineers WHERE engineer_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, engineerId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                email = rs.getString("email");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error fetching engineer email", e);
        } finally {
            closeResources(con, pstmt, rs);
        }
        return email;
    }

    private ComplaintDetails getComplaintDetails(String refId) throws ServletException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ComplaintDetails complaintDetails = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String sql = "SELECT complaint_title, complaint_text FROM complaints WHERE ref_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, refId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String complaintTitle = rs.getString("complaint_title");
                String complaintText = rs.getString("complaint_text");
                complaintDetails = new ComplaintDetails(complaintTitle, complaintText, refId);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error fetching complaint details", e);
        } finally {
            closeResources(con, pstmt, rs);
        }
        return complaintDetails;
    }

    private void assignEngineerToComplaint(int engineerId, String refId, String hodRemarks) throws ServletException {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String sql = "UPDATE complaints SET engineer_id = ?, date_assigned = ?, status = 'Assigned', hod_remarks = ? WHERE ref_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, engineerId);
            pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setString(3, hodRemarks);
            pstmt.setString(4, refId);
            pstmt.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error assigning engineer to complaint", e);
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    private void sendAssignmentEmail(String engineerName, String engineerEmail, ComplaintDetails complaintDetails) throws ServletException {
        if (complaintDetails == null) {
            throw new ServletException("Complaint details are null");
        }

        System.out.println("Preparing to send email to: " + engineerEmail);

        // Set up mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Create a session with the mail server
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            // Create a new email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpUser));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(engineerEmail));
            message.setSubject("New Complaint Assigned: " + complaintDetails.getTitle());
            message.setText("Dear " + engineerName + ",\n\n"
                    + "You have been assigned a new complaint:\n\n"
                    + "Complaint Reference ID: " + complaintDetails.getRefId() + "\n"
                    + "Title: " + complaintDetails.getTitle() + "\n"
                    + "Complaint Text: " + complaintDetails.getText() + "\n\n"
                    + "Please address this complaint at your earliest convenience.\n\n"
                    + "Best regards,\n"
                    + "Assam Gas Company Ltd");

            // Send the email
            Transport.send(message);
            System.out.println("Email sent successfully to: " + engineerEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new ServletException("Error sending email", e);
        }
    }

    // Utility method to close database resources
    private void closeResources(Connection con, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Inner class for holding complaint details
    private static class ComplaintDetails {
        private final String title;
        private final String text;
        private final String refId;

        public ComplaintDetails(String title, String text, String refId) {
            this.title = title;
            this.text = text;
            this.refId = refId;
        }

        public String getTitle() {
            return title;
        }

        public String getText() {
            return text;
        }

        public String getRefId() {
            return refId;
        }
    }
}