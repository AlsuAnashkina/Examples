#Запрос по категории , отфильтрованный по цене
	select 
	p.product_id,
	p.name, 
	p.description, 
	d.name, 
	p.price 
	from designers d 
	join products p 
		on d.designer_id =p.pr_designer_id 
			where p.pr_category_id =1 
	order by price;


#Подборка новинок
select
	p.name,
	p.description ,
	p.price ,
	d.name 
	from products p
	join designers d 
		on p.pr_designer_id =d.designer_id 
	join storehouses_products sp 
		on sp.product_id =p.product_id 
	where (sp.created_at + interval 3 month) > NOW();


#Подборка бестселлеров
 select 
	product_id, 
	name,
	description,
	price
	from products
	where product_id in 
		(select product_id from 	 (
			select product_id , count(total) as total from orders_products op 
			group by product_id 
			order by total desc
			limit 5) as t) ; #никак не соображу, как выдать запрос без самого count по-другому
		

	
	
#процедура которая меняет статус пользователя в таблице users, если он совершил покупки на общую сумму больше 200000(i)
drop procedure if exists user_type;
DELIMITER //
create procedure user_type (in for_user_id INT)
	begin
		declare i decimal;
		declare t1 decimal;
		set i = 200000; 
		
		set t1 = (
			select sum(tot) from 
				(select op.total*p.price as tot 			#ищу из заказов общую сумму заказов,которые сделал пользователь 
				from orders_products op
				join orders o on op.order_id =o.id 
				join products p on p.product_id =op.product_id 
					where o.user_id=for_user_id) as prod1);
		
		if t1>= i then 
			update users set user_type ='вип' where users_id = for_user_id;
		end if;		
	end//
DELIMITER ;

call user_type(2); 


/*Поборка "Возможно, вам понравится"- когда смотришь, например, черную сумку,
внизу отражаютcя другие товары черных цветов и другие модели сумок*/
drop procedure if exists products_offers;
DELIMITER //
create procedure products_offers (in for_product_id INT)
begin
	#одна категория товара
	select 
	p2.name,
	p2.description ,
	p2.price 
	from products p1
	join products p2
		on p1.pr_category_id =p2.pr_category_id 
	where p1.product_id =for_product_id
		and p2.product_id !=for_product_id
	
		union 
	#один цвет товара	
	select 
	p2.name,
	p2.description ,
	p2.price 
	from products p1
	join products p2
		on p1.pr_colour_id =p2.pr_colour_id 
	where p1.product_id =for_product_id
		and p2.product_id !=for_product_id
	
	order by RAND()
	limit 5;
end//

DELIMITER ;
call products_offers(8);





	
#представление товара на экране когда на него нажмешь
create or replace view prod as select
	p.name , 
	p.description, 
	p.price,
	d.name as designer_name
	from products p 
	join designers d on d.designer_id =p.pr_designer_id;

select * from prod;
	
	 
	 
#представление товара в период распродажи
create or replace view sale as 
select
	p.name,
	round(p.price * d.discount) as sale_price,
	p.description
	from products p
	join discounts d on p.product_id =d.product_id; 
	
select * from sale;	
	
			 
	
#триггер, который перед вставкой в заказ проверяет наличие товара на складе

	 /*не могу понять, почему не работает. если вставить product_id=1 отрабатывает верно, при других значениях 
	  выдает ошибку Subquery returns more than 1 row. Еще не уверена, что он проверяет количество позиций в заказе
	  с количеством позиций на складе одного и того же вида товара. 
	  В общем, недоделанный триггер*/
drop trigger if exists check_storehouse;
DELIMITER //
create trigger check_storehouse before insert on orders_products
for each row 
begin 
	declare total smallint; 
	declare v int;
	set v= (
		select sp.value 
		from storehouses_products sp 
		join orders_products op on sp.product_id =op.product_id
		where sp.product_id=2); #задаю товар
		if new.total > v and new.product_id=2 then  
		 	signal sqlstate '45000' set message_text = 'Товара нет в наличии в таком количестве';
		end if;
end//
DELIMITER ;


start transaction;
insert into orders_products values (14,7,2,4,1);
rollback;

	
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	