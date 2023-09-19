-- Fetch all columns from the table for viewing 
SELECT *
FROM `myportfolio-398102.Divvy_Trips.Bikes`;

-- Standardize Date Format for started_date

-- Create the started_date column 
ALTER TABLE `myportfolio-398102.Divvy_Trips.Bikes`
ADD COLUMN started_date DATE;

-- Update the started_date column with date value from started_at
UPDATE `myportfolio-398102.Divvy_Trips.Bikes`
SET started_date = DATE(started_at)
WHERE started_at IS NOT NULL;

-- Standardize Date Format for ended_date

-- Create the ended_date column 
ALTER TABLE `myportfolio-398102.Divvy_Trips.Bikes`
ADD COLUMN ended_date DATE;

-- Update the ended_date column with date value from ended_at
UPDATE `myportfolio-398102.Divvy_Trips.Bikes`
SET ended_date = DATE(ended_at)
WHERE ended_at IS NOT NULL;


--Remove Duplicates
SELECT *,

FROM `myportfolio-398102.Divvy_Trips.Bikes`;

WITH RowNumCTE AS (
  SELECT ride_id,  -- Assuming ride_id is a unique identifier for each row in the table
         ROW_NUMBER() OVER (
           PARTITION BY rideable_type, 
                        start_station_name,
                        start_station_id,
                        end_station_name,
                        end_station_id,
                        member_casual
           ORDER BY ride_id) AS row_num
  FROM `myportfolio-398102.Divvy_Trips.Bikes`
)

DELETE FROM `myportfolio-398102.Divvy_Trips.Bikes`
WHERE ride_id IN (SELECT ride_id FROM RowNumCTE WHERE row_num > 1);


-- Delete Unused Columns

SELECT *
FROM `myportfolio-398102.Divvy_Trips.Bikes`;


ALTER TABLE `myportfolio-398102.Divvy_Trips.Bikes`
DROP COLUMN started_at;

ALTER TABLE `myportfolio-398102.Divvy_Trips.Bikes`
DROP COLUMN ended_at;


-- Handeling Null Values

SELECT COUNT(*) as MissingRideableType
FROM `myportfolio-398102.Divvy_Trips.Bikes`
WHERE rideable_type IS NULL;

-- Standadize Text Data 
UPDATE `myportfolio-398102.Divvy_Trips.Bikes`
SET rideable_type = UPPER(TRIM(rideable_type))
WHERE rideable_type IS NOT NULL
