<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Complaints - Admin Dashboard</title>
    <link rel="stylesheet" href="CSS/viewcomplaint1.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <!-- Prevent caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" no-cache />
    <meta http-equiv="Expires" content="0" />
    <style>
        .remarks-input, .engineer-select, .assign-button {
            padding: 10px;
            margin: 5px 0;
            width: 100%;
            box-sizing: border-box;
        }
        .remarks-input {
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .engineer-select {
            border: 1px solid #ccc;
            border-radius: 4px;
            appearance: none;
            background-color: #f2f2f2;
        }
        .assign-button {
            background-color: #6d13ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .assign-button:hover {
            background-color: #400a97;
        }
        /* Loader and Background Blur */
        .loader-container {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .three-body {
            display: inline-block;
            position: relative;
            width: 80px;
            height: 60px;
        }

        .three-body__dot {
            position: absolute;
            background-color: #0a255f;
            border-radius: 50%;
            width: 10px;
            height: 10px;
            animation: three-body__dot 1.4s infinite ease-in-out;
        }

        .three-body__dot:nth-child(1) {
            left: 10px;
            animation-delay: -0.32s;
        }

        .three-body__dot:nth-child(2) {
            left: 30px;
            animation-delay: -0.16s;
        }

        .three-body__dot:nth-child(3) {
            left: 50px;
        }

        @keyframes three-body__dot {
            0%, 80%, 100% {
                transform: scale(0);
            }

            40% {
                transform: scale(1);
            }
        }

        /* Table Header Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th {
            background-color: #002e5f;
            color: white;
            padding: 10px;
            text-align: left;
        }

        td {
            padding: 10px;
            vertical-align: top;
        }

        th, td {
            border-bottom: 1px solid #ddd;
        }

        th {
            font-weight: bold;
        }
        .expand-link {
    display: block;
    color: #001933;
    text-decoration: none;
    font-size: 0.9em;
    margin-top: 0.5em;
}

.expand-link:hover {
    text-decoration: none;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
    padding: 0.5em;
    margin: 0.2em;
    border-radius: 5px;
    background-color: #002e5f;
    cursor: pointer;
    color: #fff;
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    background-color: #002144;
}

.dataTables_wrapper .dataTables_filter {
    margin-bottom: 1em;
}

.dataTables_wrapper .dataTables_filter input {
    border-radius: 5px;
    border: 1px solid #ddd;
    padding: 0.5em;
}

.dataTables_wrapper .dataTables_info {
    margin-bottom: 1em;
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
            <h1>Assign Complaints - <%= session.getAttribute("departmentName") %></h1>
            <table>
                <thead>
                    <tr>
                        <th>Complaint ID</th>
                        <th>Reference ID</th>
                        <th>Complaint Raised By</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Assign Engineer</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        Properties configProps = new Properties();
                        InputStream input = null;
                        boolean hasComplaints = false;

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

                            // Connect to the database
                            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                            String departmentName = (String) session.getAttribute("departmentName");
                            String selectComplaintsSql = "SELECT complaint_id, ref_id, employee_name, complaint_title, status FROM complaints WHERE department_name = ? AND status = 'Pending' AND engineer_id IS NULL";
                            pstmt = con.prepareStatement(selectComplaintsSql);
                            pstmt.setString(1, departmentName);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                hasComplaints = true;
                                int complaintId = rs.getInt("complaint_id");
                                String refId = rs.getString("ref_id");
                                String employeeName = rs.getString("employee_name");
                                String complaintTitle = rs.getString("complaint_title");
                                String status = rs.getString("status");

                                out.print("<tr>");
                                out.print("<td>" + complaintId + "</td>");
                                out.print("<td>" + refId + "</td>");
                                out.print("<td>" + employeeName + "</td>");
                                out.print("<td>" + complaintTitle + "</td>");
                                out.print("<td>" + status + "</td>");
                                out.print("<td>");
                                out.print("<form action='AdminAssignComplaints' method='post' onsubmit='showLoader();'>");
                                out.print("<input type='hidden' name='action' value='assignComplaint'>");
                                out.print("<input type='hidden' name='refId' value='" + refId + "'>");
                                out.print("<select name='engineerId' class='engineer-select'>");
                                // Fetch available engineers
                                Connection conEng = null;
                                PreparedStatement pstmtEng = null;
                                ResultSet rsEng = null;
                                try {
                                    conEng = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                                    String selectEngineersSql = "SELECT engineer_id, full_name FROM engineers WHERE department_name = ?";
                                    pstmtEng = conEng.prepareStatement(selectEngineersSql);
                                    pstmtEng.setString(1, departmentName);
                                    rsEng = pstmtEng.executeQuery();

                                    while (rsEng.next()) {
                                        int engineerId = rsEng.getInt("engineer_id");
                                        String fullName = rsEng.getString("full_name");
                                        out.print("<option value='" + engineerId + "'>" + fullName + "</option>");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsEng != null) try { rsEng.close(); } catch (SQLException ignore) {}
                                    if (pstmtEng != null) try { pstmtEng.close(); } catch (SQLException ignore) {}
                                    if (conEng != null) try { conEng.close(); } catch (SQLException ignore) {}
                                }
                                out.print("</select>");
                                out.print("<input type='text' name='hodRemarks' placeholder='Enter HOD remarks' class='remarks-input'>");
                                out.print("<button type='submit' class='assign-button'>Assign</button>");
                                out.print("</form>");
                                out.print("</td>");
                                out.print("</tr>");
                            }

                            if (!hasComplaints) {
                                out.print("<tr><td colspan='6'>No new complaints to be assigned. All complaints assigned to Engineers.</td></tr>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                            if (con != null) try { con.close(); } catch (SQLException ignore) {}
                            if (input != null) try { input.close(); } catch (IOException ignore) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
    <footer>
        <div class="footer-container">
            <p>&copy; 2024 Assam Gas Company Ltd. All rights reserved.</p>
            <nav>
                <a href="privacy-policy.html">Privacy Policy</a>
                <a href="terms-of-service.html">Terms of Service</a>
            </nav>
            <div class="social-links">
                <a href="https://www.facebook.com/Assamgas/"><i class="fab fa-facebook-f"></i></a>
                <a href="https://x.com/AGCLonline?t=yWtQpO2KPLBRmyIJaZkVSA&s=09"><i class="fab fa-twitter"></i></a>
                <a href="https://www.instagram.com/agclonline/?igsh=dzJ6Mmk0OWtlbXFr"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>

    <div id="loader" class="loader-container">
        <div class="three-body">
            <div class="three-body__dot"></div>
            <div class="three-body__dot"></div>
            <div class="three-body__dot"></div>
        </div>
    </div>

    <script>
        function showLoader() {
            document.getElementById('loader').style.display = 'flex';
        }

        document.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === '1') {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: `Complaint assigned successfully to ${urlParams.get('engineerName')}.`
                });
            } else if (urlParams.get('success') === '0') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to assign the complaint. Please try again.'
                });
            }
        });
    </script>
</body>

</html>
