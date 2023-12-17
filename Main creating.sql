CREATE DATABASE Athlete_FITNESS 
USE Athlete_FITNESS
-- Create the Athlete table
CREATE TABLE AthleteDetails (
    Athlete_ID INT PRIMARY KEY IDENTITY(1,1),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Contact_Info VARCHAR(100),
    Sport VARCHAR(50)
);
Drop Table AthleteDetails
CREATE TABLE FitnessHistoryDetails (
    FitnessHistory_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Weight DECIMAL(5,2),
    Height DECIMAL(5,2),
    BMI DECIMAL(5,2),
    Muscular_Strength DECIMAL(5,2),
    Endurance DECIMAL(5,2),
    Flexibility DECIMAL(5,2),
    Date_Recorded DATE,
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);

CREATE TABLE RehabilitationDetails (
    Rehab_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Start_Date DATE,
    End_Date DATE,
    Rehab_Type VARCHAR(50),
    Notes TEXT,
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);

CREATE TABLE InjuryDetails (
    Injury_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Injury_Date DATE,
    Injury_Type VARCHAR(50),
    Severity VARCHAR(50),
    Recovery_Status VARCHAR(50),
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);
CREATE TABLE ExerciseDetails (
    Exercise_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Exercise_Date DATE,
    Exercise_Type VARCHAR(50),
    DurationMinutes INT,
    CaloriesBurned DECIMAL(8,2),
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);
CREATE TABLE DietDetails (
    Diet_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Diet_Date DATE,
    Meal_Type VARCHAR(50),
    CaloriesConsumed DECIMAL(8,2),
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);
CREATE TABLE WorkoutScheduleDetails (
    Schedule_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Workout_Date DATE,
    Workout_Type VARCHAR(50),
    Workout_DurationMinutes INT,
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);

CREATE TABLE ExpensesDetails (
    Expense_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Expense_Date DATE,
    Expense_Type VARCHAR(50),
    Amount DECIMAL(10,2),
    Description TEXT,
    FOREIGN KEY (Athlete_ID) REFERENCES AthleteDetails(Athlete_ID)
);

CREATE TABLE InvoiceDetails (
    Invoice_ID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    Total_Expenses DECIMAL(10, 2),
    Invoice_Date DATE DEFAULT GETDATE()
);




Select @@SERVERNAME



------------------------------------------------
Use Athlete_FITNESS
Select * from AthleteDetails
Select * from FitnessHistoryDetails
Select * from RehabilitationDetails
Select * from InjuryDetails
Select * from ExerciseDetails
Select * from DietDetails
Select * from WorkoutScheduleDetails
Select * from ExerciseDetails
Select * from ExpensesDetails
Select * from InvoiceDetails

------------------------------------------------

