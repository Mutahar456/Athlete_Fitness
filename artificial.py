import pyodbc
from faker import Faker
import random

# Function to generate fake data for the AthleteDetails table
def generate_athlete_data(fake):
    return {
        'First_Name': fake.first_name(),
        'Last_Name': fake.last_name(),
        'Date_of_Birth': fake.date_of_birth(minimum_age=18, maximum_age=40),
        'Gender': fake.random_element(['Male', 'Female']),
        'Contact_Info': fake.phone_number(),
        'Sport': fake.random_element(['Basketball', 'Football', 'Cricket'])
    }
# Function to generate fake data for the RehabilitationDetails table
def generate_rehab_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Start_Date': fake.date_this_year(),
        'End_Date': fake.date_this_year(),
        'Rehab_Type': fake.random_element(['Physical Therapy', 'Occupational Therapy', 'Speech Therapy']),
'Notes': random.choice(['You are advised to take rest ', ' you can start slight jogging', 'you have to start the doctor advised exercise'])    }

# Function to generate fake data for InjuryDetails table
def generate_injury_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Injury_Date': fake.date_this_year(),
        'Injury_Type': fake.random_element(['Sprain', 'Fracture', 'Strain']),
        'Severity': fake.random_element(['Low', 'Medium', 'High']),
        'Recovery_Status': fake.random_element(['Ongoing', 'Recovered'])
    }

# Function to generate fake data for the FitnessHistoryDetails table
def generate_fitness_history_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Weight': round(random.uniform(50, 120), 2),
        'Height': round(random.uniform(150, 200), 2),
        'BMI': round(random.uniform(18, 30), 2),
        'Muscular_Strength': round(random.uniform(50, 100), 2),
        'Endurance': round(random.uniform(50, 100), 2),
        'Flexibility': round(random.uniform(50, 100), 2),
        'Date_Recorded': fake.date_this_year()
    }

# Function to generate fake data for ExerciseDetails table
def generate_exercise_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Exercise_Date': fake.date_this_year(),
        'Exercise_Type': fake.random_element(['Running', 'Weightlifting', 'Yoga']),
        'DurationMinutes': random.randint(10, 120),
        'CaloriesBurned': round(random.uniform(50, 500), 2)
    }

# Function to generate fake data for DietDetails table
def generate_diet_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Diet_Date': fake.date_this_year(),
        'Meal_Type': fake.random_element(['Breakfast', 'Lunch', 'Dinner']),
        'CaloriesConsumed': round(random.uniform(100, 1000), 2)
    }
def generate_expenses_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Expense_Date': fake.date_this_year(),
        'Expense_Type': fake.random_element(['Equipment', 'Nutrition', 'Training']),
        'Amount': round(random.uniform(10, 500), 2),
        'Description': fake.random_element(['You are a good athlete ','you are a bad athlete ','you are average athlete'])
    }
# Function to generate fake data for WorkoutScheduleDetails table
def generate_workout_schedule_data(fake, athlete_id):
    return {
        'Athlete_ID': athlete_id,
        'Workout_Date': fake.date_this_year(),
        'Workout_Type': fake.random_element(['Cardio', 'Strength Training', 'Pilates']),
        'Workout_DurationMinutes': random.randint(30, 120)
    }

# Establish a connection to your SQL Server database
connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=AM-Hashmi\SQLEXPRESS;DATABASE=Athlete_FITNESS;Trusted_Connection=yes'
conn = pyodbc.connect(connection_string)
cursor = conn.cursor()

# Create Faker instance
fake = Faker()

# Generate and insert fake data into the tables
for _ in range(30):  # Adjust the number of records as needed
    athlete_data = generate_athlete_data(fake)
    cursor.execute(
        'INSERT INTO AthleteDetails (First_Name, Last_Name, Date_of_Birth, Gender, Contact_Info, Sport) VALUES (?, ?, ?, ?, ?, ?)',
        athlete_data['First_Name'], athlete_data['Last_Name'], athlete_data['Date_of_Birth'], athlete_data['Gender'],
        athlete_data['Contact_Info'], athlete_data['Sport'])
    cursor.execute('SELECT @@IDENTITY')
    athlete_id = cursor.fetchone()[0] or None

    if athlete_id:  # Check if athlete_id exists
        fitness_history_data = generate_fitness_history_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO FitnessHistoryDetails (Athlete_ID, Weight, Height, BMI, Muscular_Strength, Endurance, Flexibility, Date_Recorded) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            fitness_history_data['Athlete_ID'], fitness_history_data['Weight'], fitness_history_data['Height'],
            fitness_history_data['BMI'], fitness_history_data['Muscular_Strength'], fitness_history_data['Endurance'],
            fitness_history_data['Flexibility'], fitness_history_data['Date_Recorded'])

        exercise_data = generate_exercise_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO ExerciseDetails (Athlete_ID, Exercise_Date, Exercise_Type, DurationMinutes, CaloriesBurned) VALUES (?, ?, ?, ?, ?)',
            exercise_data['Athlete_ID'], exercise_data['Exercise_Date'], exercise_data['Exercise_Type'],
            exercise_data['DurationMinutes'], exercise_data['CaloriesBurned'])

        diet_data = generate_diet_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO DietDetails (Athlete_ID, Diet_Date, Meal_Type, CaloriesConsumed) VALUES (?, ?, ?, ?)',
            diet_data['Athlete_ID'], diet_data['Diet_Date'], diet_data['Meal_Type'], diet_data['CaloriesConsumed'])

        workout_data = generate_workout_schedule_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO WorkoutScheduleDetails (Athlete_ID, Workout_Date, Workout_Type, Workout_DurationMinutes) VALUES (?, ?, ?, ?)',
            workout_data['Athlete_ID'], workout_data['Workout_Date'], workout_data['Workout_Type'], workout_data['Workout_DurationMinutes'])

        expenses_data = generate_expenses_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO ExpensesDetails (Athlete_ID, Expense_Date, Expense_Type, Amount, Description) VALUES (?, ?, ?, ?, ?)',
            expenses_data['Athlete_ID'], expenses_data['Expense_Date'], expenses_data['Expense_Type'],
            expenses_data['Amount'], expenses_data['Description'])

        rehab_data = generate_rehab_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO RehabilitationDetails (Athlete_ID, Start_Date, End_Date, Rehab_Type, Notes) VALUES (?, ?, ?, ?, ?)',
            rehab_data['Athlete_ID'], rehab_data['Start_Date'], rehab_data['End_Date'],
            rehab_data['Rehab_Type'], rehab_data['Notes'])

        injury_data = generate_injury_data(fake, athlete_id)
        cursor.execute(
            'INSERT INTO InjuryDetails (Athlete_ID, Injury_Date, Injury_Type, Severity, Recovery_Status) VALUES (?, ?, ?, ?, ?)',
            injury_data['Athlete_ID'], injury_data['Injury_Date'], injury_data['Injury_Type'],
            injury_data['Severity'], injury_data['Recovery_Status'])

# Commit the transaction
conn.commit()
# Close the connection
conn.close()
