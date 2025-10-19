<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Demande d'Expertise - Système Médical</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Test - Demande d'Expertise</div>
        <div class="page-subtitle">Page de test pour vérifier la fonctionnalité d'expertise</div>

        <!-- Simulation d'une consultation -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); padding: 30px; margin-bottom: 20px;">
            <h3>Consultation de Test</h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin: 20px 0;">
                <div>
                    <strong>Patient :</strong> Jean Dupont<br>
                    <strong>Date :</strong> 17 octobre 2025<br>
                    <strong>Motif :</strong> Douleurs thoraciques
                </div>
                <div>
                    <strong>Médecin :</strong> Dr. Martin Durand<br>
                    <strong>Statut :</strong> <span style="background: #ffc107; color: #000; padding: 2px 8px; border-radius: 4px;">En cours</span>
                </div>
            </div>

            <h4>Demander une expertise (tous les spécialistes disponibles) :</h4>
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-top: 15px;">
                
                <!-- Cardiologie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('CARDIOLOGIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-heartbeat" style="font-size: 2rem; color: #e53e3e; margin-bottom: 10px;"></i>
                    <h5>Cardiologie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies cardiaques et cardiovasculaires</p>
                </div>

                <!-- Pneumologie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('PNEUMOLOGIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-lungs" style="font-size: 2rem; color: #3182ce; margin-bottom: 10px;"></i>
                    <h5>Pneumologie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies respiratoires et pulmonaires</p>
                </div>

                <!-- Gastroentérologie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('GASTROENTEROLOGIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-stomach" style="font-size: 2rem; color: #ed8936; margin-bottom: 10px;"></i>
                    <h5>Gastroentérologie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies digestives et hépatiques</p>
                </div>

                <!-- Neurologie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('NEUROLOGIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-brain" style="font-size: 2rem; color: #9f7aea; margin-bottom: 10px;"></i>
                    <h5>Neurologie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies neurologiques et nerveuses</p>
                </div>

                <!-- Dermatologie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('DERMATOLOGIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-hand-paper" style="font-size: 2rem; color: #48bb78; margin-bottom: 10px;"></i>
                    <h5>Dermatologie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies cutanées et dermatologiques</p>
                </div>

                <!-- Orthopédie -->
                <div style="border: 2px solid #e2e8f0; border-radius: 8px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s;" 
                     onclick="requestExpertise('ORTHOPEDIE')" 
                     onmouseover="this.style.borderColor='#4299e1'; this.style.background='#ebf8ff';" 
                     onmouseout="this.style.borderColor='#e2e8f0'; this.style.background='white';">
                    <i class="fas fa-bone" style="font-size: 2rem; color: #a0aec0; margin-bottom: 10px;"></i>
                    <h5>Orthopédie</h5>
                    <p style="font-size: 0.875rem; color: #718096; margin: 0;">Pathologies osseuses et articulaires</p>
                </div>
            </div>
        </div>

        <!-- Informations supplémentaires -->
        <div style="background: #f7fafc; border-radius: 8px; padding: 20px;">
            <h4><i class="fas fa-info-circle"></i> Comment ça marche ?</h4>
            
            <div style="background: #e6fffa; border: 1px solid #38b2ac; border-radius: 6px; padding: 15px; margin: 15px 0;">
                <h6 style="color: #2c7a7b; margin-bottom: 8px;"><i class="fas fa-star"></i> Nouveauté !</h6>
                <p style="color: #2c7a7b; margin: 0; font-size: 0.875rem;">
                    Désormais, vous pouvez voir <strong>tous les spécialistes</strong> disponibles, pas seulement ceux d'une spécialité spécifique.
                    Vous pouvez filtrer par spécialité une fois sur la page de demande d'expertise.
                </p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 15px;">
                <div style="text-align: center;">
                    <div style="background: #4299e1; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px;">1</div>
                    <h6>Cliquer sur une spécialité</h6>
                    <p style="font-size: 0.875rem; color: #718096;">Cliquez sur une spécialité pour commencer (celle-ci sera suggérée mais vous pourrez voir tous les spécialistes)</p>
                </div>
                <div style="text-align: center;">
                    <div style="background: #4299e1; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px;">2</div>
                    <h6>Voir tous les spécialistes</h6>
                    <p style="font-size: 0.875rem; color: #718096;">Parcourez tous les spécialistes disponibles ou utilisez les filtres par spécialité</p>
                </div>
                <div style="text-align: center;">
                    <div style="background: #4299e1; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px;">3</div>
                    <h6>Choisir et envoyer</h6>
                    <p style="font-size: 0.875rem; color: #718096;">Sélectionnez un spécialiste, un créneau, et envoyez votre demande d'expertise</p>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        function requestExpertise(speciality) {
            // Simuler un ID de consultation pour le test
            const consultationId = 123;
            
            // Rediriger vers le formulaire de demande d'expertise
            const url = '${pageContext.request.contextPath}/generaliste/expertise/request?consultationId=' + consultationId + '&speciality=' + speciality;
            
            // Confirmation avant redirection
            if (confirm('Vous allez voir tous les spécialistes disponibles. Spécialité suggérée: ' + speciality)) {
                window.location.href = url;
            }
        }
    </script>
</body>
</html>