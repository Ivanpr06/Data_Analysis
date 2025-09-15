%%sql

select p.categoryname, 
  avg(case when s.orderdate between '2022-01-01' and '2022-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as total_net_revenue_2022,
  avg(case when s.orderdate between '2023-01-01' and '2023-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as total_net_revenue_2023,
  max(case when s.orderdate between '2022-01-01' and '2022-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as max_net_revenue_2022,
  max(case when s.orderdate between '2023-01-01' and '2023-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as max_net_revenue_2023,
  min(case when s.orderdate between '2022-01-01' and '2022-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as min_net_revenue_2022,
  min(case when s.orderdate between '2023-01-01' and '2023-12-31' then s.quantity * s.netprice * s.exchangerate else 0 end) as min_net_revenue_2023
from 
  sales s
left join product p on s.productkey = p.productkey
group by 
  p.categoryname
order by 
  p.categoryname
order by 
  p.categoryname

-- MEDIAN
%%sql

select p.categoryname, 
  percentile_cont(.50) within group (order by (case when s.orderdate between '2022-01-01' and '2022-12-31' then (s.quantity * s.netprice * s.exchangerate) end)) as y2022_median_sales,
  percentile_cont(.50) within group (order by (case when s.orderdate between '2023-01-01' and '2023-12-31' then (s.quantity * s.netprice * s.exchangerate) end)) as y2023_median_sales
from 
  sales s
left join product p on s.productkey = p.productkey
group by 
  p.categoryname
order by 
  p.categoryname