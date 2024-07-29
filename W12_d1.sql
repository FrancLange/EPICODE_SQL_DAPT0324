-- Utilizzate i file .sql disponibili per il download per generare il database nel DBMS scelto. Esercizio 1 Effettuate un’esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene? Fate in modo di avere un’idea abbastanza chiara riguardo a con cosa state lavorando. 
-- Esercizio 2 Scoprite quanti clienti si sono registrati nel 2006. 
SELECT 
   count(*) as Conta_clienti, YEAR(create_date) AS Anno_registrazione
FROM
    customer
WHERE
    YEAR(create_date) = '2006'
Group by Anno_registrazione;
-- Esercizio 3 Trovate il numero totale di noleggi effettuati il giorno 1/1/2006. 

SELECT 
    count(*)
FROM
    rental
WHERE
    DATE(rental.rental_date) = '2005-05-24';

-- Esercizio 4 Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati.

SELECT DISTINCT
    rental.rental_id,
    film.title,
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email
FROM
    rental
        JOIN
    customer ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        JOIN
    film ON inventory.film_id = film.film_id
WHERE
    DATE(rental_date) BETWEEN '2006-02-08' AND '2006-02-14';


--  Esercizio 5 Calcolate la durata media del noleggio per ogni categoria di film.

select category.name, avg(datediff(return_date,rental_date)) as Durata_media_noleggio from category
join 
film_category on category.category_id = film_category.category_id
join
film on film.film_id = film_category.film_id
join 
inventory on inventory.film_id = film.film_id
join 
rental on rental.inventory_id = inventory.inventory_id

Group by category.name;

-- Esercizio 6

select rental.rental_id,film.title, datediff(rental.return_date,rental.rental_date) as Durata_noleggio from rental
join 
inventory on rental.inventory_id = inventory.inventory_id
join 
film on inventory.film_id = film.film_id


order by Durata_noleggio desc -- Limit 1;
