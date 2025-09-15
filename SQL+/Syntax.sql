-- Explanation

%%sql

select
  customerkey as customer,
  orderdate,
  (quantity * netprice * exchangerate) as net_revenue,
  row_number() over(
    partition by customerkey
    order by quantity * netprice * exchangerate desc
  ) as order_rank
from
  sales
order by customerkey, orderdate
limit 10;


-- First Example 
%%sql

select *,
  100 * net_revenue / daily_net_revenue as pct_daily_revenue
from (
  select
    orderdate, 
    orderkey * 10 + linenumber as order_line_item,
    (quantity * netprice * exchangerate) as net_revenue,
    SUM(quantity * netprice * exchangerate) over(partition by orderdate) as daily_net_revenue
  from 
    sales
) as revenue_by_day


-- Second Example
%%sql

with yearly_cohort as (
  select distinct
    customerkey,
    extract(year from min(orderdate) over (partition by customerkey)) as cohort_year
  from 
    sales
)
select 
  y.cohort_year,
  extract(year from orderdate) as order_year,
  sum(s.quantity * s.netprice * s.exchangerate) as net_revenue
from sales s
left join yearly_cohort y on s.customerkey = y.customerkey
group by
  y.cohort_year,
  extract(year from orderdate)
limit 10;