<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGCL Complaint Management System</title>
    <link rel="stylesheet" href="CSS/index.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <style>
        /* General container styling */
        .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Styling for the logo */
        .logo {
            height: 50px;
        }

        /* Styling for header-right section */
        .header-right {
            display: flex;
            align-items: center;
            gap: 40px;
        }

        /* Add styles for the dropdown button */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            cursor: pointer;
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            padding: 15px 20px;
            z-index: 1;
        }

        .dropdown-content a {
            color: black;
            padding: 15px 26px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .dropdown-content span {
            margin-right: 10px;
            display: flex;
            color: #000000;
            font-weight: bold;
            font-size: large;
            border: none;
            padding: 8px 8px;
            border-radius: 5px;
            cursor: pointer;
            transition: box-shadow 0.3s ease-in-out;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown:hover .dropbtn {
            background-color: #3f51b5;
        }

        /* Styles for nested dropdown */
        .nested-dropdown {
            position: relative;
            display: inline-block;
        }

        .nested-dropdown-content {
            font-weight: bold;
            font-size: medium;
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 2;
            left: 100%; /* Position to the right of the parent */
            top: 0;
            transition: box-shadow 2ms ease-in-out;
        }

        .nested-dropdown:hover .nested-dropdown-content {
            display: block;
        }

        .nested-dropdown-content a {
            color: black;
            padding: 8px 16px;
            text-decoration: none;
            display: flex;
        }

        .nested-dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        /* Styles for admin-toggle */
        .admin-toggle {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .admin-toggle span {
            font-weight: bold;
        }

		.switch {
    		position: relative;
    		display: inline-block;
    		width: 72px;
    		height: 34px;
		}

		.switch input {
    		opacity: 0;
    		width: 0;
    		height: 0;
		}

		.slider {
    		position: absolute;
    		cursor: pointer;
    		top: 0;
    		left: 0;
    		right: 0;
    		bottom: 0;
    		background-color: #ccc;
    		transition: .4s;
		}

.slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: .4s;
}

input:checked + .slider {
    background-color: #af0f44;
}

input:checked + .slider:before {
    transform: translateX(26px);
}

.slider.round {
    border-radius: 34px;
}

.slider.round:before {
    border-radius: 50%;
}
    </style>
</head>
<body>
    <header>
        <div class="container">
            <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
            <div class="header-right">
                <div class="dropdown">
                    <button class="login-btn dropbtn">Login</button>
                    <div class="dropdown-content">
                        <div class="nested-dropdown">
                            <span>Employee</span>
                            <div class="nested-dropdown-content">
                                <a href="EmployeeLogin.jsp">Login as Employee</a>
                                <a href="EmployeeRegister.jsp">Sign Up as Employee</a>
                            </div>
                        </div>
                        <div class="nested-dropdown">
                            <span>Engineer</span>
                            <div class="nested-dropdown-content">
                                <a href="EngineerLogin.jsp">Login as Engineer</a>
                                <a href="RegisterEngineer.jsp">Sign Up as Engineer</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="admin-toggle">
                    <span>Admin Login</span>
                    <label class="switch">
                        <input type="checkbox" id="adminSwitch">
                        <span class="slider round"></span>
                    </label>
                </div>
            </div>
        </div>
    </header>
    
    <main>
        <div class="container">
            <section class="intro">
                <div class="intro-text">
                    <h1>Welcome to the <br>AGCL Complaint Management System</h1>
                    <p>
                        The AGCL Complaint Management System provides a seamless, efficient, and user-friendly platform 
                        for employees to lodge and manage complaints. We are dedicated to ensuring a positive and 
                        supportive work environment, and this system is key to our commitment to transparency and 
                        continuous improvement.
                    </p>
                    <p>
                    <br>
                        By using this system, you can easily report workplace concerns, track the status of your 
                        complaints, and receive timely updates on their resolution. Empower yourself to have your voice 
                        heard and contribute to creating a better work environment for all.
                    </p>
                    <h2><br><br>Key Features</h2>
                    <ul type="none">
                        <li>Easy Complaint Lodging</li>
                        <li>Real-Time Status Updates</li>
                        <li>Secure and Confidential</li>
                        <li>Efficient Resolution Process</li>
                        <li>Accountability and Transparency</li>
                    </ul>
                </div>
                <div class="intro-image">
                    <img src="images/signup-complaint.png" alt="Complaint Management Illustration">
                </div>
            </section>
        </div>
        
        <section id="signup">
            <div class="complaint-action">
            <br>
                <button class="raise-complaint-btn" onclick="location.href='EmployeeLogin.jsp'">Raise a Complaint</button>
                <p><br>
                    Don't have an account? <a href="EmployeeRegister.jsp">Sign up here</a>.
                </p>
                <br>
                <button class="admin-redirect-btn" onclick="scrollToAdminToggle()">Admin Login</button>
            </div>
        </section>
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
        // Improved adminSwitch toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            const adminSwitch = document.getElementById('adminSwitch');

            adminSwitch.addEventListener('change', function() {
                if (this.checked) {
                    // Redirect to admin login page
                    window.location.href = 'AdminLogin.jsp'; // Ensure this URL is correct
                } else {
                    // Keep switch off state without any action
                    this.checked = false; // Simply reset to false without further action
                }
            });
        });

        // Improved scroll functionality
        function scrollToAdminToggle() {
            const adminSwitchElement = document.getElementById('adminSwitch');
            const offset = adminSwitchElement.getBoundingClientRect().top + window.pageYOffset - (window.innerHeight / 2);
            window.scrollTo({ top: offset, behavior: 'smooth' });
        }
    </script>
</body>
</html>
