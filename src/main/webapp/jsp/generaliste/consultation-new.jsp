<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Consultation - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">New Consultation</div>
        <div class="page-subtitle">Create a comprehensive medical consultation for your patient</div>

        
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        
        <c:if test="${not empty success}">
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                ${success}
            </div>
        </c:if>

        
        <div class="search-section">
            <h3 class="section-title">
                <i class="fas fa-user-search"></i> Select Patient
            </h3>
            <form id="patientSelectionForm">
                <div class="form-group">
                    <label for="patientId">Search Patient</label>
                    <select id="patientId" name="patientId" required>
                        <option value="">-- Select a patient --</option>
                        <c:forEach items="${patients}" var="patient">
                            <option value="${patient.id}" 
                                data-firstname="${patient.firstName}" 
                                data-lastname="${patient.lastName}" 
                                data-dob="${patient.dob}" 
                                data-ssn="${patient.ssn}"
                                data-phone="${patient.phone}"
                                data-address="${patient.address}"
                                data-allergies="${patient.allergies}"
                                data-treatments="${patient.currentTreatments}"
                                data-history="${patient.medicalHistory}"
                                ${param.patientId == patient.id ? 'selected' : ''}>
                                ${patient.firstName} ${patient.lastName} - ${patient.ssn}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                
                <div id="patientInfo" class="card" style="display: none; background: #f7fafc; border-left: 4px solid #4299e1; margin-top: 20px;">
                    <h4 style="margin: 0 0 16px; color: #2d3748;">
                        <i class="fas fa-user-circle"></i> Patient Information
                    </h4>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div>
                            <strong>Name:</strong> <span id="patientName"></span><br>
                            <strong>Date of Birth:</strong> <span id="patientDob"></span><br>
                            <strong>SSN:</strong> <span id="patientSsn"></span>
                        </div>
                        <div>
                            <strong>Phone:</strong> <span id="patientPhone"></span><br>
                            <strong>Address:</strong> <span id="patientAddress"></span>
                        </div>
                    </div>
                    
                    
                    <div id="medicalHistorySection" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                            <div>
                                <strong style="color: #e53e3e;"><i class="fas fa-allergies"></i> Allergies:</strong>
                                <div id="allergiesContent" style="font-size: 14px; margin-top: 4px;">None</div>
                            </div>
                            <div>
                                <strong style="color: #d69e2e;"><i class="fas fa-pills"></i> Current Medications:</strong>
                                <div id="treatmentsContent" style="font-size: 14px; margin-top: 4px;">None</div>
                            </div>
                            <div>
                                <strong style="color: #4299e1;"><i class="fas fa-notes-medical"></i> Medical History:</strong>
                                <div id="historyContent" style="font-size: 14px; margin-top: 4px;">None</div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        
        <div class="form-section">
            <h3 class="section-title">
                <i class="fas fa-stethoscope"></i> Consultation Details
            </h3>

            <form action="${pageContext.request.contextPath}/generaliste/consultation/create" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" id="selectedPatientId" name="patientId" value="" required>

                
                <div class="form-row">
                    <div class="form-group">
                        <label for="motif">Chief Complaint</label>
                        <input type="text" id="motif" name="motif" required
                               placeholder="e.g., Chest pain, Fever, Routine checkup...">
                    </div>
                    <div class="form-group">
                        <label for="consultationCost">Consultation Fee</label>
                        <input type="text" id="consultationCost" value="150 DH" readonly>
                    </div>
                </div>

                
                <div class="form-group">
                    <label for="observations">General Observations</label>
                    <textarea id="observations" name="observations" rows="3" 
                              placeholder="Initial observations and general assessment..."></textarea>
                </div>

                
                <h4 style="margin: 32px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-user-injured"></i> Symptoms Analysis
                </h4>

                <div class="form-group">
                    <label for="symptoms">Patient Reported Symptoms</label>
                    <textarea id="symptoms" name="symptoms" rows="4" required
                              placeholder="Describe what the patient is experiencing and reporting..."></textarea>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        <i class="fas fa-info-circle"></i>
                        Example: "Patient complains of chest pain for 2 days, accompanied by shortness of breath..."
                    </div>
                </div>

                
                <h4 style="margin: 32px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-search"></i> Clinical Examination
                </h4>

                <div class="form-group">
                    <label for="clinicalExam">Physical Examination Results</label>
                    <textarea id="clinicalExam" name="clinicalExam" rows="4" required
                              placeholder="Results of physical examination (palpation, auscultation, inspection, etc.)..."></textarea>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        <i class="fas fa-info-circle"></i>
                        Example: "Pulmonary auscultation: fine bilateral rales. Abdominal palpation: epigastric tenderness..."
                    </div>
                </div>

                
                <div id="medicalHistorySection" class="form-section" style="display: none;">
                    <h4 style="margin: 32px 0 16px; color: #2d3748; font-size: 1.125rem;">
                        <i class="fas fa-history"></i> Medical History
                    </h4>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                        <div class="info-card">
                            <div class="card-header" style="background-color: #3182ce; color: white;">
                                <i class="fas fa-allergies"></i> Allergies
                            </div>
                            <div class="card-content" id="allergiesContent">
                                
                            </div>
                        </div>
                        <div class="info-card">
                            <div class="card-header" style="background-color: #d69e2e; color: white;">
                                <i class="fas fa-pills"></i> Current Treatments
                            </div>
                            <div class="card-content" id="treatmentsContent">
                                
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <div class="card-header" style="background-color: #718096; color: white;">
                            <i class="fas fa-notes-medical"></i> Medical History
                        </div>
                        <div class="card-content" id="historyContent">
                            
                        </div>
                    </div>
                </div>

                
                <h4 style="margin: 32px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-diagnoses"></i> Diagnosis & Treatment
                </h4>

                <div class="form-group">
                    <label for="diagnosis">Primary Diagnosis</label>
                    <textarea id="diagnosis" name="diagnosis" rows="3" required
                              placeholder="Your diagnosis based on symptoms and examination..."></textarea>
                </div>

                <div class="form-group">
                    <label for="treatment">Recommended Treatment Plan</label>
                    <textarea id="treatment" name="treatment" rows="4" required
                              placeholder="Medications, dosages, general recommendations..."></textarea>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        <i class="fas fa-info-circle"></i>
                        Include medications, dosages and treatment duration
                    </div>
                </div>

                
                <h4 style="margin: 32px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-calendar-check"></i> Follow-up & Appointments
                </h4>

                <div class="form-row">
                    <div class="form-group">
                        <label for="followUp">Follow-up Instructions</label>
                        <textarea id="followUp" name="followUp" rows="3"
                                  placeholder="Instructions for patient follow-up..."></textarea>
                    </div>
                    <div class="form-group">
                        <label for="nextAppointment">Next Appointment</label>
                        <input type="date" id="nextAppointment" name="nextAppointment">
                        <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                            <i class="fas fa-info-circle"></i>
                            Optional - If follow-up is needed
                        </div>
                    </div>
                </div>

                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 32px; padding: 24px 0; border-top: 1px solid #e2e8f0;">
                    <a href="${pageContext.request.contextPath}/generaliste/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    
                    <div style="display: flex; gap: 12px;">
                        <button type="reset" class="btn btn-outline">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Create Consultation
                        </button>
                        <button type="button" class="btn btn-outline" onclick="checkForReferral()">
                            <i class="fas fa-user-md"></i> Request Expertise
                        </button>
                    </div>
                </div>

        </div>
    </div>
</div>

    <%@ include file="../common/footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize Select2
            $('#patientId').select2({
                placeholder: "Tapez le nom ou SSN du patient...",
                allowClear: true,
                width: '100%'
            });

            // Handle patient selection
            $('#patientId').on('change', function() {
                const selectedOption = $(this).find('option:selected');
                
                if (selectedOption.val()) {
                    // Set the selected patient ID in the hidden field
                    $('#selectedPatientId').val(selectedOption.val());
                    
                    // Show patient info
                    $('#patientName').text(selectedOption.data('firstname') + ' ' + selectedOption.data('lastname'));
                    
                    // Format the LocalDate (YYYY-MM-DD) to DD/MM/YYYY
                    const dobString = selectedOption.data('dob');
                    const formattedDob = dobString ? dobString.split('-').reverse().join('/') : 'Non renseignée';
                    $('#patientDob').text(formattedDob);
                    
                    $('#patientSsn').text(selectedOption.data('ssn'));
                    $('#patientPhone').text(selectedOption.data('phone') || 'Non renseigné');
                    $('#patientAddress').text(selectedOption.data('address') || 'Non renseignée');
                    $('#patientInfo').show();

                    // Show medical history
                    const allergies = selectedOption.data('allergies');
                    const treatments = selectedOption.data('treatments');
                    const history = selectedOption.data('history');

                    $('#allergiesContent').html(allergies || '<em style="color: #718096;">No known allergies</em>');
                    $('#treatmentsContent').html(treatments || '<em style="color: #718096;">No current treatments</em>');
                    $('#historyContent').html(history || '<em style="color: #718096;">No medical history</em>');
                    $('#medicalHistorySection').show();

                    // Load vital signs (you can implement AJAX call here)
                    loadVitalSigns(selectedOption.val());
                } else {
                    // Clear the selected patient ID
                    $('#selectedPatientId').val('');
                    $('#patientInfo').hide();
                    $('#medicalHistorySection').hide();
                    $('#vitalSignsCard').hide();
                }
            });

            // Pre-select patient if patientId is provided
            if ('${param.patientId}') {
                $('#patientId').trigger('change');
            }
        });

        function loadVitalSigns(patientId) {
            // Mock vital signs - in real app, make AJAX call to load actual data
            const mockVitalSigns = {
                bloodPressure: '120/80',
                heartRate: '75',
                temperature: '37.2',
                respiratoryRate: '18',
                weight: '70',
                height: '175'
            };

            const vitalSignsHtml = `
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px;">
                    <div style="text-align: center; padding: 12px;">
                        <i class="fas fa-heartbeat" style="color: #e53e3e; font-size: 24px; margin-bottom: 8px;"></i>
                        <div style="font-weight: 600;">BP</div>
                        <div style="color: #4a5568;">${mockVitalSigns.bloodPressure}</div>
                    </div>
                    <div style="text-align: center; padding: 12px;">
                        <i class="fas fa-heart" style="color: #3182ce; font-size: 24px; margin-bottom: 8px;"></i>
                        <div style="font-weight: 600;">HR</div>
                        <div style="color: #4a5568;">${mockVitalSigns.heartRate} bpm</div>
                    </div>
                    <div style="text-align: center; padding: 12px;">
                        <i class="fas fa-thermometer-half" style="color: #d69e2e; font-size: 24px; margin-bottom: 8px;"></i>
                        <div style="font-weight: 600;">Temp</div>
                        <div style="color: #4a5568;">${mockVitalSigns.temperature}°C</div>
                    </div>
                    <div style="text-align: center; padding: 12px;">
                        <i class="fas fa-lungs" style="color: #38a169; font-size: 24px; margin-bottom: 8px;"></i>
                        <div style="font-weight: 600;">RR</div>
                        <div style="color: #4a5568;">${mockVitalSigns.respiratoryRate}/min</div>
                    </div>
                </div>
            `;

            $('#vitalSignsContent').html(vitalSignsHtml);
            $('#vitalSignsCard').show();
        }

        function checkForReferral() {
            alert('Expertise request feature will be implemented');
        }

        function validateForm() {
            const patientId = $('#selectedPatientId').val();
            if (!patientId || patientId.trim() === '') {
                alert('Please select a patient before creating the consultation.');
                return false;
            }
            return true;
        }

        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>
</html>
