-- First Example
%%sql
with monthly_revenue as (
  select
    to_char(orderdate, 'YYYY-MM') as month,
    sum(quantity * netprice * exchangerate) as net_revenue
  from sales
  where extract(year from orderdate) = 2023
  group by month
  order by month
)
select 
  *,
  first_value(net_revenue) over (order by month) as first_month_revenue,
  last_value(net_revenue) over (order by month rows between unbounded preceding and unbounded following) as last_month_revenue,
  nth_value(net_revenue, 3) over (order by month rows between unbounded preceding and unbounded following) as third_month_revenue

from monthly_revenue


-- Second Example
%%sql
with monthly_revenue as (
  select
    to_char(orderdate, 'YYYY-MM') as month,
    sum(quantity * netprice * exchangerate) as net_revenue
  from sales
  where extract(year from orderdate) = 2023
  group by month
  order by month
)
select 
  *,
  -- crea una nueva columna que acceda a una fila anterior de otra columna
  lag(net_revenue) over (order by month) as previous_month_revenue,
  --  crea una nueva columna que accede a una fila anterior de otra columna
  lead(net_revenue) over (order by month) as next_month_revenue,
  100 * (net_revenue - lag(net_revenue) over (order by month)) / lag(net_revenue) over (order by month) as monthly_rev_growth_porcent

from monthly_revenue