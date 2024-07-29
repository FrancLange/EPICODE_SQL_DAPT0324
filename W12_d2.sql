-- Esercizio 1 Identificate tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006. 
Select customer.customer_id,customer.first_name,customer.last_name from customer
left join
rental on customer.customer_id = rental.customer_id
and Date(rental.rental_date) between '2006-01-01'and '2006-01-31'
where rental.customer_id is null;

-- Esercizio 2 Elencate tutti i film che sono stati noleggiati più di 10 volte nell’ultimo quarto del 2005 
-- da aggiustare
select film.title, film.film_id, count(rental_id) as Conteggio from rental
join 
inventory on rental.inventory_id = inventory.inventory_id
join 
film on inventory.film_id = film.film_id
Where Date(rental.rental_date) between '2005-10-01' and '2006-12-31'
group by 1,2 ;


-- Esercizio 3 Trovate il numero totale di noleggi effettuati il giorno 1/1/2006. 

SELECT 
    count(*)
FROM
    rental
WHERE
    DATE(rental.rental_date) = '2005-05-24';

-- Esercizio 4 Calcolate la somma degli incassi generati nei weekend (sabato e domenica). 

SELECT SUM(AMOUNT) AS TOT_AMOUNT
FROM PAYMENT P
WHERE dayofweek(PAYMENT_DATE)=1 OR dayofweek(PAYMENT_DATE)=7;

-- Esercizio 5 Individuate il cliente che ha speso di più in noleggi. 
select customer.first_name, customer.last_name, sum(payment.amount) as totale_speso from customer
join
payment on customer.customer_id = payment.customer_id
group by 1,2
order by totale_speso desc limit 1;
-- Esercizio 6 Elencate i 5 film con la maggior durata media di noleggio.
select film.title, film.rental_duration as durata_noleggio from film
order by durata_noleggio desc limit 5;

-- Esercizio 7 Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente. 
SELECT CUSTOMER_ID, AVG(DIFFERENZA_NOLEGGI_CONSECUTIVI)
FROM(
SELECT DISTINCT
A.*,
RR1.RENTAL_DATE AS DATA_NOLEGGIO_PRECEDENTE,
RR2.RENTAL_DATE AS DATA_NOLEGGIO_SUCCESSIVO,
DATEDIFF(RR2.RENTAL_DATE, RR1.RENTAL_DATE ) DIFFERENZA_NOLEGGI_CONSECUTIVI
FROM(
SELECT 
r1.customer_id, 
r1.rental_id, 
min(r2.rental_id) AS NOLEGGIO_SUCCESSIVO
FROM
rental r1
  LEFT JOIN
        rental r2 ON r1.customer_id = r2.customer_id AND r2.rental_id > r1.rental_id
-- where r1.customer_id=1
-- and r2.customer_id=1
GROUP BY r1.customer_id, r1.rental_id) A 
LEFT JOIN RENTAL RR1 ON A.CUSTOMER_ID=RR1.CUSTOMER_ID AND A.RENTAL_ID=RR1.RENTAL_ID
LEFT JOIN RENTAL RR2 ON A.CUSTOMER_ID=RR2.CUSTOMER_ID AND A.NOLEGGIO_SUCCESSIVO=RR2.RENTAL_ID) AA
GROUP BY CUSTOMER_ID;

-- Esercizio 8 Individuate il numero di noleggi per ogni mese del 2005. 
SELECT 
    MONTH(rental_date) as mese , YEAR(rental_date) as Anno ,COUNT(rental_id) as n_noleggi
FROM
    rental
    where year(rental_date) = 2005
GROUP BY 1 , 2;


-- Esercizio 9 Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno. 

SELECT F.TITLE, COUNT(RENTAL_DATE) AS N1, COUNT(DISTINCT DATE(RENTAL_DATE)) AS N2
FROM RENTAL R
JOIN INVENTORY I ON I.INVENTORY_ID=R.INVENTORY_ID
JOIN FILM F ON I.FILM_ID=F.FILM_ID
-- WHERE F.TITLE ='CLUB GRAFFITI'
GROUP BY 1
HAVING N1<>N2
ORDER BY 1;


-- Esercizio 10 Calcolate il tempo medio di noleggio.

select Avg(film.rental_duration) from film
