-- Data CLeaning

SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standarize the data
-- 3. NULL values/Blank values
-- 4. Rmeove unnecessary columns


CREATE TABLE layoffs_stagging 
LIKE layoffs;


SELECT * FROM layoffs_stagging;


INSERT layoffs_stagging 
SELECT *
FROM layoffs;


SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date') AS row_num
FROM layoffs_stagging;


WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * FROM layoffs_stagging
WHERE company = 'Casper'; 


WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_stagging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM layoffs_stagging2; 



INSERT layoffs_stagging2 
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_stagging;


SELECT * FROM layoffs_stagging2
WHERE row_num > 1;

DELETE
FROM layoffs_stagging2
WHERE row_num > 1;


SELECT * FROM layoffs_stagging2;

-- 2

SELECT company , TRIM(company) 
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company) ;

SELECT * FROM layoffs_stagging2;

SELECT DISTINCT industry
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;

-- TRAILING : REMOVE THE SYMBOL

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER BY 1;

UPDATE layoffs_stagging2
SET country =TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;


SELECT date,
STR_TO_DATE(date, '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET date=STR_TO_DATE(date, '%m/%d/%Y');

SELECT * 
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN date DATE;

SELECT * 
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_stagging2
SET industry=NULL
WHERE industry='';

SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_stagging2
WHERE company LIKE 'Bally%';


SELECT *
FROM layoffs_stagging2 AS t1
JOIN layoffs_stagging2 AS t2
	ON t1.company=t2.company
    AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company=t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;


