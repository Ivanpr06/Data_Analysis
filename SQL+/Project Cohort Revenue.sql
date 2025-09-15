select cohort_year, 
  sum(total_net_revenue) as total_revenue, 
  count(distinct customerkey) as total_customers,
  sum(total_net_revenue) / count(distinct customerkey) as customer_revenue
from cohort_analysis
where orderdate = first_purcharse_date
group by cohort_year