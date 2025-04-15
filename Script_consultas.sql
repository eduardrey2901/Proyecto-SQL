-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
select f.title
from film f
where f.rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40
select concat(a.first_name, ' ', a.last_name)
from actor a
where "actor_id" between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select f.title 
from film f
where f.original_language_id = f.language_id;
-- Todos los original_language_id son NULL

-- 5. Ordena las películas por duración de forma ascendente.
select f.title
from film f 
order by f.length asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
select a.first_name, a.last_name
from actor a
where a.last_name like 'ALLEN';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
select f.rating, count(f.film_id) 
from film f
group by f.rating;

-- 8. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
select f.title
from film f 
where f.rating = 'PG-13' or length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select variance(f.replacement_cost) 
from film f;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select max(f.length) as mayor_duracion, min(f.length) as menor_duracion
from film f;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select p.amount, p.rental_id 
from payment p
where p.rental_id in (select r.rental_id 
					from rental r
					order by r.rental_date desc
					limit 1 offset 2);

/* 12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni
‘Gʼ en cuanto a su clasificación.*/
select f.title
from film f 
where f.rating <> 'NC-17' and f.rating <> 'G';

/* 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla
film y muestra la clasificación junto con el promedio de duración.*/
select f.rating, AVG(f.length)
from film f
group by f.rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select f.title
from film f 
where f.length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select SUM(p.amount) as Dinero_ganado
from payment p;

-- 16. Muestra los 10 clientes con mayor valor de id.
select *
from customer c 
order by c.customer_id desc 
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select a.first_name, a.last_name 
from actor a 
where a.actor_id in (select fa.actor_id
					from film f inner join film_actor fa on f.film_id = fa.film_id
					where f.title like 'EGG IGBY');

-- 18. Selecciona todos los nombres de las películas únicos.
select distinct (f.title)
from film f;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
select f.title
from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id 
where c.name = 'Comedy' and f.length > 180;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de
 la categoría junto con el promedio de duración. */
with media_categoria as (select c.name, AVG(f.length)
	from category c inner join film_category fc on c.category_id = fc.category_id inner join film f on fc.film_id = f.film_id
	group by c.category_id)
select name as Categoria, "avg" as Promedio
from media_categoria
where "avg" > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select avg(f.rental_duration) as Media_duracion
from film f;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(a.first_name, ' ', a.last_name) as Nombre_Apellidos
from actor a;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select r.rental_date, count(r.rental_id)
from rental r
group by r.rental_date 
order by count(r.rental_date) desc; 

-- 24. Encuentra las películas con una duración superior al promedio.
select *
from film f 
where f.length > (select avg(f2.length)
						from film f2);

-- 25. Averigua el número de alquileres registrados por mes.
select to_char(r.rental_date, 'Month') as mes, count(r.rental_id)
from rental r 
group by to_char(r.rental_date, 'Month');

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select avg(p.amount) as Promedio, stddev(p.amount) as Desviacion, variance(p.amount) as Variancia
from payment p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select distinct (f.*) 
from film f inner join inventory i on f.film_id = i.film_id
where i.inventory_id in (select distinct(i2.inventory_id)
						from inventory i2 inner join rental r on i2.inventory_id = r.inventory_id
						where r.rental_id in (select p.rental_id
												from payment p
												where p.amount > (select avg(p2.amount)
																	from payment p2)));

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
with pelis_actor as (select fa.actor_id, count(fa.film_id) as n_films
						from film_actor fa
						group by fa.actor_id)
select pa2.actor_id 
from  pelis_actor pa2
where pa2.n_films > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.title, f.film_id , count(i.inventory_id) as Disponibles
from film f left join inventory i on f.film_id = i.film_id
group by f.title, f.film_id;

-- 30. Obtener los actores y el número de películas en las que ha actuado
select fa.actor_id, a.first_name, a.last_name, count(fa.film_id) as n_films
from film_actor fa inner join actor a on fa.actor_id = a.actor_id 
group by fa.actor_id, a.first_name, a.last_name;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f.film_id, f.title, a.first_name, a.last_name 
from film f left join film_actor fa on f.film_id = fa.film_id left join actor a on fa.actor_id =a.actor_id;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select a.first_name, a.last_name, f.title 
from actor a left join film_actor fa on a.actor_id = fa.actor_id left join film f on fa.film_id = f.film_id ;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select f.film_id , f.title, r.*
from film f left join inventory i on f.film_id = i.film_id left join rental r on i.inventory_id = r.inventory_id ;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select c.customer_id, c.first_name, c.last_name
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.customer_id 
order by sum(p.amount) DESC
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select *
from actor a 
where a.first_name = 'JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select a.first_name as Nombre, a.last_name as Apellido
from actor a
where a.first_name = 'JOHNNY';

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select max(a.actor_id) as id_mas_alto, min(a.actor_id) as id_mas_bajo
from actor a ;

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
select count(a.actor_id) as Numero_actores
from actor a ;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select *
from actor a 
order by a.last_name asc;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
select *
from film f 
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select a.first_name, count(a.first_name)
from actor a 
group by a.first_name ;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.*, c.first_name, c.last_name
from rental r inner join customer c on r.customer_id =c.customer_id ;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.customer_id, c.first_name, c.last_name, r.*
from customer c left join rental r on c.customer_id = r.customer_id ;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
from film f cross join category c;
-- No aporta nada de valor porque no tienen ningun atributo en común, no hay claves primarias/foraneas en común en estas tablas

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select a.*
from actor a inner join film_actor fa on a.actor_id = fa.actor_id
where fa.film_id in (select f.film_id
						from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id
						where c.name = 'Action');

-- 46. Encuentra todos los actores que no han participado en películas.
select a.*
from actor a left join film_actor fa on a.actor_id = fa.actor_id 
where fa.film_id is null;

select a.*
from actor a 
where a.actor_id not in (select fa.actor_id
						from film_actor fa);

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select a.first_name, a.last_name, count(fa.film_id) as Num_peliculas
from actor a left join film_actor fa on a.actor_id = fa.actor_id 
group by a.first_name, a.last_name ;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
create view actor_num_peliculas as 
select a.first_name, a.last_name, count(fa.film_id) as Num_peliculas
from actor a left join film_actor fa on a.actor_id = fa.actor_id 
group by a.first_name, a.last_name ;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as Num_alquileres
from customer c left join rental r on c.customer_id = r.customer_id 
group by c.customer_id, c.first_name, c.last_name;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select sum(f.length) as duración_total
from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id
where c.name = 'Action';

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temporary table cliente_rentas_temporal as (
	select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as Num_alquileres
	from customer c left join rental r on c.customer_id = r.customer_id 
	group by c.customer_id, c.first_name, c.last_name
);

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas as (
	select *
	from film f 
	where f.film_id in (select t.film_id
						from (select i.film_id, count(r.rental_id) as recuento
						from inventory i inner join rental r on i.inventory_id = r.inventory_id
						group by i.film_id) as t
						where "recuento" >= 10)
);

/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena 
los resultados alfabéticamente por título de película.*/
select f.title
from film f 
where f.film_id in(select i.film_id
					from (select r.inventory_id as inv_id
							from rental r inner join customer c on r.customer_id = c.customer_id
							where c.first_name = 'TAMMY' and c.last_name = 'SANDERS' and r.return_date is null) as t inner join inventory i on t.inv_id = i.inventory_id
)
order by f.title ASC;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
select a2.first_name, a2.last_name	
from actor a2
where a2.actor_id in (select distinct(a.actor_id)
						from actor a inner join film_actor fa on a.actor_id = fa.actor_id
						where fa.film_id in (select f.film_id
												from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id
												where c.name = 'Sci-Fi')
					)					
order by a2.last_name asc;

/* 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus 
Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.*/
		
select a2.first_name, a2.last_name
from actor a2 
where a2.actor_id in (select distinct (a.actor_id)
						from actor a inner join film_actor fa on a.actor_id = fa.actor_id inner join film f on fa.film_id = f.film_id inner join inventory i on f.film_id = i.film_id inner join rental r on i.inventory_id = r.inventory_id 
						where r.rental_date > (select min(r.rental_date) as primer_alquiler
												from rental r inner join inventory i on r.inventory_id = i.inventory_id inner join film f on i.film_id = f.film_id
												where f.title = 'SPARTACUS CHEAPER'
												group by f.film_id))
												-- busco los alquileres de la pelicula 'Spartacus cheaper', agrupo por fil_id y eligo el rental_date más pequeño (el primero)
												-- hago una lista de los ids de actores que han participado en peliculas que se han alquilado posteriores a la fecha extraída previamente
order by a2.last_name asc;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
select a2.first_name, a2.last_name 
from actor a2
where a2.actor_id in (select distinct(a.actor_id)
						from actor a inner join film_actor fa on a.actor_id = fa.actor_id
						where fa.film_id not in (select f.film_id
													from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id
													where c.name = 'Music')
						);

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select f.title
from film f
where f.rental_duration > 8;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select distinct (f.title)
from film f inner join film_category fc on f.film_id = fc.film_id inner join category c on fc.category_id = c.category_id
where c.name = 'Animation';

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select f.title
from film f
where f.length = (select f2.length
					from film f2
					where f2.title = 'DANCING FEVER')
order by f.title asc;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
with costumers_nalquiler as
(select r.customer_id as ids, count(distinct i.film_id) as suma
	from rental r inner join inventory i on r.inventory_id= i.inventory_id 
	group by r.customer_id)
	-- creo una cte donde tengo los ids de los clientes con la suma de las pelis distintas que han alquilado
select c.first_name, c.last_name 
from customer c 
where c.customer_id in (select costumers_nalquiler.ids
						from costumers_nalquiler
						where costumers_nalquiler.suma >= 7)
						-- hago la seleccion de los ids que tienen una suma de peliculas distintas igual o superior a 7
order by c.last_name asc;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select c.name as Categoria, count(f.film_id) as Num_peliculas
from rental r inner join inventory i ON r.inventory_id = i.inventory_id inner join film f on i.film_id =f.film_id inner join film_category fc
on f.film_id = fc.category_id inner join category c on fc.category_id = c.category_id
group by c.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select c.name as Categoria, count(f.film_id) as Num_peliculas
from rental r inner join inventory i ON r.inventory_id = i.inventory_id inner join film f on i.film_id =f.film_id inner join film_category fc
on f.film_id = fc.category_id inner join category c on fc.category_id = c.category_id
where f.release_year = 2006
group by c.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select *
from store s cross join staff st;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c.customer_id, c.first_name, c.last_name , count(r.rental_id) as n_peliculas_alquiladas
from rental r inner join customer c on r.customer_id = c.customer_id 
group by c.customer_id, c.first_name, c.last_name;





















































