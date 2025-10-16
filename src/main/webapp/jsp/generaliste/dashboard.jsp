<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Médecin Généraliste</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .queue-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .consultation-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .expertise-card {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        .priority-urgent {
            background-color: #dc3545;
            color: white;
        }
        .priority-normal {
            background-color: #ffc107;
            color: black;
        }
        .priority-low {
            background-color: #28a745;
            color: white;
        }
        .status-open {
            background-color: #17a2b8;
            color: white;
        }
        .status-waiting {
            background-color: #ffc107;
            color: black;
        }
        .status-completed {
            background-color: #28a745;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="../common/header.jsp" %>

    <div class="container-fluid py-4">
        <div class="row">
            
            <div class="col-md-2">
                <div class="card dashboard-card">
                    <div class="card-body">
                        <h6 class="card-title">Menu Généraliste</h6>
                        <div class="list-group list-group-flush">
                            <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="list-group-item list-group-item-action active">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/generaliste/queue" class="list-group-item list-group-item-action">
                                <i class="fas fa-users me-2"></i>File d'attente
                            </a>
                            <a href="${pageContext.request.contextPath}/generaliste/consultation/new" class="list-group-item list-group-item-action">
                                <i class="fas fa-plus-circle me-2"></i>Nouvelle consultation
                            </a>
                            <a href="${pageContext.request.contextPath}/generaliste/consultations" class="list-group-item list-group-item-action">
                                <i class="fas fa-history me-2"></i>Mes consultations
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            
            <div class="col-md-10">
                
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="h3 mb-0">Bonjour, Dr. ${generaliste.fullName}</h1>
                        <p class="text-muted">Voici votre tableau de bord pour aujourd'hui</p>
                    </div>
                </div>

                
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card dashboard-card stat-card">
                            <div class="card-body text-center">
                                <i class="fas fa-users fa-2x mb-3"></i>
                                <h4 class="card-title">${todayPatients.size()}</h4>
                                <p class="card-text">Patients en attente</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card queue-card">
                            <div class="card-body text-center">
                                <i class="fas fa-stethoscope fa-2x mb-3"></i>
                                <h4 class="card-title">${myConsultations.size()}</h4>
                                <p class="card-text">Consultations du jour</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card consultation-card">
                            <div class="card-body text-center">
                                <i class="fas fa-user-md fa-2x mb-3"></i>
                                <h4 class="card-title">${pendingRequests.size()}</h4>
                                <p class="card-text">Expertises en attente</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card expertise-card">
                            <div class="card-body text-center">
                                <i class="fas fa-euro-sign fa-2x mb-3"></i>
                                <h4 class="card-title">€ 150</h4>
                                <p class="card-text">Tarif consultation</p>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card dashboard-card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0"><i class="fas fa-clock me-2"></i>File d'attente - Patients du jour</h5>
                                <a href="${pageContext.request.contextPath}/generaliste/queue" class="btn btn-primary btn-sm">
                                    Voir tout
                                </a>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty todayPatients}">
                                        <div class="text-center py-4">
                                            <i class="fas fa-user-clock fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">Aucun patient en attente pour le moment</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th><i class="fas fa-user me-1"></i>Patient</th>
                                                        <th><i class="fas fa-id-card me-1"></i>N° Sécurité Sociale</th>
                                                        <th><i class="fas fa-clock me-1"></i>Heure d'arrivée</th>
                                                        <th><i class="fas fa-heartbeat me-1"></i>Signes vitaux</th>
                                                        <th><i class="fas fa-cogs me-1"></i>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${todayPatients}" var="patient" begin="0" end="4">
                                                        <tr>
                                                            <td>
                                                                <strong>${patient.firstName} ${patient.lastName}</strong><br>
                                                                <small class="text-muted">
                                                                    <c:set var="dobParts" value="${fn:split(patient.dob, '-')}" />
                                                                    ${dobParts[2]}/${dobParts[1]}/${dobParts[0]}
                                                                </small>
                                                            </td>
                                                            <td>${patient.ssn}</td>
                                                            <td>
                                                                <c:set var="arrivalStr" value="${patient.arrivalTime}" />
                                                                <c:if test="${not empty arrivalStr}">
                                                                    ${fn:substring(arrivalStr, 11, 16)}
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty patient.vitalSignsList}">
                                                                    <c:set var="latestVital" value="${patient.vitalSignsList[patient.vitalSignsList.size()-1]}"/>
                                                                    <small>
                                                                        TA: ${latestVital.bloodPressure}<br>
                                                                        Temp: ${latestVital.temperature}°C
                                                                    </small>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/generaliste/consultation/new?patientId=${patient.id}" 
                                                                   class="btn btn-sm btn-success">
                                                                    <i class="fas fa-plus me-1"></i>Consulter
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card dashboard-card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Consultations récentes</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty myConsultations}">
                                        <div class="text-center py-4">
                                            <i class="fas fa-stethoscope fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">Aucune consultation récente</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="list-group list-group-flush">
                                            <c:forEach items="${myConsultations}" var="consultation" begin="0" end="4">
                                                <div class="list-group-item">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div>
                                                            <h6 class="mb-1">${consultation.patient.firstName} ${consultation.patient.lastName}</h6>
                                                            <p class="mb-1">${consultation.motif}</p>
                                                            <small class="text-muted">
                                                                <c:set var="consultDateStr" value="${consultation.consultationDate}" />
                                                                <c:if test="${not empty consultDateStr}">
                                                                    <c:set var="datePart" value="${fn:substring(consultDateStr, 0, 10)}" />
                                                                    <c:set var="timePart" value="${fn:substring(consultDateStr, 11, 16)}" />
                                                                    <c:set var="dateParts" value="${fn:split(datePart, '-')}" />
                                                                    ${dateParts[2]}/${dateParts[1]}/${dateParts[0]} ${timePart}
                                                                </c:if>
                                                            </small>
                                                        </div>
                                                        <div>
                                                            <c:choose>
                                                                <c:when test="${consultation.status == 'OPEN'}">
                                                                    <span class="badge status-open">En cours</span>
                                                                </c:when>
                                                                <c:when test="${consultation.status == 'EN_ATTENTE_AVIS_SPECIALISTE'}">
                                                                    <span class="badge status-waiting">En attente avis</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge status-completed">Terminée</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <a href="${pageContext.request.contextPath}/generaliste/consultation/view?id=${consultation.id}" 
                                                               class="btn btn-sm btn-outline-primary ms-2">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    
                    <div class="col-md-4">
                        <div class="card dashboard-card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-user-md me-2"></i>Expertises en attente</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty pendingRequests}">
                                        <div class="text-center py-4">
                                            <i class="fas fa-check-circle fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">Aucune expertise en attente</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="list-group list-group-flush">
                                            <c:forEach items="${pendingRequests}" var="request" begin="0" end="3">
                                                <div class="list-group-item border-0 px-0">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <h6 class="mb-1">${request.specialityRequested}</h6>
                                                            <p class="mb-1 small">${request.consultation.patient.firstName} ${request.consultation.patient.lastName}</p>
                                                            <small class="text-muted">
                                                                <c:set var="requestDateStr" value="${request.requestDate}" />
                                                                <c:if test="${not empty requestDateStr}">
                                                                    <c:set var="datePart" value="${fn:substring(requestDateStr, 0, 10)}" />
                                                                    <c:set var="timePart" value="${fn:substring(requestDateStr, 11, 16)}" />
                                                                    <c:set var="dateParts" value="${fn:split(datePart, '-')}" />
                                                                    ${dateParts[2]}/${dateParts[1]} ${timePart}
                                                                </c:if>
                                                            </small>
                                                        </div>
                                                        <div>
                                                            <c:choose>
                                                                <c:when test="${request.priority == 'URGENTE'}">
                                                                    <span class="badge priority-urgent">Urgent</span>
                                                                </c:when>
                                                                <c:when test="${request.priority == 'NORMALE'}">
                                                                    <span class="badge priority-normal">Normal</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge priority-low">Faible</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="row">
                    <div class="col-12">
                        <div class="card dashboard-card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Actions rapides</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/consultation/new" class="btn btn-primary btn-lg w-100 mb-2">
                                            <i class="fas fa-plus-circle me-2"></i>
                                            Nouvelle consultation
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/queue" class="btn btn-info btn-lg w-100 mb-2">
                                            <i class="fas fa-users me-2"></i>
                                            Voir la file d'attente
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/consultations" class="btn btn-warning btn-lg w-100 mb-2">
                                            <i class="fas fa-history me-2"></i>
                                            Historique consultations
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <button type="button" class="btn btn-success btn-lg w-100 mb-2" onclick="refreshDashboard()">
                                            <i class="fas fa-sync-alt me-2"></i>
                                            Actualiser
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../common/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function refreshDashboard() {
            location.reload();
        }

        // Auto-refresh every 5 minutes
        setInterval(function() {
            refreshDashboard();
        }, 300000);
    </script>
</body>
</html>
