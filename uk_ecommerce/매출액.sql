--국가별, 상품별 구매자 수 매출액
--1) 중복제거 아이디별 구매 가격 (내립차순 정렬)
select Country, StockCode,
count(distinct CustomerID) bu,
sum(Quantity*UnitPrice) sales
from clothes.dataset3 
group by 1,2
order by 3 desc, 4 desc;

--특정 상품 구매자가 많이 구매한 상품은?

-- 1) 가장 많이 판매된 2개 상품 조회
--#가장 많이 판매된 상품 순으로 조회
select StockCode,
sum(Quantity) qty
from clothes.dataset3
group by 1;
--#많이 판매된 상품 순으로 rownumber 순위 매기기
select *,
row_number() over(order by qty desc) rnk
from
(select StockCode,
sum(Quantity) qty
from clothes.dataset3 
group by 1) a;
--#랭크가 1,2인 데이터 조회
select StockCode
from
(select *,
row_number() over(order by qty desc) rnk
from
(select StockCode,
sum(Quantity) qty 
from clothes.dataset3 
group by 1) a) a
where rnk between 1 and 2;

-- 2) 가장 많이 판매된 2개 상품을 모두 구매한 구매자가 구매한 상품
create table clothes.bu_list as
select CustomerID
from clothes.dataset3
group by 1
having max(case when StockCode = '84007' then 1 else 0 end) = 1
and max(case when StockCode = '22197' then 1 else 0 end) = 1; --errorrrr

--국가별 재구매율 계산
select a.Country,
substr(a.InvoiceDate, 1, 4) yy, -- 연만 출력
count(distinct b.CustomerID)/count(distinct a.CustomerID) retention_date
from
(select distinct Country,
InvoiceDate, CustomerID
from clothes.dataset3) a
left join
(select distinct Country,
InvoiceDate, CustomerID
from clothes.dataset3) b 
on substr(a.InvoiceDate, 1,4) = substr(b.InvoiceDate, 1,4) -1
and a.Country = b.Country 
and a.CustomerID = b.CustomerID 
group by 1,2
order by 1,2; -- table 연도변환 필요함

