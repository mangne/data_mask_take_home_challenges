-- We have two tables. One is user id and their signup date. 
-- The other one shows all transactions done by those users, when the transaction happens and its corresponding dollar amount.

-- Find the average and median transaction amount only considering those transactions that happen on the same date as that user signed-up.

drop table if exists eligible_users;
create temporary table eligible_users
select a.*
from query_five_transactions a
join 
query_five_users b on a.user_id = b.user_id and date(a.transaction_date) = date(b.sign_up_date);

select count(*), count(distinct user_id) from eligible_users;
-- 1336

select count(distinct user_id) from query_five_users;
-- 1982

select count(*), count(distinct user_id) from query_five_transactions;

drop table if exists metrics;
create temporary table metrics
select transaction_amount,
row_number() over(order by transaction_amount) row_num_asc,
COUNT(*) OVER() - ROW_NUMBER() OVER(ORDER BY transaction_amount) + 1 AS row_num_desc
from 
eligible_users;




select avg(transaction_amount) avg_amount,
avg(case when row_num_asc between row_num_desc-1 and row_num_desc+1 then transaction_amount else null end) median
from metrics


