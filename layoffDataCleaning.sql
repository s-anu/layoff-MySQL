-- DATA CLEANING
SELECT * FROM layoffs;

-- 1.REMOVE DUPLICATES
-- 2.STANDARDIZING DATA
-- 3.NULL/BLANK VALUES
-- 4.REMOVE ROW/ COLOUMN IF NOT NEEDED

CREATE TABLE layoffs_staging LIKE layoffs;  -- to copy the schema
SELECT * FROM layoffs_staging; 
INSERT layoffs_staging SELECT * FROM layoffs; -- to copy the entries into the table


WITH duplicate_record_cte AS(
SELECT * , ROW_NUMBER() 
OVER( PARTITION BY company,location,industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
) 
SELECT * FROM duplicate_record_cte WHERE row_num>1; -- temperory result set


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT * FROM layoffs_staging2; 
INSERT INTO layoffs_staging2
SELECT * , ROW_NUMBER() 
OVER( 
PARTITION BY company,location,industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;
SELECT * FROM layoffs_staging2 WHERE row_num >1;
DELETE FROM layoffs_staging2 WHERE row_num >1;


-- GIST OF IDENTIFYING AND REMOVING DUPLICATE RECCORDS
-- 1ST WE CREATED A COPY OF ORIGINAL TABLE AS A STAGING TABLE 
-- THEN WE CREATED A CTE TEMPARORY SET WITH ROW NUM AND IDENTIFIED IF WE HAVE ANY DUPLICATES
-- THEN WE CREATEA A NEW TABLE AS A COPY OF STAGING AS STAGING2 AND DELETED THE DUPLICATES i.e ROW_NUM>1

-- 2.STANDARDIZING DATA

SELECT company,TRIM(company) FROM layoffs_staging2;
UPDATE layoffs_staging2 SET company= TRIM(company);

SELECT DISTINCT(industry) FROM layoffs_staging2 ORDER BY 1; -- found similar industry with 3 diff name cryto, cryto currency and cryptocurrency

SELECT * FROM layoffs_staging2 WHERE industry LIKE 'Crypto%' ;
UPDATE layoffs_staging2 
SET industry='Crypto'
WHERE industry LIKE 'Crypto%' ;

SELECT DISTINCT(location) FROM layoffs_staging2 ORDER BY 1;

SELECT DISTINCT(country) FROM layoffs_staging2 ORDER BY 1;
SELECT DISTINCT(country) FROM layoffs_staging2  WHERE country LIKE 'United States%' ;
SELECT DISTINCT country,TRIM(TRAILING '.' FROM country) FROM layoffs_staging2 ORDER BY 1;
UPDATE layoffs_staging2 
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%' ;

SELECT `date`,str_to_date(`date`,'%m/%d/%Y') FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date`=str_to_date(`date`,'%m/%d/%Y');
SELECT `date` FROM layoffs_staging2;
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;


-- 3.NULL/BLANK VALUES
SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT* FROM layoffs_staging2 WHERE industry IS NULL OR industry ='';
UPDATE layoffs_staging2
SET industry =NULL
WHERE industry='';
-- FINDING WHETHER WE CAN POPULATE DATA FOR INDUSTRY 
SELECT * FROM layoffs_staging2 WHERE company='Airbnb'; -- Travel
SELECT * FROM layoffs_staging2 WHERE company='Bally''s Interactive';
SELECT * FROM layoffs_staging2 WHERE company='Carvana'; -- Transportation
SELECT * FROM layoffs_staging2 WHERE company='Juul'; -- Consumer

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
    AND t1.location=t2.location
WHERE (t1. industry IS NULL OR  t1. industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
    AND t1.location=t2.location
SET t1.industry = t2.industry 
WHERE t1. industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT * FROM layoffs_staging2;


-- 4.REMOVE ROW/ COLOUMN IF NOT NEEDED

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;




