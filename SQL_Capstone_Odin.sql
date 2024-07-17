create database amazon;
use amazon;

desc amazon;

alter table amazon 
modify date date;

alter table amazon 
modify time time;

select count(distinct(payment)) from amazon;


select count(distinct(`product line`)) from amazon;

select * from amazon;

alter table amazon
add column timeofday varchar(20);

update amazon
set timeofday = CASE
    WHEN TIME(time) BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN TIME(time) BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
    ELSE 'Night'
END;


select dayname from amazon;

ALTER TABLE amazon
ADD COLUMN dayname VARCHAR(10);

UPDATE amazon
SET dayname = date_format(date, "%a");

alter table amazon
add column monthname varchar(10);

update amazon
set monthname = date_format(date, '%b');


-- Q1 What is the count of distinct cities in the dataset?
select count(distinct(city)) as Distinct_City_Name from amazon; -- 3

-- Q2 For each branch, what is the corresponding city?
select distinct branch , city from amazon;

-- Q3 What is the count of distinct product lines in the dataset?
select count(distinct(`Product line`)) as Distinct_Product_Line from amazon; -- 6
select distinct(`product line`) from amazon;

-- Q4 Which payment method occurs most frequently?
select payment,count(*) as frequency from amazon 
group by payment
order by frequency desc;

-- Q5 Which product line has the highest sales?
select `product line` , sum(total) Highest_Sales from amazon
group by `product line`
order by Highest_Sales desc;

-- Q6 How much revenue is generated each month?
select monthname, sum(total) total_revenue from amazon
group by monthname ;

-- Q7 In which month did the cost of goods sold reach its peak?
select monthname , sum(cogs) Max_Cogs from amazon
group by monthname;

-- Q8 Which product line generated the highest revenue?
select `product line` , sum(total) total_revenue from amazon
group by `product line`
order by  total_revenue desc;

-- Q9 In which city was the highest revenue recorded?
select city , sum(total) as total_revenue from amazon
group by city
order by total_revenue desc;

-- Q10 Which product line incurred the highest Value Added Tax?
select * from amazon;

select `product line`, sum(`Tax 5%`) as Total_Vat from amazon
group by `product line`
order  by Total_Vat desc;

-- Q11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

ALTER TABLE amazon
ADD COLUMN sales_category VARCHAR(10);


UPDATE amazon as a
join (
SELECT `product line`, AVG(total) AS avg_total
    FROM amazon
    GROUP BY `product line`
) AS avg_sales ON a.`product line` = avg_sales.`product line`
SET a.sales_category = CASE
    WHEN a.total > avg_sales.avg_total THEN 'Good'
    ELSE 'Bad'
END;


-- Q12. Identify the branch that exceeded the average number of products sold.

SELECT branch, SUM(quantity) AS total_quantity
FROM amazon
GROUP BY branch
HAVING total_quantity > (
    SELECT AVG(total_quantity)
    FROM (
        SELECT branch, SUM(quantity) AS total_quantity
        FROM amazon	
        GROUP BY branch
    ) AS branch_totals
);


-- Q13. Which product line is most frequently associated with each gender?

SELECT gender, `product line`, frequency
FROM (
    SELECT gender, `product line`, COUNT(*) AS frequency,
           ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
    FROM amazon
    GROUP BY gender, `product line`
) AS ranked
WHERE rnk = 1;

-- Q14 Calculate the average rating for each product line.
select  `product line`,avg(Rating) as Average_Rating
from amazon 
group by `product line`;

-- Q15 Count the sales occurrences for each time of day on every weekday.
select dayname, timeofday, count(*) as Sale_Occurrences_Count
from amazon
group by dayname,timeofday
order by dayname,timeofday;

-- Q16 Identify the customer type contributing the highest revenue.
SELECT `customer type`, SUM(total) AS total_revenue
FROM amazon
GROUP BY `customer type`
ORDER BY total_revenue DESC
LIMIT 1;

-- Q17 Determine the city with the highest VAT percentage.
select city, max(`Tax 5%`) as max_vat
from amazon
group by city
order by max_vat desc;


-- Q18 Identify the customer type with the highest VAT payments.

select `customer type`, max(`Tax 5%`) as highest_vat_payment
from amazon
group by  `customer type`
order by highest_vat_payment desc;

-- Q19 What is the count of distinct customer types in the dataset?


select count(distinct(`customer type`)) number_of_distinct_customer_type from amazon;

-- Q20 What is the count of distinct payment methods in the dataset?

select count(distinct(payment)) number_of_distinct_payment_methods
from amazon;

-- Q21 Which customer type occurs most frequently?

select `customer type`, count(*) as frequency
from amazon
group by `customer Type`
order by frequency desc;

-- Q22 Identify the customer type with the highest purchase frequency.

select `customer type` , count(distinct(`invoice id`)) as frequency
from amazon
group by `customer type`
order by frequency desc;

-- Q23 Determine the predominant gender among customers.

select gender, count(*) as frequency
from amazon
group by gender
order by frequency desc;	

-- Q24 Examine the distribution of genders within each branch.

select branch, gender, count(*) as frequency
from amazon
group by  branch, gender
order by branch, gender;

-- Q25 Identify the time of day when customers provide the most ratings.

select timeofday , count(rating) as rating_count
from amazon
group by  timeofday 
order by rating_count desc;


-- Q26 Determine the time of day with the highest customer ratings for each branch.

SELECT branch, timeofday, max(rating) AS highest_rating
FROM amazon
GROUP BY branch, timeofday
ORDER BY branch, highest_rating DESC;

-- Q 27 Identify the day of the week with the highest average ratings.

SELECT dayname, AVG(rating) AS average_rating
FROM amazon
GROUP BY dayname
ORDER BY average_rating DESC;

-- Q28 Determine the day of the week with the highest average ratings for each branch.

WITH ranked_ratings AS (
    SELECT branch, dayname, avg(rating) AS avg_rating,
           ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM amazon
    GROUP BY branch, dayname
)
SELECT branch, dayname, avg_rating
FROM ranked_ratings
WHERE rnk = 1;








