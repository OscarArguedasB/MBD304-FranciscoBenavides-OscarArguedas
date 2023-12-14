--SCRIPT DE CONSULTA DE DATOS EN DB WORD_WIDE_IMPORTERS

USE WideWorldImporters-Stadard;
GO
--DIMENSION CITY
SELECT 
 C.[CityID]
,C.[CityName]
,S.[StateProvinceName]
,X.[CountryName]
,X.[Continent]
,S.[SalesTerritory]
,X.[Region]
,X.[SubRegion]
,C.[Location]
 FROM [Application].[Cities] C
  INNER JOIN [Application].[StateProvinces] S ON S.StateProvinceID = C.StateProvinceID
  INNER JOIN [Application].[Countries]      X ON X.CountryID = S.CountryID

--DIMENSIONS CUSTOMER
SELECT C.[CustomerID]
      ,C.[CustomerName]
      ,BC.CustomerName           AS BillToCustomer
	  ,CC.[CustomerCategoryName] AS Category
	  ,B.[BuyingGroupName]       AS BuyinGroup
	  ,P.[FullName]              AS PrimaryContact
	  ,S.[StateProvinceCode]     AS PostalCode

  FROM [Sales].[Customers] C
  INNER JOIN [Application].[People] P ON P.PersonID = C.PrimaryContactPersonID
  INNER JOIN [Application].[Cities] X ON X.CityID   = C.PostalCityID
  INNER JOIN [Application].[StateProvinces] S ON S.StateProvinceID = X.StateProvinceID
  INNER JOIN [Sales].[BuyingGroups] B ON B.BuyingGroupID = C.BuyingGroupID
  INNER JOIN [Sales].[CustomerCategories] CC ON CC.CustomerCategoryID = C.CustomerCategoryID
  INNER JOIN [Sales].[Customers] BC ON BC.CustomerID = C.BillToCustomerID
--
--DIMENSION EMPLOYEE
SELECT P.[PersonID] AS EmployeID
      ,P.[FullName] AS Employee
      ,P.[PreferredName]
	  ,IIF(P.[IsSalesperson] = 1 , 'S','N') AS IsSalesperson
      ,[Photo]
  FROM [Application].[People] P
  WHERE P.IsEmployee = 1
  --
  SELECT P.[PersonID] AS EmployeID
      ,P.[FullName] AS Employee
      ,P.[PreferredName]
	  ,[IsSalesperson] 
      ,[Photo]
  FROM [Application].[People] P
  WHERE P.IsEmployee = 1




--script de validacion
SELECT C.[EmployeeID]
  FROM [dbo].[ControlDataLoad] CD
  INNER JOIN [dbo].[DimEmployee] C ON C.[ControlID] = CD.[ControlID]
 WHERE CD.TableName = 'DimEmployee'


 --SCRIPT TABLE HECHOS VENTAS
SELECT  
 C.[DeliveryCityID]    AS CityID
,I.[CustomerID]        AS CustomerID
,I.[BillToCustomerID]
,IL.[StockItemID]  
,CONVERT(INT, FORMAT(I.[InvoiceDate], 'yyyyMMdd'))  AS InvoiceDateID
,CONVERT(INT, FORMAT(O.[ExpectedDeliveryDate], 'yyyyMMdd'))  AS DeliveryDateID
,O.SalespersonPersonID
,IL.[Description]
,P.[PackageTypeName]    AS Package	 
,IL.[Quantity]
,IL.[UnitPrice]
,IL.[TaxRate]
,IL.[Quantity] * IL.[UnitPrice] AS TotalExcludingTax
,IL.[TaxAmount]
,IL.[LineProfit]
,(IL.[Quantity] * IL.[UnitPrice]) + IL.[TaxAmount] AS TotalIncludingTax
,I.[TotalDryItems]
,I.[TotalChillerItems]


  FROM [Sales].[InvoiceLines] IL
   INNER JOIN [Sales].[Invoices]         I  ON I.InvoiceID     = IL.InvoiceID
   INNER JOIN [Sales].[Orders]           O  ON O.OrderID       = I.OrderID
   INNER JOIN [Sales].[Customers]        C  ON C.CustomerID    = I.CustomerID
   INNER JOIN [Warehouse].[PackageTypes] P  ON P.PackageTypeID = IL.PackageTypeID
   INNER JOIN [Warehouse].[StockItems]   SI ON SI.StockItemID  = IL.StockItemID


--
SELECT
	   S.[StockItemID]
    ,S.[StockItemName] AS StockItem
	  ,C.[ColorName] AS Color
	  ,P.[PackageTypeName] AS SellingPackage
	  ,PT.[PackageTypeName] AS BuyingPackage
	  ,[Brand]
	  ,[Size]
	  ,[LeadTimeDays]
	  ,[QuantityPerOuter]
	  ,[IsChillerStock]
	  ,[Barcode]
	  ,[TaxRate]
	  ,[UnitPrice]
	  ,[RecommendedRetailPrice]
	  ,[TypicalWeightPerUnit]
	  ,[Photo]
  FROM [Warehouse].[StockItems] S
  INNER JOIN [Warehouse].[Colors] C ON C.ColorID = S.ColorID
  INNER JOIN [Warehouse].[PackageTypes] P ON P.PackageTypeID = S.OuterPackageID
  INNER JOIN [Warehouse].[PackageTypes] PT ON PT.PackageTypeID = S.UnitPackageID

--

   



SELECT 
C.[CityID] , 
C.[CustomerID] ,
C.[BillToCustomerID] , 
C.[StockItemID], 
C.[InvoiceDateID],
C.[DeliveryDateID],
C.[SalesPersonID]
  FROM [dbo].[ControlDataLoad] CD
  INNER JOIN [dbo].FactSale C ON C.[ControlID] = CD.[ControlID]
 WHERE CD.TableName = 'FactSale'
--
SELECT 
C.[CityID] , 
C.[CustomerID] ,
C.[BillToCustomerID] , 
C.[StockItemID], 
C.[InvoiceDateID],
C.[DeliveryDateID],
C.[SalesPersonID]
  FROM [dbo].[ControlDataLoad] CD
  INNER JOIN [dbo].StaingSale C ON C.[ControlID] = CD.[ControlID]
 WHERE CD.TableName = 'StaingSale'
--
SELECT [CityID]
      ,[CustomerID]
      ,[BillToCustomerID]
      ,[StockItemID]
      ,[InvoiceDateID]
      ,[DeliveryDateID]
      ,[SalesPersonID]
      ,[Description]
      ,[Package]
      ,[Quantity]
      ,[UnitPrice]
      ,[TaxRate]
      ,[TotalExcludingTax]
      ,[TaxAmount]
      ,[Profit]
      ,[TotalIncludingTax]
      ,[TotalDryItems]
      ,[TotalChillerItems]
     
  FROM [dbo].[FactSale]
--
SELECT [CityID]
      ,[CustomerID]
      ,[BillToCustomerID]
      ,[StockItemID]
      ,[InvoiceDateID]
      ,[DeliveryDateID]
      ,[SalesPersonID]
      ,[Description]
      ,[Package]
      ,[Quantity]
      ,[UnitPrice]
      ,[TaxRate]
      ,[TotalExcludingTax]
      ,[TaxAmount]
      ,[Profit]
      ,[TotalIncludingTax]
      ,[TotalDryItems]
      ,[TotalChillerItems]
     
  FROM [dbo].[StaingSale]
--
--QUERY PARA CARGAR DATOS DEL STAGIN AREA DE STAGING_SALE AL TABLA DE FAC_SALE
SELECT DC.[DimCityID]       AS CityID
	  ,DCU.[DimCustomerID]  AS CustomerID
      ,BTC.[DimCustomerID]  AS BillToCustomerID
	  ,DSI.[DimStockItemID] AS StockItemID
      ,DE.[DimEmployeeID]   AS InvoiceDateID
      ,SS.[DeliveryDateID]
      ,SS.[SalesPersonID]
      ,SS.[Description]
      ,SS.[Package]
      ,SS.[Quantity]
      ,SS.[UnitPrice]
      ,SS.[TaxRate]
      ,SS.[TotalExcludingTax]
      ,SS.[TaxAmount]
      ,SS.[Profit]
      ,SS.[TotalIncludingTax]
      ,SS.[TotalDryItems]
      ,SS.[TotalChillerItems]
      
  FROM [dbo].[StaingSale] SS
  INNER JOIN [dbo].[DimCity]      DC  ON DC.[CityID]       = SS.[CityID]
  INNER JOIN [dbo].[DimCustomer]  DCU ON DCU.[CustomerID]  = SS.[CustomerID]
  INNER JOIN [dbo].[DimCustomer]  BTC ON BTC.[CustomerID]  = SS.[BillToCustomerID]
  INNER JOIN [dbo].[DimStockItem] DSI ON DSI.[StockItemID] = SS.[StockItemID]
  INNER JOIN [dbo].[DimEmployee]  DE  ON DE.[EmployeeID]   = SS.[SalesPersonID]
