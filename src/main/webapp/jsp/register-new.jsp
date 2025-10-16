<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/">
                    <i class="fas fa-stethoscope"></i> Medical System
                </a>
            </div>
            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="nav-item">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
            </div>
        </nav>
    </header>

    <div class="container">
        <div class="login-container">
            <div class="login-box" style="max-width: 500px;">
                <div class="login-header">
                    <h1><i class="fas fa-user-plus"></i> Create Account</h1>
                    <h2>Join our medical system</h2>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" required 
                                   placeholder="Enter your first name">
                        </div>

                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" required 
                                   placeholder="Enter your last name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required 
                               placeholder="Choose a unique username">
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required 
                               placeholder="Enter your email address">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required 
                               placeholder="Create a strong password" minlength="6">
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               placeholder="Confirm your password" minlength="6">
                    </div>

                    <div class="form-group">
                        <label for="role">Role</label>
                        <select id="role" name="role" required>
                            <option value="">Select your role</option>
                            <option value="INFIRMIER">Nurse</option>
                            <option value="GENERALISTE">General Practitioner</option>
                            <option value="SPECIALISTE">Specialist</option>
                        </select>
                    </div>

                    
                    <div id="specialistFields" style="display: none;">
                        <div class="form-group">
                            <label for="speciality">Speciality</label>
                            <select id="speciality" name="speciality">
                                <option value="">Select your speciality</option>
                                <option value="CARDIOLOGY">Cardiology</option>
                                <option value="DERMATOLOGY">Dermatology</option>
                                <option value="ORTHOPEDICS">Orthopedics</option>
                                <option value="PEDIATRICS">Pediatrics</option>
                                <option value="NEUROLOGY">Neurology</option>
                                <option value="ONCOLOGY">Oncology</option>
                                <option value="PSYCHIATRY">Psychiatry</option>
                                <option value="RADIOLOGY">Radiology</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="experience">Years of Experience</label>
                            <input type="number" id="experience" name="experience" min="0" max="50" 
                                   placeholder="Years of experience">
                        </div>

                        <div class="form-group">
                            <label for="bio">Professional Bio</label>
                            <textarea id="bio" name="bio" rows="4" 
                                      placeholder="Brief professional biography"></textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-large">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>

                <div class="register-link">
                    Already have an account? 
                    <a href="${pageContext.request.contextPath}/jsp/login.jsp">Sign In</a>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />

    <script>
        document.getElementById('role').addEventListener('change', function() {
            const specialistFields = document.getElementById('specialistFields');
            const specialitySelect = document.getElementById('speciality');
            const experienceInput = document.getElementById('experience');
            
            if (this.value === 'SPECIALISTE') {
                specialistFields.style.display = 'block';
                specialitySelect.required = true;
                experienceInput.required = true;
            } else {
                specialistFields.style.display = 'none';
                specialitySelect.required = false;
                experienceInput.required = false;
            }
        });

        // Password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>