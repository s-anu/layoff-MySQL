-- EDA ANALYSIS

SELECT * FROM layoffs_staging2;

SELECT location, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY location;

SELECT company, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY industry ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY YEAR(`date`) ORDER BY 1 DESC;

SELECT MIN(`date`), MAX(`date`)FROM layoffs_staging2;

SELECT stage, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) FROM layoffs_staging2 GROUP BY stage ORDER BY 2 DESC;

SELECT COUNT(*) FROM layoffs_staging2 WHERE total_laid_off IS NULL;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1;

-- ROLLING SUM
-- TO LOOK AT THE PROGRESSION OF LAY OFF BASED ON THE MONTH

SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) 
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_monthly_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` ORDER BY 1 ASC
)
SELECT `MONTH`,total_monthly_layoff,SUM( total_monthly_layoff) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

-- YEARLY COMPANY LAYOFF 
SELECT company, SUM(total_laid_off),MAX(total_laid_off),  MIN(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company ,YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year(company,years,total_laid_off) AS
(
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company ,YEAR(`date`)
),Company_Year_Rank AS
(
SELECT *,DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS rank_by_year
 FROM company_year
 WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE rank_by_year <=5;



