<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Assam Gas Company Ltd</title>
    <link rel="stylesheet" href="CSS/login.css">
    <style>
        /* Universerve Loader Styles */
        .three-body {
            --uib-size: 35px;
            --uib-speed: 0.8s;
            --uib-color: #5D3FD3;
            position: fixed; /* Fixed positioning to keep it on top */
            display: inline-block;
            height: var(--uib-size);
            width: var(--uib-size);
            animation: spin78236 calc(var(--uib-speed) * 2.5) infinite linear;
        }

        .three-body__dot {
            position: absolute;
            height: 100%;
            width: 30%;
        }

        .three-body__dot:after {
            content: '';
            position: absolute;
            height: 0%;
            width: 100%;
            padding-bottom: 100%;
            background-color: var(--uib-color);
            border-radius: 50%;
        }

        .three-body__dot:nth-child(1) {
            bottom: 5%;
            left: 0;
            transform: rotate(60deg);
            transform-origin: 50% 85%;
        }

        .three-body__dot:nth-child(1)::after {
            bottom: 0;
            left: 0;
            animation: wobble1 var(--uib-speed) infinite ease-in-out;
            animation-delay: calc(var(--uib-speed) * -0.3);
        }

        .three-body__dot:nth-child(2) {
            bottom: 5%;
            right: 0;
            transform: rotate(-60deg);
            transform-origin: 50% 85%;
        }

        .three-body__dot:nth-child(2)::after {
            bottom: 0;
            left: 0;
            animation: wobble1 var(--uib-speed) infinite calc(var(--uib-speed) * -0.15) ease-in-out;
        }

        .three-body__dot:nth-child(3) {
            bottom: -5%;
            left: 0;
            transform: translateX(116.666%);
        }

        .three-body__dot:nth-child(3)::after {
            top: 0;
            left: 0;
            animation: wobble2 var(--uib-speed) infinite ease-in-out;
        }

        @keyframes spin78236 {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        @keyframes wobble1 {
            0%, 100% {
                transform: translateY(0%) scale(1);
                opacity: 1;
            }
            50% {
                transform: translateY(-66%) scale(0.65);
                opacity: 0.8;
            }
        }

        @keyframes wobble2 {
            0%, 100% {
                transform: translateY(0%) scale(1);
                opacity: 1;
            }
            50% {
                transform: translateY(66%) scale(0.65);
                opacity: 0.8;
            }
        }

        .success-message, .error-message {
            text-align: center;
            margin-top: 15px;
        }

        .success-message {
            color: #2ecc71;
        }

        .error-message {
            color: #e74c3c;
        }

        /* Hide message container initially */
        #messageContainer.hidden {
            display: none;
        }

        /* Loader container styles */
        #loader {
            display: none; /* Start as hidden */
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 1000; /* Ensure loader is on top of all other content */
        }

        /* Overlay to hide background content but show loader */
        #overlay {
            display: none; /* Start as hidden */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.7); /* Semi-transparent white background */
            z-index: 500; /* Ensure overlay is behind the loader */
        }
    </style>
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
                <h1>Forgot Password</h1>
                <form id="forgotPasswordForm" action="ForgotPassword" method="post">
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="text" id="email" name="email" required>
                    </div>
                    <div class="input-group">
                        <label for="userType">User Type</label>
                        <select id="userType" name="userType" required>
                            <option value="employee">Employee</option>
                            <option value="engineer">Engineer</option>
                            <option value="admin">Admin/HoD</option>
                        </select>
                    </div>
                    <button type="submit" class="login-btn">Submit</button>
                </form>
                <!-- Universerve Loader -->
                <div id="overlay"></div>
                <div id="loader" class="three-body">
                    <div class="three-body__dot"></div>
                    <div class="three-body__dot"></div>
                    <div class="three-body__dot"></div>
                </div>
                <!-- Success/Error Message -->
                <div id="messageContainer" class="<%= request.getAttribute("message") != null ? "" : "hidden" %> <%= request.getAttribute("errorMessage") != null ? "" : "hidden" %>">
                    <% 
                        String message = (String) request.getAttribute("message");
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (message != null) {
                    %>
                        <p class="success-message"><%= message %></p>
                    <% 
                        } else if (errorMessage != null) {
                    %>
                        <p class="error-message"><%= errorMessage %></p>
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
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
    </footer>
    <script>
        document.getElementById('forgotPasswordForm').addEventListener('submit', function () {
            // Show loader and overlay
            document.querySelector('#overlay').style.display = 'block';
            document.querySelector('#loader').style.display = 'block';
            document.querySelector('header').classList.add('hidden-content');
            document.querySelector('main').classList.add('hidden-content');
            document.querySelector('footer').classList.add('hidden-content');
        });

        // Show message if available
        window.addEventListener('load', function() {
            var messageContainer = document.getElementById('messageContainer');
            if (messageContainer && !messageContainer.classList.contains('hidden')) {
                setTimeout(function() {
                    messageContainer.classList.add('hidden');
                }, 5000); // Hide the message after 5 seconds
            }
        });
    </script>
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
</body>
</html>
