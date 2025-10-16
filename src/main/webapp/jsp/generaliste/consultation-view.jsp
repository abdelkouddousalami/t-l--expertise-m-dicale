<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultation - Médecin Généraliste</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .consultation-card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .patient-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        .section-header {
            border-left: 4px solid #007bff;
            padding-left: 15px;
            margin-bottom: 1rem;
            background-color: #f8f9fa;
            padding: 10px 15px;
            border-radius: 5px;
        }
        .status-badge {
            font-size: 0.9em;
        }
        .status-open { background-color: #17a2b8; }
        .status-waiting { background-color: #ffc107; color: black; }
        .status-completed { background-color: #28a745; }
        .cost-card {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="../common/header.jsp" %>

    <div class="container-fluid py-4">
        <div class="row">
            
            <div class="col-md-2">
                <div class="card consultation-card">
                    <div class="card-body">
                        <h6 class="card-title">Menu Généraliste</h6>
                        <div class="list-group list-group-flush">
                            <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="list-group-item list-group-item-action">
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
                
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/generaliste/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/generaliste/consultations">Consultations</a></li>
                        <li class="breadcrumb-item active">Consultation #${consultation.id}</li>
                    </ol>
                </nav>

                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                
                <div class="card consultation-card mb-4">
                    <div class="patient-header p-4">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="mb-0">
                                    <i class="fas fa-user-circle me-2"></i>
                                    ${consultation.patient.firstName} ${consultation.patient.lastName}
                                </h2>
                                <p class="mb-0">
                                    <i class="fas fa-id-card me-1"></i>SSN: ${consultation.patient.ssn} |
                                    <i class="fas fa-birthday-cake me-1"></i>Né(e) le: 
                                    <c:set var="dobParts" value="${fn:split(consultation.patient.dob, '-')}" />
                                    ${dobParts[2]}/${dobParts[1]}/${dobParts[0]}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <h4>Consultation #${consultation.id}</h4>
                                <p class="mb-0">
                                    <c:set var="consultDateStr" value="${consultation.consultationDate}" />
                                    <c:if test="${not empty consultDateStr}">
                                        <c:set var="datePart" value="${fn:substring(consultDateStr, 0, 10)}" />
                                        <c:set var="timePart" value="${fn:substring(consultDateStr, 11, 16)}" />
                                        <c:set var="dateParts" value="${fn:split(datePart, '-')}" />
                                        ${dateParts[2]}/${dateParts[1]}/${dateParts[0]} à ${timePart}
                                    </c:if>
                                </p>
                                <span class="badge status-badge ${consultation.status == 'OPEN' ? 'status-open' : 
                                    (consultation.status == 'EN_ATTENTE_AVIS_SPECIALISTE' ? 'status-waiting' : 'status-completed')}">
                                    <c:choose>
                                        <c:when test="${consultation.status == 'OPEN'}">En cours</c:when>
                                        <c:when test="${consultation.status == 'EN_ATTENTE_AVIS_SPECIALISTE'}">En attente avis spécialiste</c:when>
                                        <c:otherwise>Terminée</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    
                    <div class="col-md-8">
                        
                        <div class="card consultation-card mb-4">
                            <div class="card-body">
                                <div class="section-header">
                                    <h5><i class="fas fa-stethoscope me-2"></i>Détails de la Consultation</h5>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <strong><i class="fas fa-clipboard-list me-1"></i>Motif:</strong>
                                        <p>${consultation.motif}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <strong><i class="fas fa-user-md me-1"></i>Médecin:</strong>
                                        <p>Dr. ${consultation.generaliste.fullName}</p>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <strong><i class="fas fa-user-injured me-1"></i>Symptômes rapportés:</strong>
                                    <div class="border rounded p-3 bg-light">
                                        <p class="mb-0">${consultation.symptoms}</p>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <strong><i class="fas fa-search me-1"></i>Examen clinique:</strong>
                                    <div class="border rounded p-3 bg-light">
                                        <p class="mb-0">${consultation.clinicalExam}</p>
                                    </div>
                                </div>

                                <c:if test="${not empty consultation.observations}">
                                    <div class="mb-3">
                                        <strong><i class="fas fa-notes-medical me-1"></i>Observations:</strong>
                                        <div class="border rounded p-3 bg-light">
                                            <p class="mb-0">${consultation.observations}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        
                        <c:if test="${consultation.status == 'OPEN'}">
                            
                            <div class="card consultation-card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-prescription me-2"></i>Prise en Charge - Décision</h5>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted mb-3">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Choisissez le type de prise en charge selon la situation du patient
                                    </p>

                                    
                                    <div class="border rounded p-3 mb-3">
                                        <h6 class="text-success"><i class="fas fa-check-circle me-1"></i>Scénario A: Prise en charge directe</h6>
                                        <p class="small text-muted">
                                            Si vous pouvez gérer la situation (pathologie courante, prescription simple)
                                        </p>
                                        
                                        <form action="${pageContext.request.contextPath}/generaliste/consultation/close" method="post">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                            <input type="hidden" name="consultationId" value="${consultation.id}">
                                            
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="diagnosis" class="form-label">Diagnostic *</label>
                                                    <input type="text" class="form-control" id="diagnosis" name="diagnosis" 
                                                           placeholder="Ex: Angine virale, Hypertension artérielle..." required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="prescription" class="form-label">Prescription *</label>
                                                    <textarea class="form-control" id="prescription" name="prescription" rows="3" 
                                                              placeholder="Ex: - Paracétamol 1g, 3 fois/jour&#10;- Sirop antitussif, 2 cuillères/jour" required></textarea>
                                                </div>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-check me-1"></i>Clôturer la consultation
                                            </button>
                                        </form>
                                    </div>

                                    
                                    <div class="border rounded p-3">
                                        <h6 class="text-warning"><i class="fas fa-user-md me-1"></i>Scénario B: Demander l'avis d'un spécialiste</h6>
                                        <p class="small text-muted">
                                            Si la situation nécessite l'expertise d'un spécialiste
                                        </p>
                                        
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="speciality" class="form-label">Spécialité requise</label>
                                                <select class="form-control" id="speciality">
                                                    <option value="">-- Choisir une spécialité --</option>
                                                    <option value="CARDIOLOGIE">Cardiologue</option>
                                                    <option value="PNEUMOLOGIE">Pneumologue</option>
                                                    <option value="DERMATOLOGIE">Dermatologue</option>
                                                    <option value="NEUROLOGIE">Neurologue</option>
                                                    <option value="ENDOCRINOLOGIE">Endocrinologue</option>
                                                    <option value="GASTROENTEROLOGIE">Gastro-entérologue</option>
                                                    <option value="ORTHOPÉDIE">Orthopédiste</option>
                                                </select>
                                            </div>
                                            <div class="col-md-8">
                                                <button type="button" class="btn btn-warning" onclick="requestExpertise()" style="margin-top: 32px;">
                                                    <i class="fas fa-search me-1"></i>Demander avis spécialiste
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        
                        <c:if test="${not empty consultation.diagnosis}">
                            <div class="card consultation-card mb-4">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0"><i class="fas fa-clipboard-check me-2"></i>Diagnostic et Traitement</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <strong><i class="fas fa-diagnoses me-1"></i>Diagnostic:</strong>
                                            <div class="border rounded p-3 bg-light mt-2">
                                                <p class="mb-0">${consultation.diagnosis}</p>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <strong><i class="fas fa-prescription-bottle-alt me-1"></i>Prescription:</strong>
                                            <div class="border rounded p-3 bg-light mt-2">
                                                <pre class="mb-0" style="white-space: pre-line;">${consultation.prescription}</pre>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    
                    <div class="col-md-4">
                        
                        <div class="card consultation-card cost-card mb-4">
                            <div class="card-header text-center">
                                <h5 class="mb-0"><i class="fas fa-euro-sign me-2"></i>Résumé des Coûts</h5>
                            </div>
                            <div class="card-body text-center">
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <div class="border-bottom pb-2">
                                            <strong>Consultation généraliste</strong>
                                            <h4>150 DH</h4>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12">
                                        <hr class="bg-white">
                                        <h5><strong>Total: ${totalCost} DH</strong></h5>
                                    </div>
                                </div>
                            </div>
                        </div>

                        
                        <div class="card consultation-card">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-cogs me-2"></i>Actions</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/generaliste/consultations" class="btn btn-outline-primary">
                                        <i class="fas fa-list me-1"></i>Toutes mes consultations
                                    </a>
                                    <a href="${pageContext.request.contextPath}/generaliste/consultation/new" class="btn btn-outline-success">
                                        <i class="fas fa-plus me-1"></i>Nouvelle consultation
                                    </a>
                                    <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="btn btn-outline-info">
                                        <i class="fas fa-tachometer-alt me-1"></i>Retour au dashboard
                                    </a>
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
        function requestExpertise() {
            const speciality = document.getElementById('speciality').value;
            if (!speciality) {
                alert('Veuillez sélectionner une spécialité');
                return;
            }
            
            // Redirect to expertise request page
            window.location.href = '${pageContext.request.contextPath}/generaliste/expertise/request?consultationId=${consultation.id}&speciality=' + speciality;
        }
    </script>
</body>
</html>

