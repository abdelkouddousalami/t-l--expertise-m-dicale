package com.example.medicale.entity;

import com.example.medicale.enums.ConsultationStatus;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "generaliste_id", nullable = false)
    private User generaliste;

    @Column(nullable = false)
    private LocalDateTime consultationDate;

    @Column(length = 1000)
    private String motif;

    @Column(length = 2000)
    private String observations;

    @Column(length = 2000)
    private String clinicalExam;

    @Column(length = 2000)
    private String symptoms;

    @Column(length = 1000)
    private String diagnosis;

    @Column(length = 2000)
    private String prescription;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ConsultationStatus status = ConsultationStatus.OPEN;

    @Column(nullable = false)
    private BigDecimal cost = new BigDecimal("150.00");


    @OneToOne(mappedBy = "consultation", cascade = CascadeType.ALL)
    private ExpertiseRequest expertiseRequest;


    @ManyToMany
    @JoinTable(
        name = "consultation_medical_acts",
        joinColumns = @JoinColumn(name = "consultation_id"),
        inverseJoinColumns = @JoinColumn(name = "medical_act_id")
    )
    private List<MedicalAct> medicalActs = new ArrayList<>();


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public User getGeneraliste() {
        return generaliste;
    }

    public void setGeneraliste(User generaliste) {
        this.generaliste = generaliste;
    }

    public LocalDateTime getConsultationDate() {
        return consultationDate;
    }

    public void setConsultationDate(LocalDateTime consultationDate) {
        this.consultationDate = consultationDate;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public String getClinicalExam() {
        return clinicalExam;
    }

    public void setClinicalExam(String clinicalExam) {
        this.clinicalExam = clinicalExam;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getPrescription() {
        return prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    public ConsultationStatus getStatus() {
        return status;
    }

    public void setStatus(ConsultationStatus status) {
        this.status = status;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    public ExpertiseRequest getExpertiseRequest() {
        return expertiseRequest;
    }

    public void setExpertiseRequest(ExpertiseRequest expertiseRequest) {
        this.expertiseRequest = expertiseRequest;
    }

    public List<MedicalAct> getMedicalActs() {
        return medicalActs;
    }

    public void setMedicalActs(List<MedicalAct> medicalActs) {
        this.medicalActs = medicalActs;
    }


    public BigDecimal getTotalCost() {
        BigDecimal total = this.cost;


        if (medicalActs != null) {
            for (MedicalAct act : medicalActs) {
                total = total.add(act.getCost());
            }
        }


        if (expertiseRequest != null && expertiseRequest.getSpecialist() != null) {
            SpecialistProfile profile = expertiseRequest.getSpecialist().getSpecialistProfile();
            if (profile != null) {
                total = total.add(profile.getConsultationFee());
            }
        }

        return total;
    }
}
