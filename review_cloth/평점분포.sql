-- 1. Division별 평균 평점 계산
-- 1) Division name별 평균 평점
select `Division Name`,
avg(Rating) avg_rate
from clothes.dataset2 d 
group by 1
order by 2 desc; --4.196

-- 2) Department별 평균 평점
select `Department Name`,
avg(Rating) avg_rate
from clothes.dataset2 d 
group by 1
order by 2 desc;  --4.196

-- 3) Trend의 평점 3점 이하 리뷰
select *
from clothes.dataset2 
where `Department Name` = 'Trend'
and Rating <=3 ;

-- 4) 평점 3점 이하 리뷰의 연령 분포
-- * 연령대 구분(10대별로)
select case when Age between 0 and 9 then '0009'
when Age between 10 and 19 then '1019'
when Age between 20 and 29 then '2029'
when Age between 30 and 39 then '3039'
when Age between 40 and 49 then '4049'
when Age between 50 and 59 then '5059'
when Age between 60 and 69 then '6069'
when Age between 70 and 79 then '7079'
when Age between 80 and 89 then '8089'
when Age between 90 and 99 then '9099' end ageband,
Age
from clothes.dataset2 
where `Department Name` = 'Trend'
and Rating <=3;

-- *연령대 구분 (floor 함수 사용) *****
select floor(age/10)*10 ageband,
Age
from clothes.dataset2 
where `Department Name` = 'Trend'
and Rating <= 3;
-- Trend의 평점 3점 이하 리뷰의 연령 분포
select floor(age/10)*10 ageband,
count(*) cnt 
from clothes.dataset2 
where `Department Name` = 'Trend'
and Rating <= 3
group by 1
order by 2 desc;
-- ageband  cnt
-- 40	13
-- 50	10
-- 30	8
-- 20	5
-- 60	4
-- 70	1

-- 5) Department별 연령별 리뷰 수
select floor(Age/10)*10 ageband,
count(*) cnt
from clothes.dataset2 
where `Department Name` = 'Trend'
group by 1
order by 2 desc ;

-- 6) 50대 3점 이하 Trend 리뷰
select *
from clothes.dataset2 
where `Department Name` = 'Trend'
and Rating <= 3
and Age between 50 and 59 limit 10; --limit : head처럼 10개 출력