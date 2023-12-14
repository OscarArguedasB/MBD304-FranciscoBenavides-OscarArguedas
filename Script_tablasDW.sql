--TABLA PARA CONTROL DE CARGAR - LINE
CREATE TABLE ControlDataLoad (
    [ControlID]            INT       NOT NULL IDENTITY(1,1),
    [DataLoadStarted]      DATE      NOT NULL DEFAULT  GETDATE(),
    [TableName]            VARCHAR   NOT NULL,
    [DataLoadCompleted]    DATETIME2 (7) NULL,
    CONSTRAINT [PK_ControlDataLoad] PRIMARY KEY CLUSTERED ([ControlID] ASC)
);

--Dimensiones