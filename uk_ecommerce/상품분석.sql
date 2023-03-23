--1. 판매 수량이 20% 이상 증가한 상품 리스트
--## 2011년 판매 수량 증가한 상품 계산
select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1, 4) = '2011' 
group by 1;
--##2010년도 상품별 판매 수량
select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1, 4) = '2010' 
group by 1;

--## 두 테이블 left join 
select *
from 
(select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1, 4) = '2011' 
group by 1) a
left join 
(select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1,4) = '2010'
group by 1) b
on a.StockCode = b.StockCode;

--##2011년 판매 수량, 2010년 판매 수량 // ** 증가율 계산 **
select a.StockCode,
a.qty,
b.qty,
a.qty/b.qty-1 qty_increase_rate
from 
(select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1, 4) = '2011' 
group by 1) a
left join 
(select StockCode,
sum(Quantity) qty
from clothes.dataset3 
where substr(InvoiceDate, 1,4) = '2010'
group by 1) b
on a.StockCode = b.StockCode
;

--3. 기존 고객의 2011년 월 누적 리텐션
--##기존고객(최초 구매 연도가 2010년인 고객) 리스트
select CustomerID
from clothes.dataset3 
group by 1
having min(substr(InvoiceDate,1,4)) = '2010';

--##기존 고객들의 2011년 구매 내역 조회
select *
from clothes.dataset3 
where CustomerID in 
(select CustomerID
from clothes.dataset3 
group by 1
having min(substr(InvoiceDate,1,4)) = '2010')
and substr(InvoiceDate,1,4) = '2011'; 

--#기존고객들의 2011년 첫 구매 년월
select CustomerID,
substr(InvoiceDate,1,7) mm 
from 
(select *
from clothes.dataset3
where CustomerID in
(select CustomerID
from clothes.dataset3
group by 1
having min(substr(InvoiceDate,1,4)) = '2010')
and substr(InvoiceDate,1,4) = '2011') a
group by 1;