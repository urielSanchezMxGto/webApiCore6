USE EmpresaDB;
GO

IF OBJECT_ID('sp_CRUD_Clientes') IS NOT NULL
    DROP PROCEDURE sp_CRUD_Clientes;
GO

CREATE PROCEDURE sp_CRUD_Clientes
    @Accion NVARCHAR(10),               -- 'INSERT', 'UPDATE', 'DELETE', 'SELECT'
    @IdCliente INT = NULL,
    @Nombre NVARCHAR(150) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @CodigoPostal NVARCHAR(10) = NULL,
    @IdCiudad INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERTAR
    IF @Accion = 'INSERT'
    BEGIN
        INSERT INTO Clientes (Nombre, Direccion, CodigoPostal, IdCiudad)
        VALUES (@Nombre, @Direccion, @CodigoPostal, @IdCiudad);

        SELECT SCOPE_IDENTITY() AS NuevoIdCliente; -- regresa el id generado
        RETURN;
    END;

    -- ACTUALIZAR
    IF @Accion = 'UPDATE'
    BEGIN
        UPDATE Clientes
        SET Nombre = @Nombre,
            Direccion = @Direccion,
            CodigoPostal = @CodigoPostal,
            IdCiudad = @IdCiudad
        WHERE IdCliente = @IdCliente;

        SELECT 'Cliente actualizado correctamente' AS Mensaje;
        RETURN;
    END;

    -- ELIMINAR
    IF @Accion = 'DELETE'
    BEGIN
        DELETE FROM Clientes WHERE IdCliente = @IdCliente;
        SELECT 'Cliente eliminado correctamente' AS Mensaje;
        RETURN;
    END;

    -- CONSULTAR (si se pasa @IdCliente trae uno, si no todos)
    IF @Accion = 'SELECT'
    BEGIN
        IF @IdCliente IS NULL
        BEGIN
            SELECT 
                C.IdCliente, 
                C.Nombre, 
                C.Direccion, 
                C.CodigoPostal, 
                Ci.Nombre AS Ciudad, 
                E.Nombre AS Estado,
                Ci.IdEstado,
                 Ci.idCiudad
            FROM Clientes C
            INNER JOIN Ciudades Ci ON C.IdCiudad = Ci.IdCiudad
            INNER JOIN Estados E ON Ci.IdEstado = E.IdEstado;
        END
        ELSE
        BEGIN
            SELECT 
                C.IdCliente, 
                C.Nombre, 
                C.Direccion, 
                C.CodigoPostal, 
                Ci.Nombre AS Ciudad, 
                E.Nombre AS Estado,
                Ci.IdEstado,
                Ci.idCiudad
            FROM Clientes C
            INNER JOIN Ciudades Ci ON C.IdCiudad = Ci.IdCiudad
            INNER JOIN Estados E ON Ci.IdEstado = E.IdEstado
            WHERE C.IdCliente = @IdCliente;
        END
        RETURN;
    END;
END;
GO
