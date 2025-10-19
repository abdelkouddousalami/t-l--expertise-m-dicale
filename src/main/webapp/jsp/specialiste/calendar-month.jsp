<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendrier Mensuel - Système Médical</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .month-calendar {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .month-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }

        .month-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .month-nav button {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .month-nav button:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .month-title {
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

        .event-item.expertise_request {
            background: #ed8936;
        }

        .event-item.unavailable {
            background: #e53e3e;
        }

        .event-item.personal_appointment {
            background: #9f7aea;
        }

        .event-item.break {
            background: #718096;
        }

        .more-events {
            font-size: 0.75rem;
            color: #4a5568;
            font-style: italic;
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
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Calendrier Mensuel</div>
        <div class="page-subtitle">
            <c:choose>
                <c:when test="${not empty currentMonth}">
                    ${currentMonth.month} ${currentMonth.year}
                </c:when>
                <c:otherwise>
                    Calendrier Mensuel
                </c:otherwise>
            </c:choose>
        </div>

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

        <!-- Calendrier mensuel -->
        <div class="month-calendar">
            <div class="month-header">
                <div class="month-nav">
                    <button onclick="previousMonth()">
                        <i class="fas fa-chevron-left"></i> Mois précédent
                    </button>
                    <h2 class="month-title">
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
                        Mois suivant <i class="fas fa-chevron-right"></i>
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
                    <span style="font-size: 0.875rem; opacity: 0.9;">
                        <i class="fas fa-circle" style="color: #9f7aea; font-size: 0.5rem;"></i> Personnel
                    </span>
                </div>
            </div>

            <div class="calendar-grid">
                <!-- En-têtes des jours -->
                <div class="calendar-day-header">Lundi</div>
                <div class="calendar-day-header">Mardi</div>
                <div class="calendar-day-header">Mercredi</div>
                <div class="calendar-day-header">Jeudi</div>
                <div class="calendar-day-header">Vendredi</div>
                <div class="calendar-day-header">Samedi</div>
                <div class="calendar-day-header">Dimanche</div>

                <!-- Jours du calendrier -->
                <c:forEach var="day" items="${calendarData.days}">
                    <div class="calendar-day ${not day.isCurrentMonth ? 'other-month' : ''} ${day.isToday ? 'today' : ''}"
                         onclick="showDayDetails('${day.date}')">
                        <div class="day-number">${day.dayOfMonth}</div>
                        
                        <!-- Afficher les premiers événements -->
                        <c:set var="eventCount" value="0" />
                        <c:forEach var="event" items="${day.events}">
                            <c:if test="${eventCount < 3}">
                                <div class="event-item ${event.eventType.name().toLowerCase()}" 
                                     onclick="showEventDetails('${event.id}', event)">
                                    ${event.startTime.hour}:${event.startTime.minute < 10 ? '0' : ''}${event.startTime.minute} ${event.title}
                                </div>
                                <c:set var="eventCount" value="${eventCount + 1}" />
                            </c:if>
                        </c:forEach>
                        
                        <!-- Afficher "... plus" s'il y a plus de 3 événements -->
                        <c:if test="${fn:length(day.events) > 3}">
                            <div class="more-events">
                                +${fn:length(day.events) - 3} plus...
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
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
            document.querySelectorAll('.view-toggle button').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');

            if (view === 'week') {
                window.location.href = '${pageContext.request.contextPath}/specialist/calendar/week';
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
            // Rediriger vers la vue détaillée du jour
            window.location.href = '${pageContext.request.contextPath}/specialist/calendar/day?date=' + date;
        }

        function showEventDetails(eventId, e) {
            if (e) e.stopPropagation();
            // Rediriger vers les détails de l'événement
            window.location.href = '${pageContext.request.contextPath}/specialist/request/view?id=' + eventId;
        }

        // Gestion des messages
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