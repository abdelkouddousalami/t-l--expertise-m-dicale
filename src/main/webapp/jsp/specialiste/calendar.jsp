<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Calendrier - Système Médical</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .calendar-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .calendar-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }

        .calendar-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .calendar-nav button {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .calendar-nav button:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .calendar-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e2e8f0;
        }

        .calendar-day-header {
            background: #f8fafc;
            padding: 12px 8px;
            text-align: center;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .calendar-day {
            background: white;
            min-height: 120px;
            padding: 8px;
            position: relative;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .calendar-day:hover {
            background: #f7fafc;
        }

        .calendar-day.other-month {
            background: #f8fafc;
            color: #a0aec0;
        }

        .calendar-day.today {
            background: #ebf8ff;
            border: 2px solid #3182ce;
        }

        .day-number {
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 4px;
        }

        .today .day-number {
            color: #3182ce;
        }

        .event-item {
            background: #4299e1;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.75rem;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
        }

        .event-item.consultation {
            background: #48bb78;
        }

        .event-item.expertise {
            background: #ed8936;
        }

        .event-item.unavailable {
            background: #e53e3e;
        }

        .event-item.personal {
            background: #9f7aea;
        }

        .calendar-sidebar {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-left: 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: #f7fafc;
            padding: 16px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #4299e1;
        }

        .stat-card.consultations {
            border-left-color: #48bb78;
        }

        .stat-card.expertise {
            border-left-color: #ed8936;
        }

        .stat-card.today {
            border-left-color: #9f7aea;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
        }

        .stat-label {
            font-size: 0.875rem;
            color: #718096;
            margin-top: 4px;
        }

        .upcoming-events {
            margin-top: 24px;
        }

        .upcoming-event {
            padding: 12px;
            border-left: 4px solid #4299e1;
            background: #f7fafc;
            border-radius: 0 8px 8px 0;
            margin-bottom: 8px;
        }

        .upcoming-event.consultation {
            border-left-color: #48bb78;
        }

        .upcoming-event.expertise {
            border-left-color: #ed8936;
        }

        .event-time {
            font-size: 0.875rem;
            color: #4a5568;
            font-weight: 600;
        }

        .event-title {
            color: #2d3748;
            font-weight: 500;
            margin-top: 2px;
        }

        .calendar-actions {
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .view-toggle {
            display: flex;
            background: #edf2f7;
            border-radius: 8px;
            padding: 4px;
        }

        .view-toggle button {
            background: transparent;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .view-toggle button.active {
            background: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .event-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            border-radius: 12px;
            padding: 24px;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #718096;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
        }

        .close-modal:hover {
            background: #f7fafc;
            color: #2d3748;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Mon Calendrier</div>
        <div class="page-subtitle">Gérez vos créneaux et consultations</div>

        <!-- Actions du calendrier -->
        <div class="calendar-actions">
            <div class="view-toggle">
                <button class="active" onclick="switchView('month')">
                    <i class="fas fa-calendar-alt"></i> Mois
                </button>
                <button onclick="switchView('week')">
                    <i class="fas fa-calendar-week"></i> Semaine
                </button>
            </div>
            
            <button class="btn btn-primary" onclick="syncCalendar()">
                <i class="fas fa-sync-alt"></i> Synchroniser
            </button>
            
            <button class="btn btn-secondary" onclick="generateSlots()">
                <i class="fas fa-plus"></i> Générer créneaux
            </button>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 300px; gap: 20px;">
            <!-- Calendrier principal -->
            <div class="calendar-container">
                <div class="calendar-header">
                    <div class="calendar-nav">
                        <button onclick="previousMonth()">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <h2 class="calendar-title">
                            <c:choose>
                                <c:when test="${not empty currentMonth}">
                                    ${currentMonth.month} ${currentMonth.year}
                                </c:when>
                                <c:otherwise>
                                    Calendrier
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <button onclick="nextMonth()">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                    <div style="display: flex; justify-content: center; gap: 20px; margin-top: 10px;">
                        <span style="font-size: 0.875rem; opacity: 0.9;">
                            <i class="fas fa-circle" style="color: #48bb78; font-size: 0.5rem;"></i> Consultations
                        </span>
                        <span style="font-size: 0.875rem; opacity: 0.9;">
                            <i class="fas fa-circle" style="color: #ed8936; font-size: 0.5rem;"></i> Expertises
                        </span>
                        <span style="font-size: 0.875rem; opacity: 0.9;">
                            <i class="fas fa-circle" style="color: #e53e3e; font-size: 0.5rem;"></i> Indisponible
                        </span>
                    </div>
                </div>

                <div class="calendar-grid">
                    <!-- En-têtes des jours -->
                    <div class="calendar-day-header">Lun</div>
                    <div class="calendar-day-header">Mar</div>
                    <div class="calendar-day-header">Mer</div>
                    <div class="calendar-day-header">Jeu</div>
                    <div class="calendar-day-header">Ven</div>
                    <div class="calendar-day-header">Sam</div>
                    <div class="calendar-day-header">Dim</div>

                    <!-- Jours du calendrier -->
                    <c:forEach var="day" items="${calendarData.days}">
                        <div class="calendar-day ${not day.isCurrentMonth ? 'other-month' : ''} ${day.isToday ? 'today' : ''}"
                             onclick="showDayDetails('${day.date}')">
                            <div class="day-number">${day.dayOfMonth}</div>
                            <c:forEach var="event" items="${day.events}">
                                <div class="event-item ${event.eventType.name().toLowerCase()}" 
                                     onclick="showEventDetails('${event.id}', event)">
                                    ${event.startTime.hour}:${event.startTime.minute < 10 ? '0' : ''}${event.startTime.minute} ${event.title}
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Sidebar avec statistiques -->
            <div class="calendar-sidebar">
                <h3>Statistiques du mois</h3>
                
                <div class="stats-grid">
                    <div class="stat-card consultations">
                        <div class="stat-number">${statistics.consultations}</div>
                        <div class="stat-label">Consultations</div>
                    </div>
                    <div class="stat-card expertise">
                        <div class="stat-number">${statistics.expertiseRequests}</div>
                        <div class="stat-label">Expertises</div>
                    </div>
                    <div class="stat-card today">
                        <div class="stat-number">${statistics.todayEvents}</div>
                        <div class="stat-label">Aujourd'hui</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${statistics.upcomingEvents}</div>
                        <div class="stat-label">À venir</div>
                    </div>
                </div>

                <div class="upcoming-events">
                    <h4>Prochains événements</h4>
                    <!-- Ces données seraient chargées via AJAX ou incluses dans le modèle -->
                    <div class="upcoming-event consultation">
                        <div class="event-time">14:00 - 14:30</div>
                        <div class="event-title">Consultation - Dr. Martin</div>
                    </div>
                    <div class="upcoming-event expertise">
                        <div class="event-time">15:00 - 15:30</div>
                        <div class="event-title">Expertise cardiaque</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal pour les détails d'événement -->
    <div class="event-modal" id="eventModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Détails de l'événement</h3>
                <button class="close-modal" onclick="closeModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div id="modalBody">
                <!-- Contenu chargé dynamiquement -->
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        let currentMonth = new Date();
        <c:if test="${not empty currentMonth}">
            currentMonth = new Date(${currentMonth.year}, ${currentMonth.monthValue - 1});
        </c:if>

        function switchView(view) {
            // Mettre à jour les boutons actifs
            document.querySelectorAll('.view-toggle button').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');

            if (view === 'week') {
                window.location.href = '${pageContext.request.contextPath}/specialist/calendar/week';
            } else {
                window.location.href = '${pageContext.request.contextPath}/specialist/calendar/month';
            }
        }

        function previousMonth() {
            currentMonth.setMonth(currentMonth.getMonth() - 1);
            const yearMonth = currentMonth.getFullYear() + '-' + String(currentMonth.getMonth() + 1).padStart(2, '0');
            window.location.href = '${pageContext.request.contextPath}/specialist/calendar/month?month=' + yearMonth;
        }

        function nextMonth() {
            currentMonth.setMonth(currentMonth.getMonth() + 1);
            const yearMonth = currentMonth.getFullYear() + '-' + String(currentMonth.getMonth() + 1).padStart(2, '0');
            window.location.href = '${pageContext.request.contextPath}/specialist/calendar/month?month=' + yearMonth;
        }

        function syncCalendar() {
            fetch('${pageContext.request.contextPath}/specialist/calendar/sync', {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Erreur lors de la synchronisation');
                }
            });
        }

        function generateSlots() {
            fetch('${pageContext.request.contextPath}/specialist/slots/generate', {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Erreur lors de la génération des créneaux');
                }
            });
        }

        function showDayDetails(date) {
            // Afficher les détails du jour sélectionné
            document.getElementById('modalTitle').textContent = 'Événements du ' + date;
            document.getElementById('modalBody').innerHTML = '<p>Chargement des événements...</p>';
            document.getElementById('eventModal').style.display = 'flex';
            
            // Simulation des événements du jour (à remplacer par un appel AJAX réel)
            setTimeout(() => {
                let content = `
                    <div class="day-events">
                        <div class="event-detail">
                            <h4>Consultation - Patient A</h4>
                            <p><strong>Heure:</strong> 09:00 - 09:30</p>
                            <p><strong>Type:</strong> Consultation</p>
                        </div>
                        <div class="event-detail">
                            <h4>Expertise cardiaque</h4>
                            <p><strong>Heure:</strong> 14:00 - 14:30</p>
                            <p><strong>Type:</strong> Expertise</p>
                        </div>
                    </div>
                `;
                document.getElementById('modalBody').innerHTML = content;
            }, 500);
        }

        function showEventDetails(eventId, e) {
            if (e) e.stopPropagation();
            // Afficher les détails d'un événement spécifique
            document.getElementById('modalTitle').textContent = 'Détails de l\'événement';
            document.getElementById('modalBody').innerHTML = '<p>Chargement...</p>';
            document.getElementById('eventModal').style.display = 'flex';
            
            // Simulation des détails d'événement (à remplacer par un appel AJAX réel)
            setTimeout(() => {
                let content = `
                    <div class="event-detail">
                        <h4>Événement #` + eventId + `</h4>
                        <p><strong>Type:</strong> Consultation</p>
                        <p><strong>Date:</strong> ` + new Date().toLocaleDateString() + `</p>
                        <p><strong>Heure:</strong> 14:00 - 14:30</p>
                        <p><strong>Description:</strong> Consultation de routine</p>
                    </div>
                `;
                document.getElementById('modalBody').innerHTML = content;
            }, 500);
        }

        function closeModal() {
            document.getElementById('eventModal').style.display = 'none';
        }

        // Fermer la modal en cliquant à l'extérieur
        document.getElementById('eventModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        // Gestion des messages de succès/erreur
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'sync') {
            alert('Calendrier synchronisé avec succès!');
        }
        if (urlParams.get('error') === 'sync') {
            alert('Erreur lors de la synchronisation du calendrier.');
        }
    </script>
</body>
</html>