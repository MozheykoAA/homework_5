--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as

select model, 
	row_number() over (partition by page) as num_product,	
	page
from (select model, 
	    case 						
		when num_model % 2 = 0 then num_model/2
		else num_model/2 + 1
	    end as page
	from		
	    (select model,
		row_number() over (order by model) as num_model
	    from product) num_model
	) pages;


select l.*,
	num_product,
	page
from pages_all_products pall join laptop l on pall.model = l.model		
order by model


--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������, ���, ������� (%)


create view distribution_by_type as

select distinct(maker), 
	type,
	(cast(count(model) over (partition by maker, type) as numeric) / cast(count(model) over () as numeric)) * 100 	as percent
from product
order by 1;

select *
from distribution_by_type


--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������. ������ https://plotly.com/python/histograms/



--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����

create table ships_two_words as

select *
from ships
where name like '% %' and name not like '% % %';

select *
from ships_two_words


--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

with all_ships as			
(select name, class
from ships
union
select ship, null 
from outcomes)

select name
from all_ships
where class is null
	and name like 'S%'


--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������).
-- ������� model

select pr.model											
from product p join printer pr on p.model = pr.model 
where maker = 'A'
	and price > (select avg(price)
		    from product p join printer pr on p.model = pr.model 
		    where maker = 'C')		
union 

select model 
from (select model, 
	     price,
	     row_number() over (order by price desc)	as price_rank
      from printer) price_rank
where price_rank <= 3		



