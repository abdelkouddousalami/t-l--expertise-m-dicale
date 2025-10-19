package com.example.medicale.service;

import com.example.medicale.dao.CalendarEventDao;
import com.example.medicale.dao.SlotDao;
import com.example.medicale.entity.CalendarEvent;
import com.example.medicale.entity.CalendarEvent.EventType;
import com.example.medicale.entity.CalendarEvent.RecurrencePattern;
import com.example.medicale.entity.User;
import com.example.medicale.entity.Slot;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.*;
import java.util.stream.Collectors;

public class CalendarService {

    private CalendarEventDao calendarEventDao;
    private SlotDao slotDao;

    public CalendarService() {
        this.calendarEventDao = new CalendarEventDao();
        this.slotDao = new SlotDao();
    }

    // Créer un événement du calendrier
    public void createEvent(CalendarEvent event) {
        // Vérifier les conflits
        List<CalendarEvent> conflicts = calendarEventDao.findConflictingEvents(
            event.getSpecialist().getId(),
            event.getStartTime(),
            event.getEndTime(),
            null
        );

        if (!conflicts.isEmpty()) {
            throw new RuntimeException("Event conflicts with existing events");
        }

        calendarEventDao.save(event);
    }

    // Créer un événement récurrent
    public void createRecurringEvent(CalendarEvent baseEvent, int occurrences) {
        List<CalendarEvent> events = new ArrayList<>();
        
        for (int i = 0; i < occurrences; i++) {
            CalendarEvent event = new CalendarEvent();
            event.setSpecialist(baseEvent.getSpecialist());
            event.setTitle(baseEvent.getTitle());
            event.setDescription(baseEvent.getDescription());
            event.setEventType(baseEvent.getEventType());
            event.setAllDay(baseEvent.getAllDay());
            event.setIsRecurring(true);
            event.setRecurrencePattern(baseEvent.getRecurrencePattern());

            LocalDateTime startTime = calculateRecurringDateTime(
                baseEvent.getStartTime(),
                baseEvent.getRecurrencePattern(),
                i
            );
            LocalDateTime endTime = calculateRecurringDateTime(
                baseEvent.getEndTime(),
                baseEvent.getRecurrencePattern(),
                i
            );

            event.setStartTime(startTime);
            event.setEndTime(endTime);

            // Vérifier les conflits pour chaque occurrence
            List<CalendarEvent> conflicts = calendarEventDao.findConflictingEvents(
                event.getSpecialist().getId(),
                startTime,
                endTime,
                null
            );

            if (conflicts.isEmpty()) {
                events.add(event);
            }
        }

        if (!events.isEmpty()) {
            calendarEventDao.saveAll(events);
        }
    }

    // Calculer la date/heure récurrente
    private LocalDateTime calculateRecurringDateTime(LocalDateTime baseDateTime, RecurrencePattern pattern, int occurrence) {
        switch (pattern) {
            case DAILY:
                return baseDateTime.plusDays(occurrence);
            case WEEKLY:
                return baseDateTime.plusWeeks(occurrence);
            case MONTHLY:
                return baseDateTime.plusMonths(occurrence);
            default:
                return baseDateTime;
        }
    }

    // Synchroniser les créneaux avec le calendrier
    public void syncSlotsWithCalendar(Long specialistId) {
        List<Slot> slots = slotDao.findBySpecialistId(specialistId);
        
        for (Slot slot : slots) {
            // Vérifier si l'événement existe déjà
            List<CalendarEvent> existingEvents = calendarEventDao.findBySpecialistIdAndDateRange(
                specialistId,
                slot.getStartTime(),
                slot.getEndTime()
            );

            boolean eventExists = existingEvents.stream()
                .anyMatch(event -> event.getSlot() != null && event.getSlot().getId().equals(slot.getId()));

            if (!eventExists) {
                CalendarEvent event = new CalendarEvent();
                event.setSpecialist(slot.getSpecialist());
                event.setSlot(slot);
                event.setStartTime(slot.getStartTime());
                event.setEndTime(slot.getEndTime());
                
                if (slot.getAvailable()) {
                    event.setTitle("Créneau disponible");
                    event.setEventType(EventType.CONSULTATION);
                } else {
                    if (slot.getExpertiseRequest() != null) {
                        event.setTitle("Expertise - " + slot.getExpertiseRequest().getConsultation().getPatient().getFirstName() + " " + 
                                      slot.getExpertiseRequest().getConsultation().getPatient().getLastName());
                        event.setEventType(EventType.EXPERTISE_REQUEST);
                        event.setExpertiseRequest(slot.getExpertiseRequest());
                    } else {
                        event.setTitle("Créneau occupé");
                        event.setEventType(EventType.CONSULTATION);
                    }
                }

                calendarEventDao.save(event);
            }
        }
    }

    // Obtenir les événements d'un mois
    public List<CalendarEvent> getMonthEvents(Long specialistId, YearMonth yearMonth) {
        LocalDateTime startOfMonth = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = yearMonth.atEndOfMonth().atTime(23, 59, 59);
        
        return calendarEventDao.findBySpecialistIdAndDateRange(specialistId, startOfMonth, endOfMonth);
    }

    // Obtenir les événements d'une semaine
    public List<CalendarEvent> getWeekEvents(Long specialistId, LocalDate startOfWeek) {
        LocalDateTime weekStart = startOfWeek.atStartOfDay();
        LocalDateTime weekEnd = startOfWeek.plusDays(6).atTime(23, 59, 59);
        
        return calendarEventDao.findBySpecialistIdAndDateRange(specialistId, weekStart, weekEnd);
    }

    // Obtenir les événements d'un jour
    public List<CalendarEvent> getDayEvents(Long specialistId, LocalDate date) {
        return calendarEventDao.findBySpecialistIdAndDate(specialistId, date);
    }

    // Obtenir les événements à venir
    public List<CalendarEvent> getUpcomingEvents(Long specialistId, int limit) {
        return calendarEventDao.findUpcomingEventsBySpecialistId(specialistId, limit);
    }

    // Obtenir les événements d'aujourd'hui
    public List<CalendarEvent> getTodayEvents(Long specialistId) {
        return calendarEventDao.findTodayEventsBySpecialistId(specialistId);
    }

    // Générer la vue du calendrier mensuel
    public Map<String, Object> generateMonthlyCalendarView(Long specialistId, YearMonth yearMonth) {
        List<CalendarEvent> events = getMonthEvents(specialistId, yearMonth);
        
        Map<String, Object> calendarData = new HashMap<>();
        calendarData.put("yearMonth", yearMonth);
        calendarData.put("monthName", yearMonth.getMonth().name());
        calendarData.put("year", yearMonth.getYear());
        
        // Grouper les événements par jour
        Map<Integer, List<CalendarEvent>> eventsByDay = events.stream()
            .collect(Collectors.groupingBy(event -> event.getStartTime().getDayOfMonth()));
        
        calendarData.put("eventsByDay", eventsByDay);
        
        // Générer les jours du mois
        List<Map<String, Object>> days = new ArrayList<>();
        LocalDate firstDay = yearMonth.atDay(1);
        
        // Ajouter les jours du mois précédent pour compléter la première semaine
        LocalDate start = firstDay.minusDays(firstDay.getDayOfWeek().getValue() - 1);
        
        // Calculer le nombre total de jours à afficher (6 semaines = 42 jours)
        for (int i = 0; i < 42; i++) {
            LocalDate currentDay = start.plusDays(i);
            Map<String, Object> dayData = new HashMap<>();
            
            dayData.put("date", currentDay);
            dayData.put("dayOfMonth", currentDay.getDayOfMonth());
            dayData.put("isCurrentMonth", currentDay.getMonthValue() == yearMonth.getMonthValue());
            dayData.put("isToday", currentDay.equals(LocalDate.now()));
            dayData.put("events", eventsByDay.getOrDefault(currentDay.getDayOfMonth(), new ArrayList<>()));
            
            days.add(dayData);
        }
        
        calendarData.put("days", days);
        
        return calendarData;
    }

    // Générer la vue du calendrier hebdomadaire
    public Map<String, Object> generateWeeklyCalendarView(Long specialistId, LocalDate weekStart) {
        List<CalendarEvent> events = getWeekEvents(specialistId, weekStart);
        
        Map<String, Object> calendarData = new HashMap<>();
        calendarData.put("weekStart", weekStart);
        calendarData.put("weekEnd", weekStart.plusDays(6));
        
        // Générer les jours de la semaine
        List<Map<String, Object>> days = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate currentDay = weekStart.plusDays(i);
            Map<String, Object> dayData = new HashMap<>();
            
            dayData.put("date", currentDay);
            dayData.put("dayName", currentDay.getDayOfWeek().name());
            dayData.put("isToday", currentDay.equals(LocalDate.now()));
            
            // Filtrer les événements pour ce jour
            List<CalendarEvent> dayEvents = events.stream()
                .filter(event -> event.getStartTime().toLocalDate().equals(currentDay))
                .sorted(Comparator.comparing(CalendarEvent::getStartTime))
                .collect(Collectors.toList());
            
            dayData.put("events", dayEvents);
            days.add(dayData);
        }
        
        calendarData.put("days", days);
        calendarData.put("allEvents", events);
        
        return calendarData;
    }

    // Mettre à jour un événement
    public void updateEvent(CalendarEvent event) {
        // Vérifier les conflits (en excluant l'événement actuel)
        List<CalendarEvent> conflicts = calendarEventDao.findConflictingEvents(
            event.getSpecialist().getId(),
            event.getStartTime(),
            event.getEndTime(),
            event.getId()
        );

        if (!conflicts.isEmpty()) {
            throw new RuntimeException("Event conflicts with existing events");
        }

        calendarEventDao.update(event);
    }

    // Supprimer un événement
    public void deleteEvent(Long eventId) {
        calendarEventDao.delete(eventId);
    }

    // Obtenir les statistiques du calendrier
    public Map<String, Object> getCalendarStatistics(Long specialistId) {
        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = YearMonth.now().atEndOfMonth().atTime(23, 59, 59);
        
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalEvents", calendarEventDao.countEventsBySpecialistAndDateRange(
            specialistId, startOfMonth, endOfMonth));
        
        stats.put("consultations", calendarEventDao.countEventsBySpecialistAndEventType(
            specialistId, EventType.CONSULTATION));
        
        stats.put("expertiseRequests", calendarEventDao.countEventsBySpecialistAndEventType(
            specialistId, EventType.EXPERTISE_REQUEST));
        
        stats.put("todayEvents", getTodayEvents(specialistId).size());
        
        stats.put("upcomingEvents", getUpcomingEvents(specialistId, 10).size());
        
        return stats;
    }

    // Créer un bloc de temps libre/occupé
    public void createAvailabilityBlock(User specialist, LocalDate date, LocalTime startTime, 
                                      LocalTime endTime, boolean available, String reason) {
        CalendarEvent event = new CalendarEvent();
        event.setSpecialist(specialist);
        event.setStartTime(LocalDateTime.of(date, startTime));
        event.setEndTime(LocalDateTime.of(date, endTime));
        
        if (available) {
            event.setTitle("Disponible");
            event.setEventType(EventType.CONSULTATION);
        } else {
            event.setTitle(reason != null ? reason : "Non disponible");
            event.setEventType(EventType.UNAVAILABLE);
        }
        
        event.setDescription(reason);
        
        createEvent(event);
    }

    // Obtenir un événement par ID
    public Optional<CalendarEvent> getEventById(Long eventId) {
        return calendarEventDao.findById(eventId);
    }

    // Obtenir tous les événements d'un spécialiste
    public List<CalendarEvent> getAllEvents(Long specialistId) {
        return calendarEventDao.findBySpecialistId(specialistId);
    }
}