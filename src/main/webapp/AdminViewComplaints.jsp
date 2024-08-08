<%@ page session="true" %>
<%@ page import="java.sql.*, java.util.Properties, java.io.InputStream" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Complaints - Admin Dashboard</title>
    <link rel="stylesheet" href="CSS/viewcomplaint1.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <style>
        /* Main Content Styles */
        main {
            padding: 2em 1em;
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            margin-bottom: 1em;
            color: #00254d;
        }
        .search-bar {
            margin-bottom: 1em;
            text-align: center;
        }
        .search-bar form {
            display: inline-flex;
            justify-content: center;
            align-items: center;
        }
        .search-bar input {
            padding: 0.5em;
            font-size: 1em;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-right: 0.5em;
            width: 200px;
        }
        .search-bar button {
            padding: 0.5em 1em;
            font-size: 1em;
            color: #fff;
            background-color: #00254d;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .search-bar button:hover {
            background-color: #001933;
        }
        .filter-bar {
            margin-bottom: 1em;
            text-align: center;
        }

        .filter-bar a {
            color: #001933;
            text-decoration: none;
            margin: 0 0.5em;
            font-weight: bold;
        }

        .filter-bar a:hover {
            text-decoration: none;
        }

        /* Table Styles */
        #complaintsTable {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        #complaintsTable thead {
            background-color: #002e5f;
            color: #fff;
        }

        #complaintsTable th, #complaintsTable td {
            padding: 0.75em;
            text-align: left;
        }

        #complaintsTable th {
            border-bottom: 2px solid #122a5f;
        }

        #complaintsTable tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        #complaintsTable tbody tr:hover {
            background-color: #e0f2f1;
        }

        .truncate {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 250px; /* Adjusted for better visibility */
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
        footer {
            background-color: #333;
            color: #fff;
            padding: 1rem 0;
            text-align: center;
            margin-top: 40px;
            padding-bottom: 30px;
        }
        footer .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        footer nav a {
            color: #fff;
            text-decoration: none;
            margin: 0 10px;
        }
        footer nav a:hover {
            text-decoration: underline;
        }
        .social-links a {
            color: #fff;
            font-size: 1.2rem;
            margin: 0 10px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#complaintsTable').DataTable({
                "paging": true,
                "searching": true,
                "ordering": true,
                "order": [[0, 'desc']],
                "pageLength": 10,
                "columnDefs": [
                    {
                        "targets": [0],
                        "visible": false
                    },
                    {
                        "targets": [7, 9, 10],
                        "type": "date",
                        "render": function (data, type, row) {
                            return data ? data : "N/A";
                        }
                    }
                ]
            });
        });

        function expandDescription(complaintId) {
            var description = document.getElementById('desc_' + complaintId);
            var expandLink = document.getElementById('expand_' + complaintId);
            description.style.whiteSpace = 'normal';
            expandLink.style.display = 'none';
        }
    </script>
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
            <h1>Complaints - <%= session.getAttribute("departmentName") %></h1>

            <div class="search-bar">
                <form action="AdminViewComplaints.jsp" method="get">
                    <input type="text" name="searchRefId" placeholder="Search by Reference ID" 
                        <%= (request.getParameter("searchRefId") != null && !request.getParameter("searchRefId").isEmpty()) ? "value='" + request.getParameter("searchRefId") + "'" : "" %>>
                    <button type="submit">Search</button>
                </form>
            </div>

            <div class="filter-bar">
                <a href="AdminViewComplaints.jsp?filter=all">All Complaints</a> | 
                <a href="AdminViewComplaints.jsp?filter=assigned">Assigned Complaints</a> |                 
                <a href="AdminViewComplaints.jsp?filter=resolved">Resolved Complaints</a> | 
                <a href="AdminViewComplaints.jsp?filter=pending">Pending Complaints</a>
            </div>

            <table id="complaintsTable">
                <thead>
                    <tr>
                        <th>Complaint ID</th>
                        <th>Reference ID</th>
                        <th>Complaint Raised By</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Date Created</th>
                        <th>Assigned to Engineer</th>
                        <th>Engineer Name</th>
                        <th>Date Assigned</th>
                        <th>Date Resolved</th>
                        <th>Time Taken (days)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            // Load the properties file
                            Properties props = new Properties();
                            InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties");
                            props.load(input);

                            // Retrieve the database connection parameters
                            String dbUrl = props.getProperty("db.url");
                            String dbUsername = props.getProperty("db.username");
                            String dbPassword = props.getProperty("db.password");

                            Class.forName("org.postgresql.Driver");
                            con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                            String departmentName = (String) session.getAttribute("departmentName");
                            String filter = request.getParameter("filter");
                            String searchRefId = request.getParameter("searchRefId");

                            StringBuilder sqlBuilder = new StringBuilder();
                            sqlBuilder.append("SELECT c.complaint_id, c.ref_id, c.employee_name, c.complaint_title, c.complaint_text, c.status, c.date_created, c.date_assigned, c.date_resolved, c.engineer_id, e.full_name as engineer_name ")
                                      .append("FROM complaints c ")
                                      .append("LEFT JOIN engineers e ON c.engineer_id = e.engineer_id ")
                                      .append("WHERE c.department_name = ? ");

                            if ("resolved".equals(filter)) {
                                sqlBuilder.append("AND c.status = 'Resolved' ");
                            } else if ("pending".equals(filter)) {
                                sqlBuilder.append("AND c.status = 'Pending' ");
                            } else if ("assigned".equals(filter)) {
                                sqlBuilder.append("AND c.status = 'Assigned' ");
                            }

                            if (searchRefId != null && !searchRefId.isEmpty()) {
                                sqlBuilder.append("AND c.ref_id LIKE ? ");
                            }

                            sqlBuilder.append("ORDER BY c.date_created DESC");

                            pstmt = con.prepareStatement(sqlBuilder.toString());
                            pstmt.setString(1, departmentName);

                            if (searchRefId != null && !searchRefId.isEmpty()) {
                                pstmt.setString(2, "%" + searchRefId + "%");
                            }

                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int complaintId = rs.getInt("complaint_id");
                                String refId = rs.getString("ref_id");
                                String employeeName = rs.getString("employee_name");
                                String complaintTitle = rs.getString("complaint_title");
                                String complaintText = rs.getString("complaint_text");
                                String status = rs.getString("status");
                                Date dateCreated = rs.getDate("date_created");
                                Date dateAssigned = rs.getDate("date_assigned");
                                Date dateResolved = rs.getDate("date_resolved");
                                int engineerId = rs.getInt("engineer_id");
                                String engineerName = rs.getString("engineer_name");

                                long timeTaken = 0;
                                if (dateAssigned != null && dateResolved != null) {
                                    long diffInMillis = dateResolved.getTime() - dateAssigned.getTime();
                                    timeTaken = diffInMillis / (1000 * 60 * 60 * 24);
                                }

                                String assignedDate = (dateAssigned != null) ? dateAssigned.toString() : "N/A";
                                String resolvedDate = (dateResolved != null) ? dateResolved.toString() : "N/A";

                                out.print("<tr>");
                                out.print("<td>" + complaintId + "</td>");
                                out.print("<td>" + refId + "</td>");
                                out.print("<td>" + employeeName + "</td>");
                                out.print("<td>" + complaintTitle + "</td>");
                                out.print("<td>");
                                out.print("<div id='desc_" + complaintId + "' class='truncate'>" + complaintText + "</div>");
                                if (complaintText.length() > 100) {
                                    out.print("<a id='expand_" + complaintId + "' href='javascript:expandDescription(" + complaintId + ")' class='expand-link'>Read more</a>");
                                }
                                out.print("</td>");
                                out.print("<td>" + status + "</td>");
                                out.print("<td>" + dateCreated + "</td>");
                                out.print("<td>" + (engineerId > 0 ? "Yes" : "No") + "</td>");
                                out.print("<td>" + (engineerId > 0 ? engineerName : "N/A") + "</td>");
                                out.print("<td>" + assignedDate + "</td>");
                                out.print("<td>" + resolvedDate + "</td>");
                                out.print("<td>" + timeTaken + " days</td>");
                                out.print("</tr>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                            if (con != null) try { con.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </tbody>
            </table>
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
                <a href="https://x.com/AGCLonline?t=yWtQpO2KPLBRmyIJaZkVSA&s=09"><i class="fab fa-twitter"></i></a>
                <a href="https://www.instagram.com/agclonline/?igsh=dzJ6Mmk0OWtlbXFr"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
</body>
</html>
