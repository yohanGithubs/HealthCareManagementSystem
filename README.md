**HealthCare Management System Installation Guide**

This will help you set up the system project on your computer

**Prerequisites:** Before you start make sure you have the following installed :


**1. Python  ->** Version:3.7 or higher 


**2. MySQL** 


**3. Git** 

**Step 1: Clone the Repository** 


**1.** Open a terminal or Git Bash

**2.** Run the followin command to clone the project :


   ```git clone https://github.com/yourusername/HealthcareManagementSystem.git ```


**3.** Navigate to the project directory:


```cd HealthcareManagementSystem ```


**Step 2: Set up a Virtual Environment**
**1.** Create a virtual environment



```python -m venv venv ```


**2.** Activate the vrital environment: 

**Windows:**
``` venv\Scripts\activate```
**Linux**
```source venv/bin/activate```


**Step 3: Install Dependencies** 
**1.** Use pip to install the required Libraries:

```pip install -r requirements.txt```


**Step 4: Set up the Database** 
**1.** Open Mysql workbench
**2.** Import the healthcaredb.sql file:
- Using Mysql workbench:
   - Open **Server** > **Data Import**
   - Select the healthcaredb.sql file and import it
 
**3.** Ensure the database HealthcareDB is created successfully:

```
   SHOW DATABASES;
   USE HealthcareDB;
   SHOW TABLES;
```

**sTEP 5 : Update Confirguration**
**1.** Open the config.py file in the project directory
**2.** Update the MySQL connection settings:


```
    class Config:
        SECRET_KEY = 'your_secret_key'
        MYSQL_HOST = 'localhost'
        MYSQL_USER = 'root'
        MYSQL_PASSWORD = 'your_mysql_password"
        MYSQL_DB = 'HealthcareDB'
```

**Step 6: Run the Application**
**1.** Start the Flask application

``` python app.py ```

**2.2 Open your web browswer and ggo to:

```https://127.0.0.1:5000 ```





