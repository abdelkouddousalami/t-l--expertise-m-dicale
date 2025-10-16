<header>
    <nav class="navbar">
        <div class="nav-brand">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-stethoscope"></i> Medical System
            </a>
        </div>

        <div class="nav-menu">
            <% if (session.getAttribute("user") != null) { %>
                <span class="nav-item">
                    <i class="fas fa-user"></i> Hello, ${sessionScope.username}
                </span>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            <% } %>
        </div>
    </nav>
</header>

