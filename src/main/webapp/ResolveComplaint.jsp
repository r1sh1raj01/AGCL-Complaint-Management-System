<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resolve Complaints</title>
    <link rel="stylesheet" href="CSS/viewcomplaint1.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function expandDescription(complaintId) {
            var description = document.getElementById('desc_' + complaintId);
            var expandLink = document.getElementById('expand_' + complaintId);
            description.style.whiteSpace = 'normal';
            expandLink.style.display = 'none';
        }

        document.addEventListener('DOMContentLoaded', function() {
            var form = document.querySelector('form');
            form.addEventListener('submit', function() {
                var loader = document.getElementById('loader');
                if (loader) {
                    loader.classList.add('show');
                }
            });
        });
    </script>
    <style>
        .remarks-input, .resolve-button {
            padding: 10px;
            margin: 5px 0;
            width: 100%;
            box-sizing: border-box;
        }
        .remarks-input {
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 200px; /* Make the input field longer */
        }
        .resolve-button {
            background-color: #0a255f;
            width: 100%; /* Make the button field longer */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .resolve-button:hover {
            background-color: #001b57;
        }

        /* Loader and Background Blur */
        .loader-container {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8); /* Semi-transparent white background */
            backdrop-filter: blur(5px); /* Background blur effect */
            justify-content: center;
            align-items: center;
            z-index: 9999; /* Make sure the loader is above all other content */
        }

        .loader-container.show {
            display: flex; /* Show the loader when the 'show' class is added */
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
    </style>
</head>

<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
            <nav>
                <ul>
                    <li><a href="EngineerDashboard.jsp">Home</a></li>
                    <li><a href="Logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </header>
    <main>
        <div class="container">
            <h1>Resolve Complaints</h1>
            <c:if test="${not empty successMessage}">
                <script>
                    Swal.fire({
                        title: 'Success!',
                        text: '${successMessage}',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    });
                </script>
            </c:if>
            <form action="ResolveComplaint" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Complaint ID</th>
                            <th>Reference ID</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Date Created</th>
                            <th>Date Assigned</th>
                            <th>Date Resolved</th>
                            <th>HOD Remarks</th>
                            <th>Engineer Remarks</th>
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
                                Class.forName("org.postgresql.Driver");
                                con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                                Integer engineerId = (Integer) session.getAttribute("engineerId");
                                if (engineerId == null) {
                                    response.sendRedirect("EngineerLogin.jsp");
                                    return;
                                }

                                String searchRefId = request.getParameter("searchRefId");

                                String sql = "SELECT complaint_id, ref_id, complaint_title, complaint_text, status, date_created, date_assigned, date_resolved, hod_remarks FROM complaints WHERE engineer_id = ? AND status <> 'Resolved'";

                                if (searchRefId != null && !searchRefId.isEmpty()) {
                                    sql += " AND ref_id LIKE ?";
                                }

                                pstmt = con.prepareStatement(sql);
                                pstmt.setInt(1, engineerId);

                                if (searchRefId != null && !searchRefId.isEmpty()) {
                                    pstmt.setString(2, "%" + searchRefId + "%");
                                }

                                rs = pstmt.executeQuery();

                                while (rs.next()) {
                                    hasComplaints = true;
                                    int complaintId = rs.getInt("complaint_id");
                                    String refId = rs.getString("ref_id");
                                    String title = rs.getString("complaint_title");
                                    String description = rs.getString("complaint_text");
                                    String status = rs.getString("status");
                                    Date dateCreated = rs.getDate("date_created");
                                    Date dateAssigned = rs.getDate("date_assigned");
                                    Date dateResolved = rs.getDate("date_resolved");
                                    String hodRemarks = rs.getString("hod_remarks");

                                    out.print("<tr>");
                                    out.print("<td><input type='checkbox' name='selectedComplaints' value='" + refId + "'></td>");
                                    out.print("<td>" + complaintId + "</td>");
                                    out.print("<td>" + refId + "</td>");
                                    out.print("<td>" + title + "</td>");

                                    // Truncate description with read more option
                                    out.print("<td>");
                                    out.print("<div id='desc_" + complaintId + "' class='truncate'>" + description + "</div>");
                                    if (description.length() > 100) {
                                        out.print("<a id='expand_" + complaintId + "' href='javascript:expandDescription(" + complaintId + ")'>Read more</a>");
                                    }
                                    out.print("</td>");

                                    out.print("<td>" + status + "</td>");
                                    out.print("<td>" + dateCreated + "</td>");
                                    out.print("<td>" + dateAssigned + "</td>");
                                    out.print("<td>" + (dateResolved != null ? dateResolved : "Not resolved") + "</td>");
                                    out.print("<td>" + hodRemarks + "</td>");
                                    out.print("<td><input type='text' name='remarks_" + refId + "' class='remarks-input'></td>");
                                    out.print("</tr>");
                                }

                                if (!hasComplaints) {
                                    out.print("<tr><td colspan='11'>No complaints found</td></tr>");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (input != null) try { input.close(); } catch (IOException e) { e.printStackTrace(); }
                            }
                        %>
                    </tbody>
                </table>
                <input type="submit" value="Resolve Complaints" class="resolve-button">
            </form>
        </div>
        <div id="loader" class="loader-container">
            <div class="three-body">
                <div class="three-body__dot"></div>
                <div class="three-body__dot"></div>
                <div class="three-body__dot"></div>
            </div>
        </div>
    </main>
</body>
</html>
