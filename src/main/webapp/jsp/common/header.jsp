<%@ page import="com.example.medicale.entity.User" %>
<%@ page import="com.example.medicale.enums.Role" %>
<header>
    <nav class="navbar">
        <div class="nav-brand">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-stethoscope"></i> Medical System
            </a>
        </div>

        <div class="nav-menu">
            <% if (session.getAttribute("user") != null) { 
                User currentUser = (User) session.getAttribute("user");
                Role userRole = currentUser.getRole();
            %>
                <!-- Navigation pour Spécialiste -->
                <% if (userRole == Role.SPECIALISTE) { %>
                    <a href="${pageContext.request.contextPath}/specialist/requests" class="nav-item">
                        <i class="fas fa-envelope"></i> Demandes
                    </a>
                    <a href="${pageContext.request.contextPath}/specialist/calendar" class="nav-item">
                        <i class="fas fa-calendar-alt"></i> Calendrier
                    </a>
                    <a href="${pageContext.request.contextPath}/specialist/slots" class="nav-item">
                        <i class="fas fa-clock"></i> Créneaux
                    </a>
                    <a href="${pageContext.request.contextPath}/specialist/profile" class="nav-item">
                        <i class="fas fa-user-md"></i> Profil
                    </a>
                <% } %>
                
                <!-- Navigation pour Généraliste -->
                <% if (userRole == Role.GENERALISTE) { %>
                    <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="nav-item">
                        <i class="fas fa-tachometer-alt"></i> Tableau de bord
                    </a>
                    <a href="${pageContext.request.contextPath}/generaliste/queue" class="nav-item">
                        <i class="fas fa-users"></i> File d'attente
                    </a>
                    <a href="${pageContext.request.contextPath}/generaliste/consultations" class="nav-item">
                        <i class="fas fa-notes-medical"></i> Consultations
                    </a>
                <% } %>
                
                <!-- Navigation pour Infirmier -->
                <% if (userRole == Role.INFIRMIER) { %>
                    <a href="${pageContext.request.contextPath}/nurse/patients" class="nav-item">
                        <i class="fas fa-user-injured"></i> Patients
                    </a>
                    <a href="${pageContext.request.contextPath}/nurse/register" class="nav-item">
                        <i class="fas fa-user-plus"></i> Enregistrer
                    </a>
                <% } %>

                <span class="nav-item">
                    <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                </span>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item logout">
                    <i class="fas fa-sign-out-alt"></i> Déconnexion
                </a>
            <% } %>
        </div>
    </nav>
</header>

