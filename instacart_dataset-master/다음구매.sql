-- 상품별 재구매율 계산, 가장 높은 순서대로 순위
--1)상품별 재구매율 계산
select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio 
from instacart.order_products
group by 1

--2) 높은 순서대로 순위매기기
select *,
row_number() over(order by ret_ratio desc) rnk
from 
(select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio 
from instacart.order_products
group by 1) a

--3) 최종
select *
from 
(select *,
row_number() over(order by ret_ratio desc) rnk
from 
(select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio 
from instacart.order_products
group by 1) a) a

-- 각 상품을 10분위로 나눔 (create temporary table)
create temporary table instacart.product_repurchase_q as
select a.product_id,
case when rnk <= 929 then 'q1'
when rnk <= 1858 then 'q2'
when rnk <= 2786 then 'q3'
when rnk <= 3715 then 'q4'
when rnk <= 4644 then 'q5'
when rnk <= 5573 then 'q6'
when rnk <= 6502 then 'q7'
when rnk <= 7430 then 'q8'
when rnk <= 8359 then 'q9'
when rnk <= 9288 then 'q10' end rnk_grp
from
(select *,
row_number() over(order by ret_ratio desc) rnk
from 
(select product_id,
sum(case when reordered = 1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products
group by 1) a) a
group by 1,2

-- 각 분위수별 재구매 소요 기간의 분산 구하기

