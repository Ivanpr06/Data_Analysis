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
  month,
  net_revenue,
  -- Es un promedio móvil sobre una sola fila (la actual), así que es igual al valor actual
  avg(net_revenue) over (order by month rows between current row and current row) as net_revenue_current,
  -- Calcula un promedio móvil de los últimos 2 meses
  avg(net_revenue) over (order by month rows between 1 preceding and current row) as net_revenue_1,
  avg(net_revenue) over (order by month rows between 1 preceding and 1 following) as net_revenue_1

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
  month,
  net_revenue,
  -- Calcula el promedio acumulado mes a mes
  avg(net_revenue) over (order by month rows between unbounded preceding and current row) as net_revenue_current

from monthly_revenue