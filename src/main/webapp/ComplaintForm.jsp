<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assam Gas Company Ltd - Employee Dashboard</title>
    <link rel="stylesheet" href="CSS/complaintform.css">
    <!-- Font Icon -->
    <link rel="stylesheet" href="D:\\AGCL Complaint Portal\\material-design-iconic-font\\css\\material-design-iconic-font.css">
    <script src="https://kit.fontawesome.com/702c9153e2.js" crossorigin="anonymous"></script>
    <!-- SweetAlert for success and error messages -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <!-- jQuery for handling dynamic dropdown -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Loader CSS -->
    <style>
        .three-body {
            --uib-size: 35px;
            --uib-speed: 0.8s;
            --uib-color: #5D3FD3;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: none;
            height: var(--uib-size);
            width: var(--uib-size);
            animation: spin78236 calc(var(--uib-speed) * 2.5) infinite linear;
            z-index: 9999;
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
            animation: wobble1 var(--uib-speed) infinite
            calc(var(--uib-speed) * -0.15) ease-in-out;
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
            0%,
            100% {
                transform: translateY(0%) scale(1);
                opacity: 1;
            }
            50% {
                transform: translateY(-66%) scale(0.65);
                opacity: 0.8;
            }
        }
        @keyframes wobble2 {
            0%,
            100% {
                transform: translateY(0%) scale(1);
                opacity: 1;
            }
            50% {
                transform: translateY(66%) scale(0.65);
                opacity: 0.8;
            }
        }
        .blurred {
            filter: blur(5px);
            pointer-events: none;
        }
    </style>
</head>
<body>
<header>
    <div class="container">
        <img src="images/agcl-logo.png" alt="Assam Gas Company Ltd Logo" class="logo">
        <nav>
            <ul>
                <li><a href="EmployeeDashboard.jsp">Dashboard</a></li>
                <li><a href="Logout">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>
<main>
    <div class="container" id="content">
        <h2>Hi, <%= request.getSession().getAttribute("fullName") %>!</h2>
        <h2>Fill up the form to raise a Complaint</h2>
        <form action="<%=request.getContextPath() %>/ComplaintServlet" method="post" id="complaintForm">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" value="<%= request.getSession().getAttribute("fullName") %>" required>
            </div>
            <div class="form-group">
                <label for="title">Complaint Title</label>
                <input type="text" id="title" name="title" placeholder="Enter your complaint title" required>
            </div>
            <div class="form-group">
                <label for="department">Department</label>
                <select id="department" name="department" required>
                    <option value="">Select the Department you want to raise your complaint to</option>
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
                <label for="type">Complaint Type</label>
                <select id="type" name="type" required>
                    <option value="">Select Complaint Type</option>
                    <!-- Complaint options will be dynamically added here -->
                </select>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="Describe your complaint in detail" required></textarea>
            </div>
            <div class="form-group">
                <label for="location">Location</label>
                <input type="text" id="location" name="location" placeholder="Enter your location" required>
            </div>
            <button type="submit" class="btn">Submit Complaint</button>
        </form>
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
<div class="three-body" id="loader">
    <div class="three-body__dot"></div>
    <div class="three-body__dot"></div>
    <div class="three-body__dot"></div>
</div>
<script>
    // jQuery to handle dynamic loading of complaint types based on selected department
    $(document).ready(function() {
        $('#department').change(function() {
            var dept = $(this).val();
            var complaintTypes = [];

            switch(dept) {
                case 'Projects & Planning':
                    complaintTypes = ['Select Complaint Type', 'Delayed Project Approval', 'Inadequate Planning Resources', 'Others'];
                    break;
                case 'Business Development (BD)':
                    complaintTypes = ['Select Complaint Type', 'Market Research Issues', 'Business Proposal Delays', 'Others'];
                    break;
                case 'Pipeline':
                    complaintTypes = ['Select Complaint Type', 'Pipeline Leakage', 'Maintenance Scheduling Issues', 'Others'];
                    break;
                case 'Cathodic Protection (CP)':
                    complaintTypes = ['Select Complaint Type', 'CP System Failure', 'Corrosion Issues', 'Others'];
                    break;
                case 'Instrumentation & TGG':
                    complaintTypes = ['Select Complaint Type', 'Instrument Calibration Problems', 'Sensor Failures', 'Others'];
                    break;
                case 'SCADA':
                    complaintTypes = ['Select Complaint Type', 'SCADA System Outages', 'Data Communication Failures', 'Others'];
                    break;
                case 'Compressor':
                    complaintTypes = ['Select Complaint Type', 'Compressor Breakdown', 'Maintenance Delays', 'Others'];
                    break;
                case 'City Gas Distribution (CGD)':
                    complaintTypes = ['Select Complaint Type', 'Gas Supply Interruption', 'Metering Issues', 'Others'];
                    break;
                case 'Retail Business & Coordination':
                    complaintTypes = ['Select Complaint Type', 'Stock Management Issues', 'Customer Service Complaints', 'Others'];
                    break;
                case 'Health Safety & Environment (HSE)':
                    complaintTypes = ['Select Complaint Type', 'Safety Violations', 'Environmental Hazard', 'Others'];
                    break;
                case 'Electrical':
                    complaintTypes = ['Select Complaint Type', 'Power Outages', 'Electrical Equipment Failure', 'Others'];
                    break;
                case 'Civil':
                    complaintTypes = ['Select Complaint Type', 'Structural Damages', 'Construction Delays', 'Others'];
                    break;
                case 'Contracts & Procurements (C&P)':
                    complaintTypes = ['Select Complaint Type', 'Procurement Delays', 'Contract Disputes', 'Others'];
                    break;
                case 'Human Resource and Admin (HR&A)':
                    complaintTypes = ['Select Complaint Type', 'Payroll Issues', 'Employee Grievances', 'Others'];
                    break;
                case 'Land':
                    complaintTypes = ['Select Complaint Type', 'Land Acquisition Delays', 'Boundary Disputes', 'Others'];
                    break;
                case 'Medical':
                    complaintTypes = ['Select Complaint Type', 'Medical Equipment Shortage', 'Staff Availability Issues', 'Others'];
                    break;
                case 'Transport':
                    complaintTypes = ['Select Complaint Type', 'Vehicle Maintenance Issues', 'Scheduling Conflicts', 'Others'];
                    break;
                case 'Company Secretary':
                    complaintTypes = ['Select Complaint Type', 'Documentation Errors', 'Compliance Issues', 'Others'];
                    break;
                case 'Security & Vigilance':
                    complaintTypes = ['Select Complaint Type', 'Security Breaches', 'Surveillance System Failures', 'Others'];
                    break;
                case 'Finance & Accounts (F&A)':
                    complaintTypes = ['Select Complaint Type', 'Financial Discrepancies', 'Payment Processing Delays', 'Others'];
                    break;
                case 'Information Technology':
                    complaintTypes = ['Select Complaint Type', 'Hardware Issues', 'Software Malfunctions', 'Network Connectivity', 'Data Loss or Backup', 'Security Concerns', 'Website or Portal Issues', 'IT Equipment Requests', 'Others'];
                    break;
                default:
                    complaintTypes = ['Select Complaint Type'];
                    break;
            }

            $('#type').empty();
            $.each(complaintTypes, function(index, value) {
                $('#type').append($('<option>', {
                    value: value,
                    text: value
                }));
            });
        });

        $('#complaintForm').on('submit', function() {
            $('#content').addClass('blurred');
            $('#loader').show();
        });
    });

    // SweetAlert for error message
    <% if (request.getAttribute("errorMessage") != null) { %>
    swal({
        title: "Error!",
        text: "<%= request.getAttribute("errorMessage") %>",
        icon: "error",
        button: "OK",
    });
    <% } %>
</script>
</body>
</html>
