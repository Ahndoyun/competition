-- 1)RFM : 가치 있는 고객 추출, 이를 기준으로 고객 분류
-- #Recency: 최근에 구입한 시기
-- #frequency: 어느 정도로 자주 구입했는지?
-- #Monetary: 구입한 총 금액

--#고객의 마지막 구매일 출력
select CustomerId,
max(InvoiceDate) mndt
from clothes.dataset3 
group by 1;  -- 2011년 12월 2일

--#가장 최근 날짜로부터 TIMER INTERVAL시간 차이 계산
-- ##1. RECENCY (얼마나 최근에 구매했는지)
select CustomerID,
datediff('2011-12-02', mxdt) recency
from
(select CustomerID,
max(InvoiceDate) mxdt 
from clothes.dataset3 
group by 1) a;

-- #재구매 segment
-- #고객별, 상품별, 구매연도 카운트
select CustomerID, StockCode, 
count(distinct substr(InvoiceDate,1,4)) unique_yy
from clothes.dataset3 
group by 1,2;

-- ## unique_yy가 2 이상인 고객 : 2년에 걸쳐 구매 (재구매 고객)
select CustomerId,
max(unique_yy) mx_unique_yy
from
(select CustomerID,
StockCode,
count(distinct substr(InvoiceDate,1,4)) unique_yy
from clothes.dataset3
group by 1,2
)a
group by 1;

-- unique_yy가 2 이상인 고객과 그렇지 않은 고객 구분
select CustomerID,
case when mx_unique_yy >= 2 then 1 else 0 end repurchase_segment
from
(select CustomerId,
max(unique_yy) mx_unique_yy
from
(select CustomerID,
StockCode,
count(distinct substr(InvoiceDate,1,4)) unique_yy
from clothes.dataset3
group by 1,2
)a
group by 1) a
group by 1;

-- 일자별 첫 구매자 수
--1) 고객별 첫 구매일
select CustomerID,
min(InvoiceDate) mndt
from clothes.dataset3
group by CustomerID ;

--2) 일자별 첫 구매자 수
select mndt,
count(distinct CustomerID) bu
from 
(select CustomerID,
min(InvoiceDate) mndt
from clothes.dataset3 
group by CustomerID)a
group by mndt ;

-- 상품별 첫 구매자 수 
--1) 고객별, 상품별 첫 구매 일자
select CustomerID,
StockCode,
min(InvoiceDate) mndt
from clothes.dataset3 
group by 1,2;
--2) 고객별 구매와 기준 순위 생성 (rank)
select *,
row_number() over(partition by CustomerID order by mndt) rnk
from 
(select CustomerID,
StockCode,
min(InvoiceDate) mndt
from clothes.dataset3 
group by 1,2) a;

--3) 고객별 첫 구매 내역 조회
select *
from 
(select *,
row_number() over(partition by customerid order by mndt) rnk
from 
(select CustomerID,
StockCode,
min(InvoiceDate) mndt
from clothes.dataset3 
group by 1,2) a) a
where rnk = 1
;
--4) 상품별 첫 구매 고객 수 집계
select StockCode,
count(distinct customerid) first_bu
from
(select * 
from 
(select *,
row_number() over(partition by customerid order by mndt) rnk
from 
(select CustomerID,
StockCode,
min(InvoiceDate) mndt 
from clothes.dataset3
group by 1,2) a) a
where rnk = 1) a
group by StockCode
order by 2 desc;

--5) 첫 구매 후 이탈하는 고객
--# 고객별로 구매 일자 중복 제거 카운트, 1의 갑은 첫 구매하고 이탈한 고객
--##구매일자 중복제거, id 추출
select CustomerID,
count(distinct InvoiceDate) f_date
from clothes.dataset3 
group by 1;

--## 1의 값을 가지는 고객 count, 나누기 전체 고객 수
--(sum(1) = 전체 고객수) 
select sum(case when f_date = 1 then 1 else 0 end)/sum(1) bounc_rate
from 
(select CustomerID,
count(distinct InvoiceDate) f_date
from clothes.dataset3 
group by 1) a; --#0.3005

-- #국가별 첫 구매 후 이탈 고객 비중
select Country,
sum(case when f_date = 1 then 1 else 0 end)/sum(1) bounc_rate
from
(select CustomerID,
Country,
count(distinct InvoiceDate) f_date
from clothes.dataset3 
group by 1,2) a
group by 1
order by Country;