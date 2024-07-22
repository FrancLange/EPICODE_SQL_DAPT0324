-- Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory).
SELECT 
    dimproduct.ProductKey ,
    dimproduct.EnglishProductName,
    dimproductsubcategory.EnglishProductSubcategoryName
FROM
    dimproduct p
        Left outer Join 
    dimproductsubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
    Order by dimproduct.ProductSubcategoryKey Desc;
    
    -- 2 versione  Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory).
SELECT 
    pc.EnglishProductCategoryName,
     psc.EnglishProductSubcategoryName,
    p.EnglishProductName,
    psc.EnglishProductSubcategoryName
    
FROM
    dimproduct p
        inner Join 
    dimproductsubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey 
    inner join
    dimproductcategory pc on pc.ProductCategoryKey = psc.ProductSubcategoryKey;
    
    -- 3 Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory).
    -- dimproductcategory.ProductSubcategoryKey
    SELECT 
    p.ProductKey,
    p.EnglishProductName,
    psc.EnglishProductSubcategoryName
FROM
    dimproduct p
        LEFT OUTER JOIN
    dimproductsubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey;
    
    -- 3.Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales)
    Select distinct
    p.ProductKey,
    p.EnglishProductName
    from
    dimproduct p
     inner JOIN
    factresellersales fss on p.ProductKey = fss.ProductKey;
    
    -- 4.Esponi l’elenco dei prodotti non venduti 
    -- (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1).
    
        Select distinct
    p.ProductKey,
    p.EnglishProductName
    from
    dimproduct p
    Where p.ProductKey not in (Select ProductKey from factresellersales) and p.FinishedGoodsFlag =1 ;
    
    -- Tenendo conto anche della tabella di internet
    
SELECT DISTINCT
    p.ProductKey, p.EnglishProductName
FROM
    dimproduct p
WHERE
    p.ProductKey NOT IN (SELECT ProductKey FROM factresellersales Union SELECT ProductKey FROM factinternetsales )
        AND p.FinishedGoodsFlag = 1;
    
   -- 5.Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)
SELECT 
    frs.SalesOrderNumber,
	frs.SalesOrderLineNumber,
    frs.OrderDate,
    dimproduct.ProductKey,
    dimproduct.EnglishProductName,
    frs.UnitPrice ,
    frs.OrderQuantity
FROM
    factresellersales AS frs
        left JOIN
   dimproduct ON frs.ProductKey = dimproduct.ProductKey;
    
--    6.Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
SELECT 
dimproductcategory.ProductCategoryKey,
dimproductsubcategory.EnglishProductSubcategoryName,
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    dimproduct.ProductKey,
    dimproduct.EnglishProductName,
    frs.UnitPrice,
    frs.OrderQuantity
FROM
    factresellersales AS frs
        LEFT JOIN
    dimproduct ON frs.ProductKey = dimproduct.ProductKey
   left join 
dimproductsubcategory on dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
left join
dimproductcategory on dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;


-- 7.Esplora la tabella DimReseller.
select * from dimreseller;

-- 8.Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.
Select 
dimreseller.ResellerName,
dimgeography.EnglishCountryRegionName
 from dimreseller
Inner Join dimgeography on dimreseller.GeographyKey = dimgeography.GeographyKey;

-- 9-Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, 
-- UnitPrice, Quantity, TotalProductCost. Il result set deve anche indicare il nome del prodotto, 
-- il nome della categoria del prodotto, il nome del reseller e l’area geografica.

SELECT DISTINCT
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost,
    dimproduct.EnglishProductName,
    dimproductcategory.EnglishProductCategoryName,
    dimreseller.ResellerName,
    dimgeography.EnglishCountryRegionName
FROM
    factresellersales AS frs
        LEFT JOIN
    dimproduct ON frs.ProductKey = dimproduct.ProductKey
        LEFT JOIN
    dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
        LEFT JOIN
    dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey
    left join 
    dimreseller on frs.ResellerKey = dimreseller.ResellerKey
        JOIN
    dimgeography ON dimreseller.GeographyKey = dimgeography.GeographyKey;

