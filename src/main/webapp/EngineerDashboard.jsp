<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Engineer Dashboard</title>
    <link rel="stylesheet" href="CSS/Engineerdashboard.css">
    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .notification {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .closebtn {
            margin-left: 15px;
            color: white;
            font-weight: bold;
            float: right;
            font-size: 20px;
            line-height: 20px;
            cursor: pointer;
            transition: 0.3s;
        }
        .closebtn:hover {
            color: black;
        }
    </style>
    <script src="js/engineerDashboard.js"></script>
</head>
<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
            <nav>
                <ul>
                    <li><a href="EngineerDashboard.jsp">Dashboard</a></li>
                    <li><a href="ViewAssignedComplaints.jsp">View Assigned Complaints</a></li>
                    <li><a href="ResolveComplaint.jsp">Resolve Complaints</a>
                    <li><a href="Logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <!-- Display success message if available -->
            <%
                String successMessage = (String) session.getAttribute("successMessage");
                if (successMessage != null) { 
            %>
            <div id="notification" class="notification">
                <span class="closebtn" onclick="closeNotification()">&times;</span> 
                <%= successMessage %>
            </div>
            <%
                session.removeAttribute("successMessage");
                }
            %>

            <!-- Display error message if available -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div id="errorNotification" class="notification">
                <span class="closebtn" onclick="closeNotification()">&times;</span> 
                <%= errorMessage %>
            </div>
            <%
                }
            %>

            <h1>Welcome, <%= session.getAttribute("fullName") %>!</h1>
            
            <section class="profile">
                <h2>My Profile</h2>
                <p><strong>Name:</strong> <%= session.getAttribute("fullName") %></p>
                <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
                <p><strong>Phone:</strong> <%= session.getAttribute("phoneNumber") %></p>
                <p><strong>Department:</strong> <%= session.getAttribute("departmentName") %></p>
                <p><strong>Date of Birth:</strong> <%= session.getAttribute("dob") %></p>
                <p><strong>Gender:</strong> <%= session.getAttribute("gender") %></p>
            </section>

            <section class="quick-actions">
                <h2>Quick Actions</h2>
                <button onclick="window.location.href='ViewAssignedComplaints.jsp'">View Assigned Complaints</button>
				<button onclick="window.location.href='ResolveComplaint.jsp'">Resolve Assigned Complaints</button>
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
                <a href="https://x.com/AGCLonline?t=yWtQpO2KPLBRmyIJaZkVSA&s=09"><i class="fab fa-twitter"></i></a>
                <a href="https://www.instagram.com/agclonline/?igsh=dzJ6Mmk0OWtlbXFr"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
</body>
</html>
