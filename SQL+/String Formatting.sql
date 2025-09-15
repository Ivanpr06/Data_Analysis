drop view cohort_analysis;

create or replace view public.cohort_analysis as 
with customer_revenue as (
  select
    s.customerkey,
    s.orderdate,
    sum(s.quantity::double precision * s.netprice * s.exchangerate) as total_net_revenue,
    count(s.orderkey) as num_orders,
    c.countryfull,
    c.age,
    c.givenname,
    c.surname,
    from sales s
      left join customer c on c.customerkey = s.customerkey
    group by s.customerkey, s.orderdate, c.countryfull, c.age, c.givenname, c.surname
)

select customerkey,
  orderdate,
  total_net_revenue,
  num_orders,
  countryfull,
  age,
  concat(givenname, surname) as cleaned_name,
  min(orderdate) over (partition by customerkey) as first_purchase_date,
  extract(year from min(orderdate) over (partition by customerkey)) as cohort_year
from customer_revenue cr;