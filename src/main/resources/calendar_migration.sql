-- Migration script for calendar functionality
-- Add this to your existing database

CREATE TABLE IF NOT EXISTS calendar_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    specialist_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    event_type ENUM('CONSULTATION', 'EXPERTISE_REQUEST', 'PERSONAL_APPOINTMENT', 'BREAK', 'UNAVAILABLE', 'MEETING', 'TRAINING') NOT NULL,
    slot_id BIGINT,
    expertise_request_id BIGINT,
    all_day BOOLEAN NOT NULL DEFAULT FALSE,
    is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
    recurrence_pattern ENUM('NONE', 'DAILY', 'WEEKLY', 'MONTHLY') DEFAULT 'NONE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (specialist_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (slot_id) REFERENCES slots(id) ON DELETE SET NULL,
    FOREIGN KEY (expertise_request_id) REFERENCES expertise_requests(id) ON DELETE SET NULL,
    
    INDEX idx_specialist_date (specialist_id, start_time),
    INDEX idx_event_type (event_type),
    INDEX idx_time_range (start_time, end_time)
);

-- Add some sample calendar events for testing
INSERT INTO calendar_events (specialist_id, title, description, start_time, end_time, event_type, all_day) VALUES
-- Assuming we have a specialist with ID 1
(1, 'Consultation - Maintenance', 'Consultations de routine', '2025-10-17 09:00:00', '2025-10-17 09:30:00', 'CONSULTATION', FALSE),
(1, 'Expertise Cardiaque', 'Expertise pour patient avec arythmie', '2025-10-17 14:00:00', '2025-10-17 14:30:00', 'EXPERTISE_REQUEST', FALSE),
(1, 'Pause déjeuner', 'Pause repas', '2025-10-17 12:00:00', '2025-10-17 13:00:00', 'BREAK', FALSE),
(1, 'Formation continue', 'Formation sur nouvelles techniques', '2025-10-18 16:00:00', '2025-10-18 18:00:00', 'TRAINING', FALSE),
(1, 'Indisponible - RDV personnel', 'Rendez-vous médical personnel', '2025-10-19 15:00:00', '2025-10-19 16:00:00', 'UNAVAILABLE', FALSE);

-- Update the persistence.xml mapping if needed
-- Add the CalendarEvent entity to your persistence configuration