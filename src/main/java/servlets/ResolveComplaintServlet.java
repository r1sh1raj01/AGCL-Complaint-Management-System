package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/ResolveComplaint")
public class ResolveComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ResolveComplaintServlet.class.getName());
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] selectedComplaints = request.getParameterValues("selectedComplaints");

        if (selectedComplaints == null || selectedComplaints.length == 0) {
            response.sendRedirect("ResolveComplaint.jsp");
            return;
        }

        try (Connection con = DriverManager.getConnection(
                configProps.getProperty("db.url"),
                configProps.getProperty("db.username"),
                configProps.getProperty("db.password"))) {

            boolean hasComplaintsToResolve = false;

            for (String refId : selectedComplaints) {
                String engineerRemarks = request.getParameter("engineerRemarks_" + refId);

                String updateSql = configProps.getProperty("sql.update_complaint_status");
                try (PreparedStatement pstmt = con.prepareStatement(updateSql)) {
                    pstmt.setTimestamp(1, java.sql.Timestamp.valueOf(LocalDateTime.now()));
                    pstmt.setString(2, engineerRemarks);
                    pstmt.setString(3, refId);
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        hasComplaintsToResolve = true;
                        sendEmailNotification(refId);
                    }
                }
            }

            if (hasComplaintsToResolve) {
                request.getSession().setAttribute("successMessage", "Complaints resolved successfully.");
            } else {
                request.getSession().setAttribute("successMessage", "No complaints were resolved.");
            }

            response.sendRedirect("ResolveComplaint.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error resolving complaints", e);
            request.getSession().setAttribute("successMessage", "Error resolving complaints. Please try again.");
            response.sendRedirect("ResolveComplaint.jsp");
        }
    }

    private void sendEmailNotification(String refId) throws SQLException, ClassNotFoundException, MessagingException {
        try (Connection con = DriverManager.getConnection(
                configProps.getProperty("db.url"),
                configProps.getProperty("db.username"),
                configProps.getProperty("db.password"));
             PreparedStatement pstmt = con.prepareStatement(configProps.getProperty("sql.select_complaint_details"))) {

            pstmt.setString(1, refId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String employeeEmail = rs.getString("employee_email");
                    String complaintTitle = rs.getString("complaint_title");
                    String complaintText = rs.getString("complaint_text");
                    Date dateCreated = rs.getDate("date_created");
                    Date dateResolved = rs.getDate("date_resolved");
                    String engineerName = rs.getString("engineer_name");
                    String hodEmail = rs.getString("hod_email");

                    String subject = "Your Complaint has been Resolved";
                    String body = "Dear Employee,\n\n" +
                                  "We are pleased to inform you that your complaint has been resolved.\n\n" +
                                  "Complaint Title: " + complaintTitle + "\n" +
                                  "Complaint Description: " + complaintText + "\n" +
                                  "Date Created: " + dateCreated + "\n" +
                                  "Date Resolved: " + dateResolved + "\n" +
                                  "Engineer: " + engineerName + "\n\n" +
                                  "Thank you for your patience.\n\n" +
                                  "Best Regards,\n" +
                                  "AGCL Complaints Management Team";

                    Properties properties = System.getProperties();
                    properties.setProperty("mail.smtp.host", configProps.getProperty("email.host"));
                    properties.setProperty("mail.smtp.port", configProps.getProperty("email.port"));
                    properties.setProperty("mail.smtp.auth", "true");
                    properties.setProperty("mail.smtp.starttls.enable", "true");

                    Session session = Session.getInstance(properties, new Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(
                                    configProps.getProperty("email.from"),
                                    configProps.getProperty("email.password"));
                        }
                    });

                    MimeMessage message = new MimeMessage(session);
                    message.setFrom(new InternetAddress(configProps.getProperty("email.from")));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(employeeEmail));
                    message.addRecipient(Message.RecipientType.CC, new InternetAddress(hodEmail));
                    message.setSubject(subject);
                    message.setText(body);

                    Transport.send(message);
                }
            }
        }
    }
}
