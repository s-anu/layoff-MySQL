
# Data Cleaning and Exploratory Data Analysis (EDA)for Layoffs Dataset




## Overview

This project focuses on cleaning and preprocessing the layoffs dataset using SQL. The cleaning process involves handling duplicates, standardizing data, dealing with null values, and removing unnecessary columns or rows. The cleaned dataset is stored in a staging table (layoffs_staging2).


This project also involves performing Exploratory Data Analysis (EDA) on the cleaned layoffs_staging2 dataset using SQL. The analysis provides insights into layoff trends across companies, locations, industries, and time periods


## Steps Data Preprocessing

1. Removing Duplicates
2. Standardizing Data
3. Handling NULL/Blank Values
4. Removing Unnecessary Rows/Columns


## Steps EDA

1. Basic Dataset Overview
2. Layoff Statistics by Different Attributes
3. Time-Based Analysis
4. Yearly Company Layoff Trends


## SQL Techniques Used --Data Preprocessing



•	Common Table Expressions (CTEs) for identifying duplicates.

•	ROW_NUMBER() window function for duplicate detection.

•	TRIM(), LIKE, UPDATE, JOIN, and ALTER TABLE for data transformation.

•	DELETE and DROP COLUMN to remove unnecessary data.



## SQL Techniques Used --EDA

•	Aggregate functions (SUM(), MAX(), MIN())

•	Grouping and ordering (GROUP BY, ORDER BY)

•	Date extraction and manipulation (YEAR(), SUBSTRING())

•	Common Table Expressions (CTEs) for rolling totals and yearly rankings

•	Window functions (DENSE_RANK() for ranking companies by layoffs

## Insights

•	Identify industries and locations most affected by layoffs.

•	Analyze layoff trends over time to understand economic impacts.

•	Highlight top companies contributing to layoffs each year.

•	Provide valuable insights for workforce planning and market predictions.
