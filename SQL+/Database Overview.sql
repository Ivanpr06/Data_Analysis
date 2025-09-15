%%sql

select s.orderdate, 
  s.netprice * s.exchangerate as net_revenue,
  c.givenname,
  c.surname,
  c.countryfull,
  c.continent,
  p.productname,
  p.categoryname,
  p.subcategoryname,
  case when s.quantity * s.netprice * s.exchangerate > 1000 then 'HIGH' else 'LOW' end as high_low
from 
  sales s
left join customer c on s.customerkey = c.customerkey
left join product p on s.productkey = p.productkey

where 
  orderdate::date >= '2020-01-01'
