<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Register HoD</title>
    <link rel="stylesheet" href="CSS/adminreg1.css">
    <!-- Font Icon -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/material-design-iconic-font/css/material-design-iconic-font.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
</head>
<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
        </div>
    </header>
    <main>
        <div class="container">
        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success-message">
            <%= request.getAttribute("successMessage") %>
        </div>
        <% } else if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>
            <div class="login-box">
                <h1>Welcome, Admin!<br>Register Here</h1>
                <form action="RegisterHoD" method="post">
                    <div class="input-group">
                        <label for="name">Full Name</label>
                        <input type="text" name="name" id="name" placeholder="Enter your Name" required />
                    </div>
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" placeholder="Enter your official email address" required>
                    </div>
                    <div class="input-group">
                        <label for="password">Password</label>
                        <div class="password-input">
                            <input type="password" id="password" name="password" placeholder="Enter your Password" required>
                            <button type="button" class="toggle-password" data-target="password">
                                <img src="images/view.png" alt="Toggle Password">
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="confirm_password">Confirm Password</label>
                        <div class="password-input">
                            <input type="password" id="confirm_password" name="confirm_password" placeholder="Re-enter your Password" required>
                            <button type="button" class="toggle-password" data-target="confirm_password">
                                <img src="images/view.png" alt="Toggle Password">
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <div class="phone-no">
                            <label for="phone_no">Phone Number</label>
                            <input type="text" id="phone_no" name="phone_no" placeholder="Enter your Phone Number">
                        </div>
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
                    <button type="submit" class="login-btn">Register</button>
                </form>
            </div>
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
    <script>
        // Toggle password visibility
        document.querySelectorAll('.toggle-password').forEach(function(btn) {
            btn.addEventListener('click', function () {
                var passwordField = document.getElementById(this.dataset.target);
                var icon = this.querySelector('img');
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    icon.src = 'images/hide.png'; // Change icon to "hide"
                } else {
                    passwordField.type = 'password';
                    icon.src = 'images/view.png'; // Change icon to "view"
                }
            });
        });
    </script>
</body>
</html>
