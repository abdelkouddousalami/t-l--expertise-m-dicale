<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendrier Simple - Test</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <div class="page-title">Calendrier de Test</div>
        <div class="page-subtitle">Version simplifiée pour tester la fonctionnalité</div>

        <!-- Actions du calendrier -->
        <div style="margin-bottom: 20px; display: flex; gap: 12px;">
            <button class="btn btn-primary" onclick="testSync()">
                <i class="fas fa-sync-alt"></i> Test Synchronisation
            </button>
            
            <button class="btn btn-secondary" onclick="testGenerate()">
                <i class="fas fa-plus"></i> Test Génération
            </button>
        </div>

        <!-- Calendrier simple avec données statiques -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); overflow: hidden;">
            <!-- En-tête -->
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; text-align: center;">
                <h2>Octobre 2025</h2>
                <div style="display: flex; justify-content: center; gap: 20px; margin-top: 10px;">
                    <span style="font-size: 0.875rem; opacity: 0.9;">
                        <i class="fas fa-circle" style="color: #48bb78; font-size: 0.5rem;"></i> Consultations
                    </span>
                    <span style="font-size: 0.875rem; opacity: 0.9;">
                        <i class="fas fa-circle" style="color: #ed8936; font-size: 0.5rem;"></i> Expertises
                    </span>
                </div>
            </div>

            <!-- Grille du calendrier -->
            <div style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 1px; background: #e2e8f0;">
                <!-- En-têtes des jours -->
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Lun</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Mar</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Mer</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Jeu</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Ven</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Sam</div>
                <div style="background: #f8fafc; padding: 12px 8px; text-align: center; font-weight: 600; color: #4a5568;">Dim</div>

                <!-- Jours du mois (statiques pour test) -->
                <div style="background: #f8fafc; min-height: 100px; padding: 8px; color: #a0aec0;">
                    <div style="font-weight: 600; font-size: 0.875rem;">30</div>
                </div>
                <!-- Jour 1 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(1)">
                    <div style="font-weight: 600; font-size: 0.875rem;">1</div>
                </div>
                <!-- Jour 2 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(2)">
                    <div style="font-weight: 600; font-size: 0.875rem;">2</div>
                    <div style="background: #48bb78; color: white; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; margin-bottom: 2px;">
                        09:00 Consultation
                    </div>
                </div>
                <!-- Jour 3 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(3)">
                    <div style="font-weight: 600; font-size: 0.875rem;">3</div>
                    <div style="background: #ed8936; color: white; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; margin-bottom: 2px;">
                        14:00 Expertise
                    </div>
                </div>
                <!-- Jour 4 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(4)">
                    <div style="font-weight: 600; font-size: 0.875rem;">4</div>
                </div>
                <!-- Jour 5 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(5)">
                    <div style="font-weight: 600; font-size: 0.875rem;">5</div>
                </div>
                <!-- Jour 6 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(6)">
                    <div style="font-weight: 600; font-size: 0.875rem;">6</div>
                </div>
                
                <!-- Semaine 2 -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(7)">
                    <div style="font-weight: 600; font-size: 0.875rem;">7</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(8)">
                    <div style="font-weight: 600; font-size: 0.875rem;">8</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(9)">
                    <div style="font-weight: 600; font-size: 0.875rem;">9</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(10)">
                    <div style="font-weight: 600; font-size: 0.875rem;">10</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(11)">
                    <div style="font-weight: 600; font-size: 0.875rem;">11</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(12)">
                    <div style="font-weight: 600; font-size: 0.875rem;">12</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(13)">
                    <div style="font-weight: 600; font-size: 0.875rem;">13</div>
                </div>

                <!-- Semaine 3 avec jour d'aujourd'hui -->
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(14)">
                    <div style="font-weight: 600; font-size: 0.875rem;">14</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(15)">
                    <div style="font-weight: 600; font-size: 0.875rem;">15</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(16)">
                    <div style="font-weight: 600; font-size: 0.875rem;">16</div>
                </div>
                <!-- Aujourd'hui (17) -->
                <div style="background: #ebf8ff; border: 2px solid #3182ce; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(17)">
                    <div style="font-weight: 600; font-size: 0.875rem; color: #3182ce;">17</div>
                    <div style="background: #48bb78; color: white; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; margin-bottom: 2px;">
                        09:30 Consultation
                    </div>
                    <div style="background: #ed8936; color: white; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; margin-bottom: 2px;">
                        15:00 Expertise
                    </div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(18)">
                    <div style="font-weight: 600; font-size: 0.875rem;">18</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(19)">
                    <div style="font-weight: 600; font-size: 0.875rem;">19</div>
                </div>
                <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay(20)">
                    <div style="font-weight: 600; font-size: 0.875rem;">20</div>
                </div>

                <!-- Continue avec le reste du mois... -->
                <!-- Pour simplifier, on ajoute juste quelques jours de plus -->
                <c:forEach var="day" begin="21" end="31">
                    <div style="background: white; min-height: 100px; padding: 8px; cursor: pointer;" onclick="showDay('${day}')">
                        <div style="font-weight: 600; font-size: 0.875rem;">${day}</div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Statistiques simples -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); padding: 20px; margin-top: 20px;">
            <h3>Statistiques</h3>
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px;">
                <div style="background: #f7fafc; padding: 16px; border-radius: 8px; text-align: center; border-left: 4px solid #48bb78;">
                    <div style="font-size: 1.5rem; font-weight: 700; color: #2d3748;">12</div>
                    <div style="font-size: 0.875rem; color: #718096;">Consultations</div>
                </div>
                <div style="background: #f7fafc; padding: 16px; border-radius: 8px; text-align: center; border-left: 4px solid #ed8936;">
                    <div style="font-size: 1.5rem; font-weight: 700; color: #2d3748;">5</div>
                    <div style="font-size: 0.875rem; color: #718096;">Expertises</div>
                </div>
                <div style="background: #f7fafc; padding: 16px; border-radius: 8px; text-align: center; border-left: 4px solid #3182ce;">
                    <div style="font-size: 1.5rem; font-weight: 700; color: #2d3748;">2</div>
                    <div style="font-size: 0.875rem; color: #718096;">Aujourd'hui</div>
                </div>
                <div style="background: #f7fafc; padding: 16px; border-radius: 8px; text-align: center; border-left: 4px solid #9f7aea;">
                    <div style="font-size: 1.5rem; font-weight: 700; color: #2d3748;">8</div>
                    <div style="font-size: 0.875rem; color: #718096;">À venir</div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        function testSync() {
            alert('Test de synchronisation - Fonctionnalité OK!');
        }

        function testGenerate() {
            alert('Test de génération de créneaux - Fonctionnalité OK!');
        }

        function showDay(dayNumber) {
            alert('Jour ' + dayNumber + ' sélectionné - Fonctionnalité de détail OK!');
        }

        console.log('Calendrier de test chargé avec succès!');
    </script>
</body>
</html>