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


