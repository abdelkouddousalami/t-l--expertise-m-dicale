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
        <div class="page-subtitle">Create a new consultation for your patient</div>

        
        <div class="search-section">
            <h3 class="section-title">
                <i class="fas fa-search"></i> Select Patient
            </h3>
            <form id="patientSearchForm">
                <div style="display: flex; gap: 16px; align-items: end; flex-wrap: wrap;">
                    <div class="form-group" style="flex: 1; min-width: 250px;">
                        <label for="patientSearch">Search Patient (Name or SSN)</label>
                        <input type="text" id="patientSearch" name="patientSearch" 
                               placeholder="Type patient name or SSN" required>
                    </div>
                    <button type="submit" class="btn btn-secondary">
                        <i class="fas fa-search"></i> Search
                    </button>
                </div>
            </form>

            
            <div id="selectedPatientInfo" style="display: none; margin-top: 20px;">
                <div class="card" style="background: #f7fafc; border-left: 4px solid #4299e1;">
                    <div style="display: flex; justify-content: space-between; align-items: start;">
                        <div>
                            <h4 style="margin: 0 0 8px; color: #2d3748;" id="patientName">John Doe</h4>
                            <div style="font-size: 14px; color: #718096;" id="patientDetails">
                                Age: 45 | SSN: ***-**-1234 | Phone: (555) 123-4567
                            </div>
                            <div style="font-size: 14px; color: #718096; margin-top: 4px;" id="patientInsurance">
                                Insurance: Blue Cross Blue Shield
                            </div>
                        </div>
                        <button type="button" class="btn btn-small btn-secondary" onclick="clearPatientSelection()">
                            <i class="fas fa-times"></i> Change
                        </button>
                    </div>
                </div>
            </div>
        </div>

        
        <div class="form-section">
            <h3 class="section-title">
                <i class="fas fa-stethoscope"></i> Consultation Details
            </h3>

            <form action="${pageContext.request.contextPath}/generaliste/consultation/create" method="post">
                <input type="hidden" id="patientId" name="patientId" value="">

                
                <div class="form-group">
                    <label for="chiefComplaint">Chief Complaint</label>
                    <textarea id="chiefComplaint" name="chiefComplaint" rows="3" 
                              placeholder="What is the main reason for today's visit?" required></textarea>
                </div>

                
                <div class="form-group">
                    <label for="symptoms">Symptoms Description</label>
                    <textarea id="symptoms" name="symptoms" rows="4" 
                              placeholder="Describe the patient's symptoms in detail" required></textarea>
                </div>

                
                <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-user-md"></i> Physical Examination
                </h4>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bloodPressure">Blood Pressure</label>
                        <input type="text" id="bloodPressure" name="bloodPressure" 
                               placeholder="120/80 mmHg" required>
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
                        <label for="respiratoryRate">Respiratory Rate</label>
                        <input type="number" id="respiratoryRate" name="respiratoryRate" 
                               placeholder="16" min="8" max="40" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="physicalExam">Physical Examination Findings</label>
                    <textarea id="physicalExam" name="physicalExam" rows="4" 
                              placeholder="Describe physical examination findings"></textarea>
                </div>

                
                <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-diagnoses"></i> Diagnosis
                </h4>

                <div class="form-group">
                    <label for="diagnosis">Primary Diagnosis</label>
                    <textarea id="diagnosis" name="diagnosis" rows="3" 
                              placeholder="Primary diagnosis based on examination" required></textarea>
                </div>

                <div class="form-group">
                    <label for="differentialDiagnosis">Differential Diagnosis</label>
                    <textarea id="differentialDiagnosis" name="differentialDiagnosis" rows="2" 
                              placeholder="Other possible diagnoses to consider"></textarea>
                </div>

                
                <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">
                    <i class="fas fa-prescription"></i> Treatment Plan
                </h4>

                <div class="form-group">
                    <label for="treatmentPlan">Treatment & Recommendations</label>
                    <textarea id="treatmentPlan" name="treatmentPlan" rows="4" 
                              placeholder="Treatment plan, medications, lifestyle recommendations"></textarea>
                </div>

                <div class="form-group">
                    <label for="followUp">Follow-up Instructions</label>
                    <textarea id="followUp" name="followUp" rows="2" 
                              placeholder="When should the patient return? Any specific instructions?"></textarea>
                </div>

                
                <div class="form-row">
                    <div class="form-group">
                        <label for="priority">Consultation Priority</label>
                        <select id="priority" name="priority" required>
                            <option value="">Select priority level</option>
                            <option value="NON_URGENTE">Low Priority</option>
                            <option value="NORMALE">Normal Priority</option>
                            <option value="URGENTE">Urgent</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="needsSpecialist">Requires Specialist Consultation?</label>
                        <select id="needsSpecialist" name="needsSpecialist" onchange="toggleSpecialistSection()">
                            <option value="false">No</option>
                            <option value="true">Yes</option>
                        </select>
                    </div>
                </div>

                
                <div id="specialistSection" style="display: none;">
                    <h4 style="margin: 24px 0 16px; color: #2d3748; font-size: 1.125rem;">
                        <i class="fas fa-user-md"></i> Specialist Referral
                    </h4>

                    <div class="form-group">
                        <label for="specialistType">Specialist Type Required</label>
                        <select id="specialistType" name="specialistType">
                            <option value="">Select specialist type</option>
                            <option value="CARDIOLOGY">Cardiologist</option>
                            <option value="DERMATOLOGY">Dermatologist</option>
                            <option value="ORTHOPEDICS">Orthopedist</option>
                            <option value="PEDIATRICS">Pediatrician</option>
                            <option value="NEUROLOGY">Neurologist</option>
                            <option value="ONCOLOGY">Oncologist</option>
                            <option value="PSYCHIATRY">Psychiatrist</option>
                            <option value="RADIOLOGY">Radiologist</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="referralReason">Reason for Referral</label>
                        <textarea id="referralReason" name="referralReason" rows="3" 
                                  placeholder="Why is specialist consultation needed?"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="urgency">Referral Urgency</label>
                        <select id="urgency" name="urgency">
                            <option value="NON_URGENTE">Non-urgent (within 2 weeks)</option>
                            <option value="NORMALE">Normal (within 1 week)</option>
                            <option value="URGENTE">Urgent (within 24 hours)</option>
                        </select>
                    </div>
                </div>

                
                <div class="form-group">
                    <label for="notes">Additional Notes</label>
                    <textarea id="notes" name="notes" rows="3" 
                              placeholder="Any additional observations or notes"></textarea>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-primary btn-large">
                        <i class="fas fa-save"></i> Save Consultation
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="saveDraft()">
                        <i class="fas fa-draft"></i> Save as Draft
                    </button>
                    <a href="${pageContext.request.contextPath}/generaliste/consultations" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        function toggleSpecialistSection() {
            const needsSpecialist = document.getElementById('needsSpecialist').value === 'true';
            const specialistSection = document.getElementById('specialistSection');
            const specialistType = document.getElementById('specialistType');
            const referralReason = document.getElementById('referralReason');
            
            if (needsSpecialist) {
                specialistSection.style.display = 'block';
                specialistType.required = true;
                referralReason.required = true;
            } else {
                specialistSection.style.display = 'none';
                specialistType.required = false;
                referralReason.required = false;
            }
        }

        function clearPatientSelection() {
            document.getElementById('selectedPatientInfo').style.display = 'none';
            document.getElementById('patientId').value = '';
            document.getElementById('patientSearch').value = '';
        }

        function saveDraft() {
            const form = document.querySelector('form');
            const formData = new FormData(form);
            formData.append('draft', 'true');
            
            fetch('${pageContext.request.contextPath}/generaliste/consultation/draft', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Draft saved successfully!');
                }
            });
        }

        // Patient search functionality
        document.getElementById('patientSearchForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const searchTerm = document.getElementById('patientSearch').value;
            
            if (searchTerm.trim()) {
                // Mock patient selection - replace with actual search
                document.getElementById('selectedPatientInfo').style.display = 'block';
                document.getElementById('patientId').value = '1';
            }
        });

        // Auto-save functionality
        let autoSaveTimer;
        const formInputs = document.querySelectorAll('input, textarea, select');
        
        formInputs.forEach(input => {
            input.addEventListener('input', function() {
                clearTimeout(autoSaveTimer);
                autoSaveTimer = setTimeout(() => {
                    // Auto-save draft logic here
                    console.log('Auto-saving draft...');
                }, 30000); // Save after 30 seconds of inactivity
            });
        });
    </script>
</body>
</html>