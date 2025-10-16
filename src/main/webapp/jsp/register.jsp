<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
            min-height: 100vh;
        }

        .navbar {
            background: #2c3e50;
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            width: 100%;
        }

        .nav-container {
            width: 100%;
            max-width: none;
            margin: 0;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-size: 1.5rem;
            font-weight: 600;
            color: white;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: #bdc3c7;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: #34495e;
            color: white;
        }

        .register-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 80px);
            background: #ffffff;
            padding: 40px 20px;
        }

        .register-box {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            border: 1px solid #e9ecef;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header .logo {
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .register-header .subtitle {
            color: #6c757d;
            font-size: 1rem;
            font-weight: 400;
            margin-bottom: 20px;
        }

        .welcome-text {
            color: #495057;
            font-size: 1.3rem;
            font-weight: 500;
            text-align: center;
            margin-bottom: 25px;
        }

        .info-box {
            background: #e3f2fd;
            color: #1976d2;
            padding: 15px 18px;
            border-radius: 6px;
            margin-bottom: 25px;
            border: 1px solid #bbdefb;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #495057;
            font-weight: 500;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            background: white;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.25);
        }

        .form-group input::placeholder {
            color: #adb5bd;
        }

        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 16px;
        }

        .form-group input:focus + .input-icon {
            color: #4a90e2;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.15s ease-in-out;
            margin-top: 10px;
        }

        .btn-primary {
            background: #4a90e2;
            color: white;
        }

        .btn-primary:hover {
            background: #357abd;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            border: 1px solid #e9ecef;
        }

        .login-link a {
            color: #4a90e2;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            color: #357abd;
            text-decoration: underline;
        }

        .error-message,
        .success-message {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .field-error {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
            font-weight: 500;
        }

        .error-field {
            border-color: #dc3545 !important;
            background: rgba(220, 53, 69, 0.05) !important;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .password-strength {
            margin-top: 5px;
            height: 3px;
            background: #dee2e6;
            border-radius: 2px;
            overflow: hidden;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .password-strength.visible {
            opacity: 1;
        }

        .password-strength .strength-bar {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #fd7e14; width: 50%; }
        .strength-good { background: #198754; width: 75%; }
        .strength-strong { background: #0d6efd; width: 100%; }

        @media (max-width: 600px) {
            .nav-container {
                padding: 0 15px;
            }
            
            .nav-brand {
                font-size: 1.3rem;
            }
            
            .nav-links {
                gap: 10px;
            }
            
            .register-box {
                padding: 30px 20px;
                margin: 15px;
            }
            
            .register-header .logo {
                font-size: 1.6rem;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-brand">
                <i class="fas fa-stethoscope"></i>
                Medical System
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/auth">Connexion</a>
                <a href="${pageContext.request.contextPath}/register" class="active">Inscription</a>
            </div>
        </div>
    </nav>

    <div class="register-container">
        <div class="register-box">
            <div class="register-header">
                <div class="logo">
                    <i class="fas fa-user-plus"></i>
                    Inscription
                </div>
                <p class="subtitle">Système de Télé-Expertise Médicale</p>
            </div>

            <h2 class="welcome-text">Créer votre compte</h2>

            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                <span>Vous serez enregistré(e) en tant qu'<strong>Infirmier(ère)</strong> par défaut.</span>
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

            <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Nom d'utilisateur *</label>
                        <div class="input-wrapper">
                            <input type="text" id="username" name="username" required
                                   placeholder="Nom d'utilisateur"
                                   value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                            <i class="fas fa-user input-icon"></i>
                        </div>
                        <span class="field-error" id="usernameError">Ce champ est obligatoire</span>
                    </div>

                    <div class="form-group">
                        <label for="fullName">Nom complet *</label>
                        <div class="input-wrapper">
                            <input type="text" id="fullName" name="fullName" required
                                   placeholder="Votre nom complet"
                                   value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                            <i class="fas fa-id-card input-icon"></i>
                        </div>
                        <span class="field-error" id="fullNameError">Ce champ est obligatoire</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Adresse email *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" required
                               placeholder="votre.email@exemple.com"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                    <span class="field-error" id="emailError">Entrez une adresse email valide</span>
                </div>

                <div class="form-group">
                    <label for="password">Mot de passe *</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" required
                               placeholder="Minimum 6 caractères">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar"></div>
                    </div>
                    <span class="field-error" id="passwordError">Le mot de passe doit contenir au moins 6 caractères</span>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirmer le mot de passe *</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Répétez votre mot de passe">
                        <i class="fas fa-check-double input-icon"></i>
                    </div>
                    <span class="field-error" id="confirmPasswordError">Les mots de passe ne correspondent pas</span>
                </div>

                <button type="submit" class="btn btn-primary">
                    Créer mon compte
                </button>
            </form>

            <div class="login-link">
                Vous avez déjà un compte ?
                <a href="${pageContext.request.contextPath}/auth">Se connecter</a>
            </div>
        </div>
    </div>

    <script>
        // Password strength checker
        function checkPasswordStrength(password) {
            const strengthBar = document.querySelector('.strength-bar');
            const strengthContainer = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strengthContainer.classList.remove('visible');
                return;
            }
            
            strengthContainer.classList.add('visible');
            
            let strength = 0;
            
            // Length check
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            
            // Character variety checks
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z\d]/.test(password)) strength++;
            
            // Remove all strength classes
            strengthBar.className = 'strength-bar';
            
            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength <= 3) {
                strengthBar.classList.add('strength-fair');
            } else if (strength <= 4) {
                strengthBar.classList.add('strength-good');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        }

        // Enhanced form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            let isValid = true;

            // Reset all errors
            document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
            document.querySelectorAll('input').forEach(el => el.classList.remove('error-field'));

            // Get form values
            const username = document.getElementById('username').value.trim();
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Validate username
            if (!username) {
                showError('username', 'Ce champ est obligatoire');
                isValid = false;
            } else if (username.length < 3) {
                showError('username', 'Le nom d\'utilisateur doit contenir au moins 3 caractères');
                isValid = false;
            }

            // Validate full name
            if (!fullName) {
                showError('fullName', 'Ce champ est obligatoire');
                isValid = false;
            } else if (fullName.length < 2) {
                showError('fullName', 'Le nom doit contenir au moins 2 caractères');
                isValid = false;
            }

            // Validate email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!email) {
                showError('email', 'Ce champ est obligatoire');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                showError('email', 'Entrez une adresse email valide');
                isValid = false;
            }

            // Validate password
            if (!password) {
                showError('password', 'Ce champ est obligatoire');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'Le mot de passe doit contenir au moins 6 caractères');
                isValid = false;
            }

            // Validate password confirmation
            if (!confirmPassword) {
                showError('confirmPassword', 'Ce champ est obligatoire');
                isValid = false;
            } else if (password !== confirmPassword) {
                showError('confirmPassword', 'Les mots de passe ne correspondent pas');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = document.querySelector('.error-field');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus();
                }
                return false;
            }

            return true;
        });

        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            field.classList.add('error-field');
            if (errorElement) {
                errorElement.textContent = message;
                errorElement.style.display = 'block';
            }
        }

        // Real-time validation and input enhancements
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('input', function() {
                this.classList.remove('error-field');
                const errorElement = document.getElementById(this.id + 'Error');
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
                
                // Password strength checking
                if (this.id === 'password') {
                    checkPasswordStrength(this.value);
                }
                
                // Real-time password confirmation
                if (this.id === 'confirmPassword') {
                    const password = document.getElementById('password').value;
                    if (this.value && this.value !== password) {
                        showError('confirmPassword', 'Les mots de passe ne correspondent pas');
                    }
                }
            });


        });

        // Add loading state to submit button
        document.getElementById('registerForm').addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.innerHTML = 'Création en cours...';
            submitBtn.disabled = true;
            
            // Re-enable after 5 seconds as fallback
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
        });
    </script>
</body>
</html>
