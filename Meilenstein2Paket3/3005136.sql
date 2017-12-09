-- 1. Nachnamen die mit A, B oder C beginnen
select last_name as Nachnamen from customer where last_name like 'A%' or last_name like 'B%' or last_name like 'C%';

-- 2. Nur aktive Kunden in Form: Firstname Lastname
select CONCAT_WS(' ',first_name, last_name) as Namen from customer where active = 1;

-- 3. 10 kürzeste Emails
select customer_id, email from customer order by email asc limit 10;

-- 4. Anzahl der Kunden pro Store
select store_id, COUNT(customer_id) as 'Anzahl der Kunden' from customer group by store_id;

-- 5. Filme mit rating G und unter 1$
select film_id, title, rental_rate from film where rating = 'G' and rental_rate < 1;

-- 6. Anzahl der im Geschäft verfügbaren Kopien
select f.film_id, f.title, f.rental_rate, COUNT(f.film_id) as 'Anzahl der Kopien'
	from film as f join inventory as i on f.film_id = i.film_id 
		where f.rating = 'G' and f.rental_rate < 1 and i.store_id = 1 group by f.film_id;

-- 7. Verfügbare Kopien pro Store und rating
select i.store_id, f.rating, COUNT(f.film_id) as 'Anzahl der Kopien'
	from film as f join inventory as i on f.film_id = i.film_id 
		group by i.store_id, f.rating order by i.store_id, f.rating asc;

-- 8. Category Children aber rating nicht geeignet für Kinder
select f.film_id, f.rating, f.title from film as f 
	join film_category as fc on f.film_id = fc.film_id
	join category as c on fc.category_id = c.category_id
		where c.name = 'Children' and (f.rating = 'R' or f.rating = 'NC-17');

-- 9. Kundendaten deutscher Kunden ausgeben
select c.customer_id, c.first_name, c.last_name, c.email, a.address, a.postal_code, ci.city from customer as c
	join address as a on a.address_id = c.address_id
	join city as ci on a.city_id = ci.city_id
	join country as co on co.country_id = ci.country_id
		where co.country = 'Germany';

-- 10. Anzahl der Kunden pro Land mit mind. 30 Kunden
select co.country, COUNT(c.customer_id) as 'Anzahl der Kunden' from customer as c
	join address as a on a.address_id = c.address_id
	join city as ci on a.city_id = ci.city_id
	join country as co on co.country_id = ci.country_id
		group by co.country_id
			having COUNT(c.customer_id) >= 30;

-- 11. Zahlungen der Kunden pro Monat
select c.first_name, c.last_name, MONTHNAME(p.payment_date), SUM(p.amount) from payment as p 
	join customer as c on c.customer_id = p.customer_id
	join rental as r on r.rental_id = p.rental_id
		where p.payment_date < '2005-07-01 00:00:00'
		group by c.customer_id, MONTHNAME(p.payment_date)
		order by MONTHNAME(p.payment_date) desc, SUM(p.amount) desc;

-- 12. Umsatzstärkster Monat
select MONTHNAME(p.payment_date) as Monat, SUM(p.amount) as Umastz from payment as p
	group by MONTHNAME(p.payment_date)
	order by SUM(p.amount) desc limit 1;
	
-- 13. Umsatz je Kategorie je Store
select c.name as 'Kategorie', i.store_id as 'Store', SUM(p.amount) as 'Umsatz' from payment as p 
	join rental as r on r.rental_id=p.rental_id
	join inventory as i on i.inventory_id=r.inventory_id
	join film as f on f.film_id=i.film_id
	join film_category as fc on fc.film_id=f.film_id
	join category as c on c.category_id=fc.category_id
		group by c.name;
		
-- 14. Staff supervisors Auflistung
with recursive supervisor as (
select * from staff where staff_id=6
union
select s.* from staff as s, supervisor as su
where s.staff_id=su.supervisor_id
)
select * from supervisor;		
	
-- 15. Detailinfos zu staff Tabelle ohne NOT NULL Spalten
show columns from sakila.staff where `Null`='YES';
	


