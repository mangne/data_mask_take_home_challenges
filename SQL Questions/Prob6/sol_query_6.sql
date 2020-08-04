-- We have a table with users, their country and when they created the account. We want to find:

-- The country with the largest and smallest number of users
-- A query that returns for each country the first and the last user who signed up (if that country has just one user, it should just return that single user)


select *
from query_six
order by user_id, created_at;

select count(*), count(distinct user_id) from query_six;

-- solution 1
select b.country, users
from(
select a.*, row_number() over(order by users) as rank_asc,
row_number() over(order by users desc) as rank_desc
from(
select country, count(distinct user_id) as users
from query_six
group by country) a) b
where rank_asc = 1 or rank_desc = 1;

-- solution 2

select * from(
select user_id, country, created_at, row_number() over(partition by country order by created_at) created_asc,
row_number() over(partition by country order by created_at desc) created_desc
from query_six) a
where a.created_asc = 1 or a.created_desc = 1
order by country, created_at
