<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendrier Hebdomadaire - Système Médical</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .week-calendar {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .week-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }

        .week-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .week-nav button {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .week-nav button:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .week-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        .time-grid {
            display: grid;
            grid-template-columns: 80px repeat(7, 1fr);
            gap: 1px;
            background: #e2e8f0;
        }

        .time-slot {
            background: #f8fafc;
            padding: 8px 4px;
            text-align: center;
            font-size: 0.75rem;
            color: #4a5568;
            border-right: 1px solid #e2e8f0;
        }

        .day-header {
            background: #f8fafc;
            padding: 12px 8px;
            text-align: center;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.875rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .day-header.today {
            background: #ebf8ff;
            color: #3182ce;
            border-bottom-color: #3182ce;
        }

        .day-column {
            background: white;
            min-height: 60px;
            padding: 8px;
            position: relative;
            border-right: 1px solid #e2e8f0;
        }

        .time-block {
            border-bottom: 1px solid #f1f5f9;
            min-height: 60px;
            padding: 4px;
            position: relative;
        }

        .time-block:last-child {
            border-bottom: none;
        }

        .week-event {
            background: #4299e1;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            margin-bottom: 2px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .week-event.consultation {
            background: #48bb78;
        }

        .week-event.expertise {
            background: #ed8936;
        }

        .week-event.unavailable {
            background: #e53e3e;
        }

        .week-event.personal {
            background: #9f7aea;
        }

        .current-time-line {
            position: absolute;
            left: 80px;
            right: 0;
            height: 2px;
            background: #e53e3e;
            z-index: 10;
            box-shadow: 0 0 4px rgba(229, 62, 62, 0.5);
        }

        .current-time-marker {
            position: absolute;
            left: -6px;
            top: -4px;
            width: 12px;
            height: 12px;
            background: #e53e3e;
            border-radius: 50%;
            border: 2px solid white;
        }

        .time-label {
            font-weight: 500;
            color: #2d3748;
            padding: 4px 0;
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

        .empty-slot {
            color: #a0aec0;
            font-style: italic;
            font-size: 0.75rem;
            text-align: center;
            padding: 20px 8px;
        }

        .today-marker {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: #3182ce;
        }

        .specialist-card:hover {
            border-color: #4299e1;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(66, 153, 225, 0.2);
        }

        .specialist-card.selected {
            border-color: #3182ce;
            background: #ebf8ff;
            box-shadow: 0 0 0 2px rgba(49, 130, 206, 0.2);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px 12px 0 0;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #e2e8f0;
            text-align: right;
        }

        .close {
            color: white;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
            margin-top: -5px;
        }

        .close:hover {
            opacity: 0.7;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #4a5568;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #4299e1;
            color: white;
        }

        .btn-primary:hover {
            background: #3182ce;
        }

        .btn-secondary {
            background: #a0aec0;
            color: white;
            margin-right: 10px;
        }

        .btn-secondary:hover {
            background: #718096;
        }

        .selected-specialist-info {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Calendrier Hebdomadaire</div>
        <div class="page-subtitle">
            Semaine du <c:out value="${weekStart}" /> au <c:out value="${weekStart.plusDays(6)}" />
        </div>

        <!-- Actions du calendrier -->
        <div class="calendar-actions">
            <div class="view-toggle">
                <button onclick="switchView('month')">
                    <i class="fas fa-calendar-alt"></i> Mois
                </button>
                <button class="active" onclick="switchView('week')">
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

        <!-- Section des Spécialistes Disponibles -->
        <div class="specialists-section" style="background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); margin-bottom: 20px; overflow: hidden;">
            <div class="specialists-header" style="background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%); color: white; padding: 20px;">
                <h3 style="margin: 0; font-size: 1.2rem; font-weight: 600;">
                    <i class="fas fa-user-md"></i> Spécialistes Disponibles
                </h3>
                <p style="margin: 5px 0 0 0; font-size: 0.9rem; opacity: 0.9;">
                    Sélectionnez un spécialiste pour envoyer une demande d'expertise
                </p>
            </div>
            <div class="specialists-grid" style="padding: 20px; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 15px;">
                <c:forEach var="user" items="${specialistUsers}">
                    <!-- Find corresponding profile if exists -->
                    <c:set var="userProfile" value="${null}" />
                    <c:forEach var="profile" items="${specialists}">
                        <c:if test="${profile.specialist.id == user.id}">
                            <c:set var="userProfile" value="${profile}" />
                        </c:if>
                    </c:forEach>
                    
                    <c:set var="specialityValue" value="${not empty userProfile ? userProfile.speciality : 'SPECIALISTE'}" />
                    <div class="specialist-card" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px; transition: all 0.2s; cursor: pointer;" 
                         onclick="selectSpecialist('${user.id}', '${user.fullName}', '${specialityValue}')">>>
                        <div class="specialist-info">
                            <div class="specialist-name" style="font-weight: 600; font-size: 1rem; color: #2d3748; margin-bottom: 5px;">
                                <i class="fas fa-user-md" style="color: #4299e1; margin-right: 8px;"></i>
                                <c:out value="${user.fullName}" />
                            </div>
                            <div class="specialist-role" style="color: #4a5568; font-size: 0.9rem; margin-bottom: 8px;">
                                <i class="fas fa-id-badge" style="color: #38a169; margin-right: 8px;"></i>
                                Rôle: SPECIALISTE
                            </div>
                            <c:choose>
                                <c:when test="${not empty userProfile}">
                                    <div class="specialist-speciality" style="color: #4a5568; font-size: 0.9rem; margin-bottom: 8px;">
                                        <i class="fas fa-stethoscope" style="color: #38a169; margin-right: 8px;"></i>
                                        <c:out value="${userProfile.speciality}" />
                                    </div>
                                    <div class="specialist-fee" style="color: #2b6cb0; font-size: 0.85rem; margin-bottom: 8px;">
                                        <i class="fas fa-euro-sign" style="margin-right: 8px;"></i>
                                        <c:out value="${userProfile.consultationFee}" /> € / consultation
                                    </div>
                                    <div class="specialist-duration" style="color: #4a5568; font-size: 0.85rem; margin-bottom: 10px;">
                                        <i class="fas fa-clock" style="margin-right: 8px;"></i>
                                        <c:out value="${userProfile.consultationDuration}" /> minutes
                                    </div>
                                    <c:if test="${not empty userProfile.description}">
                                        <div class="specialist-description" style="color: #718096; font-size: 0.8rem; margin-top: 8px; padding-top: 8px; border-top: 1px solid #e2e8f0;">
                                            <c:out value="${userProfile.description}" />
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <div class="specialist-basic-info" style="color: #718096; font-size: 0.85rem; margin-bottom: 8px;">
                                        <i class="fas fa-envelope" style="margin-right: 8px;"></i>
                                        <c:out value="${user.email}" />
                                    </div>
                                    <div class="specialist-username" style="color: #718096; font-size: 0.85rem; margin-bottom: 10px;">
                                        <i class="fas fa-user" style="margin-right: 8px;"></i>
                                        Username: <c:out value="${user.username}" />
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="specialist-status" style="margin-top: 10px;">
                                <c:choose>
                                    <c:when test="${not empty userProfile and userProfile.available}">
                                        <span style="display: inline-block; background: #38a169; color: white; font-size: 0.75rem; padding: 2px 8px; border-radius: 12px;">
                                            <i class="fas fa-check-circle"></i> Disponible
                                        </span>
                                    </c:when>
                                    <c:when test="${not empty userProfile and not userProfile.available}">
                                        <span style="display: inline-block; background: #e53e3e; color: white; font-size: 0.75rem; padding: 2px 8px; border-radius: 12px;">
                                            <i class="fas fa-times-circle"></i> Non disponible
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="display: inline-block; background: #4299e1; color: white; font-size: 0.75rem; padding: 2px 8px; border-radius: 12px;">
                                            <i class="fas fa-user-check"></i> Spécialiste Actif
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty specialistUsers}">
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #a0aec0;">
                        <i class="fas fa-user-md" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.3;"></i>
                        <p>Aucun utilisateur avec le rôle SPECIALISTE disponible pour le moment</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Calendrier hebdomadaire -->
        <div class="week-calendar">
            <div class="week-header">
                <div class="week-nav">
                    <button onclick="previousWeek()">
                        <i class="fas fa-chevron-left"></i> Semaine précédente
                    </button>
                    <h2 class="week-title">
                        Semaine du <c:out value="${weekStart}" /> - <c:out value="${weekStart.plusDays(6)}" />
                    </h2>
                    <button onclick="nextWeek()">
                        Semaine suivante <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>

            <div class="time-grid">
                <!-- En-tête avec heure vide -->
                <div class="time-slot"></div>
                
                <!-- En-têtes des jours -->
                <c:forEach var="day" items="${calendarData.days}">
                    <div class="day-header ${day.isToday ? 'today' : ''}">
                        <div style="font-weight: 700; font-size: 1rem;">
                            ${day.dayName}
                        </div>
                        <div style="font-size: 0.875rem; margin-top: 2px;">
                            <c:out value="${day.date}" />
                        </div>
                        ${day.isToday ? '<div class="today-marker"></div>' : ''}
                    </div>
                </c:forEach>

                <!-- Créneaux horaires -->
                <c:forEach var="hour" begin="8" end="18">
                    <!-- Label de l'heure -->
                    <div class="time-slot">
                        <div class="time-label">
                            <fmt:formatNumber value="${hour}" pattern="00"/>:00
                        </div>
                    </div>
                    
                    <!-- Colonnes pour chaque jour -->
                    <c:forEach var="day" items="${calendarData.days}">
                        <div class="day-column">
                            <div class="time-block">
                                <!-- Événements pour cette heure -->
                                <c:set var="hasEvents" value="false" />
                                <c:forEach var="event" items="${day.events}">
                                    <c:set var="eventHour" value="${event.startTime.hour}" />
                                    <c:if test="${eventHour == hour}">
                                        <div class="week-event ${event.eventType.name().toLowerCase()}" 
                                             onclick="showEventDetails('${event.id}')">
                                            <div style="font-weight: 600;">
                                                ${event.startTime.hour}:${event.startTime.minute < 10 ? '0' : ''}${event.startTime.minute}
                                            </div>
                                            <div>${event.title}</div>
                                        </div>
                                        <c:set var="hasEvents" value="true" />
                                    </c:if>
                                </c:forEach>
                                
                <!-- Afficher un slot vide si aucun événement -->
                                <c:if test="${not hasEvents}">
                                    <div class="empty-slot" onclick="createEvent('${day.date}', '${hour}')">
                                        <i class="fas fa-plus-circle"></i>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:forEach>
            </div>

            <!-- Ligne de temps actuelle (si aujourd'hui) -->
            <div id="currentTimeLine" class="current-time-line" style="display: none;">
                <div class="current-time-marker"></div>
            </div>
        </div>
    </div>

    <!-- Modal pour la demande d'expertise -->
    <div id="expertiseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="close" onclick="closeExpertiseModal()">&times;</span>
                <h3><i class="fas fa-clipboard-list"></i> Demande d'Expertise Médicale</h3>
            </div>
            <form id="expertiseForm" action="${pageContext.request.contextPath}/generaliste/expertise/create" method="post">
                <div class="modal-body">
                    <div class="selected-specialist-info" id="selectedSpecialistInfo" style="display: none;">
                        <h4><i class="fas fa-user-md"></i> Spécialiste Sélectionné</h4>
                        <div id="specialistDetails"></div>
                    </div>

                    <input type="hidden" name="consultationId" id="consultationId" value="">
                    <input type="hidden" name="specialistId" id="specialistId" value="">
                    <input type="hidden" name="speciality" id="speciality" value="">

                    <div class="form-group">
                        <label for="slotId">Créneaux Disponibles *</label>
                        <select name="slotId" id="slotId" required>
                            <option value="">Sélectionnez un créneau</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="question">Question pour le spécialiste *</label>
                        <textarea name="question" id="question" required placeholder="Décrivez votre question ou préoccupation médicale..."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="additionalData">Données supplémentaires</label>
                        <textarea name="additionalData" id="additionalData" placeholder="Informations complémentaires, résultats d'examens, etc."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="priority">Priorité *</label>
                        <select name="priority" id="priority" required>
                            <option value="NORMALE">Normale</option>
                            <option value="ELEVEE">Élevée</option>
                            <option value="URGENTE">Urgente</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeExpertiseModal()">Annuler</button>
                    <button type="submit" class="btn btn-primary">Envoyer la Demande</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        let currentWeekStart = new Date('${weekStart}');
        let selectedSpecialistId = null;

        // Récupérer l'ID de consultation depuis l'URL
        function getConsultationIdFromUrl() {
            const urlParams = new URLSearchParams(window.location.search);
            const consultationId = urlParams.get('consultationId');
            if (consultationId) {
                document.getElementById('consultationId').value = consultationId;
            }
            return consultationId;
        }

        function selectSpecialist(specialistId, specialistName, speciality) {
            // Réinitialiser les sélections précédentes
            document.querySelectorAll('.specialist-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Sélectionner le nouveau spécialiste
            event.currentTarget.classList.add('selected');
            selectedSpecialistId = specialistId;

            // Mettre à jour les informations dans le modal
            document.getElementById('specialistId').value = specialistId;
            document.getElementById('speciality').value = speciality;

            // Afficher les détails du spécialiste sélectionné
            const specialistDetails = `
                <p><strong>Nom:</strong> ${specialistName}</p>
                <p><strong>Spécialité:</strong> ${speciality}</p>
            `;
            document.getElementById('specialistDetails').innerHTML = specialistDetails;
            document.getElementById('selectedSpecialistInfo').style.display = 'block';

            // Charger les créneaux disponibles
            loadAvailableSlots(specialistId);

            // Ouvrir le modal
            document.getElementById('expertiseModal').style.display = 'block';
        }

        function loadAvailableSlots(specialistId) {
            fetch(`${pageContext.request.contextPath}/specialist/slots/available?specialistId=${specialistId}`)
                .then(response => response.json())
                .catch(error => {
                    console.error('Erreur lors du chargement des créneaux:', error);
                    // Simulation de créneaux pour le développement
                    return [
                        {id: 1, startTime: '2024-10-20T09:00:00', endTime: '2024-10-20T09:30:00'},
                        {id: 2, startTime: '2024-10-20T10:00:00', endTime: '2024-10-20T10:30:00'},
                        {id: 3, startTime: '2024-10-21T14:00:00', endTime: '2024-10-21T14:30:00'},
                        {id: 4, startTime: '2024-10-21T15:00:00', endTime: '2024-10-21T15:30:00'},
                        {id: 5, startTime: '2024-10-22T09:30:00', endTime: '2024-10-22T10:00:00'}
                    ];
                })
                .then(slots => {
                    const slotSelect = document.getElementById('slotId');
                    slotSelect.innerHTML = '<option value="">Sélectionnez un créneau</option>';

                    if (slots && slots.length > 0) {
                        slots.forEach(slot => {
                            const option = document.createElement('option');
                            option.value = slot.id;
                            
                            const startDate = new Date(slot.startTime);
                            const endDate = new Date(slot.endTime);
                            const dateStr = startDate.toLocaleDateString('fr-FR');
                            const timeStr = `${startDate.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})} - ${endDate.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})}`;
                            
                            option.textContent = `${dateStr} - ${timeStr}`;
                            slotSelect.appendChild(option);
                        });
                    } else {
                        const option = document.createElement('option');
                        option.value = '';
                        option.textContent = 'Aucun créneau disponible';
                        option.disabled = true;
                        slotSelect.appendChild(option);
                    }
                });
        }

        function closeExpertiseModal() {
            document.getElementById('expertiseModal').style.display = 'none';
            // Réinitialiser le formulaire
            document.getElementById('expertiseForm').reset();
            document.getElementById('selectedSpecialistInfo').style.display = 'none';
            
            // Désélectionner les cartes de spécialistes
            document.querySelectorAll('.specialist-card').forEach(card => {
                card.classList.remove('selected');
            });
            selectedSpecialistId = null;
        }

        // Fermer le modal en cliquant à l'extérieur
        window.onclick = function(event) {
            const modal = document.getElementById('expertiseModal');
            if (event.target === modal) {
                closeExpertiseModal();
            }
        }

        // Initialiser l'ID de consultation au chargement de la page
        document.addEventListener('DOMContentLoaded', function() {
            const consultationId = getConsultationIdFromUrl();
            if (!consultationId) {
                // Si aucun ID de consultation n'est fourni, utiliser la valeur par défaut de l'URL fournie
                document.getElementById('consultationId').value = '15';
            }
        });

        function switchView(view) {
            document.querySelectorAll('.view-toggle button').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');

            if (view === 'month') {
                window.location.href = '${pageContext.request.contextPath}/specialist/calendar/month';
            }
        }

        function previousWeek() {
            currentWeekStart.setDate(currentWeekStart.getDate() - 7);
            const weekStr = formatDate(currentWeekStart);
            window.location.href = '${pageContext.request.contextPath}/specialist/calendar/week?week=' + weekStr;
        }

        function nextWeek() {
            currentWeekStart.setDate(currentWeekStart.getDate() + 7);
            const weekStr = formatDate(currentWeekStart);
            window.location.href = '${pageContext.request.contextPath}/specialist/calendar/week?week=' + weekStr;
        }

        function formatDate(date) {
            return date.getFullYear() + '-' + 
                   String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                   String(date.getDate()).padStart(2, '0');
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

        function showEventDetails(eventId) {
            // Rediriger vers la page de détails ou ouvrir une modal
            window.location.href = '${pageContext.request.contextPath}/specialist/request/view?id=' + eventId;
        }

        function createEvent(date, hour) {
            // Ouvrir un formulaire pour créer un nouvel événement
            const startTime = date + 'T' + String(hour).padStart(2, '0') + ':00';
            const newEventUrl = '${pageContext.request.contextPath}/specialist/event/new?startTime=' + encodeURIComponent(startTime);
            window.location.href = newEventUrl;
        }

        // Afficher la ligne de temps actuelle si c'est aujourd'hui
        function showCurrentTimeLine() {
            const now = new Date();
            const weekStartStr = '${not empty weekStart ? weekStart : ""}';
            
            if (!weekStartStr) return;
            
            const weekStart = new Date(weekStartStr);
            const weekEnd = new Date(weekStart);
            weekEnd.setDate(weekEnd.getDate() + 6);
            
            // Vérifier si maintenant est dans la plage de la semaine
            const nowTime = now.getTime();
            const startTime = weekStart.getTime();
            const endTime = weekEnd.getTime();
            
            if (nowTime >= startTime && nowTime <= endTime) {
                const currentHour = now.getHours();
                const currentMinute = now.getMinutes();
                
                // Calculer la position de la ligne (seulement entre 8h et 18h)
                if (currentHour >= 8 && currentHour <= 18) {
                    const hourPosition = (currentHour - 8) * 61; // 60px + 1px border
                    const minuteOffset = (currentMinute / 60) * 60;
                    const totalOffset = hourPosition + minuteOffset + 80; // 80px pour la colonne des heures
                    
                    const timeLine = document.getElementById('currentTimeLine');
                    if (timeLine) {
                        timeLine.style.top = totalOffset + 'px';
                        timeLine.style.display = 'block';
                    }
                }
            }
        }

        // Mettre à jour la ligne de temps toutes les minutes
        showCurrentTimeLine();
        setInterval(showCurrentTimeLine, 60000);

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