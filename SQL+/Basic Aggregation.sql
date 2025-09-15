-- First example

%%sql

select s.orderdate, 
  count(DISTINCT s.customerkey) as total_customers,
  count(distinct case when c.continent = 'Europe' then s.customerkey end) as total_europe_customers,
  count(distinct case when c.continent = 'North America' then s.customerkey end) as total_north_america_customers,
  count(distinct case when c.continent = 'Australia' then s.customerkey end) as total_australia_customers
from 
  sales s
left join customer c on s.customerkey = c.customerkey
where
  s.orderdate between '2023-01-01' and '2023-12-31'
group by 
  s.orderdate
order by 
  s.orderdate


-- Second example
%%sql

select p.categoryname, 
  sum(s.quantity * s.netprice * s.exchangerate) as net_revenue,
  sum(case when s.orderdate between '2022-01-01' and '2022-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as total_net_revenue_2022,
  sum(case when s.orderdate between '2023-01-01' and '2023-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as total_net_revenue_2023
from 
  sales s
left join product p on s.productkey = p.productkey
group by 
  p.categoryname
order by 
  p.categoryname