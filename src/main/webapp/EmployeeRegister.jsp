<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Employee Registration</title>
    <link rel="stylesheet" href="CSS/registration.css">
    <!-- Font Icon -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/material-design-iconic-font/css/material-design-iconic-font.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/alert/dist/sweetalert.css">
</head>
<body>
    <header>
        <div class="container">
            <img src="<%= request.getContextPath() %>/images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
        </div>
    </header>
    <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success-message">
            <%= request.getAttribute("successMessage") %>
        </div>
    <% } else if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>
    <main>
        <div class="container">
            <div class="content-wrapper">
                <div class="form-container">
                    <h2>Employee Registration</h2>
                    <form id="registrationForm" action="EmployeeRegisterServlet" method="POST">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" name="name" id="name" placeholder="Enter your Name" required />
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" placeholder="Enter your official email address" required>
                        </div>
                        <div class="form-group">
                            <label for="Phone">Phone No.</label>
                            <input type="text" id="number" name="number" placeholder="Enter your Mobile No." required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <div class="password-input">
                                <input type="password" id="password" name="password" placeholder="Enter your Password" required>
                                <button type="button" class="toggle-password" data-target="password">
                                    <img src="<%= request.getContextPath() %>/images/view.png" alt="Toggle Password">
                                </button>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="confirm_password">Confirm Password</label>
                            <div class="password-input">
                                <input type="password" id="confirm_password" name="confirm_password" placeholder="Re-enter your Password" required>
                                <button type="button" class="toggle-password" data-target="confirm_password">
                                    <img src="<%= request.getContextPath() %>/images/view.png" alt="Toggle Password">
                                </button>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <input type="radio" name="gender" value="Male" required> Male
                            <input type="radio" name="gender" value="Female" required> Female
                            <input type="radio" name="gender" value="Other" required> Other
                        </div>
                        <div class="form-group">
                            <label for="dob">Date of Birth:</label>
                            <input type="date" id="dob" name="dob" required>
                        </div>
                        <div class="form-group">
                            <label for="department">Department</label>
                            <select id="department" name="department" required>
                                <option value="">Select your Department</option>
                                <option value="Projects & Planning">Projects & Planning</option>
                            <option value="Business Development (BD)">Business Development (BD)</option>
                            <option value="Pipeline">Pipeline</option>
                            <option value="Cathodic Protection (CP)">Cathodic Protection (CP)</option>
                            <option value="Instrumentation & TGG">Instrumentation & TGG</option>
                            <option value="SCADA">SCADA</option>
                            <option value="Compressor">Compressor</option>
                            <option value="City Gas Distribution (CGD)">City Gas Distribution (CGD)</option>
                            <option value="Retail Business & Coordination">Retail Business & Coordination</option>
                            <option value="Health Safety & Environment (HSE)">Health Safety & Environment (HSE)</option>
                            <option value="Electrical">Electrical</option>
                            <option value="Civil">Civil</option>
                            <option value="Contracts & Procurements (C&P)">Contracts & Procurements (C&P)</option>
                            <option value="Human Resource and Admin (HR&A)">Human Resource and Admin (HR&A)</option>
                            <option value="Land">Land</option>
                            <option value="Medical">Medical</option>
                            <option value="Transport">Transport</option>
                            <option value="Company Secretary">Company Secretary</option>
                            <option value="Security & Vigilance">Security & Vigilance</option>
                            <option value="Finance & Accounts (F&A)">Finance & Accounts (F&A)</option>
                            <option value="Information Technology">Information Technology</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="date_joined">Date Joined:</label>
                            <input type="date" id="date_joined" name="date_joined" required>
                        </div>
                        <div class="form-group">
                            <button type="submit">Register</button>
                        </div>
                    </form>
                </div>
                <div class="sign-up img">
                    <img src="<%= request.getContextPath() %>/images/consumer-reg.png" alt="Employee Registration">
                </div>
            </div>
        </div>
    </main>
    <footer>
        <div class="container">
            <p>&copy; 2024 Assam Gas Company Ltd. All rights reserved.</p>
            <nav>
                <a href="<%= request.getContextPath() %>/privacy-policy.jsp">Privacy Policy</a>
                <a href="<%= request.getContextPath() %>/terms-of-service.jsp">Terms of Service</a>
            </nav>
            <div class="social-links">
                <a href="https://www.facebook.com/Assamgas/"><i class="fab fa-facebook-f"></i></a>
                <a href="https://x.com/AGCLonline?t=yWtQpO2KPLBRmyIJaZkVSA&s=09"><i class="fab fa-twitter"></i></a>
                <a href="https://www.instagram.com/agclonline/?igsh=dzJ6Mmk0OWtlbXFr"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
    <script>
        // Validate email domain
        function validateEmail(email) {
            const domain = email.substring(email.lastIndexOf("@") + 1);
            return domain === "agclgas.com";
        }

        document.getElementById("registrationForm").addEventListener("submit", function (event) {
            const email = document.getElementById("email").value;
            if (!validateEmail(email)) {
                event.preventDefault();
                alert("Please use your official email address ending with @agclgas.com");
            }
        });

        // Toggle password visibility
        document.querySelectorAll('.toggle-password').forEach(button => {
            button.addEventListener('click', function () {
                const targetId = this.getAttribute('data-target');
                const passwordField = document.getElementById(targetId);
                const img = this.querySelector('img');

                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    img.src = '<%= request.getContextPath() %>/images/hide.png';
                } else {
                    passwordField.type = 'password';
                    img.src = '<%= request.getContextPath() %>/images/view.png';
                }
            });
        });
    </script>
    <script src="<%= request.getContextPath() %>/vendor/jquery/jquery.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <script src="https://www.google.com/recaptcha/api.js"></script>
</body>
</html>
