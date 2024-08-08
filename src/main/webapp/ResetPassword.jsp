<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Assam Gas Company Ltd</title>
    <link rel="stylesheet" href="CSS/login.css">
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
                <h1>Reset Your Password</h1>
                <form action="ResetPassword" method="post">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
                    
                    <div class="input-group">
                        <label for="password">New Password</label>
                        <input type="password" id="password" name="password" required>
                        <button type="button" class="toggle-password" data-target="#password">
                            <img src="images/view.png" class="toggle-password-icon" data-target="#password">
                        </button>
                    </div>
                    
                    <div class="input-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <button type="button" class="toggle-password" data-target="#confirmPassword">
                            <img src="images/view.png" class="toggle-password-icon" data-target="#confirmPassword">
                        </button>
                    </div>
                    
                    <button type="submit" class="login-btn">Reset Password</button>
                </form>
                <div id="messageContainer">
                    <% 
                        String error = request.getParameter("error");
                        String message = request.getParameter("message");
                        if (message != null) {
                            %>
                            <p class="success-message"><%= message %></p>
                            <script>
                                setTimeout(function() {
                                    window.location.href = "index.jsp";
                                }, 3000); // Redirect after 3 seconds
                            </script>
                            <% 
                        } else if (error != null) {
                            %>
                            <p class="error-message"><%= error %></p>
                            <% 
                        } 
                    %>
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
        // Toggle password visibility for both password fields
        document.querySelectorAll('.toggle-password').forEach(function(button) {
            button.addEventListener('click', function () {
                const target = document.querySelector(this.getAttribute('data-target'));
                const isPassword = target.type === 'password';
                target.type = isPassword ? 'text' : 'password';
                this.querySelector('img').src = isPassword ? 'images/hide.png' : 'images/view.png'; // Change icon to "hide" or "view"
            });
        });
    </script>
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
</body>
</html>
