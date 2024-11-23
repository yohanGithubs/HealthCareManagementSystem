-- Create Database
CREATE DATABASE IF NOT EXISTS HealthcareDB;

USE HealthcareDB;

-- Patients Table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255),
    InsuranceProvider VARCHAR(50),
    InsuranceNumber VARCHAR(50),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    LicenseNumber VARCHAR(50) UNIQUE,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    ReasonForVisit VARCHAR(255),
    Notes TEXT,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Medical Records Table
CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    DiagnosisDate DATE,
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    Notes TEXT,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Prescriptions Table
CREATE TABLE Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    MedicationName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50),
    Frequency VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    Instructions TEXT,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create Indexes for better performance
CREATE INDEX IX_Appointments_PatientID ON Appointments(PatientID);
CREATE INDEX IX_Appointments_DoctorID ON Appointments(DoctorID);
CREATE INDEX IX_MedicalRecords_PatientID ON MedicalRecords(PatientID);
CREATE INDEX IX_Prescriptions_PatientID ON Prescriptions(PatientID);

-- Create Stored Procedures

DELIMITER //

-- Add New Patient
CREATE PROCEDURE sp_AddNewPatient(
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_DateOfBirth DATE,
    IN p_Gender VARCHAR(10),
    IN p_PhoneNumber VARCHAR(15),
    IN p_Email VARCHAR(100),
    IN p_Address VARCHAR(255),
    IN p_InsuranceProvider VARCHAR(50),
    IN p_InsuranceNumber VARCHAR(50)
)
BEGIN
    INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber, Email, Address, InsuranceProvider, InsuranceNumber)
    VALUES (p_FirstName, p_LastName, p_DateOfBirth, p_Gender, p_PhoneNumber, p_Email, p_Address, p_InsuranceProvider, p_InsuranceNumber);
    SELECT LAST_INSERT_ID() AS PatientID;
END //

-- Schedule Appointment
CREATE PROCEDURE sp_ScheduleAppointment(
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_AppointmentDate DATE,
    IN p_AppointmentTime TIME,
    IN p_ReasonForVisit VARCHAR(255)
)
BEGIN
    INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, ReasonForVisit)
    VALUES (p_PatientID, p_DoctorID, p_AppointmentDate, p_AppointmentTime, p_ReasonForVisit);
    SELECT LAST_INSERT_ID() AS AppointmentID;
END //

-- Get Patient Appointments
CREATE PROCEDURE sp_GetPatientAppointments(
    IN p_PatientID INT
)
BEGIN
    SELECT 
        a.AppointmentID,
        a.AppointmentDate,
        a.AppointmentTime,
        a.Status,
        a.ReasonForVisit,
        CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
        d.Specialty
    FROM Appointments a
    JOIN Doctors d ON a.DoctorID = d.DoctorID
    WHERE a.PatientID = p_PatientID
    ORDER BY a.AppointmentDate DESC;
END //

-- Get Doctor's Schedule
CREATE PROCEDURE sp_GetDoctorSchedule(
    IN p_DoctorID INT,
    IN p_Date DATE
)
BEGIN
    SELECT 
        a.AppointmentID,
        a.AppointmentTime,
        CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
        a.ReasonForVisit,
        a.Status
    FROM Appointments a
    JOIN Patients p ON a.PatientID = p.PatientID
    WHERE a.DoctorID = p_DoctorID 
    AND a.AppointmentDate = p_Date
    ORDER BY a.AppointmentTime;
END //

DELIMITER ;

SHOW DATABASES;
USE HealthcareDB;
SHOW TABLES;

SHOW PROCEDURE STATUS WHERE Db = 'HealthcareDB';

INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber, Email, Address, InsuranceProvider, InsuranceNumber)
VALUES
('John', 'Doe', '1980-05-20', 'Male', '1234567890', 'john.doe@example.com', '123 Elm St', 'HealthCare Inc.', 'HC12345'),
('Jane', 'Smith', '1990-08-15', 'Female', '9876543210', 'jane.smith@example.com', '456 Oak St', 'Better Health', 'BH67890');

INSERT INTO Doctors (FirstName, LastName, Specialty, PhoneNumber, Email, LicenseNumber)
VALUES
('Alice', 'Brown', 'Cardiology', '5551112222', 'alice.brown@hospital.com', 'LIC123'),
('Bob', 'Johnson', 'Dermatology', '5553334444', 'bob.johnson@hospital.com', 'LIC456');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, ReasonForVisit, Notes)
VALUES
(1, 1, '2024-11-20', '10:00:00', 'Scheduled', 'Routine Checkup', 'Bring medical history'),
(2, 2, '2024-11-21', '14:30:00', 'Scheduled', 'Skin rash', 'Use prescribed ointment');

CALL sp_AddNewPatient('Mark', 'Taylor', '1975-07-12', 'Male', '4445556666', 'mark.taylor@example.com', '789 Pine St', 'Wellness Co.', 'WC09876');

CALL sp_ScheduleAppointment(3, 2, '2024-11-22', '09:00:00', 'Allergy Test');

CALL sp_GetDoctorSchedule(2, '2024-11-21');





