<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Medical System</title>
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
                <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="nav-item">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            </div>
        </nav>
    </header>

    <div class="login-container">
        <div class="login-box">
            <h1><i class="fas fa-sign-in-alt"></i> Welcome Back</h1>
            <h2>Sign in to your account</h2>
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

            <form action="${pageContext.request.contextPath}/auth" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required 
                           placeholder="Enter your username">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Enter your password">
                </div>

                <button type="submit" class="btn btn-primary btn-large">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>

            <div class="register-link">
                Don't have an account? 
                <a href="${pageContext.request.contextPath}/jsp/register.jsp">Create Account</a>
            </div>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />
</body>
</html>
