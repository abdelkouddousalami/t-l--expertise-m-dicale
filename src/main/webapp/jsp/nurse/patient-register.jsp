<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Registration - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Patient Registration</div>
        <div class="page-subtitle">Register new patients or search existing patient records</div>

        
        <div class="search-section">
            <h3 class="section-title">
                <i class="fas fa-search"></i> Search Existing Patient
            </h3>
            <form action="${pageContext.request.contextPath}/nurse/search" method="get">
                <div style="display: flex; gap: 16px; align-items: end; flex-wrap: wrap;">
                    <div class="form-group" style="flex: 1; min-width: 250px;">
                        <label for="ssn">Social Security Number</label>
                        <input type="text" id="ssn" name="ssn" placeholder="Enter patient SSN" required>
                    </div>
                    <button type="submit" class="btn btn-secondary">
                        <i class="fas fa-search"></i> Search Patient
                    </button>
                </div>
            </form>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success-message">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <div class="form-section">
            <h3 class="section-title">
                <i class="fas fa-user-plus"></i> Patient Information
            </h3>
            <form action="${pageContext.request.contextPath}/nurse/register" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" 
                               value="${patient.firstName}" placeholder="Enter first name" required>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" 
                               value="${patient.lastName}" placeholder="Enter last name" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" value="${patient.dob}" required>
                    </div>

                    <div class="form-group">
                        <label for="ssnInput">Social Security Number</label>
                        <input type="text" id="ssnInput" name="ssn" 
                               value="${patient.ssn}" placeholder="XXX-XX-XXXX" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" 
                               value="${patient.phone}" placeholder="Enter phone number">
                    </div>

                    <div class="form-group">
                        <label for="mutuelle">Insurance Provider</label>
                        <input type="text" id="mutuelle" name="mutuelle" 
                               value="${patient.mutuelle}" placeholder="Insurance company name">
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" rows="2" 
                              placeholder="Enter patient's full address">${patient.address}</textarea>
                </div>

                
                <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">Medical Information</h4>

                <div class="form-group">
                    <label for="medicalHistory">Medical History</label>
                    <textarea id="medicalHistory" name="medicalHistory" rows="3" 
                              placeholder="Previous medical conditions, surgeries, etc.">${patient.medicalHistory}</textarea>
                </div>

                <div class="form-group">
                    <label for="allergies">Allergies</label>
                    <textarea id="allergies" name="allergies" rows="2" 
                              placeholder="Known allergies (medications, food, environmental)">${patient.allergies}</textarea>
                </div>

                <div class="form-group">
                    <label for="currentTreatments">Current Medications</label>
                    <textarea id="currentTreatments" name="currentTreatments" rows="2" 
                              placeholder="Current medications and dosages">${patient.currentTreatments}</textarea>
                </div>

                
                <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-heartbeat"></i> Vital Signs
                </h4>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bloodPressure">Blood Pressure</label>
                        <input type="text" id="bloodPressure" name="bloodPressure" 
                               placeholder="120/80" required>
                    </div>

                    <div class="form-group">
                        <label for="heartRate">Heart Rate (bpm)</label>
                        <input type="number" id="heartRate" name="heartRate" 
                               placeholder="72" min="30" max="200" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="temperature">Temperature (°C)</label>
                        <input type="number" id="temperature" name="temperature" 
                               step="0.1" placeholder="36.5" min="30" max="45" required>
                    </div>

                    <div class="form-group">
                        <label for="respiratoryRate">Respiratory Rate (breaths/min)</label>
                        <input type="number" id="respiratoryRate" name="respiratoryRate" 
                               placeholder="16" min="8" max="40" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="weight">Weight (kg)</label>
                        <input type="number" id="weight" name="weight" step="0.1" 
                               placeholder="70.0" min="1" max="300">
                    </div>

                    <div class="form-group">
                        <label for="height">Height (cm)</label>
                        <input type="number" id="height" name="height" step="0.1" 
                               placeholder="170.0" min="50" max="250">
                    </div>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-primary btn-large">
                        <i class="fas fa-user-plus"></i> Register Patient
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-undo"></i> Clear Form
                    </button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>

