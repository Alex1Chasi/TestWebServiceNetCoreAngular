CREATE DATABASE BDTestAC;
GO

USE BDTestAC;
GO

CREATE TABLE PRODUCTO (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Categoria NVARCHAR(50),
    Imagen NVARCHAR(255), 
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0
);
GO


CREATE TABLE TRANSACCION (
    IdTransaccion INT IDENTITY(1,1) PRIMARY KEY,
    FechaTransaccion DATETIME DEFAULT GETDATE(),
    TipoTransaccion NVARCHAR(10) CHECK (TipoTransaccion IN ('Compra', 'Venta')),
    IdProducto INT,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    PrecioTotal AS (Cantidad * PrecioUnitario) PERSISTED,
    Detalle NVARCHAR(255),
    FOREIGN KEY (IdProducto) REFERENCES PRODUCTO(IdProducto)
);
GO

CREATE PROCEDURE sp_registrarTransaccion
(
    @TipoTransaccion NVARCHAR(10),
    @IdProducto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10,2),
    @Detalle NVARCHAR(255)
)
AS
BEGIN
    DECLARE @StockActual INT;
    SELECT @StockActual = Stock FROM PRODUCTO WHERE IdProducto = @IdProducto;
    
    IF @TipoTransaccion = 'Venta' AND @StockActual < @Cantidad
    BEGIN
        RAISERROR ('Stock insuficiente para la venta.', 16, 1);
        RETURN;
    END
    
    INSERT INTO TRANSACCION (TipoTransaccion, IdProducto, Cantidad, PrecioUnitario, Detalle)
    VALUES (@TipoTransaccion, @IdProducto, @Cantidad, @PrecioUnitario, @Detalle);
    
    IF @TipoTransaccion = 'Compra'
        UPDATE PRODUCTO SET Stock = Stock + @Cantidad WHERE IdProducto = @IdProducto;
    ELSE
        UPDATE PRODUCTO SET Stock = Stock - @Cantidad WHERE IdProducto = @IdProducto;
END
GO

CREATE PROCEDURE sp_listaTransacciones
AS
BEGIN
    SELECT 
        T.IdTransaccion,
        T.FechaTransaccion,
        T.TipoTransaccion,
        P.Nombre AS Producto,
        T.Cantidad,
        T.PrecioUnitario,
        T.PrecioTotal,
        T.Detalle
    FROM TRANSACCION T
    INNER JOIN PRODUCTO P ON T.IdProducto = P.IdProducto;
END
GO

CREATE PROCEDURE sp_historialTransaccionesPorProducto
(
    @IdProducto INT,
    @FechaInicio DATETIME = NULL,
    @FechaFin DATETIME = NULL,
    @TipoTransaccion NVARCHAR(10) = NULL
)
AS
BEGIN
    SELECT 
        T.IdTransaccion,
        T.FechaTransaccion,
        T.TipoTransaccion,
        P.Nombre AS Producto,
        P.Stock,
        T.Cantidad,
        T.PrecioUnitario,
        T.PrecioTotal,
        T.Detalle
    FROM TRANSACCION T
    INNER JOIN PRODUCTO P ON T.IdProducto = P.IdProducto
    WHERE (@IdProducto IS NULL OR T.IdProducto = @IdProducto)
        AND (@FechaInicio IS NULL OR T.FechaTransaccion >= @FechaInicio)
        AND (@FechaFin IS NULL OR T.FechaTransaccion <= @FechaFin)
        AND (@TipoTransaccion IS NULL OR T.TipoTransaccion = @TipoTransaccion)
    ORDER BY T.FechaTransaccion DESC;
END
GO



CREATE PROCEDURE sp_listaProductos
AS
BEGIN
    SELECT 
        IdProducto,
        Nombre,
        Descripcion,
        Categoria,
        Imagen,
        Precio,
        Stock
    FROM PRODUCTO;
END
GO

CREATE PROCEDURE sp_obtenerProducto
(
    @IdProducto INT
)
AS
BEGIN
    SELECT 
        IdProducto,
        Nombre,
        Descripcion,
        Categoria,
        Imagen,
        Precio,
        Stock
    FROM PRODUCTO 
    WHERE IdProducto = @IdProducto;
END
GO

CREATE PROCEDURE sp_crearProducto
(
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @Categoria NVARCHAR(50),
    @Imagen NVARCHAR(255),
    @Precio DECIMAL(10,2),
    @Stock INT
)
AS
BEGIN
    INSERT INTO PRODUCTO 
    (
        Nombre,
        Descripcion,
        Categoria,
        Imagen,
        Precio,
        Stock
    )
    VALUES
    (
        @Nombre,
        @Descripcion,
        @Categoria,
        @Imagen,
        @Precio,
        @Stock
    );
END
GO

CREATE PROCEDURE sp_editarProducto
(
    @IdProducto INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @Categoria NVARCHAR(50),
    @Imagen NVARCHAR(255),
    @Precio DECIMAL(10,2),
    @Stock INT
)
AS
BEGIN
    UPDATE PRODUCTO
    SET
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        Categoria = @Categoria,
        Imagen = @Imagen,
        Precio = @Precio,
        Stock = @Stock
    WHERE IdProducto = @IdProducto;
END
GO

CREATE PROCEDURE sp_eliminarProducto
(
    @IdProducto INT
)
AS
BEGIN
    DELETE FROM PRODUCTO WHERE IdProducto = @IdProducto;
END
GO




