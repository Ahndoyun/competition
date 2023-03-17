-- 10분위 분석
-- 전체를 10분위로 나누어 분위 수에 해당하는 집단의 성질을 나타내는 방법

-- 1. 아이디별 주문 건수 순위 매기기
select *,
row_number() over(order by f desc) rnk
from 
(select user_id,
count(distinct order_id) f
from instacart.orders   -- 중복되지 않은 아이디별로 다른 주문 건수
group by 1) a

-- 2. 10분위 나누고 q로 분류
select *,
case when rnk between 1 and 316 then 'q1' -- case when rnk <= 316 then 'q1'
when rnk between 317 and 632 then 'q2'
when rnk between 633 and 948 then 'q3'
when rnk between 949 and 1264 then 'q4'
when rnk between 1265 and 1580 then 'q5'
when rnk between 1581 and 1895 then 'q6'
when rnk between 1896 and 2211 then 'q7'
when rnk between 2212 and 2527 then 'q8'
when rnk between 2528 and 2843 then 'q9'
when rnk between 2844 and 3159 then 'q10' end q
from 
(select *,
row_number() over(order by f desc) rnk
from
(select user_id,
count(distinct order_id) f
from instacart.orders 
group by 1) a) a 

--전체 주문 건수 계산,
-- 각 분위 수의 주문 건수/전체 주문 건수
select q,
sum(f)/3220 f
from instacart.user_q
group by 1;