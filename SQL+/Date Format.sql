-- Date Trunc
%%sql

select 
  date_trunc('month', orderdate)::date as order_month,
  sum(quantity * netprice * exchangerate) as net_revenue,
  count(distinct customerkey) as total_unique_customers
from 
  sales
group by 
  order_month
limit 10


-- To Char
%%sql

select 
  to_char(orderdate, 'YYYY-MM') as order_month,
  sum(quantity * netprice * exchangerate) as net_revenue,
  count(distinct customerkey) as total_unique_customers
from 
  sales
group by 
  order_month
limit 10