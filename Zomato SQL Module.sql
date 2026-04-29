USE zomato_project;
TRUNCATE TABLE zomato_restaurants;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zomato_clean.csv'
INTO TABLE zomato_restaurants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@RestaurantID,
@RestaurantName,
@CountryCode,
@City,
@Address,
@Locality,
@LocalityVerbose,
@Longitude,
@Latitude,
@Cuisines,
@Currency,
@Has_Table_booking,
@Has_Online_delivery,
@Is_delivering_now,
@Switch_to_order_menu,
@Price_range,
@Votes,
@Average_Cost_for_two,
@Rating,
@DateKey,
@Extra1,
@Extra2)
SET
RestaurantID = @RestaurantID,
RestaurantName = @RestaurantName,
CountryCode = @CountryCode,
City = @City,
Address = @Address,
Locality = @Locality,
LocalityVerbose = @LocalityVerbose,
Longitude = @Longitude,
Latitude = @Latitude,
Cuisines = @Cuisines,
Currency = @Currency,
Has_Table_booking = @Has_Table_booking,
Has_Online_delivery = @Has_Online_delivery,
Is_delivering_now = @Is_delivering_now,
Switch_to_order_menu = @Switch_to_order_menu,
Price_range = @Price_range,
Votes = @Votes,
Average_Cost_for_two = @Average_Cost_for_two,
Rating = @Rating,
DateKey = STR_TO_DATE(@DateKey, '%Y-%m-%d');
SELECT COUNT(*) FROM zomato_restaurants;
SELECT Votes, Average_Cost_for_two, Rating, DateKey
FROM zomato_restaurants
LIMIT 10;

-- Q1 -- Country Map Table
SELECT r.RestaurantName, r.City, c.CountryName
FROM zomato_restaurants r
JOIN country_map c
ON r.CountryCode = c.CountryCode
LIMIT 10;

-- Q2 -- Calendar Table --
SELECT 
    Datekey,
    YEAR(Datekey) AS Year,
    MONTH(Datekey) AS MonthNo,
    MONTHNAME(Datekey) AS MonthFullName,
    CONCAT('Q', QUARTER(Datekey)) AS Quarter,
    DATE_FORMAT(Datekey,'%Y-%b') AS YearMonth,
    DAYOFWEEK(Datekey) AS WeekdayNo,
    DAYNAME(Datekey) AS WeekdayName,
    CASE 
        WHEN MONTH(Datekey) >= 4 THEN MONTH(Datekey) - 3
        ELSE MONTH(Datekey) + 9
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(Datekey) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Datekey) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(Datekey) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter
FROM zomato_restaurants;

-- Q3 Number of Restaurants by City & Country --
SELECT 
    c.CountryName,
    z.City,
    COUNT(*) AS Total_Restaurants
FROM zomato_restaurants z
JOIN country_map c
ON z.CountryCode = c.CountryCode
GROUP BY c.CountryName, z.City
ORDER BY Total_Restaurants DESC;

-- Q4 Restaurants Opening Trend --
SELECT YEAR(Datekey) AS Year,
COUNT(*) AS Total_Openings
FROM zomato_restaurants
GROUP BY Year;
SELECT CONCAT('Q', QUARTER(Datekey)) AS Quarter,
COUNT(*) AS Total_Openings
FROM zomato_restaurants
GROUP BY Quarter;
SELECT MONTHNAME(Datekey) AS Month,
COUNT(*) AS Total_Openings
FROM zomato_restaurants
GROUP BY MONTH(Datekey), Month;

-- Q5 Restaurant Ratings Analysis (Bucket)--
SELECT Rating,
COUNT(*) AS Total_Restaurants
FROM zomato_restaurants
GROUP BY Rating
ORDER BY Rating DESC;
-- Rating Bucket --
SELECT 
CASE 
    WHEN Rating >= 4 THEN 'Excellent'
    WHEN Rating >= 3 THEN 'Good'
    WHEN Rating >= 2 THEN 'Average'
    ELSE 'Poor'
END AS Rating_Category,
COUNT(*) AS Total
FROM zomato_restaurants
GROUP BY Rating_Category;

-- Q6 Price Bucket Analysis --
SELECT 
CASE 
    WHEN Average_Cost_for_two < 500 THEN 'Budget'
    WHEN Average_Cost_for_two BETWEEN 500 AND 1500 THEN 'Mid-Range'
    WHEN Average_Cost_for_two BETWEEN 1501 AND 3000 THEN 'Premium'
    ELSE 'Luxury'
END AS Price_Category,
COUNT(*) AS Total
FROM zomato_restaurants
GROUP BY Price_Category; 

-- Q7 Restaurant Table Booking Percentage --
SELECT 
Has_Table_booking,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM zomato_restaurants),2) AS Percentage
FROM zomato_restaurants
GROUP BY Has_Table_booking;

-- Q8 Restaurant Online Delivery Percentage --
SELECT 
Has_Online_delivery,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM zomato_restaurants),2) AS Percentage
FROM zomato_restaurants
GROUP BY Has_Online_delivery;

 -- Q9  KPI --
-- Top 10 Cuisines --
SELECT Cuisines, COUNT(*) AS Count
FROM zomato_restaurants
GROUP BY Cuisines
ORDER BY Count DESC
LIMIT 10;

-- Total Restaurants --
SELECT COUNT(*) AS Total_Restaurants FROM zomato_restaurants;

-- Top 10 Expensive Restaurants --
SELECT RestaurantName, City, Average_Cost_for_two
FROM zomato_restaurants
ORDER BY Average_Cost_for_two DESC
LIMIT 10;

-- Top 10 Cities by Avg Rating(highest avg. restaurant ratings) --
SELECT City,
ROUND(AVG(Rating),2) AS Avg_Rating
FROM zomato_restaurants
GROUP BY City
ORDER BY Avg_Rating DESC
LIMIT 10;

-- Most Popular Restaurants --
SELECT RestaurantName, City, Votes
FROM zomato_restaurants
ORDER BY Votes DESC
LIMIT 10;



















