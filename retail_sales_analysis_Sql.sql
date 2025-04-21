create database retail_sales_analysis;
use retail_sales_analysis;
/*table creation*/
create table retail_sales(
transactions_id	int,
sale_time time,
customer_id	int,
gender	varchar(20),
category varchar(20),
quantiy	int,
price_per_unit	float,
cogs float,
total_sale float,
age	int,
sale_date date
);
alter table retail_sales
change quantiy quantity int;
select * from retail_sales;
drop table retail_sales;
/*to verify total number of rows data imported or not*/
select count(*) from retail_sales;
/*DATA CLEANING*/
/*to check for null values*/
select * from retail_sales
where 
	transactions_id is null or sale_time is null or customer_id is null or gender is null or
    category is null or quantity is null or  price_per_unit is null or  cogs is null or total_sale is null
    or age is null or sale_date is null;
    
SET SQL_SAFE_UPDATES = 0;

/*delete null values if exists*/
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
/*DATA EXPLORATION*/
/*How many sale we have*/
select count(*) as total_sales from retail_Sales;
/*how unique many customers we have?*/
select count(distinct customer_id) as total_customers from retail_Sales;
/*how many unique categories we have?*/
select count(distinct category) as "total unique categories" from retail_sales;

/*business questions*/
/*Write a SQL query to retrieve all columns for sales made on '2022-11-05:*/
select * 
from retail_sales
where sale_date="2022-11-05";
/*Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:*/
select *
from retail_sales
where category="Clothing" and quantity >=4 and year(sale_date)=2022 and month(sale_date)= 11;
/* DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'*/
/*Write a SQL query to calculate the total sales (total_sale) and total_orders for each category.*/
select category,
sum(total_sale) as "net_sales",
count(*) as "total_orders"
from retail_sales
group by category
order by net_sales desc;
/*Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:*/
select category,
round(avg(age),2) as "Average age of customers"
from retail_sales
where category="Beauty";

/*Write a SQL query to find all transactions where the total_sale is greater than 1000.:*/
select *
from retail_sales
where total_sale>1000
order by total_sale desc;

/*Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:*/
select category,
gender,
count(transactions_id) as "total_transactions"
from retail_sales
group by category,gender
order by total_transactions desc;

select category,
count(case when gender="Male" then transactions_id end) as "Male",
count(Case when gender="Female" then transactions_id end)as "Female"
from retail_sales
group by category;

/*Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:*/
select * from
(select 
year(sale_date) as "Year",
month(sale_date) as "Month_number",
monthname(sale_date) as "Month",
round(avg(total_sale),2) as "Average sale",
rank() over (partition by year(sale_date) order by round(avg(total_sale),2) Desc) as month_rank
from retail_sales
group by Year,Month_number,Month
) as t1
where month_rank=1;
/*order by Year, Month_number;


/*Write a SQL query to find the top 5 customers based on the highest total sales :*/
select customer_id,
sum(total_sale) as "total_sales"
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

/*Write a SQL query to find the number of unique customers who purchased items from each category.:*/
select count(distinct customer_id) as "unique_customers",
category
from retail_sales
group by category
order by unique_customers desc;

/*Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):*/
with hourly_sale as
(select *,
case
when hour(sale_time)<12 then "Morning"
when hour(sale_time) between 12 and 17 then "Afternoon"
else "Evening"
end as Shift
from retail_sales)
select shift,
count(*) as "total_orders"
from hourly_sale
group by Shift;
/*revenue*/
select distinct category,
round(sum((quantity*price_per_unit)),2) as "revenue"
from retail_sales
group by category
order by revenue desc;

