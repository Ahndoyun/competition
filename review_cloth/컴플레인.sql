-- 1. Department name, Clothing Name별 평균 평점 계산
select `Department Name`,
'Clothing ID',
avg(Rating) avg_rate
from clothes.dataset2 
group by 1,2;

-- 2. Department별 순위 생성
-- 위의 표를 바탕으로 department 내에서 평균 평점을 기준으로 순위 매기기
-- 3. 1~10위 데이터 조회
select *
from 
(select *,
row_number() over(partition by `Department Name` -- row number로 rank생성
order by avg_rate) rnk
from  (
select `Department Name`, `Clothing ID`,
avg(Rating) avg_rate
from clothes.dataset2 
group by 1,2) A) A
where rnk <=10;

-- 1) Department별 평균 평점이 낮은 10개 상품
--* *temporary table 생성
--** 위의 테이블에서 bottom 평점이 낮은 clothing id 추출
select `Clothing ID`
from clothes.stat
where `Department Name` = 'Bottoms';

-- Clothing ID 리뷰 내용 조회
select *
from clothes.dataset2 
where `Clothing ID` in 
(select `Clothing ID`
from clothes.stat
where `Department Name` = 'Bottoms'
)
order by `Clothing ID`;

-- 4. 연령별 worst Department
-- Department Name, Age 그룹핑, 평점을 평균화
select `Department Name`, 
floor(age/10)*10 ageband,
avg(Rating) avg_rating
from clothes.dataset2 
group by 1,2;

-- 낮은 연령대 순으로 정렬, 낮은 rating 순으로 정렬,순위 매기기
-- (row number over partition by ~ )
select *,
row_number() over(partition by ageband order by avg_rating) rnk
from
(select `Department Name`,
floor(age/10)*10 ageband,
avg(Rating) avg_rating
from clothes.dataset2 
group by 1,2) a;

-- 연령별로 가장 낮은 평점 준 데이터 조회
select *
from 
(select *,
row_number() over(partition by ageband order by avg_rating) rnk
from
(select `Department Name`,
floor(age/10)*10 ageband,
avg(Rating) avg_rating
from clothes.dataset2 
group by 1,2) a) a
where rnk = 1;

