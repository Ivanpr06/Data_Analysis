-- First Explanation
%%sql
select
  orderdate,
  extract(year from orderdate) as extract_year,
  extract(month from orderdate) as extract_month,
  extract(day from orderdate) as extract_day
from
  sales
order by random()
limit 10;


-- Second Explanation
%%sql
select
  extract(year from orderdate) as order_year,
  extract(month from orderdate) as extract_month,
  sum(quantity * netprice * exchangerate) as net_revenue
from
  sales
group by
  order_year,
  extract_month
order by
  order_year,
  extract_month;


-- First Example
%%sql

select
  s.orderdate,
  p.categoryname, 
  sum(s.quantity * s.netprice * s.exchangerate) as net_revenue
from 
  sales s
left join product p on s.productkey = p.productkey
where
  extract(year from orderdate) >= extract(year from CURRENT_DATE) - 5
  -- orderdate >= current_date - Interval '5 years'
group by 
  s.orderdate,
  p.categoryname
order by 
  s.orderdate,
  p.categoryname;


-- Delivery Avg Time 
%%sql

select
  date_part('year', orderdate) as order_year,
  -- age(deliverydate, orderdate) as delivery_time
  round(avg(extract (day from age(deliverydate, orderdate))), 2) as avg_delivery_time
from 
  sales
group by
  order_year
order by 
  order_year;