Use Athlete_FITNESS
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
    RD.Notes AS Rehab_Notes,
    ID.Injury_Date,
    ID.Injury_Type,
    ID.Severity AS Injury_Severity,
    ID.Recovery_Status,
    ED.Exercise_Date,
    ED.Exercise_Type,
    ED.DurationMinutes AS Exercise_Duration,
    ED.CaloriesBurned AS Exercise_CaloriesBurned,
    DD.Diet_Date,
    DD.Meal_Type,
    DD.CaloriesConsumed AS Diet_CaloriesConsumed,
    WD.Workout_Date,
    WD.Workout_Type,
    WD.Workout_DurationMinutes AS Workout_Duration
FROM AthleteDetails AD
LEFT JOIN FitnessHistoryDetails FH ON AD.Athlete_ID = FH.Athlete_ID
LEFT JOIN RehabilitationDetails RD ON AD.Athlete_ID = RD.Athlete_ID
LEFT JOIN InjuryDetails ID ON AD.Athlete_ID = ID.Athlete_ID
LEFT JOIN ExerciseDetails ED ON AD.Athlete_ID = ED.Athlete_ID
LEFT JOIN DietDetails DD ON AD.Athlete_ID = DD.Athlete_ID
LEFT JOIN WorkoutScheduleDetails WD ON AD.Athlete_ID = WD.Athlete_ID;

