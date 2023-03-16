-- 지표 추출

-- 1) 전체 주문 건수
select count(distinct order_id) f --distinct 중복제거
from instacart.orders o 

-- 2) 구매자 수
select count(distinct user_id) BU
from instacart.orders;

-- 3) 상품별 주문 건수
select *
from instacart.order_products op 
left
join instacart.products p -- leftjoin : 합집합
on op.product_id = p.product_id ;

select p.product_name,
count(distinct op.order_id) f
from instacart.order_products op 
left
join instacart.products p 
on op.product_id  = p.product_id 
group by 1;

-- 4) 카트에 가장 먼저 넣는 상품 10개
-- case when x = y then a else b end
-- : 조건 x  =y 가 true 일 경우 a 이고 그렇지 않으면 b

-- case when x < y then a when x = y then b else c end
-- : 조건 x<y 가 true 일 경우 a 로, 조건 x = y 일 경우엔 b 로 그렇지 않으면 c 로 변경

-- case XYZ when 'foo' then 'moo' else 'bar' end
-- :  XYZ 가 foo  일 경우  moo 로 변경,  그렇지 않으면  bar   로 변경
select product_id,
case when add_to_cart_order = 1 then 1 else 0 end F_1st 
from instacart.order_products op ;

-- select row_number() over(partition by 그룹핑할 칼럼 order by 정렬할 칼럼)
-- from 테이블명
-- (order by 정렬할 칼럼 asc가 디폴트값)- partition by에 지정한 칼럼 기준 그룹핑
-- order by 지정한 칼럼 기준으로 정렬해준 다음
-- row_number 행마다 순서 매기기
select *,
row_number() over(order by F_1st desc) rnk
from
(select product_id,
sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
from instacart.order_products
group
by 1) ;

-- rank 대신 order by 사용
select product_id,
sum(case when add_to_cart_order = 1 then 1 else 0 end) F_1st
from instacart.order_products
group
by 1
order by 2 desc limit 10;

-- 5) 시간별 주문 건수 (orderhourofday로 그룹핑 후 id 카운트)
select order_hour_of_day,
count(distinct order_id) f
from instacart.orders 
group by 1
order by 1;

-- 6) 첫 구매 후 다음 구매까지 걸린 평균 일수
select avg(days_since_prior_order) avg_recency 
from instacart.orders 
where order_number = 2;

-- 7) 주문건당 평균 구매 상품수 (UPT, unit per transaction)
select count(product_id)/count(distinct order_id) upt
from instacart.order_products ;

-- 8) 인당 평균 주문건수
select count(distinct order_id)/count(distinct user_id) avg_f 
from instacart.orders;

-- 9) 재구매율이 가장 높은 상품 10개
--상품별 재구매율 계산
select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products 
group by 1;

--순위 생성,
select *,
row_number() over(order by ret_ratio)
from instacart.order_products 
(select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products 
group by 1) a
; 
-- top10 추출(ORDER BY 사용)
select *
from 
(select *,
row_number() over(order by ret_ratio) rnk
from 
(select product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products 
group by 1) a) a
where rnk between 1 and 10
;

-- 10) Department별 재구매율 가장 높은 상품 10개
select * 
from
(select *,
row_number() over(order by ret_ratio desc) rnk
from
(select d.department,
product_id,
sum(case when reordered = 1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products a
left join
instacart.products p 
on a.product_id = p.product_id 
left join 
instacart.departments d 
on p.department_id = d.department_id 
group by 1,2) a) a
where rnk between 1 and 10;