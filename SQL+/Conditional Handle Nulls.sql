with sales_data as (
  select 
    customerkey,
    sum(quantity * netprice * exchangerate) as net_revenue
  from sales
  group by customerkey
)

select
  -- c.customerkey,
  -- s.net_revenue,
  avg(s.net_revenue) as spending_customers_avg_net_revenue,
  avg(coalesce(s.net_revenue, 0)) as all_customers_avg_net_revenue
from customer c
left join sales_data s on c.customerkey = s.customerkey