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































