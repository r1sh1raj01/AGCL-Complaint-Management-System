<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Admin Login</title>
    <link rel="stylesheet" href="CSS/adminlogin.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <script src="https://www.google.com/recaptcha/api.js"></script>
    
    <style>
    	select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #fff; /* Ensure background color matches other inputs */
    font-size: 14px; /* Adjust font size to match other inputs */
    color: #333; /* Ensure text color is consistent */
}

select:focus {
    outline: none;
    border-color: #1a237e;
    box-shadow: 0 0 5px rgba(26, 35, 126, 0.5);
}
    </style>
</head>
<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
            <div class="admin-reg">
                <button class="signup-button" onclick="location.href='RegisterHoD.jsp'">Register</button>
            </div>
        </div>
    </header>
    <main>
        <div class="container">
            <div class="login-box">
                <h1>Hello, Admin!<br>Login</h1>
                <form action="AdminLoginServlet" method="post">
                    <div class="input-group">
                        <label for="user">Email</label>
                        <input type="text" id="user" name="user" required>
                    </div>
                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                        <button type="button" class="toggle-password">
                            <img src="images/view.png" id="togglePasswordIcon">
                        </button>
                    </div>
                    <div class="input-group">
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
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember Me</label>
                    </div>
                    <button type="submit" class="login-btn">Login</button>
                </form>
                <div class="links">
                    <a href="ForgotPassword.jsp?userType=employee">Forgot Password?</a>
                    <a href="RegisterHoD.jsp">New Admin? Register now!</a>
                </div>
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
        document.querySelector('.toggle-password').addEventListener('click', function () {
            var passwordField = document.getElementById('password');
            var passwordIcon = document.getElementById('togglePasswordIcon');
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.src = 'images/hide.png'; // Change icon to "hide"
            } else {
                passwordField.type = 'password';
                passwordIcon.src = 'images/view.png'; // Change icon to "eye"
            }
        });
    </script>
</body>
</html>
