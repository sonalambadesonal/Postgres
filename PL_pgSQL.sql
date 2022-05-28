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
































