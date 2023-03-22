-- 1) size 관련 리뷰 내용 yes or no 조회
select `Review Text`,
case when`Review Text` like '%size%' then 1 else 0 end size_yn
from clothes.dataset2 ;

--size가 포함된 리뷰 수 / 전체 리뷰 수
select sum(case when `Review Text` like '%size%' then 1 else 0 end) n_size,
count(*) n_total
from clothes.dataset2 ; -- 7388, 23486

-- 각종 text 포함 리뷰 개수 출력 (size 관련)
select sum(case when `Review Text` like '%size%' then 1 else 0 end) n_size, --7388
sum(case when `Review Text` like '%large%' then 1 else 0 end) n_large, --2921
sum(case when `Review Text` like '%loose%' then 1 else 0 end) n_loose, --1341
sum(case when `Review Text` like '%small%' then 1 else 0 end) n_small, --4283
sum(case when `Review Text` like '%tight%' then 1 else 0 end) n_tight, --1752
sum(1) n_total --23486
from clothes.dataset2 ;

-- department name 별로 사이즈 리뷰 분류
select `Department Name`,
sum(case when `Review Text` like '%size%' then 1 else 0 end) n_size,
sum(case when `Review Text` like '%large%' then 1 else 0 end) n_large,
sum(case when `Review Text` like '%loose%' then 1 else 0 end) n_loose,
sum(case when `Review Text` like '%small%' then 1 else 0 end) n_small,
sum(case when `Review Text` like '%tight%' then 1 else 0 end) n_tight,
sum(1) n_total
from clothes.dataset2 
group by 1;

--+연령별 사이즈 리뷰 구문
select floor(Age/10)*10 ageband,
`Department Name`,
sum(case when `Review Text` like '%size%' then 1 else 0 end) n_size,
sum(case when `Review Text` like '%large%' then 1 else 0 end) n_large,
sum(case when `Review Text` like '%loose%' then 1 else 0 end) n_loose,
sum(case when `Review Text` like '%small%' then 1 else 0 end) n_small,
sum(case when `Review Text` like '%tight%' then 1 else 0 end) n_tight,
sum(1) n_total
from clothes.dataset2 
group by 1,2
order by 1,2;

--2. clothing id별 사이즈 리뷰 
--1) 사이즈 관련 리뷰 yes or no
select `Clothing ID`,
sum(case when 'Review Text' like '%size%' then 1 else 0 end) n_size
from clothes.dataset2 
group by 1;

--2) 사이즈 타입 추가한 후 개수 집계 (비율 계산)
select `Clothing ID`,
sum(case when `Review Text` like '%size%' then 1 else 0 end) n_size_t,
sum(case when `Review Text` like '%size%' then 1 else 0 end)/sum(1) n_size,
sum(case when `Review Text` like '%large%' then 1 else 0 end)/sum(1) n_large,
sum(case when `Review Text` like '%loose%' then 1 else 0 end)/sum(1) n_loose,
sum(case when `Review Text` like '%small%' then 1 else 0 end)/sum(1) n_small,
sum(case when `Review Text` like '%tight%' then 1 else 0 end)/sum(1) n_tight
from clothes.dataset2 
group by 1;

create table clothes.size_stat as


