<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Today's Patients - Nurse</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container">
        <h1>Today's Patients</h1>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/nurse/register" class="btn btn-primary">Register New Patient</a>
        </div>

        <table class="patients-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>SSN</th>
                    <th>Arrival Time</th>
                    <th>Last Vital Signs</th>
                    <th>Phone</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${patients}" var="patient">
                    <tr>
                        <td>${patient.firstName} ${patient.lastName}</td>
                        <td>${patient.ssn}</td>
                        <td>
                            <c:if test="${not empty patient.arrivalTime}">
                                ${patient.arrivalTime.hour}:${patient.arrivalTime.minute < 10 ? '0' : ''}${patient.arrivalTime.minute}
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty patient.vitalSignsList and patient.vitalSignsList.size() > 0}">
                                    <c:set var="latestVitals" value="${patient.vitalSignsList[0]}" />
                                    <div class="vital-signs">
                                        <span>BP: ${latestVitals.bloodPressure}</span><br/>
                                        <span>HR: ${latestVitals.heartRate} bpm</span><br/>
                                        <span>Temp: ${latestVitals.temperature}°C</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-vitals">No vital signs recorded</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${patient.phone}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty patients}">
                    <tr>
                        <td colspan="5" class="no-data">No patients registered today</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
