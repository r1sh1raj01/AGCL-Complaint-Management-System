<%@ page session="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - AGCL Complaint Management System</title>
    <link rel="stylesheet" href="CSS/AdminDashboard.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <style>
        .success-message {
            background-color: #4CAF50;
            color: white;
            text-align: center;
            padding: 10px;
            margin-bottom: 10px;
        }
        .stat-item {
            cursor: pointer;
            background: #f4f4f4;
            border-radius: 10px;
            padding: 20px;
            margin: 10px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat-item h2 {
            margin: 10px 0;
            font-size: 24px;
        }
        .filter-bar a {
            text-decoration: none;
            color: #007bff;
            margin-right: 10px;
        }
        .profile {
            background: #f4f4f4;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .profile h2 {
            margin-bottom: 20px;
        }
        .profile p {
            margin: 10px 0;
        }
        footer {
            background: #222;
            color: #fff;
            padding: 20px 0;
        }
        footer .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        footer nav a {
            color: #fff;
            margin: 0 10px;
            text-decoration: none;
        }
        .social-links a {
            color: #fff;
            margin: 0 10px;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
            <nav>
                <ul>
                    <li><a href="AdminDashboard.jsp">Home</a></li>
                    <li><a href="AdminViewComplaints.jsp">View Complaints</a></li>
                    <li><a href="AdminAssignComplaints.jsp">Assign Complaints</a></li>
                    <li><a href="RegisterEngineer.jsp">Add Engineers</a></li>
                    <li><a href="Logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <%-- Check if engineer registration was successful --%>
            <% 
                Boolean engineerRegistrationSuccess = (Boolean) request.getAttribute("engineerRegistrationSuccess");
                if (engineerRegistrationSuccess != null && engineerRegistrationSuccess) {
            %>
            <div class="success-message">
                Engineer registered successfully!
            </div>
            <% 
                }
            %>

            <section class="dashboard-overview">
                <h1>Welcome, <%= session.getAttribute("fullName") %>!</h1>
                <div class="overview-stats">
                    <%
                        Connection con = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        Properties configProps = new Properties();
                        InputStream input = null;

                        try {
                            // Load the properties file
                            input = getServletContext().getResourceAsStream("/WEB-INF/config.properties");
                            if (input == null) {
                                throw new IOException("Unable to find config.properties");
                            }
                            configProps.load(input);

                            // Get database connection details
                            String dbUrl = configProps.getProperty("db.url");
                            String dbUsername = configProps.getProperty("db.username");
                            String dbPassword = configProps.getProperty("db.password");

                            // SQL queries (kept as is from your original code)
                            String totalComplaintsSql = "SELECT COUNT(*) AS total FROM complaints WHERE department_name = ?";
                            String resolvedComplaintsSql = "SELECT COUNT(*) AS resolved FROM complaints WHERE department_name = ? AND status = 'Resolved'";
                            String pendingComplaintsSql = "SELECT COUNT(*) AS pending FROM complaints WHERE department_name = ? AND status = 'Pending'";
                            String assignedComplaintsSql = "SELECT COUNT(*) AS assigned FROM complaints WHERE department_name = ? AND status = 'Assigned'";

                            // Connect to the database
                            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                            String departmentName = (String) session.getAttribute("departmentName");

                            if (departmentName == null) {
                                throw new Exception("Department name is not set in the session.");
                            }

                            // Fetch total complaints
                            pstmt = con.prepareStatement(totalComplaintsSql);
                            pstmt.setString(1, departmentName);
                            rs = pstmt.executeQuery();
                            int totalComplaints = 0;
                            if (rs.next()) {
                                totalComplaints = rs.getInt("total");
                            }
                            rs.close();
                            pstmt.close();

                            // Fetch resolved complaints
                            pstmt = con.prepareStatement(resolvedComplaintsSql);
                            pstmt.setString(1, departmentName);
                            rs = pstmt.executeQuery();
                            int resolvedComplaints = 0;
                            if (rs.next()) {
                                resolvedComplaints = rs.getInt("resolved");
                            }
                            rs.close();
                            pstmt.close();

                            // Fetch pending complaints
                            pstmt = con.prepareStatement(pendingComplaintsSql);
                            pstmt.setString(1, departmentName);
                            rs = pstmt.executeQuery();
                            int pendingComplaints = 0;
                            if (rs.next()) {
                                pendingComplaints = rs.getInt("pending");
                            }
                            rs.close();
                            pstmt.close();

                            // Fetch assigned complaints
                            pstmt = con.prepareStatement(assignedComplaintsSql);
                            pstmt.setString(1, departmentName);
                            rs = pstmt.executeQuery();
                            int assignedComplaints = 0;
                            if (rs.next()) {
                                assignedComplaints = rs.getInt("assigned");
                            }
                            rs.close();
                            pstmt.close();

                            // Set attributes for the JSP
                            request.setAttribute("totalComplaints", totalComplaints);
                            request.setAttribute("resolvedComplaints", resolvedComplaints);
                            request.setAttribute("pendingComplaints", pendingComplaints);
                            request.setAttribute("assignedComplaints", assignedComplaints);

                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                            if (con != null) try { con.close(); } catch (SQLException ignore) {}
                            if (input != null) try { input.close(); } catch (IOException ignore) {}
                        }
                    %>
                    <div class='stat-item' onclick="location.href='AdminViewComplaints.jsp?filter=all';"><p>Total Complaints:</p><h2><%= request.getAttribute("totalComplaints") %></h2></div>
                    <div class='stat-item' onclick="location.href='AdminViewComplaints.jsp?filter=resolved';"><p>Complaints Resolved:</p><h2><%= request.getAttribute("resolvedComplaints") %></h2></div>
                    <div class='stat-item' onclick="location.href='AdminViewComplaints.jsp?filter=pending';"><p>Pending Complaints:</p><h2><%= request.getAttribute("pendingComplaints") %></h2></div>
                    <div class='stat-item' onclick="location.href='AdminViewComplaints.jsp?filter=assigned';"><p>Assigned Complaints:</p><h2><%= request.getAttribute("assignedComplaints") %></h2></div>
                </div>
            </section>

            <section class="profile">
                <h2>Your Profile</h2>
                <p><strong>Name:</strong> <%= session.getAttribute("fullName") %></p>
                <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
                <p><strong>Phone:</strong> <%= session.getAttribute("phoneNumber") %></p>
                <p><strong>Department:</strong> <%= session.getAttribute("departmentName") %></p>
                
            </section>
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2024 Assam Gas Company Ltd. All rights reserved.</p>
            <nav>
                <a href="privacy-policy.html">Privacy Policy</a>
                <a href="terms-of-service.html">Terms of Service</a>
            </nav>
            <div class="social-links">
                <a href="https://www.facebook.com/Assamgas/"><i class="fab fa-facebook-f"></i></a>
                <a href="https://twitter.com/AssamGas"><i class="fab fa-twitter"></i></a>
                <a href="https://www.linkedin.com/company/assam-gas-company-limited"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
    </footer>
</body>
</html>
