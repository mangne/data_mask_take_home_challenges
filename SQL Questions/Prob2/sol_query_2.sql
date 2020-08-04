#We have two tables. One table has all mobile actions, 
#i.e. all pages visited by the users on mobile. 
#The other table has all web actions, i.e. all pages visited on web by the users.
#Write a query that returns the percentage of users who only visited mobile, 
#only web and both. That is, the percentage of users who are only in the mobile table, 
#only in the web table and in both tables. The sum of the percentages should return 1.


select  100*sum(case when a_user_id is not null and b_user_id is null then 1 else 0 end)/count(*) mob,
100*sum(case when b_user_id is not null and a_user_id is null then 1 else 0 end)/count(*) web,
100*sum(case when a_user_id is not null and b_user_id is not null then 1 else 0 end)/count(*) as common 
from
(select a.user_id as a_user_id, b.user_id as b_user_id from query_two_mobile a
left join (select distinct user_id from query_two_web) b on a.user_id = b.user_id
UNION
select a.user_id as a_user_id, b.user_id as b_user_id from query_two_mobile  a
right join (select distinct user_id from query_two_web) b on a.user_id = b.user_id) all_

