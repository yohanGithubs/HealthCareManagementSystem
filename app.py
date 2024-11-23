from flask import Flask, render_template, request, redirect, flash
from flask_mysqldb import MySQL
from config import Config

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Initialize MySQL connection
mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('home.html')

# Add Patient
@app.route('/add_patient', methods=['GET', 'POST'])
def add_patient():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        dob = request.form['dob']
        gender = request.form['gender']
        phone = request.form['phone']
        email = request.form['email']
        address = request.form['address']
        insurance_provider = request.form['insurance_provider']
        insurance_number = request.form['insurance_number']

        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber, Email, Address, InsuranceProvider, InsuranceNumber)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, dob, gender, phone, email, address, insurance_provider, insurance_number))
        mysql.connection.commit()
        cur.close()

        flash('Patient added successfully!', 'success')
        return redirect('/add_patient')

    return render_template('add_patient.html')

# View Patients
@app.route('/view_patients')
def view_patients():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Patients")
    patients = cur.fetchall()
    cur.close()
    return render_template('view_patients.html', patients=patients)

# Add Doctor
@app.route('/add_doctor', methods=['GET', 'POST'])
def add_doctor():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        specialty = request.form['specialty']
        phone = request.form['phone']
        email = request.form['email']
        license_number = request.form['license_number']

        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO Doctors (FirstName, LastName, Specialty, PhoneNumber, Email, LicenseNumber)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, specialty, phone, email, license_number))
        mysql.connection.commit()
        cur.close()

        flash('Doctor added successfully!', 'success')
        return redirect('/add_doctor')

    return render_template('add_doctor.html')

# View Doctors
@app.route('/view_doctors')
def view_doctors():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Doctors")
    doctors = cur.fetchall()
    cur.close()
    return render_template('view_doctors.html', doctors=doctors)

# Schedule Appointment
@app.route('/schedule_appointment', methods=['GET', 'POST'])
def schedule_appointment():
    if request.method == 'POST':
        patient_id = request.form['patient_id']
        doctor_id = request.form['doctor_id']
        appointment_date = request.form['appointment_date']
        appointment_time = request.form['appointment_time']
        reason_for_visit = request.form['reason_for_visit']

        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, ReasonForVisit)
            VALUES (%s, %s, %s, %s, %s)
        """, (patient_id, doctor_id, appointment_date, appointment_time, reason_for_visit))
        mysql.connection.commit()
        cur.close()

        flash('Appointment scheduled successfully!', 'success')
        return redirect('/schedule_appointment')

    cur = mysql.connection.cursor()
    cur.execute("SELECT PatientID, CONCAT(FirstName, ' ', LastName) FROM Patients")
    patients = cur.fetchall()
    cur.execute("SELECT DoctorID, CONCAT(FirstName, ' ', LastName) FROM Doctors")
    doctors = cur.fetchall()
    cur.close()

    return render_template('schedule_appointment.html', patients=patients, doctors=doctors)

# View Appointments
@app.route('/view_appointments')
def view_appointments():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT 
            a.AppointmentID, 
            CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, 
            CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
            a.AppointmentDate,
            a.AppointmentTime,
            a.Status,
            a.ReasonForVisit
        FROM Appointments a
        JOIN Patients p ON a.PatientID = p.PatientID
        JOIN Doctors d ON a.DoctorID = d.DoctorID
    """)
    appointments = cur.fetchall()
    cur.close()
    return render_template('view_appointments.html', appointments=appointments)

# View Medical Records
@app.route('/view_medical_records')
def view_medical_records():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT 
            r.RecordID, 
            CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
            CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
            r.DiagnosisDate, 
            r.Diagnosis, 
            r.Treatment, 
            r.Notes
        FROM MedicalRecords r
        JOIN Patients p ON r.PatientID = p.PatientID
        JOIN Doctors d ON r.DoctorID = d.DoctorID
    """)
    records = cur.fetchall()
    cur.close()
    return render_template('view_medical_records.html', records=records)

if __name__ == '__main__':
    app.run(debug=True)
