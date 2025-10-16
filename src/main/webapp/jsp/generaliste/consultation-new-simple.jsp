<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Consultation - Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>Nouvelle Consultation - Version Test</h1>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/generaliste/consultation/create" method="post">
            <div class="card">
                <div class="card-body">
                    <h5>Sélection du Patient</h5>
                    
                    <div class="mb-3">
                        <label for="patientId" class="form-label">Patient *</label>
                        <select id="patientId" name="patientId" class="form-control" required>
                            <option value="">-- Sélectionner un patient --</option>
                            <c:forEach items="${patients}" var="patient">
                                <option value="${patient.id}">
                                    ${patient.firstName} ${patient.lastName} - ${patient.ssn}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="motif" class="form-label">Motif de consultation *</label>
                        <input type="text" class="form-control" id="motif" name="motif" required>
                    </div>

                    <div class="mb-3">
                        <label for="symptoms" class="form-label">Symptômes *</label>
                        <textarea class="form-control" id="symptoms" name="symptoms" rows="3" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="clinicalExam" class="form-label">Examen clinique *</label>
                        <textarea class="form-control" id="clinicalExam" name="clinicalExam" rows="3" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="observations" class="form-label">Observations</label>
                        <textarea class="form-control" id="observations" name="observations" rows="3"></textarea>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-success">
                            Créer la consultation
                        </button>
                        <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="btn btn-secondary">
                            Retour
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>