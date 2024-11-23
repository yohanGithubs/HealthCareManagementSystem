from flask import Flask
from flask_mysqldb import MySQL

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'of006801035'  # Add your MySQL root password
app.config['MYSQL_DB'] = 'HealthcareDB'

mysql = MySQL(app)

@app.route('/')
def test_connection():
    try:
        cur = mysql.connection.cursor()
        cur.execute('SELECT 1')
        return "Database connection successful!"
    except Exception as e:
        return f"Database connection failed: {e}"

if __name__ == '__main__':
    app.run(debug=True)
