-- First Example
%%sql

with yearly_cohort as (
select distinct
  customerkey,
  extract(year from min(orderdate) over (partition by customerkey)) as cohort_year,
  extract(year from orderdate) as purchase_year
from 
  sales
)
select 
  cohort_year,
  purchase_year,
  count(customerkey) over (partition by cohort_year, purchase_year) as customer_count
from yearly_cohort