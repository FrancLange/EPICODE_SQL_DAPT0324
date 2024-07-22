-- 1 Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia?

SELECT 
    productkey,
    Count(*) as Unico
FROM
    dimproduct ;
-- Risultato è 606 come righe 
SELECT 
    productkey,
    Count(*) as Unico
FROM
    dimproduct 
Group by productkey 
Having unico >= 2;
-- Cosi abbiamo verificato che nessuna product key si ripeta almeno 2 volte, perchè il risultato è 0

-- 2.Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.
-- Verifica quantità righe 57851
Select SalesOrderNumber,SalesOrderLineNumber
from factresellersales;
-- verifica che la loro combinazione dia un risultato unico
Select SalesOrderNumber,SalesOrderLineNumber, count(*) as Unico
from factresellersales 
Group by SalesOrderNumber,SalesOrderLineNumber
having unico >= 2;
 -- Anche in questo caso nessun campo è presente due volte . 
 
 -- 3.Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
 Select 
 OrderDate,
count(*) as Transazioni_per_giorno
 from factresellersales
 where OrderDate >= '2020-01-01'
Group by OrderDate;

 Select 
 OrderDate,
count(distinct SalesOrderNumber) as Transazioni_per_giorno
 from factresellersales
 where OrderDate >= '2020-01-01'
Group by OrderDate;



/* 4 4.Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice) 
  per prodotto (DimProduct) a partire dal 1 Gennaio 2020. 
 Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti! */

 Select 
dimproduct.ProductKey,
dimproduct.EnglishProductName,
SUM(frs.SalesAmount) As Fatturato_totale,
SUM(frs.OrderQuantity) As Quantità_totale_vendita,
avg(frs.UnitPrice) AS Prezzo_medio_vendita
 from factresellersales AS frs
 Right join
 dimproduct on dimproduct.ProductKey = frs.ProductKey
 where OrderDate >= '2020-01-01'
Group by dimproduct.ProductKey;

/* 5.Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory). 
Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!*/

SELECT 
    dimproductcategory.ProductCategoryKey,
  --  dimproductcategory.EnglishProductName As Nome_categorie,
    SUM(frs.SalesAmount) AS Fatturato_totale,
    SUM(frs.OrderQuantity) AS Quantità_totale_vendita,
    AVG(frs.UnitPrice) AS Prezzo_medio_vendita
FROM
    factresellersales AS frs
 JOIN
    dimproduct ON dimproduct.ProductKey = frs.ProductKey
left JOIN
dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
      left  JOIN
  dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey
GROUP BY dimproductcategory.ProductCategoryKey;

/*6.Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.*/

SELECT 
    dimgeography.City,
    SUM(frs.SalesAmount) AS Fatturato_totale
FROM
    factresellersales AS frs
 JOIN
    dimreseller ON dimreseller.ResellerKey = frs.ResellerKey
JOIN
dimgeography ON dimgeography.GeographyKey = dimreseller.GeographyKey
where OrderDate >='2020-1-1'
GROUP BY dimgeography.City
Having SUM(frs.SalesAmount) > 60000;