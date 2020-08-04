-- Write a query that returns the total amount of money spent by each user. 
-- That is, the sum of the column transaction_amount for each user over both tables.

-- Write a query that returns day by day the cumulative sum of money spent by each user. 
-- That is, each day a user had a transcation, we should have how much money she has spent in total until that day. 
-- Obviously, the last day cumulative sum should match the numbers from the previous bullet point.

-- Solution 1
-- Grand Total

Drop table if exists a;
CREATE TEMPORARY TABLE a
select * from query_four_april union select * from query_four_march;

Drop table if exists b;
CREATE TEMPORARY TABLE b
select * from query_four_april union all select * from query_four_march;
-- union all over union since there may be same transaction for a particular user
-- select user_id, date, transaction_amount, count(*) from b
-- group by user_id, date, transaction_amount
-- having count(*) >1


select count(distinct user_id) from query_four_april
where user_id not in (select distinct user_id from a);

select count(*) from a;
select count(*) from b;

-- subquery solution
select total.user_id, sum(total.transaction_amount) from 
(select a.* from query_four_april a union all select b.* from query_four_march b) total
group by total.user_id
order by total.user_id;


-- Solution 2
-- Running Total
drop table if exists march_trans;
create temporary table march_trans
(select user_id, date, sum(transaction_amount) transaction_amount
from query_four_march
group by user_id, date);

drop table if exists april_trans;
create temporary table april_trans
(select user_id, date, sum(transaction_amount) transaction_amount
from query_four_april
group by user_id, date);


select user_id, date, transaction_amount as day_total, sum(transaction_amount) over (partition by user_id order by date) running_total
from(
select a.* from march_trans a union all select b.* from april_trans b) total
order by user_id, date;


-- subquery solution
select user_id, date, 
		transaction_amount as day_total, 
        sum(transaction_amount) over (partition by user_id order by date) running_total
from(
select user_id, date, sum(transaction_amount) transaction_amount
from query_four_march
group by user_id, date
union 
select user_id, date, sum(transaction_amount) transaction_amount
from query_four_april
group by user_id, date) total
order by user_id, date;





