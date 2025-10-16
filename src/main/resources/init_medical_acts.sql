-- Script d'initialisation des actes médicaux
-- À exécuter après la création automatique des tables par Hibernate

USE medicale_db;

-- Insertion des actes médicaux avec leurs coûts

-- IMAGERIE
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Radiographie', 'Radiographie standard', 150.00, 'IMAGERIE'),
('Échographie', 'Échographie diagnostique', 300.00, 'IMAGERIE'),
('IRM', 'Imagerie par résonance magnétique', 1200.00, 'IMAGERIE'),
('Scanner', 'Tomodensitométrie', 800.00, 'IMAGERIE');

-- CARDIOLOGIE
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Électrocardiogramme', 'ECG - Enregistrement de l\'activité électrique du cœur', 100.00, 'CARDIOLOGIE'),
('Échographie cardiaque', 'Écho-doppler cardiaque', 500.00, 'CARDIOLOGIE'),
('Holter cardiaque', 'Enregistrement ECG sur 24h', 350.00, 'CARDIOLOGIE');

-- DERMATOLOGIE
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Laser dermatologique', 'Traitement au laser', 600.00, 'DERMATOLOGIE'),
('Cryothérapie', 'Traitement par le froid', 200.00, 'DERMATOLOGIE'),
('Biopsie cutanée', 'Prélèvement de peau pour analyse', 250.00, 'DERMATOLOGIE');

-- OPHTALMOLOGIE
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Fond d\'œil', 'Examen de la rétine', 150.00, 'OPHTALMOLOGIE'),
('Tonométrie', 'Mesure de la pression intraoculaire', 80.00, 'OPHTALMOLOGIE'),
('OCT', 'Tomographie par cohérence optique', 400.00, 'OPHTALMOLOGIE');

-- ANALYSES
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Analyse de sang complète', 'Bilan sanguin complet (NFS, VS, CRP)', 200.00, 'ANALYSE'),
('Analyse d\'urine', 'ECBU - Examen cytobactériologique des urines', 100.00, 'ANALYSE'),
('Bilan lipidique', 'Cholestérol et triglycérides', 120.00, 'ANALYSE'),
('Glycémie', 'Mesure du taux de sucre dans le sang', 50.00, 'ANALYSE'),
('Bilan hépatique', 'Transaminases et bilirubine', 150.00, 'ANALYSE'),
('Bilan rénal', 'Créatinine et urée', 130.00, 'ANALYSE');

-- PNEUMOLOGIE
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Spirométrie', 'Test de fonction respiratoire', 180.00, 'PNEUMOLOGIE'),
('Gazométrie', 'Mesure des gaz du sang artériel', 220.00, 'PNEUMOLOGIE');

-- AUTRES
INSERT INTO medical_acts (name, description, cost, category) VALUES
('Ponction', 'Ponction diagnostique', 300.00, 'AUTRE'),
('Endoscopie', 'Examen endoscopique', 700.00, 'AUTRE'),
('Électromyogramme', 'EMG - Étude de l\'activité musculaire', 400.00, 'NEUROLOGIE');

-- Afficher les actes insérés
SELECT * FROM medical_acts ORDER BY category, name;

