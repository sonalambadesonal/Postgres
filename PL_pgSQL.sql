--PL/pgSQL

SELECT $$I'm a string constant that contains a backslash \$$;

SELECT $message$I'm a string constant that contains a backslash \$message$;
--Using escape 
do
 'declare
 	film_count integer;
begin
    SELECT count(*) into film_count
	from film;
	raise notice ''The number of films: %'', film_count;
end;';

--Using Doller $$ quote
do
$$
declare
	film_count integer;
begin
	select count(*) into film_count
	from film;
	raise notice 'The number of films: %', film_count;
end;
$$

--create function with escape (by singal quotes)

create function find_film_by_id(
	id int
)returns film
language sql
as
  'select * from film
   where film_id = id';
   
-- create funtion with Doller $$ quote

create function find_film_by_id_doller_quote(
	id int
) returns film
language sql
as
$$
  select * from film
  where film_id = id;
$$;

-- block structure
do $$
 <<first_block>>
declare
	film_count integer := 0;
begin
	-- get the number of films
	select count(*)
	into film_count
	from film;
	-- display a message
	raise notice 'The number of films is %', film_count;
end first_block $$;

-- Variables

do $$
declare
	counter integer := 1;
	first_name varchar(50) := 'John';
	last_name varchar(50) := 'Doe';
	payment numeric(11,2) := 20.5;
begin 
	raise notice '% % % has been paid % USD',
		counter,first_name, last_name, payment;
end $$;

do $$
declare
	created_at time := now();
begin
 	raise notice '%', created_at;
	perform pg_sleep(10);
	raise notice '%', created_at;
end $$;
   
-- Copying Data Tyoes

do $$
declare
	film_title film.title%type;
	featured_title film_title%type;
begin
	-- get title of the film id 100
	select title
	from film 
	into film_title
	where film_id = 100;
	
	-- show the film title
	raise notice 'Film title id 100: %s', film_title;
end $$;

-- Variables in block and subblock

do $$
	<<outer_block>>
declare
	counter integer := 0;
begin
	counter := counter + 1;
	raise notice 'The current value of the counter is %', counter;
	
	declare
		counter integer := 0;
	begin 
		counter := counter + 10;
		raise notice 'Counter Value in the subblock is %', counter;
		raise notice 'Counter Value in Outer Block is %', outer_block.counter;
	end;
	
	raise notice 'Counter value in Outer block is %', counter;
end outer_block $$;

-- Select into
do $$
declare
	actor_count integer;
begin
	-- select the number of actores from the actor table
	select count(*)
	into actor_count
	from actor;
	
	--show the number of actors
	raise notice 'The number of actors: %', actor_count;
end; $$

-- Row Types

do $$
declare
	selected_actor actor%rowtype;
begin
	--select actor with id 10
	select *
	from actor
	into selected_actor
	where actor_id = 10;
	
	--Show the number of actor
	raise notice 'The actor name is % %', selected_actor.first_name, selected_actor.last_name;
end; $$

-- Record Types
do $$
declare
	rec record;
begin
	select film_id, title, length
	from film
	into rec
	where film_id = 200;
	
	raise notice '% % %', rec.film_id, rec.title, rec.length;
end; $$
language plpgsql;

do $$
declare
	rec record;
begin
	for rec in select title, length
				from film
				where length > 50
				order by length
	loop
		
		raise notice '% (%)', rec.title, rec.length;
	
	end loop;
end; $$

-- Constants
do $$
declare
	vat constant numeric := 0.1;
	net_price numeric := 20.5;
begin
	raise notice 'The selling price is %', net_price * (1 + vat);
end $$;

do $$
declare
	vat constant numeric := 0.1;
	net_price numeric := 20.5;
begin
	raise notice 'The selling price is %', net_price * (1 + vat);
	vat := 0.5;
end $$;

do $$
declare
	start_at constant time := now();
begin
	raise notice 'Start excuting block at %', start_at;
end $$;

-- Errors And Messages

do $$
begin
	raise info 'information message %', now();
	raise log 'log message %', now();
	raise debug 'debug message %', now();
	raise warning 'warning message %', now();
	raise notice 'notice message %', now();
end $$;

do $$
declare
	email varchar(255) := 'info@postgressqltutorial.com';
begin
	raise exception 'duplicate email: %', email using hint = 'check the email again';
end $$

do $$
begin
	raise sqlstate '2201B';
end $$;

do $$
begin
	raise invalid_regular_expression;
end $$

-- Assert Statement

do $$
declare
	film_count integer;
begin
	select count(*)
	from film
	into film_count;
	
	assert film_count > 0, 'Film not found, check the film table';
end $$;

do $$
declare
	film_count integer;
begin
	select count(*)
	into film_count
	from film;
	
	assert film_count > 1000, '1000 film found, check the film table';
end $$;

-- If Statment

do $$
declare
	selected_film film%rowtype;
	input_film_id film.film_id%type := 0;
begin
	select * from film
	into selected_film 
	where film_id = input_film_id;
	
	if not found then
		raise notice 'the film % could not be found', input_film_id;
	end if;
end $$;

do $$
declare
	selected_film film%rowtype;
	input_film_id film.film_id%type := 100;
begin
	select * from film
	into selected_film
	where film_id = input_film_id;
	
	if not found then
		raise notice 'the film % could not be found', input_film_id;
	else 
		raise notice 'the film % is found', selected_film.title;
	end if;
end $$;

do $$
declare
	v_film film%rowtype;
	len_description varchar(100);
begin
	select * from film
	into v_film
	where film_id = 100;
	
	if not found then
		raise notice 'Film not Found';
	else
		if v_film.length >0 and v_film.length <= 50 then
			len_description := 'Short';
		elseif v_film.length > 50 and v_film.length <= 120 then
			len_description := 'Medium';
		elseif v_film.length > 120 then
			len_description := 'Long';
		else
			len_description := 'N/A';
		end if;
		
		raise notice 'The % film is %', v_film.title, len_description;
		
	end if;
	
end $$;

-- Case Statement

do $$
declare
	rate film.rental_rate%type;
	price_segment varchar(50);
begin
	select rental_rate into rate
	from film
	where film_id = 100;
	
		-- assign the price segment
		if found then
			case rate
				when 0.99 then
				price_segment = 'Mass';
				when 2.99 then
				price_segment = 'Mainstream';
				when 4.99 then
				price_segment = 'High End';
				else
				price_segment = 'Unspecified';
			end case;
			raise notice '%',price_segment;
		end if;
end $$;

--Searched case statement

do $$
declare
	total_payment numeric;
	service_level varchar(25);
begin
	select sum(amount) into total_payment
	from payment
	where customer_id = 100;
	
	if found then
		case
			when total_payment > 200 then
			service_level = 'Platinum';
			when total_payment > 100 then
			service_level = 'Gold';
			else
				service_level = 'Silver';
		end case;
		raise notice 'Service Level: %', service_level;
	else
		raise notice 'Customer not found';
	end if;
end $$;
	
--Loop Statement

do $$
declare
	n integer := 10;
	fib integer := 0;
	counter integer := 0;
	i integer := 0;
	j integer := 1;
begin
	if (n > 1) then
		fib := 0;
	end if;
	loop
		exit when counter = n;
		counter := counter + 1;
		raise notice '% %', i,j;
		select j, i+j into i, j;
	end loop;
	fib := i;
	raise notice '%', fib;
end $$;

-- While Loop

do $$
declare
	counter integer := 0;
begin
	while counter < 5 loop
		raise notice 'Counter %', counter;
			counter := counter + 1;
	end loop;
end $$;


-- For Loop
do $$
begin
	for counter in 1..5 loop
		raise notice 'Counter: %', counter;
	end loop;
end $$;

do $$
begin
	for counter in reverse 5..1 loop
		raise notice  'Counter : %', counter;
	end loop;
end $$;

do $$
begin
	for counter in 1..6 by 2 loop
		raise notice 'Counter : %', counter;
	end loop;
end $$;

do $$
begin
	for counter in reverse 6..1 by 2 loop
		raise notice 'Counter : %', counter;
	end loop;
end $$;

-- for loop iterate over result set.

do $$
declare
	f record;
begin
	for f in select title, length
			from film
			order by length desc, title
			limit 10
	loop
		raise notice '%(% mins)', f.title, f.length;
	end loop;
end $$;

-- for loop iterate over result set of a dynamic query
-- 1.select title, release_year from film order by title limit 1;
--2. select title, release_year from film order by release_year limit 1;

do $$
declare
	-- sort by 1:title, 2:release year
	sort_type smallint  := 1;
	-- return the number of films
	rec_count int := 10;
	-- use the iterate over the film
	rec record;
	-- dynamic query
	query text;
begin
	query := 'select title, release_year from film';
	
	if sort_type = 1 then
		query := query || ' order by title';
	elseif sort_type = 2 then
		query := query ||  ' order by release_year';
	else
		raise 'invalid sort type %s', sort_type;
	end if;
	
	query := query || ' Limit $1';
	
	for rec in execute query using rec_count loop
		raise notice '% - %', rec.release_year, rec.title;
	end loop;
end $$;

--Exit Statment

do $$
declare
	i int := 0;
	j int := 0;
begin
	<<outer_loop>>
	loop
		i = i + 1;
		exit  when i > 3;
			-- inner loop
			j = 0;
			<<inner_loop>>
			loop
				j = j + 1;
				exit when j > 3;
				raise notice '(i,j): % %', i,j;
			end loop inner_loop;
	end loop outer_loop;
end $$;

do $$
declare
	i int := 0;
	j int := 0;
begin
	<<outer_loop>>
	loop
		i = i + 1;
		exit  when i > 3;
			-- inner loop
			j := 0;
			<<inner_loop>>
			loop
				j = j + i;
				exit inner_loop when j > i;
				raise notice '(i,j): (% %)', i,j;
			end loop inner_loop;
	end loop outer_loop;
end $$;
	
do $$
begin
	<<simple_block>>
	begin
		exit simple_block;
		-- for demo purposes
		raise notice '%', 'Unreachable!';
	end;
	raise notice '%', 'End of block';
end $$;

--Continue

do $$
declare
	counter int := 0;
begin
	loop
		counter = counter + 1;
		-- exit the loop when counter > 10
		exit when counter > 10;
		-- skip the current iteration if counter is an even number.
		continue when mod(counter,2) = 0;
		-- print out the counter,
		raise notice '%', counter;
	end loop;
end $$;


-- User-defined functions

-- create function

create function get_film_count(len_from int, len_to int)
returns int
language plpgsql
as
$$
declare
	film_count integer;
begin
	select count(*)
	from film
	into film_count
	where length between len_from and len_to;
	
	return film_count;
end $$;
	
select get_film_count(40, 90);

select get_film_count(len_from => 40, len_to => 90);

select get_film_count(40, len_to => 90);

select get_film_count(len_from => 40, 90);


-- Function Parameter Modes: IN, OUT, INOUT

create or replace function find_film_by_id(p_film_id int)
returns varchar
language plpgsql
as $$
declare
	film_title film.title%type;
begin
	select title
	into film_title
	from film
	where film_id = p_film_id;
	
	if not found then
		raise 'Film with id % not found', p_film_id;
	end if;
	
	return film_title;
	
end $$;

select * from film;

select find_film_by_id(133);


---------

create or replace function get_film_stat(
	out min_len int,
	out max_len int,
	out avg_len numeric)
language plpgsql
as $$
begin
	select min(length),
			max(length),
			avg(length):: numeric(5,1)
	into min_len, max_len, avg_len
	from film;
end $$;

select get_film_stat();

select * from get_film_stat();

----

create or replace function swap(
	inout x int,
	inout y int
)
language plpgsql
as $$
begin
	select x,y into y,x;
end $$;

select swap(10,20);

-- Function Overloading

create or replace function get_rental_duration(
	p_customer_id integer
)
returns integer
language plpgsql
as $$
declare
	rental_duration integer;
begin
	select
		sum(extract(day from return_date - rental_date))
	into rental_duration
	from rental
	where customer_id = p_customer_id;
	return rental_duration;
end $$;

select * from get_rental_duration(509);

select * from rental;

-----

create or replace function get_rental_duration(
	p_customer_id integer,
	p_from_date date
)

returns integer
language plpgsql
as $$
declare
	rental_duration integer;
begin
	-- get the rental duration based on customer_id
	-- and rental date
	
	select sum(extract(day from return_date + '12:00:00' - rental_date))
	into rental_duration
	from rental
	where customer_id = p_customer_id and rental_date >= p_from_date;
	return rental_duration;
end $$;

select get_rental_duration(232, '2005-07-01');
	
-- function overloading and defualt parameter

create or replace function get_rental_duration(
	p_customer_id integer,
	p_from_date date default '2005-01-01'
)
returns integer
language plpgsql
as $$
declare
	rental_duration integer;
begin
	select sum(extract(day from return_date + '12:00:00' - rental_date))
	into rental_duration
	from rental
	where customer_id = p_customer_id and rental_date >= p_from_date;
	return rental_duration;
end $$;

select get_rental_duration(232,'2005-07-01');

-------------------------------------------------

--Function That Returns a Table

create or replace function get_film (
	p_pattern varchar
)

returns table (
	film_title varchar,
	film_release_year int
)

language plpgsql
as $$
begin
	return query
		select title, release_year::integer
		from film
		where title ilike p_pattern;
end $$;

select get_film('aL%');
	
DROP FUNCTION get_film(p_pattern varchar);

select * from get_film('Al%');

-- Function overloading example.

create or replace function get_film(
	p_pattern varchar,
	p_year int
)
returns table (
	film_title varchar,
	film_release_year int
)
language plpgsql
as $$
declare
	var_r record;
begin 
	for var_r in(
		select title, release_year
		from film
		where title ilike p_pattern and release_year = p_year
	)loop film_title := upper(var_r.title);
		film_release_year := var_r.release_year;
	return next;
	end loop;
end $$;

select * from get_film('AL%', 2006);

----------------------------------------------

-- Drop Function

create or replace function get_film_actors()
	returns setof record
as $$
declare
	rec record;
begin
	for rec in select film_id, title,
			(first_name || '' || last_name)::varchar
			from film
			inner join film_actor using(film_id)
			inner join actor using(actor_id)
			order by title
	loop
	return next  rec;
	end loop;
end; $$
language plpgsql;


create or replace function get_film_actors(p_film_id int)
	returns setof record
as $$
declare
	rec record;
begin
	for rec in select film_id, title,
	  		(first_name || '' || last_name)::varchar
			from film
			inner join film_actor using(film_id)
			inner join actor using(actor_id)
			where film_id =p_film_id
			order by title
	loop
	return next rec;
	end loop;
end; $$
language plpgsql;

drop function get_film_actors;

drop function get_film_actors();



























