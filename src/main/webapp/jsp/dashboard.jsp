<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.medicale.enums.Role" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="page-title">Welcome Back!</div>
        <div class="page-subtitle">Hello, ${sessionScope.username} - Ready to help your patients today?</div>

        <div class="dashboard-menu">
            <% Role role = (Role) session.getAttribute("role"); %>

            <% if (role == Role.INFIRMIER) { %>
                <div class="menu-card">
                    <h3><i class="fas fa-user-nurse"></i> Nurse Dashboard</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/nurse/register">
                            <i class="fas fa-user-plus"></i> Register New Patient
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/nurse/patients">
                            <i class="fas fa-calendar-day"></i> Today's Patients
                        </a></li>
                    </ul>
                </div>
            <% } else if (role == Role.GENERALISTE) { %>
                <div class="menu-card">
                    <h3><i class="fas fa-user-md"></i> General Practitioner Dashboard</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/generaliste/consultation/new">
                            <i class="fas fa-plus-circle"></i> New Consultation
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/generaliste/consultations">
                            <i class="fas fa-clipboard-list"></i> My Consultations
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/generaliste/queue">
                            <i class="fas fa-users"></i> Patient Queue
                        </a></li>
                    </ul>
                </div>
            <% } else if (role == Role.SPECIALISTE) { %>
                <div class="menu-card">
                    <h3><i class="fas fa-microscope"></i> Specialist Dashboard</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/specialist/profile">
                            <i class="fas fa-id-card"></i> My Profile
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/specialist/slots">
                            <i class="fas fa-calendar-alt"></i> My Availability
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/specialist/requests">
                            <i class="fas fa-envelope"></i> Expertise Requests
                        </a></li>
                    </ul>
                </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />
</body>
</html>

