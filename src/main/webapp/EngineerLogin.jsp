<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Login</title>
    <link rel="stylesheet" href="CSS/login.css">
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
            <div class="login-box">
                <h1>Hello,<br>Welcome Back!</h1>
                <% 
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <p class="error-message"><%= errorMessage %></p>
                <% 
                    } 
                %>
                <form action="EngineerLogin" method="post">
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="text" id="email" name="user" required>
                    </div>
                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                        <button type="button" class="toggle-password">
                            <img src="images/view.png" id="togglePasswordIcon">
                        </button>
                    </div>
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember Me</label>
                    </div>
                    <p>
                      <a href="ForgotPassword.jsp?userType=employee">Forgot Password?</a>
                    </p>
                    <p><br>
                    Don't have an account? <a href="RegisterEngineer.jsp">Sign up here</a>.
                	</p>
                    <button type="submit" class="login-btn">Login</button>
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
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
</body>
</html>
