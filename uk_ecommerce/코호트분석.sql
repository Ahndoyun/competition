-- 첫 구매 월, 가입 월, 구매 월 기준으로 시간의 흐름에 따른 변화
-- 1) 첫 구매월 기준으로 그룹 간의 패턴 분석
-- # 고객별 첫 구매일
select CustomerID,
min(InvoiceDate) mndt
from clothes.dataset3 
group by 1;

-- # 각 고객의 주문 일자, 구매액 조회
select CustomerID,
InvoiceDate, 
UnitPrice * Quantity sales
from clothes.dataset3;

-- #첫 번째 구매했던 고객별 첫 구매월 테이블에 고객의 구매 내역 join
select *
from
(select CustomerID,
min(InvoiceDate) mndt
from clothes.dataset3
group by 1) a 
left join
(select CustomerID,
InvoiceDate,
UnitPrice * Quantity sales
from clothes.dataset3) b 
on a.CustomerID = b.CustomerID ; -- mndt : 각 고객의 최초 구매 일
                                 -- datediff : 첫 구매 이후 몇 개월 뒤에 구매했는지
select substr(mndt,1,7) mm,
timestampdiff(month, mndt, InvoiceDate) datediff, -- timestamp: 시간 차이 계산 달 시 분 초 등
count(distinct a.CustomerID) bu,
sum(Sales) sales
from
(select CustomerID,
min(InvoiceDate) mndt
from clothes.dataset3
group by 1) a
left join
(select customerid,
InvoiceDate,
UnitPrice * Quantity sales
from clothes.dataset3) b
on a.CustomerID= b.CustomerID 
group by 1,2