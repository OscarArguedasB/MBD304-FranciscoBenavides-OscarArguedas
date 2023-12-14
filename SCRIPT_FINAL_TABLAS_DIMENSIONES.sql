--SCRIPT PROYECTO FINAL MBD304 Bases De Datos Multidimensionales

--TABLA DE CONTROL DE CARGAS
CREATE DATABASE WWI_DW;
GO

USE WWI_DW;
GO

DROP TABLE FactSale;
DROP TABLE DimCity;
DROP TABLE DimCustomer;
DROP TABLE DimEmployee;
DROP TABLE DimPaymentMethod;
DROP TABLE DimStockItem;
DROP TABLE DimSupplier;
DROP TABLE DimTrasactionTyp;
DROP TABLE ControlDataLoad;

IF OBJECT_ID('dbo.ControlDataLoad', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.ControlDataLoad;
END
--
CREATE TABLE ControlDataLoad (
    [ControlID]            BIGINT         NOT NULL IDENTITY(1,1),
    [DataLoadStarted]      DATE           NOT NULL DEFAULT  GETDATE(),
    [TableName]            NVARCHAR (255) NOT NULL,
    [DataLoadCompleted]    DATETIME2 (7) NULL,
    CONSTRAINT [PK_ControlDataLoad] PRIMARY KEY CLUSTERED ([ControlID] ASC)
);
--
/*
DimCity
DimCustomer
DimDate
DimEmployee
DimPaymentMethod
DimStockItem
DimSupplier
DimTrasactionTyp

*/
/*SCRIPT DE TABLAS DE DIMENSIONES*/
IF OBJECT_ID('dbo.DimCity', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.DimCity;
END
CREATE TABLE [dbo].[DimCity] (
    [DimCityID]      [INT]             NOT NULL IDENTITY(1,1),
    [CityID]         [INT]             NOT NULL,
    [City]           [NVARCHAR] (255)  NOT NULL,
    [StateProvince]  [NVARCHAR] (255)  NOT NULL,
    [Country]        [NVARCHAR] (255)  NOT NULL,
    [Continent]      [NVARCHAR] (255)  NOT NULL,
    [SalesTerritory] [NVARCHAR] (255)  NOT NULL,
    [Region]         [NVARCHAR] (255)  NOT NULL,
    [Subregion]      [NVARCHAR] (255)  NOT NULL,
    [Location]       [sys].[geography] NOT NULL,
    [ControlID]      [BIGINT]          NULL  ,
    CONSTRAINT [PK_Dimension_City] PRIMARY KEY CLUSTERED ([DimCityID] ASC)
);
ALTER TABLE [dbo].[DimCity] WITH CHECK ADD CONSTRAINT [FK_DimCity_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);

--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_CITY] ON [dbo].[DimCity]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimCity';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimCity] dc
    INNER JOIN INSERTED i ON dc.CityID = i.CityID;
END
GO
/*************************************************************************************/
--DIMENSION CUSTOMER
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.[DimCustomer];
END
CREATE TABLE [dbo].[DimCustomer] (
    [DimCustomerID]  [int] NOT NULL IDENTITY(1,1),
    [CustomerID]     [int] NOT NULL,
    [Customer]       [nvarchar](255) NOT NULL,
    [BillToCustomer] [nvarchar](255) NOT NULL,
	[Category]       [nvarchar](255) NOT NULL,
	[BuyingGroup]    [nvarchar](255) NOT NULL,
	[PrimaryContact] [nvarchar](255) NOT NULL,
	[PostalCode]     [nvarchar](255) NOT NULL,
    [ControlID]      [BIGINT] NULL
     CONSTRAINT [PK_Dimension_Customer] PRIMARY KEY CLUSTERED ([DimCustomerID] ASC)
);
ALTER TABLE [dbo].[DimCustomer] WITH CHECK ADD CONSTRAINT [FK_DimCustomer_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);

--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_CUSTOMER] ON [dbo].[DimCustomer]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimCustomer';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimCustomer] dc
    INNER JOIN INSERTED i ON dc.CustomerID = i.CustomerID;
END
GO
/*************************************************************************************/
--DIMENSION EMPLOYEE
IF OBJECT_ID('dbo.DimEmployee', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.[DimEmployee];
END
CREATE TABLE [dbo].[DimEmployee] (
    [DimEmployeeID]  [int] NOT NULL IDENTITY(1,1),
    [EmployeeID]     [int] NOT NULL,
    [Employee]       [nvarchar](255) NOT NULL,
	[PreferredName]  [nvarchar](255) NOT NULL,
	[IsSalesperson]  [bit] NOT NULL,
	[Photo]          [varbinary](max) NULL,
    [ControlID]      [BIGINT] NULL
     CONSTRAINT [PK_Dimension_Employee] PRIMARY KEY CLUSTERED ([DimEmployeeID] ASC)
);
ALTER TABLE [dbo].[DimEmployee] WITH CHECK ADD CONSTRAINT [FK_DimEmployee_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_EMPLOYEE] ON [dbo].[DimEmployee]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimEmployee';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimEmployee] dc
    INNER JOIN INSERTED i ON dc.EmployeeID = i.EmployeeID;
END
GO
/*****************************************************************************************************/
--DIMENSIONES FECHA
IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.[DimDate];
END

CREATE TABLE DimDate (
    [DateID]      [INT] NOT NULL,
    [Date]        [DATE],
    [Day]         [INT],
    [Month]       [INT],
    [Year]        [INT],
    [Weekday]     [INT],
    [WeekdayName] [NVARCHAR](255),
    [MonthName]   [NVARCHAR](255),
    [IsWeekend]   [BIT]
      CONSTRAINT [PK_Dimension_Date] PRIMARY KEY CLUSTERED ([DateID] ASC)
);
--llenar tabla dimension fechas
CREATE OR ALTER PROCEDURE PopulateDimDate
AS
BEGIN
    DECLARE @StartDate DATE = '2010-01-01';
    DECLARE @EndDate   DATE = '2023-12-31';

    WHILE @StartDate <= @EndDate
    BEGIN
        INSERT INTO DimDate (
            DateID,
            Date,
            Day,
            Month,
            Year,
            Weekday,
            WeekdayName,
            MonthName,
            IsWeekend
        )
        VALUES (
            CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
            @StartDate,
            DAY(@StartDate),
            MONTH(@StartDate),
            YEAR(@StartDate),
            DATEPART(WEEKDAY, @StartDate),
            FORMAT(@StartDate, 'dddd'),
            FORMAT(@StartDate, 'MMMM'),
            CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END
        );

        SET @StartDate = DATEADD(DAY, 1, @StartDate);
    END;
END;
--
EXEC PopulateDimDate;
/*****************************************************************************************************/

--DIMENSION PAYMENT METHOD
IF OBJECT_ID('dbo.DimPaymentMethod', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.DimPaymentMethod;
END
CREATE TABLE [dbo].[DimPaymentMethod] (

    [DimPaymentMethodID] [INT]           NOT NULL IDENTITY(1,1),
    [PaymentMethodID]    [INT]           NOT NULL,
    [Payment Method]     [nvarchar](255) NOT NULL,
    [ControlID]          [BIGINT]        NULL,
    CONSTRAINT [PK_Dimension_PaymentMethod] PRIMARY KEY CLUSTERED ([DimPaymentMethodID] ASC)
);
ALTER TABLE [dbo].[DimPaymentMethod] WITH CHECK ADD CONSTRAINT [FK_DimPaymentMethod_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_PAYMENTMETHOD] ON [dbo].[DimPaymentMethod]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimPaymentMethod';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimPaymentMethod] dc
    INNER JOIN INSERTED i ON dc.PaymentMethodID = i.PaymentMethodID;
END
GO
/*****************************************************************************************************/
--DIMENSION DimStockItem
IF OBJECT_ID('dbo.DimStockItem', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.DimStockItem;
END
CREATE TABLE [dbo].[DimStockItem] (

    [DimStockItemID]         [INT]           NOT NULL IDENTITY(1,1),
    [StockItemID]            [INT]           NOT NULL,
    [StockItem]              [nvarchar](255) NOT NULL,
	[Color]                  [nvarchar](255)  NOT NULL,
	[SellingPackage]         [nvarchar](255)  NOT NULL,
	[BuyingPackage]          [nvarchar](255)  NOT NULL,
	[Brand]                  [nvarchar](255)  NULL,
	[Size]                   [nvarchar](255)  NULL,
	[LeadTimeDays]           [int] NOT NULL,
	[QuantityPerOuter]       [int] NOT NULL,
	[IsChillerStock]         [bit] NOT NULL,
	[Barcode]                [nvarchar](255)  NULL,
	[TaxRate]                [decimal](18, 3) NOT NULL,
	[UnitPrice]              [decimal](18, 2) NOT NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit]   [decimal](18, 3) NOT NULL,
	[Photo]                  [varbinary](max) NULL,
    [ControlID]              [BIGINT]         NULL,
    CONSTRAINT [PK_Dimension_StockItem] PRIMARY KEY CLUSTERED ([DimStockItemID] ASC)
);
ALTER TABLE [dbo].[DimStockItem] WITH CHECK ADD CONSTRAINT [FK_DimStockItem_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_STOCKITEM] ON [dbo].[DimStockItem]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimStockItem';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimStockItem] dc
    INNER JOIN INSERTED i ON dc.StockItemID = i.StockItemID;
END
GO
/*****************************************************************************************************/
--DIMENSION DimSupplier

IF OBJECT_ID('dbo.DimSupplier', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.DimSupplier;
END

CREATE TABLE [dbo].[DimSupplier] (
    [DimSupplierID]     [INT]            NOT NULL IDENTITY(1,1),
    [SupplierID]        [INT]            NOT NULL,
    [Supplier]          [nvarchar](255)  NOT NULL,
	[Category]          [nvarchar](255)  NOT NULL,
	[PrimaryContact]    [nvarchar](255)  NOT NULL,
	[SupplierReference] [nvarchar](255)  NULL,
	[PaymentDays]       [int]            NOT NULL,
	[PostalCode]        [nvarchar](255)  NOT NULL,
    [ControlID]         [BIGINT]         NULL,
    CONSTRAINT [PK_Dimension_Supplier] PRIMARY KEY CLUSTERED ([DimSupplierID] ASC)
);
ALTER TABLE [dbo].[DimSupplier] WITH CHECK ADD CONSTRAINT [FK_DimSupplier_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_SUPPLIER] ON [dbo].[DimSupplier]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimSupplier';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimSupplier] dc
    INNER JOIN INSERTED i ON dc.SupplierID = i.SupplierID;
END
GO
/*****************************************************************************************************/
--DIMENSIONS DimTrasactionTyp
IF OBJECT_ID('dbo.DimTrasactionTyp', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.DimTrasactionTyp;
END

CREATE TABLE [dbo].[DimTrasactionTyp] (

    [DimTrasactionTypID] [INT]           NOT NULL IDENTITY(1,1),
    [TrasactionTypID]    [INT]           NOT NULL,
    [TransactionType]    [nvarchar](255) NOT NULL,
    [ControlID]          [BIGINT]        NULL,
    CONSTRAINT [PK_Dimension_TrasactionTyp] PRIMARY KEY CLUSTERED ([DimTrasactionTypID] ASC)
);
ALTER TABLE [dbo].[DimTrasactionTyp] WITH CHECK ADD CONSTRAINT [FK_DimTrasactionTyp_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_TRANSACTIONTYP] ON [dbo].[DimTrasactionTyp]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'DimTrasactionTyp';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[DimTrasactionTyp] dc
    INNER JOIN INSERTED i ON dc.TrasactionTypID = i.TrasactionTypID;
END
GO
/*****************************************************************************************************/
/*****************************************************************************************************/

--tablas de hecho
--DIMENSIONS FactSale
IF OBJECT_ID('dbo.FactSale', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.FactSale;
END

CREATE TABLE [dbo].[FactSale] (

    [FactSaleID]        [BIGINT] NOT NULL IDENTITY(1,1),
    [CityID]            [int]    NOT NULL,
    [CustomerID]        [int]    NOT NULL,
    [BillToCustomerID]  [int]    NOT NULL,
    [StockItemID]       [int]    NOT NULL,
    [InvoiceDateID]     [int]    NOT NULL,
    [DeliveryDateID]    [int]    NOT NULL,
    [SalesPersonID]     [int]    NOT NULL,
    [Description]       [nvarchar](100) NOT NULL,
	[Package]           [nvarchar](50) NOT NULL,
	[Quantity]          [int] NOT NULL,
	[UnitPrice]         [decimal](18, 2) NOT NULL,
	[TaxRate]           [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount]         [decimal](18, 2) NOT NULL,
	[Profit]            [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[TotalDryItems]     [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
    [ControlID]        [BIGINT] NULL,
    CONSTRAINT [PK_Fact_Sale] PRIMARY KEY CLUSTERED ([FactSaleID] ASC)
);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_ControlDataLoad] FOREIGN KEY([ControlID])
REFERENCES [dbo].[ControlDataLoad] ([ControlID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimCustomer_CDimCity] FOREIGN KEY([CityID])
REFERENCES [dbo].[DimCity] ([DimCityID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimCustomer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[DimCustomer] ([DimCustomerID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimCustomer_BillToCustomer] FOREIGN KEY([BillToCustomerID])
REFERENCES [dbo].[DimCustomer] ([DimCustomerID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimDate_InvoiceDateID] FOREIGN KEY([InvoiceDateID])
REFERENCES [dbo].[DimDate] ([DateID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimDate_DeliveryDateID] FOREIGN KEY([DeliveryDateID])
REFERENCES [dbo].[DimDate] ([DateID]);
--
ALTER TABLE [dbo].[FactSale] WITH CHECK ADD CONSTRAINT [FK_FactSale_DimDate_DimEmployee] FOREIGN KEY([SalesPersonID])
REFERENCES [dbo].[DimEmployee] ([DimEmployeeID]);


--TRIGGER
CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_FactSale] ON [dbo].[FactSale]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'FactSale';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[FactSale] dc
    INNER JOIN INSERTED i ON dc.CityID           = i.CityID AND 
                             dc.CustomerID       = i.CustomerID AND
                             dc.BillToCustomerID = i.BillToCustomerID AND
                             dc.StockItemID      = i.StockItemID AND
                             dc.InvoiceDateID    = i.InvoiceDateID AND
                             dc.DeliveryDateID   = i.DeliveryDateID AND
                             dc.SalesPersonID    = i.SalesPersonID;
END
GO
/*****************************************************************************************************/
IF OBJECT_ID('dbo.StaingSale', 'U') IS NOT NULL
BEGIN
    -- Si existe, eliminar la tabla
    DROP TABLE dbo.StaingSale;
END

CREATE TABLE [dbo].[StaingSale] (

    [StaingSaleID]      [BIGINT] NOT NULL IDENTITY(1,1),
    [CityID]            [int]    NOT NULL,
    [CustomerID]        [int]    NOT NULL,
    [BillToCustomerID]  [int]    NOT NULL,
    [StockItemID]       [int]    NOT NULL,
    [InvoiceDateID]     [int]    NOT NULL,
    [DeliveryDateID]    [int]    NOT NULL,
    [SalesPersonID]     [int]    NOT NULL,
    [Description]       [nvarchar](100) NOT NULL,
	[Package]           [nvarchar](50) NOT NULL,
	[Quantity]          [int] NOT NULL,
	[UnitPrice]         [decimal](18, 2) NOT NULL,
	[TaxRate]           [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount]         [decimal](18, 2) NOT NULL,
	[Profit]            [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[TotalDryItems]     [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
    [ControlID]        [BIGINT] NULL,
    CONSTRAINT [PK_StaingSale] PRIMARY KEY CLUSTERED ([StaingSaleID] ASC)
);

CREATE OR ALTER TRIGGER [dbo].[TRG_CONTROL_StaingSale] ON [dbo].[StaingSale]
AFTER INSERT
AS
BEGIN

	DECLARE @ControlIDs table (id BIGINT);
	DECLARE @ControlID BIGINT;
	--
	INSERT INTO [dbo].[ControlDataLoad] (DATALOADSTARTED, TABLENAME) 
    OUTPUT INSERTED.ControlID INTO @ControlIDs
    SELECT GETDATE(), 'StaingSale';

	SET @ControlID  = (SELECT TOP 1 ID FROM @ControlIDs);
    --
	UPDATE dc
    SET dc.ControlID = @ControlID
    FROM [dbo].[StaingSale] dc
    INNER JOIN INSERTED i ON dc.CityID           = i.CityID AND 
                             dc.CustomerID       = i.CustomerID AND
                             dc.BillToCustomerID = i.BillToCustomerID AND
                             dc.StockItemID      = i.StockItemID AND
                             dc.InvoiceDateID    = i.InvoiceDateID AND
                             dc.DeliveryDateID   = i.DeliveryDateID AND
                             dc.SalesPersonID    = i.SalesPersonID;
END
GO