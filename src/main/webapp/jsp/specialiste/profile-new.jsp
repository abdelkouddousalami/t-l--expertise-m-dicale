<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">My Profile</div>
        <div class="page-subtitle">Manage your professional information and availability</div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
            
            <div class="card">
                <h3 class="section-title">Profile Information</h3>
                
                <form action="${pageContext.request.contextPath}/specialist/profile/update" method="post">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" value="Dr. John" required>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="Smith" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="john.smith@medical.com" required>
                    </div>

                    <div class="form-group">
                        <label for="speciality">Speciality</label>
                        <select id="speciality" name="speciality" required>
                            <option value="CARDIOLOGY" selected>Cardiology</option>
                            <option value="DERMATOLOGY">Dermatology</option>
                            <option value="ORTHOPEDICS">Orthopedics</option>
                            <option value="PEDIATRICS">Pediatrics</option>
                            <option value="NEUROLOGY">Neurology</option>
                            <option value="ONCOLOGY">Oncology</option>
                            <option value="PSYCHIATRY">Psychiatry</option>
                            <option value="RADIOLOGY">Radiology</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="experience">Years of Experience</label>
                        <input type="number" id="experience" name="experience" value="15" min="0" max="50" required>
                    </div>

                    <div class="form-group">
                        <label for="bio">Professional Bio</label>
                        <textarea id="bio" name="bio" rows="4" placeholder="Brief professional biography">Experienced cardiologist with over 15 years in cardiovascular medicine. Specialized in interventional cardiology and heart disease prevention.</textarea>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Profile
                        </button>
                    </div>
                </form>
            </div>

            
            <div class="card">
                <h3 class="section-title">Statistics & Actions</h3>
                
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                    <div style="background: #f7fafc; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #4299e1;">
                        <div style="font-size: 1.5rem; font-weight: 700; color: #4299e1;">42</div>
                        <div style="font-size: 0.875rem; color: #718096;">Total Consultations</div>
                    </div>
                    <div style="background: #f7fafc; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #38a169;">
                        <div style="font-size: 1.5rem; font-weight: 700; color: #38a169;">38</div>
                        <div style="font-size: 0.875rem; color: #718096;">Completed This Month</div>
                    </div>
                    <div style="background: #f7fafc; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #d69e2e;">
                        <div style="font-size: 1.5rem; font-weight: 700; color: #d69e2e;">3</div>
                        <div style="font-size: 0.875rem; color: #718096;">Pending Reviews</div>
                    </div>
                    <div style="background: #f7fafc; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #e53e3e;">
                        <div style="font-size: 1.5rem; font-weight: 700; color: #e53e3e;">1</div>
                        <div style="font-size: 0.875rem; color: #718096;">Urgent Cases</div>
                    </div>
                </div>

                
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/specialist/requests" class="btn btn-primary">
                        <i class="fas fa-envelope"></i> View Expertise Requests
                    </a>
                    <a href="${pageContext.request.contextPath}/specialist/schedule" class="btn btn-secondary">
                        <i class="fas fa-calendar-alt"></i> Manage Schedule
                    </a>
                    <a href="${pageContext.request.contextPath}/specialist/reports" class="btn btn-secondary">
                        <i class="fas fa-chart-bar"></i> View Reports
                    </a>
                </div>
            </div>
        </div>

        
        <div class="card" style="margin-top: 24px;">
            <h3 class="section-title">Weekly Availability</h3>
            
            <div style="overflow-x: auto;">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Day</th>
                            <th>Morning (9:00 - 12:00)</th>
                            <th>Afternoon (14:00 - 17:00)</th>
                            <th>Evening (19:00 - 21:00)</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Monday</strong></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Tuesday</strong></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span class="badge badge-urgent">Busy</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Wednesday</strong></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Thursday</strong></td>
                            <td><span class="badge badge-urgent">Busy</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Friday</strong></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span class="badge badge-low">Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Saturday</strong></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                        <tr>
                            <td><strong>Sunday</strong></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><span style="color: #718096;">Not Available</span></td>
                            <td><button class="btn btn-small btn-secondary">Edit</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        
        <div class="card" style="margin-top: 24px;">
            <h3 class="section-title">Recent Activity</h3>
            
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="border-left: 4px solid #4299e1; padding: 16px; background: #f7fafc; border-radius: 0 8px 8px 0;">
                    <div style="font-weight: 600; color: #2d3748;">New expertise request received</div>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        Patient: John Doe - Chest pain case - 2 hours ago
                    </div>
                </div>
                
                <div style="border-left: 4px solid #38a169; padding: 16px; background: #f7fafc; border-radius: 0 8px 8px 0;">
                    <div style="font-weight: 600; color: #2d3748;">Consultation completed</div>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        Patient: Jane Smith - Headache analysis - 5 hours ago
                    </div>
                </div>
                
                <div style="border-left: 4px solid #d69e2e; padding: 16px; background: #f7fafc; border-radius: 0 8px 8px 0;">
                    <div style="font-weight: 600; color: #2d3748;">Profile updated</div>
                    <div style="font-size: 14px; color: #718096; margin-top: 4px;">
                        Updated professional bio and availability - Yesterday
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>