USE sakila;

-- 1 --
-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
drop procedure if exists nr_of_actions_movies;
-- Create stored procedure  
delimiter //
create procedure nr_of_actions_movies ()
begin
select first_name, last_name, email, name
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end;
//
delimiter ;

call nr_of_actions_movies();
#select @x as 'First name',@y as 'Last name', @z as 'Email';

-- 2 --
-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that 
-- it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.
drop procedure if exists nr_of_actions_movies;
-- Create stored procedure  
delimiter //
create procedure nr_of_actions_movies (in param1 varchar(25))
begin
select first_name, last_name, email, name
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = param1
  group by first_name, last_name, email;
end;
//
delimiter ;

call nr_of_actions_movies('Children');

#select name from category;

-- 3 --
-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure 
-- to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
-- step 1 --
select c.name, count(f.film_id) as nr_of_movies
from film_category f
	join category c on f.category_id = c.category_id
group by c.name
having nr_of_movies > 65
order  by nr_of_movies desc;

-- step 2 --
drop procedure if exists movie_categories;
-- Create stored procedure  
delimiter //
create procedure movie_categories (in param1 int)
begin
	select c.name, count(f.film_id) as nr_of_movies
	from film_category f
		join category c on f.category_id = c.category_id
	group by c.name
	having nr_of_movies > param1
	order  by nr_of_movies desc;
end;
//
delimiter ;

call movie_categories(65);










