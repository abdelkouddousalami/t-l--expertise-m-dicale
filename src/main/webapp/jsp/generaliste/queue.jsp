<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File d'attente - Médecin Généraliste</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .queue-card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .queue-card:hover {
            transform: translateY(-3px);
        }
        .queue-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        .patient-row {
            border-left: 4px solid #007bff;
        }
        .waiting-time {
            font-size: 0.9em;
        }
        .priority-normal { border-left-color: #28a745; }
        .priority-urgent { border-left-color: #dc3545; }
        .vital-signs-mini {
            font-size: 0.8em;
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 5px;
        }
        .queue-stats {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="../common/header.jsp" %>

    <div class="container-fluid py-4">
        <div class="row">
            
            <div class="col-md-2">
                <div class="card queue-card">
                    <div class="card-body">
                        <h6 class="card-title">Menu Généraliste</h6>
                        <div class="list-group list-group-flush">
                            <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="list-group-item list-group-item-action">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/generaliste/queue" class="list-group-item list-group-item-action active">
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
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">
                            <i class="fas fa-users me-2"></i>File d'attente - Patients du jour
                        </h1>
                        <p class="text-muted mb-0">
                            <i class="fas fa-calendar-day me-1"></i>
                            <jsp:useBean id="now" class="java.util.Date" />
                            <fmt:formatDate value="${now}" pattern="EEEE dd MMMM yyyy"/>
                        </p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-outline-primary me-2" onclick="refreshQueue()">
                            <i class="fas fa-sync-alt me-1"></i>Actualiser
                        </button>
                        <a href="${pageContext.request.contextPath}/generaliste/consultation/new" class="btn btn-success">
                            <i class="fas fa-plus me-1"></i>Nouvelle consultation
                        </a>
                    </div>
                </div>

                
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card queue-card queue-stats">
                            <div class="card-body text-center">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <h3>${queuePatients.size()}</h3>
                                <p class="mb-0">Patients en attente</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card queue-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white;">
                            <div class="card-body text-center">
                                <i class="fas fa-clock fa-2x mb-2"></i>
                                <h3 id="avgWaitTime">--</h3>
                                <p class="mb-0">Temps d'attente moyen</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card queue-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); color: white;">
                            <div class="card-body text-center">
                                <i class="fas fa-user-clock fa-2x mb-2"></i>
                                <h3 id="nextPatient">--</h3>
                                <p class="mb-0">Prochain patient</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card queue-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white;">
                            <div class="card-body text-center">
                                <i class="fas fa-euro-sign fa-2x mb-2"></i>
                                <h3>150 DH</h3>
                                <p class="mb-0">Tarif consultation</p>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="card queue-card">
                    <div class="queue-header p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-list-ol me-2"></i>Liste des patients
                            </h5>
                            <div class="badge bg-light text-dark">
                                <i class="fas fa-sort-amount-down me-1"></i>
                                Triés par heure d'arrivée
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty queuePatients}">
                                <div class="text-center py-5">
                                    <i class="fas fa-user-clock fa-4x text-muted mb-3"></i>
                                    <h4 class="text-muted">Aucun patient en attente</h4>
                                    <p class="text-muted">
                                        Tous les patients du jour ont été pris en charge ou aucune arrivée enregistrée.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="btn btn-primary">
                                        <i class="fas fa-tachometer-alt me-1"></i>Retour au dashboard
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th width="5%">#</th>
                                                <th width="25%">
                                                    <i class="fas fa-user me-1"></i>Patient
                                                </th>
                                                <th width="15%">
                                                    <i class="fas fa-id-card me-1"></i>Sécurité Sociale
                                                </th>
                                                <th width="12%">
                                                    <i class="fas fa-clock me-1"></i>Arrivée
                                                </th>
                                                <th width="15%">
                                                    <i class="fas fa-hourglass-half me-1"></i>Temps d'attente
                                                </th>
                                                <th width="18%">
                                                    <i class="fas fa-heartbeat me-1"></i>Signes vitaux
                                                </th>
                                                <th width="10%">
                                                    <i class="fas fa-cogs me-1"></i>Actions
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${queuePatients}" var="patient" varStatus="status">
                                                <tr class="patient-row ${status.index < 3 ? 'priority-urgent' : 'priority-normal'}">
                                                    <td class="text-center">
                                                        <span class="badge ${status.index == 0 ? 'bg-danger' : 
                                                            (status.index < 3 ? 'bg-warning' : 'bg-secondary')}">
                                                            ${status.index + 1}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-circle me-3 ${status.index == 0 ? 'bg-danger' : 'bg-primary'} text-white rounded-circle d-flex align-items-center justify-content-center"
                                                                 style="width: 40px; height: 40px; font-weight: bold;">
                                                                ${patient.firstName.substring(0,1)}${patient.lastName.substring(0,1)}
                                                            </div>
                                                            <div>
                                                                <strong>${patient.firstName} ${patient.lastName}</strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="fas fa-birthday-cake me-1"></i>
                                                                    <c:set var="dobParts" value="${fn:split(patient.dob, '-')}" />
                                                                    ${dobParts[2]}/${dobParts[1]}/${dobParts[0]}
                                                                </small>
                                                                <c:if test="${not empty patient.phone}">
                                                                    <br>
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-phone me-1"></i>${patient.phone}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <code class="text-dark">${patient.ssn}</code>
                                                    </td>
                                                    <td>
                                                        <div class="text-center">
                                                            <c:set var="arrivalStr" value="${patient.arrivalTime}" />
                                                            <c:if test="${not empty arrivalStr}">
                                                                <strong class="text-primary">
                                                                    ${fn:substring(arrivalStr, 11, 16)}
                                                                </strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <c:set var="datePart" value="${fn:substring(arrivalStr, 0, 10)}" />
                                                                    <c:set var="dateParts" value="${fn:split(datePart, '-')}" />
                                                                    ${dateParts[2]}/${dateParts[1]}
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="waiting-time text-center">
                                                            <jsp:useBean id="currentTime" class="java.util.Date" />
                                                            <c:set var="waitingMinutes" value="${(currentTime.time - patient.arrivalTime.time) / (1000 * 60)}" />
                                                            <span class="badge ${waitingMinutes > 60 ? 'bg-danger' : 
                                                                (waitingMinutes > 30 ? 'bg-warning' : 'bg-success')}">
                                                                <i class="fas fa-clock me-1"></i>
                                                                <fmt:formatNumber value="${waitingMinutes}" maxFractionDigits="0"/> min
                                                            </span>
                                                            <c:if test="${waitingMinutes > 60}">
                                                                <br><small class="text-danger">Attente prolongée!</small>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty patient.vitalSignsList and patient.vitalSignsList.size() > 0}">
                                                                <c:set var="latestVital" value="${patient.vitalSignsList[patient.vitalSignsList.size()-1]}"/>
                                                                <div class="vital-signs-mini">
                                                                    <div class="row text-center">
                                                                        <div class="col-6">
                                                                            <small><strong>TA:</strong> ${latestVital.bloodPressure}</small>
                                                                        </div>
                                                                        <div class="col-6">
                                                                            <small><strong>Temp:</strong> ${latestVital.temperature}°C</small>
                                                                        </div>
                                                                        <div class="col-6">
                                                                            <small><strong>FC:</strong> ${latestVital.heartRate}</small>
                                                                        </div>
                                                                        <div class="col-6">
                                                                            <small><strong>FR:</strong> ${latestVital.respiratoryRate}</small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <small class="text-muted">
                                                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                                                    Signes vitaux manquants
                                                                </small>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group-vertical" role="group">
                                                            <a href="${pageContext.request.contextPath}/generaliste/consultation/new?patientId=${patient.id}" 
                                                               class="btn btn-success btn-sm mb-1" title="Commencer la consultation">
                                                                <i class="fas fa-stethoscope"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-info btn-sm" 
                                                                    onclick="showPatientDetails('${patient.id}')" title="Voir détails patient">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
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

                
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card queue-card">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-bolt me-2"></i>Actions rapides</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/consultation/new" class="btn btn-primary w-100 mb-2">
                                            <i class="fas fa-plus-circle me-1"></i>Nouvelle consultation
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/consultations" class="btn btn-info w-100 mb-2">
                                            <i class="fas fa-history me-1"></i>Mes consultations
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="btn btn-secondary w-100 mb-2">
                                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <button type="button" class="btn btn-warning w-100 mb-2" onclick="refreshQueue()">
                                            <i class="fas fa-sync-alt me-1"></i>Actualiser la file
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            calculateQueueStats();
            
            // Auto-refresh every 2 minutes
            setInterval(function() {
                refreshQueue();
            }, 120000);
        });

        function calculateQueueStats() {
            const patientCount = <c:out value="${queuePatients.size()}" default="0"/>;
            
            if (patientCount > 0) {
                // Calculate average waiting time
                let totalWaitTime = 0;
                $('.waiting-time .badge').each(function() {
                    const text = $(this).text();
                    const match = text.match(/\d+/);
                    if (match) {
                        const minutes = parseInt(match[0]);
                        totalWaitTime += minutes;
                    }
                });
                
                const avgWait = Math.round(totalWaitTime / patientCount);
                $('#avgWaitTime').text(avgWait + ' min');
                
                // Set next patient
                const nextPatientName = $('.patient-row:first-child strong').text();
                $('#nextPatient').text(nextPatientName || 'N/A');
            } else {
                $('#avgWaitTime').text('0 min');
                $('#nextPatient').text('Aucun');
            }
        }

        function refreshQueue() {
            window.location.reload();
        }

        function showPatientDetails(patientId) {
            alert('Fonctionnalité à implémenter: Afficher les détails du patient #' + patientId);
        }

        // Add real-time clock update
        function updateClock() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('fr-FR');
            document.title = `File d'attente (${timeString}) - Médecin Généraliste`;
        }
        
        setInterval(updateClock, 1000);
    </script>
</body>
</html>
