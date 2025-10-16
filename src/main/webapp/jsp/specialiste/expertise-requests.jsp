<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expertise Requests - Medical System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Expertise Requests</div>
        <div class="page-subtitle">Review and respond to consultation requests from general practitioners</div>

        
        <div class="filters">
            <div class="form-group" style="margin-bottom: 0;">
                <label for="priorityFilter">Priority:</label>
                <select id="priorityFilter" onchange="filterRequests()">
                    <option value="">All Priorities</option>
                    <option value="URGENTE">Urgent</option>
                    <option value="NORMALE">Normal</option>
                    <option value="NON_URGENTE">Low</option>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 0;">
                <label for="statusFilter">Status:</label>
                <select id="statusFilter" onchange="filterRequests()">
                    <option value="">All Status</option>
                    <option value="PENDING">Pending</option>
                    <option value="COMPLETED">Completed</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
            </div>

            <button class="btn btn-secondary" onclick="clearFilters()">
                <i class="fas fa-times"></i> Clear Filters
            </button>
        </div>

        
        <div class="dashboard-menu" style="margin-bottom: 32px;">
            <div class="menu-card">
                <h3><i class="fas fa-clock"></i> Pending Requests</h3>
                <div style="font-size: 2rem; font-weight: 700; color: #d69e2e;" id="pendingCount">2</div>
            </div>
            <div class="menu-card">
                <h3><i class="fas fa-check-circle"></i> Completed Today</h3>
                <div style="font-size: 2rem; font-weight: 700; color: #38a169;" id="completedCount">1</div>
            </div>
            <div class="menu-card">
                <h3><i class="fas fa-exclamation-triangle"></i> Urgent Requests</h3>
                <div style="font-size: 2rem; font-weight: 700; color: #e53e3e;" id="urgentCount">1</div>
            </div>
        </div>

        
        <div class="table-container">
            <table class="requests-table" id="requestsTable">
                <thead>
                    <tr>
                        <th>Patient</th>
                        <th>GP Doctor</th>
                        <th>Priority</th>
                        <th>Symptoms</th>
                        <th>Requested Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr data-priority="URGENTE" data-status="PENDING">
                        <td>
                            <div style="font-weight: 600;">John Doe</div>
                            <div style="font-size: 12px; color: #718096;">Age: 45, M</div>
                        </td>
                        <td>
                            <div style="font-weight: 500;">Dr. Sarah Johnson</div>
                            <div style="font-size: 12px; color: #718096;">General Practice</div>
                        </td>
                        <td>
                            <span class="badge badge-URGENTE">URGENT</span>
                        </td>
                        <td>
                            <div style="max-width: 200px;">
                                Chest pain, shortness of breath, dizziness
                            </div>
                        </td>
                        <td>
                            <div>Oct 15, 2025</div>
                            <div style="font-size: 12px; color: #718096;">09:30 AM</div>
                        </td>
                        <td>
                            <span class="status-pending">Pending</span>
                        </td>
                        <td>
                            <div class="flex gap-2">
                                <button class="btn btn-primary btn-small" onclick="viewRequest(1)">
                                    <i class="fas fa-eye"></i> View
                                </button>
                                <button class="btn btn-success btn-small" onclick="respondToRequest(1)">
                                    <i class="fas fa-reply"></i> Respond
                                </button>
                            </div>
                        </td>
                    </tr>
                    
                    <tr data-priority="NORMALE" data-status="PENDING">
                        <td>
                            <div style="font-weight: 600;">Jane Smith</div>
                            <div style="font-size: 12px; color: #718096;">Age: 32, F</div>
                        </td>
                        <td>
                            <div style="font-weight: 500;">Dr. Michael Brown</div>
                            <div style="font-size: 12px; color: #718096;">General Practice</div>
                        </td>
                        <td>
                            <span class="badge badge-NORMALE">NORMAL</span>
                        </td>
                        <td>
                            <div style="max-width: 200px;">
                                Persistent headaches, fatigue
                            </div>
                        </td>
                        <td>
                            <div>Oct 15, 2025</div>
                            <div style="font-size: 12px; color: #718096;">11:15 AM</div>
                        </td>
                        <td>
                            <span class="status-pending">Pending</span>
                        </td>
                        <td>
                            <div class="flex gap-2">
                                <button class="btn btn-primary btn-small" onclick="viewRequest(2)">
                                    <i class="fas fa-eye"></i> View
                                </button>
                                <button class="btn btn-success btn-small" onclick="respondToRequest(2)">
                                    <i class="fas fa-reply"></i> Respond
                                </button>
                            </div>
                        </td>
                    </tr>
                    
                    <tr data-priority="NORMALE" data-status="COMPLETED">
                        <td>
                            <div style="font-weight: 600;">Robert Wilson</div>
                            <div style="font-size: 12px; color: #718096;">Age: 58, M</div>
                        </td>
                        <td>
                            <div style="font-weight: 500;">Dr. Emily Davis</div>
                            <div style="font-size: 12px; color: #718096;">General Practice</div>
                        </td>
                        <td>
                            <span class="badge badge-NORMALE">NORMAL</span>
                        </td>
                        <td>
                            <div style="max-width: 200px;">
                                Joint pain, stiffness in morning
                            </div>
                        </td>
                        <td>
                            <div>Oct 14, 2025</div>
                            <div style="font-size: 12px; color: #718096;">02:20 PM</div>
                        </td>
                        <td>
                            <span class="status-completed">Completed</span>
                        </td>
                        <td>
                            <div class="flex gap-2">
                                <button class="btn btn-primary btn-small" onclick="viewRequest(3)">
                                    <i class="fas fa-eye"></i> View
                                </button>
                                <button class="btn btn-secondary btn-small" onclick="viewResponse(3)">
                                    <i class="fas fa-file-alt"></i> Response
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        function filterRequests() {
            const priorityFilter = document.getElementById('priorityFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const table = document.getElementById('requestsTable');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = tbody.getElementsByTagName('tr');
            
            let visibleRows = 0;
            
            for (let row of rows) {
                const priority = row.getAttribute('data-priority');
                const status = row.getAttribute('data-status');
                
                const priorityMatch = !priorityFilter || priority === priorityFilter;
                const statusMatch = !statusFilter || status === statusFilter;
                
                if (priorityMatch && statusMatch) {
                    row.style.display = '';
                    visibleRows++;
                } else {
                    row.style.display = 'none';
                }
            }
        }
        
        function clearFilters() {
            document.getElementById('priorityFilter').value = '';
            document.getElementById('statusFilter').value = '';
            filterRequests();
        }
        
        function viewRequest(requestId) {
            alert('View request: ' + requestId);
        }
        
        function respondToRequest(requestId) {
            alert('Respond to request: ' + requestId);
        }
        
        function viewResponse(requestId) {
            alert('View response for request: ' + requestId);
        }
    </script>
</body>
</html>
