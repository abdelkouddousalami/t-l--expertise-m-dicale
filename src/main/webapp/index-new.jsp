<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Tele-Expertise System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/">
                    <i class="fas fa-stethoscope"></i> Medical System
                </a>
            </div>
            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="nav-item">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
                <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="nav-item">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            </div>
        </nav>
    </header>

    <div class="container">
        
        <div style="text-align: center; padding: 80px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                    border-radius: 12px; margin-bottom: 40px; color: white;">
            <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 16px; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <i class="fas fa-stethoscope"></i> Medical Tele-Expertise System
            </h1>
            <p style="font-size: 1.25rem; margin-bottom: 32px; opacity: 0.9;">
                Connecting healthcare professionals for better patient outcomes
            </p>
            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" 
                   class="btn btn-primary btn-large" 
                   style="background: white; color: #667eea; border-color: white;">
                    <i class="fas fa-sign-in-alt"></i> Get Started
                </a>
                <a href="#features" 
                   class="btn btn-secondary btn-large" 
                   style="background: transparent; color: white; border-color: white;">
                    <i class="fas fa-info-circle"></i> Learn More
                </a>
            </div>
        </div>

        
        <div id="features" style="margin-bottom: 60px;">
            <h2 style="text-align: center; font-size: 2.5rem; font-weight: 700; color: #2d3748; margin-bottom: 16px;">
                Comprehensive Healthcare Solution
            </h2>
            <p style="text-align: center; font-size: 1.125rem; color: #718096; margin-bottom: 48px; max-width: 600px; margin-left: auto; margin-right: auto;">
                Our platform enables seamless collaboration between nurses, general practitioners, and specialists 
                for efficient patient care and medical expertise sharing.
            </p>

            <div class="dashboard-menu">
                <div class="menu-card">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <i class="fas fa-user-nurse" style="font-size: 3rem; color: #4299e1; margin-bottom: 16px;"></i>
                        <h3>For Nurses</h3>
                    </div>
                    <ul>
                        <li><i class="fas fa-user-plus"></i> Register new patients</li>
                        <li><i class="fas fa-notes-medical"></i> Record vital signs</li>
                        <li><i class="fas fa-calendar-check"></i> Manage daily schedules</li>
                        <li><i class="fas fa-chart-line"></i> Track patient progress</li>
                    </ul>
                </div>

                <div class="menu-card">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <i class="fas fa-user-md" style="font-size: 3rem; color: #38a169; margin-bottom: 16px;"></i>
                        <h3>For General Practitioners</h3>
                    </div>
                    <ul>
                        <li><i class="fas fa-stethoscope"></i> Conduct consultations</li>
                        <li><i class="fas fa-prescription"></i> Prescribe treatments</li>
                        <li><i class="fas fa-share-alt"></i> Request specialist expertise</li>
                        <li><i class="fas fa-history"></i> Access patient history</li>
                    </ul>
                </div>

                <div class="menu-card">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <i class="fas fa-microscope" style="font-size: 3rem; color: #e53e3e; margin-bottom: 16px;"></i>
                        <h3>For Specialists</h3>
                    </div>
                    <ul>
                        <li><i class="fas fa-envelope"></i> Receive expertise requests</li>
                        <li><i class="fas fa-eye"></i> Review patient cases</li>
                        <li><i class="fas fa-comments"></i> Provide recommendations</li>
                        <li><i class="fas fa-clock"></i> Manage availability</li>
                    </ul>
                </div>
            </div>
        </div>

        
        <div style="background: white; padding: 48px; border-radius: 12px; 
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 60px;">
            <h3 style="text-align: center; font-size: 1.875rem; font-weight: 600; 
                       color: #2d3748; margin-bottom: 40px;">
                Trusted by Healthcare Professionals
            </h3>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
                        gap: 32px; text-align: center;">
                <div>
                    <div style="font-size: 2.5rem; font-weight: 700; color: #4299e1; margin-bottom: 8px;">500+</div>
                    <div style="color: #718096; font-size: 1rem;">Healthcare Professionals</div>
                </div>
                <div>
                    <div style="font-size: 2.5rem; font-weight: 700; color: #38a169; margin-bottom: 8px;">10K+</div>
                    <div style="color: #718096; font-size: 1rem;">Patients Served</div>
                </div>
                <div>
                    <div style="font-size: 2.5rem; font-weight: 700; color: #d69e2e; margin-bottom: 8px;">25K+</div>
                    <div style="color: #718096; font-size: 1rem;">Consultations Completed</div>
                </div>
                <div>
                    <div style="font-size: 2.5rem; font-weight: 700; color: #e53e3e; margin-bottom: 8px;">98%</div>
                    <div style="color: #718096; font-size: 1rem;">Satisfaction Rate</div>
                </div>
            </div>
        </div>

        
        <div style="text-align: center; padding: 48px 32px; background: #f7fafc; 
                    border-radius: 12px; border: 1px solid #e2e8f0;">
            <h3 style="font-size: 1.875rem; font-weight: 600; color: #2d3748; margin-bottom: 16px;">
                Ready to Get Started?
            </h3>
            <p style="font-size: 1.125rem; color: #718096; margin-bottom: 32px; max-width: 500px; 
                      margin-left: auto; margin-right: auto;">
                Join our platform today and experience seamless healthcare collaboration.
            </p>
            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-primary btn-large">
                    <i class="fas fa-user-plus"></i> Sign Up Now
                </a>
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-secondary btn-large">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="jsp/common/footer.jsp" />
</body>
</html>