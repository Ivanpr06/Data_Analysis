-- First Example
%%sql

select 
  orderdate,
  quantity,
  netprice,
  case 
    when quantity >= 2 and netprice >= 100 then 'Multiple High Value Order' 
    when quantity >= 2 then 'Single High Value Item' 
    when netprice >= 100 then 'Multiple Standard Items'
    else 'Single Standard Item' end as order_type
from 
  sales s
limit 10


-- Second Example
%%sql

with median_value as (
  select
    PERCENTILE_CONT(0.5) within group (order by (s.quantity * s.netprice * s.exchangerate)) as median_value
  from 
    sales s
  where
    orderdate between '2022-01-01' and '2023-12-31'
)

select p.categoryname, 
  sum(case when (s.quantity * s.netprice * s.exchangerate) < mv.median_value
    and s.orderdate between '2022-01-01' and '2022-12-31'
    then (s.quantity * s.netprice * s.exchangerate) end) as low_net_revenue_2022,
  sum(case when (s.quantity * s.netprice * s.exchangerate) >= mv.median_value 
    and s.orderdate between '2022-01-01' and '2022-12-31'
    then (s.quantity * s.netprice * s.exchangerate) end) as high_net_revenue_2022,
  sum(case when (s.quantity * s.netprice * s.exchangerate) < mv.median_value 
    and s.orderdate between '2023-01-01' and '2023-12-31'
    then (s.quantity * s.netprice * s.exchangerate) end) as low_net_revenue_2023,
  sum(case when (s.quantity * s.netprice * s.exchangerate) >= mv.median_value 
    and s.orderdate between '2023-01-01' and '2023-12-31'
    then (s.quantity * s.netprice * s.exchangerate) end) as high_net_revenue_2023
from 
  sales s
  left join product p on s.productkey = p.productkey,
  median_value mv
group by 
  p.categoryname
order by 
  p.categoryname


-- Third example
%%sql

with percentiles as(
  select
    PERCENTILE_CONT(0.25) within group (order by (s.quantity * s.netprice * s.exchangerate)) as revenue_25th_percentile,
    PERCENTILE_CONT(0.5) within group (order by (s.quantity * s.netprice * s.exchangerate)) as revenue_50th_percentile,
    PERCENTILE_CONT(0.75) within group (order by (s.quantity * s.netprice * s.exchangerate)) as revenue_75th_percentile
  from 
    sales s
  where
    orderdate between '2022-01-01' and '2023-12-31'
)

select p.categoryname, 
  CASE
    when (s.quantity * s.netprice * s.exchangerate) <= pc.revenue_25th_percentile then '1 - LOW'
    when (s.quantity * s.netprice * s.exchangerate) >= pc.revenue_75th_percentile then '3 - HIGH'
    else '2 - MEDIUM' 
  end as revenue_tier,
  sum(s.quantity * s.netprice * s.exchangerate) as total_revenue
from 
  sales s
  left join product p on s.productkey = p.productkey,
  percentiles pc
group by 
  p.categoryname,
  revenue_tier
order by 
  p.categoryname,
  revenue_tier;