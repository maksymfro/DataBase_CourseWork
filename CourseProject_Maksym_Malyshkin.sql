CREATE DATABASE HospitalDB;
USE HospitalDB;

-- 1. Patients table 
CREATE TABLE Patients (
PatientID INT AUTO_INCREMENT PRIMARY KEY,
First_name VARCHAR(50) NOT NULL,
Last_name VARCHAR(50) NOT NULL,
DOB DATE NOT NULL,
Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
Phone VARCHAR(15),
Email VARCHAR(100)
);

-- 2. Doctors table
CREATE TABLE Doctors (
DoctorID INT AUTO_INCREMENT PRIMARY KEY,
First_name VARCHAR(50) NOT NULL,
Last_name VARCHAR(50) NOT NULL,
Specialty VARCHAR(50),
Phone VARCHAR(15),
Email VARCHAR(100)
);

-- 3. Appointments table
CREATE TABLE Appointments (
AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
PatientID INT NOT NULL,
DoctorID INT NOT NULL,
AppointmentDate DATETIME NOT NULL,
Reason VARCHAR(255),
FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 4. Admissions table
CREATE TABLE Admissions(
AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
PatientID INT NOT NULL,
AdmissionDate DATETIME NOT NULL,
DischargeDate DATETIME,
Reason VARCHAR(255),
RoomNumber VARCHAR(10),
FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- 5. Bills table
CREATE TABLE Bills (
BillID INT AUTO_INCREMENT PRIMARY KEY,
AdmissionID INT NOT NULL,
Amount DECIMAL(10,2) NOT NULL,
BillDate DATETIME NOT NULL,
Paid BOOLEAN DEFAULT FALSE,
FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID)
);


-- Insert data into Patients
INSERT INTO Patients (First_name, Last_name, DOB, Gender, Phone, Email) VALUES 
('John', 'Doe', '1980-05-15', 'M', '+37038746464', 'john.doe@gmail.com'),
('Jane', 'Smith', '1990-08-22', 'F', '+37040850439', 'jane.smith@outlook.com'),
('Alice', 'Johnson', '1975-12-05', 'F', '+37043209815', 'alice.johnson@gmail.com'),
('Bob', 'Wilson', '1988-03-10', 'M', '+37029847598', 'bob.wilson@gmail.com');

SELECT * FROM Patients;

-- Insert data into Doctors 
INSERT INTO Doctors (First_name, Last_name, Specialty, Phone, Email) VALUES
('Mark', 'Brown', 'Cardiology', '+37023048443', 'mark.brown@gmail.com'),
('Susan', 'Lee', 'Neurology', '+37094325724', 'susan.lee@yahoo.com'),
('David', 'Wilson', 'General Medicine', '+37039247234', 'david.wilson@gmail.com'),
('Anjela', 'Loktiova', 'dentist', '+37040385034', 'anjela.loktiova@outlook.com');

SELECT * FROM Doctors;

-- Inser data into Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(1, 1, '2025-12-01 10:00:00', 'Routine Checkup'),
(2, 2, '2025-12-02 14:30:00', 'Migraine Consultation'),
(3, 1, '2025-12-03 09:00:00', 'Heart Palpitations'),
(4, 3, '2025-12-04 11:00:00', 'General Checkup');

SELECT * FROM Appointments;

-- Insert data into Admission
INSERT INTO Admissions (PatientID, AdmissionDate, DischargeDate, Reason, RoomNumber) VALUES
(1, '2025-11-20 08:00:00', '2025-11-25 09:00:00', 'Heart Surgery', '101A'),
(2, '2025-11-22 10:00:00', NULL, 'Observation', '102B'),
(3, '2025-11-24 12:00:00', '2025-11-27 11:00:00', 'Chest Pain Monitoring', '103C');

SELECT * FROM Admissions;

-- Insert data into Bills
INSERT INTO Bills (AdmissionID, Amount, BillDate, Paid) VALUES
(1, 5500.00, '2025-11-26', FALSE),
(2, 1200.00, '2025-11-26', TRUE),
(3, 800.00, '2025-11-28', FALSE);

SELECT * FROM Bills;

-- Update operations
UPDATE Patients
SET Phone = '+37039139174'
WHERE PatientID = 1;

SELECT Phone FROM Patients WHERE PatientID = 1;

-- Update payment row
UPDATE Bills
SET Paid = True
WHERE BillID = 1;

SELECT Paid FROM Bills WHERE BillID = 1;

-- Update Doctor's specialty
UPDATE DOCTORS
SET Specialty = 'Internal Medicine'
WHERE DoctorID = 3;

SELECT Specialty FROM Doctors WHERE DoctorID = 3;

-- Delete opearations
DELETE FROM Appointments
WHERE AppointmentID = 4;

SELECT * FROM Appointments WHERE AppointmentID = 4;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM Bills
WHERE Paid = False;
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM Bills;

-- Data Retrieval and Queries
SELECT 
COUNT(BillID) AS TotalBills,
SUM(AMOUNT) AS TotalRevenue,
AVG(Amount) AS AverageBillAmount
FROM Bills;

-- Use GROUP BY and ORDER BY implement ASCENDING and DSECENDING
SELECT 
Doctors.First_name,
Doctors.last_name,
COUNT(Appointments.AppointmentID) AS TotalAppointments
FROM DOCTORS 
LEFT JOIN Appointments 
ON Doctors.DoctorID = Appointments.DoctorID
GROUP BY Doctors.DoctorID
ORDER BY TotalAppointments DESC;

-- Pagination + ORDER BY 
SELECT PatientID, First_name, Last_name, DOB
FROM Patients
ORDER BY Last_name ASC
LIMIT 2 OFFSET 0;

-- Use Left Join
SELECT
Patients.PatientID,
Patients.First_name,
Patients.Last_name,
Appointments.AppointmentDate,
Appointments.Reason
FROM Patients
LEFT JOIN Appointments
ON Patients.PatientID = Appointments.AppointmentID;

-- Inner join
SELECT
Patients.PatientID,
Patients.First_name AS PatientFirstName,
Patients.Last_name AS PatientLastName,
Appointments.AppointmentDate,
Appointments.Reason
FROM Patients
INNER JOIN Appointments
ON Patients.PatientId = Appointments.AppointmentID;

-- Join three tables 
SELECT 
Patients.First_name,
Patients.Last_name,
Bills.Amount,
Bills.Paid,
Admissions.AdmissionDate
FROM Bills
INNER JOIN Admissions
on Bills.AdmissionID = Admissions.AdmissionID
INNER JOIN Patients
ON Admissions.PatientID = Patients.PatientID

-- Create a view of 3 tables
CREATE VIEW v_AppointmentSummary AS 
SELECT 
Appointments.AppointmentId,
Patients.First_name AS PatientFirstName,
Patients.Last_name AS PatientLastName,
Doctors.First_name AS DoctorFirstName,
Doctors.Last_name AS DoctorLastName,
Appointments.AppointmentDate,
Appointments.Reason
FROM Appointments 
INNER JOIN Patients
ON Appointments.PatientID = Patients.PatientID
INNER JOIN Doctors
ON Appointments.DoctorID = Doctors.DoctorID;

SELECT * FROM v_appointmentSummary
ORDER BY AppointmentDate ASC;


-- Create Trigger 
CREATE TABLE Appointment_Log (
LogID INT AUTO_INCREMENT PRIMARY KEY,
AppointmentID INT,
PatientID INT,
DoctorID INT,
AppointmentDate DATETIME,
LoggesAt DATETIME
);

SELECT * FROM Appointment_Log;

DROP TRIGGER trg_LogNameAppointment;

CREATE TRIGGER trg_LogNameAppointment
AFTER INSERT ON Appointments
FOR EACH ROW
INSERT INTO Appointment_Log (AppointmentId, PatientID, DoctorID, AppointmentDate, LoggesAt)
VALUES (NEW.AppointmentID, NEW.PatientID, NEW.DoctorID, NEW.AppointmentDate, NOW());

INSERT INTO Patients (First_name, Last_name, DOB, Gender, Phone, Email) VALUES 
('Simon', 'Gonan', '1986-12-15', 'M', '+37034958547', 'simon.gonan@gmail.com');

INSERT INTO Patients (First_name, Last_name, DOB, Gender, Phone, Email) VALUES 
('Saule', 'Rondon', '1989-07-14', 'F', '+37034039854', 'saule.rondon@gmail.com');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(5, 2, '2025-12-05 12:00:00', 'General Observation');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(6, 3, '2025-11-05 11:25:00', 'General Observation');


SELECT * FROM Appointments;

SELECT * FROM Appointment_Log;