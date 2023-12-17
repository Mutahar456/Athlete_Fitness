Use Athlete_FITNESS

CREATE VIEW AthleteSummaryView
AS
SELECT 
    AD.Athlete_ID,
    AD.First_Name,
    AD.Last_Name,
    AD.Date_of_Birth,
    AD.Gender,
    FH.Weight,
    FH.Height,
    FH.BMI,
    FH.Muscular_Strength,
    FH.Endurance,
    FH.Flexibility,
    RD.Start_Date AS Rehab_Start_Date,
    RD.End_Date AS Rehab_End_Date,
    RD.Rehab_Type,
    ID.Injury_Date,
    ID.Injury_Type,
    ID.Severity,
    ID.Recovery_Status,
    ED.Exercise_Date,
    ED.Exercise_Type,
    ED.DurationMinutes AS Exercise_DurationMinutes,
    ED.CaloriesBurned AS Exercise_CaloriesBurned,
    DD.Diet_Date,
    DD.Meal_Type,
    DD.CaloriesConsumed AS Diet_CaloriesConsumed,
    WSD.Workout_Date AS Schedule_Workout_Date,
    WSD.Workout_Type AS Schedule_Workout_Type,
    WSD.Workout_DurationMinutes AS Schedule_Workout_DurationMinutes,
    XD.Expense_Date,
    XD.Expense_Type AS Expense_Type,
    XD.Amount AS Expense_Amount,
    XD.Description AS Expense_Description
FROM AthleteDetails AD
LEFT JOIN FitnessHistoryDetails FH ON AD.Athlete_ID = FH.Athlete_ID
LEFT JOIN RehabilitationDetails RD ON AD.Athlete_ID = RD.Athlete_ID
LEFT JOIN InjuryDetails ID ON AD.Athlete_ID = ID.Athlete_ID
LEFT JOIN ExerciseDetails ED ON AD.Athlete_ID = ED.Athlete_ID
LEFT JOIN DietDetails DD ON AD.Athlete_ID = DD.Athlete_ID
LEFT JOIN WorkoutScheduleDetails WSD ON AD.Athlete_ID = WSD.Athlete_ID
LEFT JOIN ExpensesDetails XD ON AD.Athlete_ID = XD.Athlete_ID;


SELECT * FROM AthleteSummaryView;
















