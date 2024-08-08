<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Add New Engineer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminreg1.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/material-design-iconic-font/css/material-design-iconic-font.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
</head>
<body>
    <header>
        <div class="container">
            <img src="<%= request.getContextPath() %>/images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
        </div>
    </header>
    <main>
        <div class="container">
            <div class="login-box">
                <h1>Welcome, Admin!<br>Add New Engineers</h1>
                <form action="<%= request.getContextPath() %>/RegisterEngineerServlet" method="post">
                    <div class="input-group">
                        <label for="full_name">Full Name</label> <!-- Updated `for` attribute to `full_name` -->
                        <input type="text" name="full_name" id="full_name" placeholder="Enter the Engineer's Name" required />
                    </div>
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" placeholder="Enter the official email address" required>
                    </div>
                    <div class="input-group">
                        <label for="password">Password</label>
                        <div class="password-input">
                            <input type="password" id="password" name="password" placeholder="Enter the Password" required>
                            <button type="button" class="toggle-password" data-target="password">
                                <img src="<%= request.getContextPath() %>/images/view.png" alt="Toggle Password" id="togglePasswordIcon">
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="confirm_password">Confirm Password</label>
                        <div class="password-input">
                            <input type="password" id="confirm_password" name="confirm_password" placeholder="Re-enter the Password" required>
                            <button type="button" class="toggle-password" data-target="confirm_password">
                                <img src="<%= request.getContextPath() %>/images/view.png" alt="Toggle Password">
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="phone_number">Phone Number</label> <!-- Updated `for` attribute to `phone_number` -->
                        <input type="text" id="phone_number" name="phone_number" placeholder="Enter the Phone Number" required>
                    </div>
                    <div class="input-group">
                        <label for="dob">Date of Birth</label>
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
                    <div class="input-group">
                        <label for="gender">Gender</label>
                        <label><input type="radio" name="gender" value="Male" required> Male</label>
                        <label><input type="radio" name="gender" value="Female" required> Female</label>
                        <label><input type="radio" name="gender" value="Other" required> Other</label>
                    </div>
                    <button type="submit" class="login-btn">Add Engineer</button>
                </form>
            </div>
        </div>
    </main>
    <footer>
        <div class="container">
            <p>&copy; 2024 Assam Gas Company Ltd. All rights reserved.</p>
            <nav>
                <a href="<%= request.getContextPath() %>/privacy-policy.html">Privacy Policy</a>
                <a href="<%= request.getContextPath() %>/terms-of-service.html">Terms of Service</a>
            </nav>
            <div class="social-links">
                <a href="https://www.facebook.com/Assamgas/"><i class="fab fa-facebook-f"></i></a>
                <a href="https://x.com/AGCLonline?t=yWtQpO2KPLBRmyIJaZkVSA&s=09"><i class="fab fa-twitter"></i></a>
                <a href="https://www.linkedin.com/company/assamgas/"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
    </footer>
    <script>
        document.querySelectorAll('.toggle-password').forEach(button => {
            button.addEventListener('click', function () {
                const target = document.getElementById(this.dataset.target);
                const passwordIcon = this.querySelector('img');
                if (target.type === 'password') {
                    target.type = 'text';
                    passwordIcon.src = '<%= request.getContextPath() %>/images/hide.png';
                } else {
                    target.type = 'password';
                    passwordIcon.src = '<%= request.getContextPath() %>/images/view.png';
                }
            });
        });
    </script>
<!-- SweetAlert2 for messages -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

    <script type="text/javascript">
        // Function to show SweetAlert2 message based on status attribute
        function showAlert(status) {
            if (status === "success") {
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: 'Engineer Registered Successfully!',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "<%= request.getContextPath() %>/AdminDashboard.jsp";
                    }
                });
            } else if (status === "failed") {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'Registration Failed.',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'OK'
                });
            } else if (status === "error") {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'An error occurred during registration.',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'OK'
                });
            }
        }

        // Trigger the showAlert function onload
        window.onload = function() {
            var status = "<%= request.getAttribute("status") %>";
            showAlert(status);
        };
    </script></body>
</html>

