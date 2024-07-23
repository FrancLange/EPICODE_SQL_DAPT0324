-- Esercizio 1 Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce.

Select
ge.name,
count(ge.name) as Nr_canzoni
  from track as tr

Join
genre as ge on ge.GenreId = tr.GenreId
Group by ge.name
having Nr_canzoni >10
Order by ge.name desc;

-- Esercizio 2 Trovate le tre canzoni più costose.

Select Name,UnitPrice
from track
order by UnitPrice desc
Limit 3;

Select UnitPrice,count(*)
from track
group by track.UnitPrice
order by UnitPrice desc;




-- Esercizio 3 Elencate gli artisti che hanno canzoni più lunghe di 6 minuti.

SELECT DISTINCT
art.Name
FROM 
    track AS tk
    JOIN album AS alb ON alb.AlbumId = tk.AlbumId
    JOIN artist AS art ON art.ArtistId = alb.ArtistId
    WHERE tk.Milliseconds > 360000;
    
-- Esercizio 4 Individuate la durata media delle tracce per ogni genere.

Select
ge.name,
avg(tr.Milliseconds) as Media_Durata
  from track as tr

Join
genre as ge on ge.GenreId = tr.GenreId
Group by ge.name
Order by ge.name desc;

-- Esercizio 5 Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome.

Select distinct
ge.name,
tr.name 
  from track as tr

Join
genre as ge on ge.GenreId = tr.GenreId
Having tr.name like '%Love%'
and tr.name not like '%glove%'
and tr.name not like '%llove%'
Order by ge.name, tr.name ;

-- Esercizio 6 Trovate il costo medio per ogni tipologia

Select distinct
mt.Name,
avg(tr.UnitPrice)
  from track as tr

Join
mediatype as mt on mt.MediaTypeId = tr.MediaTypeId
group by mt.name
Order by mt.name ;

-- Esercizio 7 Individuate il genere con più tracce.
SELECT 
    ge.name, COUNT(*) AS numero_tracce
FROM
    genre AS ge
        inner JOIN
    track AS tr ON ge.GenreId = tr.GenreId
GROUP BY ge.name
ORDER BY numero_tracce DESC limit 1;


-- Esercizio 8 Esercizio Query Avanzate Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.

SELECT 
    artist.Name, COUNT(*) AS numero_album
FROM
    artist
        JOIN
    album ON album.ArtistId = artist.ArtistId
GROUP BY artist.ArtistId
HAVING numero_album = (SELECT 
        COUNT(*)
    FROM
        artist
            JOIN
        album ON artist.ArtistId = album.ArtistId
    WHERE
        artist.name = 'The Rolling Stones');
        

-- Esercizio 9 Trovate l’artista con l’album più costoso.

SELECT 
    artist.name,
    album.title,
    SUM(track.UnitPrice) AS Album_price
FROM
    artist
        INNER JOIN
    album ON album.ArtistId = artist.ArtistId
        INNER JOIN
    track ON track.AlbumId = album.AlbumId
GROUP BY album.title , artist.name
ORDER BY Album_price DESC
LIMIT 1;
-- alternativa con subquery
SELECT AR.NAME ARTIST, AL.TITLE ALBUM -- , SUM(T.UNITPRICE) AS ALBUM_PRICE
FROM TRACK T
LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME, AL.TITLE
HAVING SUM(T.UNITPRICE)=(SELECT MAX(ALBUM_PRICE)
                            FROM(SELECT AR.NAME ARTIST, AL.TITLE ALBUM, SUM(T.UNITPRICE) AS ALBUM_PRICE
                            FROM TRACK T
                            LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
                            LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
                            GROUP BY AR.NAME, AL.TITLE)A);
