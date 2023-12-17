Use Athlete_FITNESS
CREATE TABLE DenormalizedAthleteData (
    Athlete_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Contact_Info VARCHAR(100),
    Sport VARCHAR(50),
    Weight DECIMAL(5,2),
    Height DECIMAL(5,2),
    BMI DECIMAL(5,2),
    Muscular_Strength DECIMAL(5,2),
    Endurance DECIMAL(5,2),
    Flexibility DECIMAL(5,2),
    Rehabilitation_Start_Date DATE,
    Rehabilitation_End_Date DATE,
    Rehab_Type VARCHAR(50),
    Rehab_Notes TEXT,
    Injury_Date DATE,
    Injury_Type VARCHAR(50),
    Severity VARCHAR(50),
    Recovery_Status VARCHAR(50),
    Exercise_Date DATE,
    Exercise_Type VARCHAR(50),
    DurationMinutes INT,
    CaloriesBurned DECIMAL(8,2),
    Diet_Date DATE,
    Meal_Type VARCHAR(50),
    CaloriesConsumed DECIMAL(8,2),
    Workout_Date DATE,
    Workout_Type VARCHAR(50),
    Workout_DurationMinutes INT,
    Expense_Date DATE,
    Expense_Type VARCHAR(50),
    Amount DECIMAL(10,2),
    Expense_Description TEXT
);




Drop Table DenormalizedAthleteData

