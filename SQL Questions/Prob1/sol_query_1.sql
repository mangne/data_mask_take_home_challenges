
select a.user_id, (a.unix_timestamp-a.prev_timestamp) as delta
from(
SELECT user_id, unix_timestamp, 
lag(unix_timestamp, 1) over (PARTITION BY user_id order by unix_timestamp) as prev_timestamp,
row_number() OVER (PARTITION BY user_id order by unix_timestamp desc) as order_id	
FROM query_one) as a
where a.order_id = 1
order by 2 desc
