-- We define as power users those users who bought at least 10 products. 
-- Write a query that returns for each user on which day they became a power user. That is, for each user, on which day they bought the 10th item.

-- The table below represents transactions. That is, each row means that the corresponding user has bought something on that date.
select user_id, date
from
(select user_id,date,
row_number() over (partition by user_id order by date) purchase
from dataz_query_3) as a
where purchase = 10
order by user_id