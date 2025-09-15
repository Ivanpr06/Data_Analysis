with customer_ltv as (
  select
    customerkey,
    cleaned_name,
    sum(total_net_revenue) as total_ltv
  from cohort_analysis
  group by customerkey, cleaned_name
), customer_segments as(
  select
    percentile_count(0.25) within group (order by total_ltv) as ltv_25th_percentile,
    percentile_count(0.75) within group (order by total_ltv) as ltv_75th_percentile,
  from customer_ltv
), segment_values as(
  select
    c.*,
    case
      when c.total_ltv < cs.ltv_25th_percentile then '1 - Low-Value'
      when c.total_ltv <= cs.ltv_75th_percentile then '2 - Mid-Value'
      else '3 - High-Value'
    end as customer_segment
  from customer_ltv c,
    customer_segments cs
)

select
  customer_segment,
  sum(total_ltv) as total_ltv,
  count(customerkey) as customer_count,
  sum(total_ltv) / count(customerkey) as avg_ltv
from segment_values
group by customer_segment
order by customer_segment desc

