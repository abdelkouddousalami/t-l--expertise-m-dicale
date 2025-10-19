<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demande d'Expertise - Système Médical</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .expertise-form {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 20px;
        }

        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #f8fafc;
        }

        .form-section h3 {
            color: #2d3748;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .specialist-card {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }

        .specialist-card:hover {
            border-color: #4299e1;
            background: #ebf8ff;
        }

        .specialist-card.selected {
            border-color: #3182ce;
            background: #ebf8ff;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }

        .specialist-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .specialist-details h4 {
            margin: 0 0 5px 0;
            color: #2d3748;
        }

        .specialist-details p {
            margin: 0;
            color: #718096;
            font-size: 0.875rem;
        }

        .specialist-availability {
            text-align: right;
        }

        .availability-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .available {
            background: #c6f6d5;
            color: #22543d;
        }

        .busy {
            background: #fed7d7;
            color: #742a2a;
        }

        .slots-container {
            margin-top: 15px;
            padding: 15px;
            background: #f7fafc;
            border-radius: 6px;
            display: none;
        }

        .slot-item {
            display: inline-block;
            margin: 5px;
            padding: 8px 12px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .slot-item:hover {
            border-color: #4299e1;
            background: #ebf8ff;
        }

        .slot-item.selected {
            background: #3182ce;
            color: white;
            border-color: #3182ce;
        }

        .priority-selector {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .priority-option {
            flex: 1;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .priority-option:hover {
            border-color: #4299e1;
        }

        .priority-option.selected {
            border-color: #3182ce;
            background: #ebf8ff;
        }

        .priority-urgent {
            border-color: #e53e3e !important;
            background: #fed7d7 !important;
            color: #742a2a !important;
        }

        .priority-low {
            border-color: #718096 !important;
            background: #edf2f7 !important;
            color: #4a5568 !important;
        }

        .priority-normal {
            border-color: #48bb78 !important;
            background: #c6f6d5 !important;
            color: #22543d !important;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .consultation-summary {
            background: #edf2f7;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .consultation-summary h3 {
            margin-top: 0;
            color: #2d3748;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 15px;
        }

        .summary-item {
            background: white;
            padding: 12px;
            border-radius: 6px;
            border-left: 4px solid #4299e1;
        }

        .summary-label {
            font-weight: 600;
            color: #4a5568;
            font-size: 0.875rem;
        }

        .summary-value {
            color: #2d3748;
            margin-top: 5px;
        }

        .loading-state {
            text-align: center;
            padding: 20px;
            color: #718096;
        }

        .error-message {
            background: #fed7d7;
            color: #742a2a;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            border-left: 4px solid #e53e3e;
        }

        .success-message {
            background: #c6f6d5;
            color: #22543d;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            border-left: 4px solid #48bb78;
        }

        .filter-btn {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 8px 12px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-btn:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }

        .filter-btn.active {
            background: #3182ce;
            color: white;
            border-color: #3182ce;
        }

        .specialist-card {
            transition: all 0.3s;
        }

        .specialist-card.hidden {
            display: none;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Demande d'Expertise Médicale</div>
        <div class="page-subtitle">Demander l'avis d'un spécialiste pour une consultation</div>

        <!-- Messages d'erreur/succès -->
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

        <!-- Résumé de la consultation -->
        <div class="consultation-summary">
            <h3><i class="fas fa-file-medical"></i> Résumé de la Consultation</h3>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">ID Consultation</div>
                    <div class="summary-value">#${consultationId}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Spécialité Suggérée</div>
                    <div class="summary-value">${not empty speciality ? speciality : 'Aucune spécialité spécifique'}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Spécialistes Disponibles</div>
                    <div class="summary-value">
                        ${fn:length(specialistUsers)} utilisateurs avec rôle SPECIALISTE
                        <c:if test="${fn:length(specialists) > 0}">
                            (${fn:length(specialists)} avec profils)
                        </c:if>
                    </div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Type de Demande</div>
                    <div class="summary-value">Expertise Médicale</div>
                </div>
            </div>
        </div>

        <!-- Formulaire de demande d'expertise -->
        <form id="expertiseForm" action="${pageContext.request.contextPath}/generaliste/expertise/create" method="post" class="expertise-form">
            <input type="hidden" name="consultationId" value="${consultationId}">
            <input type="hidden" name="speciality" value="${speciality}">
            <input type="hidden" name="specialistId" id="selectedSpecialistId">
            <input type="hidden" name="slotId" id="selectedSlotId">

            <!-- Section 1: Sélection du spécialiste -->
            <div class="form-section">
                <h3><i class="fas fa-user-md"></i> Sélection du Spécialiste</h3>
                
                <!-- Filtres par spécialité -->
                <div style="margin-bottom: 20px;">
                    <label for="specialityFilter">Filtrer par type :</label>
                    <div style="display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap;">
                        <button type="button" class="filter-btn active" onclick="filterSpecialists('ALL')" id="filter_ALL">
                            <i class="fas fa-users"></i> Tous les Spécialistes (${fn:length(specialistUsers)})
                        </button>
                        <button type="button" class="filter-btn" onclick="filterSpecialists('WITH_PROFILE')" id="filter_WITH_PROFILE">
                            <i class="fas fa-user-md"></i> Avec Profil Complet (${fn:length(specialists)})
                        </button>
                        <c:if test="${fn:length(specialists) > 0}">
                            <button type="button" class="filter-btn" onclick="filterSpecialists('CARDIOLOGIE')" id="filter_CARDIOLOGIE">
                                <i class="fas fa-heartbeat"></i> Cardiologie
                            </button>
                            <button type="button" class="filter-btn" onclick="filterSpecialists('PNEUMOLOGIE')" id="filter_PNEUMOLOGIE">
                                <i class="fas fa-lungs"></i> Pneumologie
                            </button>
                            <button type="button" class="filter-btn" onclick="filterSpecialists('NEUROLOGIE')" id="filter_NEUROLOGIE">
                                <i class="fas fa-brain"></i> Neurologie
                            </button>
                            <button type="button" class="filter-btn" onclick="filterSpecialists('DERMATOLOGIE')" id="filter_DERMATOLOGIE">
                                <i class="fas fa-hand-paper"></i> Dermatologie
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty specialistUsers}">
                        <div id="specialistsList">
                            <!-- Users with SPECIALISTE role -->
                            <c:forEach var="user" items="${specialistUsers}">
                                <!-- Find corresponding profile if exists -->
                                <c:set var="userProfile" value="${null}" />
                                <c:forEach var="profile" items="${specialists}">
                                    <c:if test="${profile.specialist.id == user.id}">
                                        <c:set var="userProfile" value="${profile}" />
                                    </c:if>
                                </c:forEach>
                                
                                <div class="specialist-card" 
                                     data-specialist-id="${user.id}" 
                                     data-speciality="${not empty userProfile ? userProfile.speciality : 'GENERAL'}"
                                     data-has-profile="${not empty userProfile ? 'true' : 'false'}"
                                     onclick="selectSpecialist(this, '${user.id}')">
                                    <div class="specialist-info">
                                        <div class="specialist-details">
                                            <h4>
                                                Dr. ${user.fullName}
                                                <c:choose>
                                                    <c:when test="${not empty userProfile}">
                                                        <span style="background: #4299e1; color: white; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; margin-left: 8px;">
                                                            ${userProfile.speciality}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: #718096; color: white; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; margin-left: 8px;">
                                                            SPÉCIALISTE
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </h4>
                                            <p>
                                                <i class="fas fa-user"></i> Utilisateur: ${user.username}
                                                | <i class="fas fa-envelope"></i> ${user.email}
                                            </p>
                                            <c:choose>
                                                <c:when test="${not empty userProfile}">
                                                    <p><i class="fas fa-euro-sign"></i> Consultation: ${userProfile.consultationFee} € 
                                                       | <i class="fas fa-clock"></i> ${userProfile.consultationDuration} min</p>
                                                    <c:if test="${not empty userProfile.description}">
                                                        <p><i class="fas fa-info-circle"></i> ${userProfile.description}</p>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <p><i class="fas fa-info-circle"></i> Profil spécialisé non configuré</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="specialist-availability">
                                            <c:choose>
                                                <c:when test="${not empty userProfile}">
                                                    <div class="availability-badge ${userProfile.available ? 'available' : 'busy'}">
                                                        <i class="fas fa-calendar-${userProfile.available ? 'check' : 'times'}"></i> 
                                                        ${userProfile.available ? 'Disponible' : 'Occupé'}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="availability-badge available">
                                                        <i class="fas fa-user-check"></i> 
                                                        Spécialiste Actif
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <p style="margin-top: 5px; font-size: 0.75rem;">
                                                <i class="fas fa-id-badge"></i> ID: ${user.id}
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- Créneaux horaires (cachés par défaut) -->
                                    <div class="slots-container" id="slots_${user.id}">
                                        <h5><i class="fas fa-calendar-alt"></i> Créneaux disponibles :</h5>
                                        <div class="loading-state">
                                            <i class="fas fa-spinner fa-spin"></i> Chargement des créneaux...
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="error-message">
                            <i class="fas fa-exclamation-triangle"></i> 
                            Aucun utilisateur avec le rôle SPECIALISTE n'est disponible dans le système.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Section 2: Question et contexte médical -->
            <div class="form-section">
                <h3><i class="fas fa-question-circle"></i> Question Médicale</h3>
                
                <div class="form-group">
                    <label for="question">Question pour le spécialiste *</label>
                    <textarea id="question" name="question" required 
                              placeholder="Décrivez précisément la question que vous souhaitez poser au spécialiste..." 
                              rows="4"></textarea>
                </div>

                <div class="form-group">
                    <label for="additionalData">Données supplémentaires</label>
                    <textarea id="additionalData" name="additionalData" 
                              placeholder="Examens complémentaires, résultats d'analyses, historique médical pertinent..." 
                              rows="4"></textarea>
                </div>
            </div>

            <!-- Section 3: Priorité -->
            <div class="form-section">
                <h3><i class="fas fa-exclamation"></i> Niveau de Priorité</h3>
                
                <div class="priority-selector">
                    <div class="priority-option" data-priority="NORMALE" onclick="selectPriority(this, 'NORMALE')">
                        <div style="font-weight: 600; color: #48bb78;"><i class="fas fa-clock"></i> NORMALE</div>
                        <small>Réponse dans les 48h</small>
                    </div>
                    <div class="priority-option" data-priority="NON_URGENTE" onclick="selectPriority(this, 'NON_URGENTE')">
                        <div style="font-weight: 600; color: #718096;"><i class="fas fa-calendar"></i> NON URGENTE</div>
                        <small>Réponse dans la semaine</small>
                    </div>
                    <div class="priority-option" data-priority="URGENTE" onclick="selectPriority(this, 'URGENTE')">
                        <div style="font-weight: 600; color: #e53e3e;"><i class="fas fa-exclamation-triangle"></i> URGENTE</div>
                        <small>Réponse immédiate</small>
                    </div>
                </div>
                <input type="hidden" name="priority" id="selectedPriority" value="NORMALE">
            </div>

            <!-- Actions -->
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="goBack()">
                    <i class="fas fa-arrow-left"></i> Retour
                </button>
                <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                    <i class="fas fa-paper-plane"></i> Envoyer la Demande
                </button>
            </div>
        </form>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        let selectedSpecialistId = null;
        let selectedSlotId = null;
        let selectedPriority = 'NORMALE';

        function filterSpecialists(filter) {
            // Remove active class from all filter buttons
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Add active class to clicked button
            document.getElementById('filter_' + filter).classList.add('active');
            
            // Show/hide specialist cards based on filter
            const cards = document.querySelectorAll('.specialist-card');
            cards.forEach(card => {
                const cardSpeciality = card.getAttribute('data-speciality');
                const hasProfile = card.getAttribute('data-has-profile') === 'true';
                
                let shouldShow = false;
                
                if (filter === 'ALL') {
                    shouldShow = true;
                } else if (filter === 'WITH_PROFILE') {
                    shouldShow = hasProfile;
                } else {
                    // Filter by specific specialty
                    shouldShow = cardSpeciality === filter;
                }
                
                if (shouldShow) {
                    card.classList.remove('hidden');
                } else {
                    card.classList.add('hidden');
                }
            });
            
            // Reset selection if current selected specialist is hidden
            const selectedCard = document.querySelector('.specialist-card.selected');
            if (selectedCard && selectedCard.classList.contains('hidden')) {
                selectedCard.classList.remove('selected');
                selectedCard.querySelector('.slots-container').style.display = 'none';
                selectedSpecialistId = null;
                selectedSlotId = null;
                document.getElementById('selectedSpecialistId').value = '';
                document.getElementById('selectedSlotId').value = '';
                updateSubmitButton();
            }
        }

        function selectSpecialist(element, specialistId) {
            // Déselectionner les autres spécialistes
            document.querySelectorAll('.specialist-card').forEach(card => {
                card.classList.remove('selected');
                card.querySelector('.slots-container').style.display = 'none';
            });

            // Sélectionner le spécialiste cliqué
            element.classList.add('selected');
            selectedSpecialistId = parseInt(specialistId);
            document.getElementById('selectedSpecialistId').value = specialistId;

            // Afficher et charger les créneaux
            const slotsContainer = document.getElementById('slots_' + specialistId);
            slotsContainer.style.display = 'block';
            loadSlots(specialistId);

            // Réinitialiser la sélection de créneau
            selectedSlotId = null;
            document.getElementById('selectedSlotId').value = '';
            updateSubmitButton();
        }

        function loadSlots(specialistId) {
            const slotsContainer = document.getElementById('slots_' + specialistId);
            
            // Simuler le chargement des créneaux
            setTimeout(() => {
                // Pour cette démonstration, on génère des créneaux fictifs
                const mockSlots = [
                    { id: 1, date: 'Aujourd\'hui', time: '09:00 - 09:30' },
                    { id: 2, date: 'Aujourd\'hui', time: '14:00 - 14:30' },
                    { id: 3, date: 'Demain', time: '10:00 - 10:30' },
                    { id: 4, date: 'Demain', time: '15:30 - 16:00' }
                ];

                let slotsHtml = '<h5><i class="fas fa-calendar-alt"></i> Créneaux disponibles :</h5>';
                mockSlots.forEach(slot => {
                    slotsHtml += '<div class="slot-item" data-slot-id="' + slot.id + '" onclick="selectSlot(this, \'' + slot.id + '\')">';
                    slotsHtml += '<i class="fas fa-calendar"></i> ' + slot.date + ' - ' + slot.time;
                    slotsHtml += '</div>';
                });

                slotsContainer.innerHTML = slotsHtml;
            }, 1000);
        }

        function selectSlot(element, slotId) {
            // Déselectionner les autres créneaux
            document.querySelectorAll('.slot-item').forEach(slot => {
                slot.classList.remove('selected');
            });

            // Sélectionner le créneau cliqué
            element.classList.add('selected');
            selectedSlotId = parseInt(slotId);
            document.getElementById('selectedSlotId').value = slotId;
            updateSubmitButton();
        }

        function selectPriority(element, priority) {
            // Déselectionner les autres options
            document.querySelectorAll('.priority-option').forEach(option => {
                option.classList.remove('selected');
                option.classList.remove('priority-urgent', 'priority-high', 'priority-normal');
            });

            // Sélectionner l'option cliquée
            element.classList.add('selected');
            
            // Ajouter la classe de couleur appropriée
            if (priority === 'URGENTE') {
                element.classList.add('priority-urgent');
            } else if (priority === 'NON_URGENTE') {
                element.classList.add('priority-low');
            } else {
                element.classList.add('priority-normal');
            }

            selectedPriority = priority;
            document.getElementById('selectedPriority').value = priority;
        }

        function updateSubmitButton() {
            const submitBtn = document.getElementById('submitBtn');
            const questionField = document.getElementById('question');
            
            if (selectedSpecialistId && selectedSlotId && questionField.value.trim()) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        function goBack() {
            window.history.back();
        }

        // Validation en temps réel
        document.getElementById('question').addEventListener('input', updateSubmitButton);

        // Initialiser la priorité normale par défaut
        document.addEventListener('DOMContentLoaded', function() {
            const normalPriority = document.querySelector('[data-priority="NORMALE"]');
            if (normalPriority) {
                selectPriority(normalPriority, 'NORMALE');
            }
        });

        // Validation du formulaire
        document.getElementById('expertiseForm').addEventListener('submit', function(e) {
            if (!selectedSpecialistId || !selectedSlotId) {
                e.preventDefault();
                alert('Veuillez sélectionner un spécialiste et un créneau horaire.');
                return false;
            }

            const question = document.getElementById('question').value.trim();
            if (!question) {
                e.preventDefault();
                alert('Veuillez saisir votre question pour le spécialiste.');
                return false;
            }

            // Confirmation avant envoi
            if (!confirm('Êtes-vous sûr de vouloir envoyer cette demande d\'expertise ?')) {
                e.preventDefault();
                return false;
            }

            return true;
        });
    </script>
</body>
</html>
