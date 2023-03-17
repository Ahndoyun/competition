-- 재구매 비중이 높은 상품


-- 재구매 비중(%)과 주문 건수 계산
select product_id,
sum(reordered)/sum(1) reorder_rate,
count(distinct order_id) f
from instacart.order_products 
group by product_id 
order by reorder_rate desc 

-- 주문 건수가 10건 이하인 상품 제외 (having 절 사용)
select a.product_id,
sum(reordered)/sum(1) reorder_rate,
count(distinct order_id) f
from instacart.order_products a
left join instacart.products b 
on a.product_id = b.product_id 
group by product_id 
having count(distinct order_id) > 10 

-- 상품별 재구매 비중과 주문 건수 계산
select a.product_id,
b.product_name,
sum(reordered)/sum(1) reorder_rate,
count(distinct order_id) f
from instacart.order_products a
left join instacart.products b
on a.product_id = b.product_id 
group by product_id, b.product_name 
having count(distinct order_id) > 10