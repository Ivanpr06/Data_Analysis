--First Example
%%sql
with row_numbering as (
  select 
    row_number() over(
      partition by
        orderdate
      order by 
        orderdate,
        orderkey,
        linenumber
    ) as row_number,
    *
from 
  sales
)

select *
from row_numbering
where orderdate > '2015-01-01'
limit 10

-- Second example
%%sql
select
  customerkey,
  count(*) as total_orders,
  -- row_number() over (order by count(*) desc) as total_orders_row_num,
  -- rank() over (order by count(*) desc) as rank_row_num,
  dense_rank() over (order by count(*) desc) as dense_rank_row_num

from sales
group by customerkey
limit 10