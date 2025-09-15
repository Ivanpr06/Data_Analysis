with customer_last_purchase as (
  select
    customerkey,
    cleaned_name,
    orderdate,
    row_number() over (partition by customerkey order by orderdate desc) as rn,
    first_purchase_date
  from cohort_analysis
), Churned_customers as (
  select 
    customerkey,
    cleaned_name,
    first_purchase_date,
    orderdate as last_purchase_date,
    case 
      when orderdate < (select max(orderdate) from sales) - interval '6 months' then 'Churned'
      else 'Active'
    end as customer_status
  from customer_last_purchase
  where rn = 1
    and first_purchase_date (select max(orderdate) from sales) - interval '6 months';
)

select
  cohort_year,
  customer_status,
  count(customerkey) as num_customers,
  sum(count(customerkey)) over(partition by cohort_year) as total_customers,
  round(count(customerkey) / sum(count(customerkey)) over(partition by cohort_year), 2) as status_percentage
from Churned_customers
group by cohort_year, customer_status