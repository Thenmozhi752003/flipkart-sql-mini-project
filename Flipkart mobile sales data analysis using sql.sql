--Data Exploration
use flipkart_db;                               --database
select * from flipkart_mobiles_sales;    
select count(*) from flipkart_mobiles_sales;
DESC flipkart_mobiles_sales;                   --show the table structure
--get unique brand names
select distinct brand,count(*)                 
from flipkart_mobiles_sales 
group by brand; 
--check the null values      
select * from flipkart_mobiles_sales where processor is null;
select brand,Category,base_color,count(*) 
from flipkart_mobiles_sales 
group by brand,Category,base_color having count(*)>1;

select min(sales_price),max(sales_price) from flipkart_mobiles_sales;
--data cleaning 
alter table flipkart_mobiles_sales add id int auto_increment primary key;
select * from flipkart_mobiles_sales;
select
sum(case when brand is null then 1 else 0 end) as brand_null,
sum(case when processor is null then 1 else 0 end) as processor_null,
sum(case when battery_capacity is null then 1 else 0 end) as BC_null,
sum(case when Category is null then 1 else 0 end) as cat_null,
sum(case when base_color is null then 1 else 0 end) as basecolor_null,
sum(case when screen_size is null then 1 else 0 end) as screensize_null,
sum(case when ROM is null then 1 else 0 end) as ROM_null,
sum(case when RAM is null then 1 else 0 end) as RAM_null,
sum(case when display_size is null then 1 else 0 end) as displaysize_null,
sum(case when num_rear_camera is null then 1 else 0 end) as rearcamera_null,
sum(case when sales_price is null then 1 else 0 end) as sp_null,
sum(case when sales is null then 1 else 0 end) as sales_null
from flipkart_mobiles_sales;
select *,count(*) from flipkart_mobiles_sales 
group by brand,Category,base_color,processor,screen_size,ROM,RAM,display_size,num_front_camera,battery_capacity,ratings,num_of_ratings,sales_price,discount_percent,sales,id 
having count(*)>1;
select count(*) - count(distinct id) from flipkart_mobiles_sales;
select distinct brand from flipkart_mobiles_sales;
update flipkart_mobiles_sales set brand=upper(brand); 
select * from flipkart_mobiles_sales; 
DESC flipkart_mobiles_sales; 
update flipkart_mobiles_sales set brand=trim(brand);
select * from flipkart_mobiles_sales; 
select
min(sales_price),max(sales_price),avg(sales_price) from flipkart_mobiles_sales; 
select brand,sales_price 
from flipkart_mobiles_sales
order by sales_price desc limit 20;
--data analysis
select brand, count(*) as total_models
from flipkart_mobiles_sales
group by brand 
order by total_models desc;
--index
create index idx_brand on flipkart_mobiles_sales(brand);
alter table flipkart_mobiles_sales modify brand varchar(50);
show index from flipkart_mobiles_sales;
select brand,avg(sales_price) as avg_price from flipkart_mobiles_sales group by brand;
select brand,avg(ratings) as avg_rating from flipkart_mobiles_sales
group by brand order by avg_rating desc;
select brand,max(ratings) as max_ratings from flipkart_mobiles_sales
group by brand  order by max_ratings desc;
select sales_price,ratings from flipkart_mobiles_sales order by ratings desc;
select brand,sales_price from flipkart_mobiles_sales
where sales_price >(select avg(sales_price) from flipkart_mobiles_sales);
select brand,count(*) as total from flipkart_mobiles_sales group by brand having total>50;
create table brand_info(brand varchar(50),country varchar(50));
select * from brand_info;
insert into brand_info values('APPLE','USA'),('SAMSUNG','South korea'),('XIAOMI','China'),('REALME','China'),('POCO','China');
select * from brand_info; 
select distinct f.brand,f.sales_price,b.country from flipkart_mobiles_sales f inner join brand_info b on f.brand=b.brand;
select b.country,count(*) as total_models from flipkart_mobiles_sales f join brand_info b on f.brand=b.brand group by b.country;
select b.country,round(avg(f.sales_price),2) as avg_price  from flipkart_mobiles_sales f join brand_info b on f.brand=b.brand group by b.country; 
select f.brand,f.sales_price,b.country from flipkart_mobiles_sales f left join brand_info b on f.brand=b.brand;
--CTE
with avg_price  as(
		select avg(sales_price) as avg_value from flipkart_mobiles_sales
        )
        select * from flipkart_mobiles_sales, avg_price  where sales_price > avg_value;
with ranked_data as(
        select brand,sales_price,row_number() over(partition by brand order by sales_price desc) as rn
        from flipkart_mobiles_sales
        )
        select brand,sales_price
        from ranked_data 
        where rn=1;
select brand,sales_price,
case
   when sales_price<20000 then 'budget'
   when sales_price between 20000 and 50000 then 'mid range'
   else 'premium'
end as price_category
from flipkart_mobiles_sales;
--window functions
select brand,sales_price,ROW_number() over(order by sales_price desc) as rn from flipkart_mobiles_sales;
select brand,sales_price,rank() over(order by sales_price desc) as rnk from flipkart_mobiles_sales ;
select brand,sales_price,dense_rank() over(order by sales_price desc) as rnk from flipkart_mobiles_sales;
--view
create view high_price_mobiles as select * from flipkart_mobiles_sales where sales_price>50000;
select * from high_price_mobiles;
