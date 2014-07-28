SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetBusquedaAsuntos]
	-- Add the parameters for the stored procedure here
	@Titulo nvarchar(250),
	@Folio nvarchar(10),
	@Descripcion nvarchar(max)
AS
BEGIN

	SET NOCOUNT ON;
		
   -- DECLARACION DE VARIBLES.
	DECLARE
	@TituloValue nvarchar(250),	
	@FolioValue nvarchar(10),
	@DescripcionValue nvarchar(max)		
	
	-- VALIDACION DE CAMPOS
	IF @Titulo is null SET @Titulo = null	
	IF @Folio is null SET @Folio = null	
	IF @Descripcion is null SET @Descripcion = null	
	
	-- ASIGNACION DE CAMPOS
	SELECT
	@TituloValue = @Titulo,
	@FolioValue = @Folio,
	@DescripcionValue = @Descripcion
	--DECLARACION DE LA BUSQUEDA CON CODICIONES
	DECLARE @BusquedaConds nvarchar(max)
	SELECT @BusquedaConds = ''	
	
	
	-----------< BUSQUEDA POR FOLIO DEL ASUNTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Folio LIKE '''+'%'+RTRIM(@FolioValue)+'%'+'''','')
	
	-----------< BUSQUEDA POR TITULO DEL ASUNTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Titulo LIKE '''+'%'+RTRIM(@TituloValue)+'%'+'''','')
	
	-----------< BUSQUEDA POR TITULO DEL ASUNTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Descripcion LIKE '''+'%'+RTRIM(@DescripcionValue)+'%'+'''','')
	
	-----------------< ----ASUNTO---- >---------------------.
	SET DATEFORMAT ymd;
	
	DECLARE @Asunto nvarchar(max)
	
	SELECT @Asunto = 
		'SELECT DISTINCT a.*
		FROM GET_ASUNTO as a
		WHERE 1=1' +' '+ @BusquedaConds
	 	 	 
	PRINT @Asunto
	EXEC (@Asunto)    
	 
END
GO
