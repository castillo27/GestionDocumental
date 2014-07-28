SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE PROCEDURE [dbo].[GetAsuntos2]
	-- Add the parameters for the stored procedure here
	@Prioridad nvarchar(max),
	@StatusAsunto nvarchar(max),
	@Destinatario nvarchar(max),
	@Signatario nvarchar(max),
	@RangoFechaDesde datetime,
	@RangoFechaHasta datetime,
	@Folio nvarchar(10),
	@Titulo nvarchar(250),
	@Descripcion nvarchar(max),
	@DocumentoName nvarchar(250)
AS
BEGIN

	SET NOCOUNT ON;
		
   -- DECLARACION DE VARIBLES.
	DECLARE
	@PrioridadValue nvarchar(max),
	@StatusAsuntoValue nvarchar(max),
	@DestinatarioValue nvarchar(max),
	@SignatarioValue nvarchar(max),
	@RangoFechaDesdeValue datetime,
	@RangoFechaHastaValue datetime,
	@FolioValue nvarchar(250),	
	@TituloValue nvarchar(250),
	@DescripcionValue nvarchar(max),
	@DocumentoNameValue nvarchar(250)		
	
	-- VALIDACION DE CAMPOS
	IF @Prioridad is null SET @Prioridad = null
	IF @StatusAsunto is null SET @StatusAsunto = null
	IF @Destinatario is null SET @Destinatario = null
	IF @Signatario is null SET @Signatario = null
	IF @RangoFechaDesde is null SET @RangoFechaDesde = null
	IF @RangoFechaHasta is null SET @RangoFechaHasta = null
	IF @Folio is null SET @Folio = null	
	IF @Titulo is null SET @Titulo = null	
	IF @Descripcion is null SET @Descripcion = null	
	IF @DocumentoName is null SET @DocumentoName = null	
	
	-- ASIGNACION DE CAMPOS
	SELECT
	@PrioridadValue = @Prioridad,
	@StatusAsuntoValue = @StatusAsunto,
	@DestinatarioValue = @Destinatario,
	@SignatarioValue = @Signatario,
	@RangoFechaDesdeValue = @RangoFechaDesde,
	@RangoFechaHastaValue = @RangoFechaHasta,
	@FolioValue = @Folio,
	@TituloValue = @Titulo,
	@DescripcionValue = @Descripcion,
	@DocumentoNameValue = @DocumentoName
	
	--DECLARACION DE LA BUSQUEDA CON CODICIONES
	DECLARE @BusquedaConds nvarchar(max)
	SELECT @BusquedaConds = ''	
	
	---------< BUSQUEDA DESTINATARIO >------------.			
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND e.IdJerarquia IN ('+ @DestinatarioValue + ')','')
	
	----------< BUSQUEDA SIGNATARIO >--------------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND g.IdDeterminante IN ('+@SignatarioValue + ')','')				
	
	-----------< BUSQUEDA RANGO DE FECHAS >---------.
		SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND FechaDocumento between '''+
				convert(nvarchar(100),@RangoFechaDesdeValue,121)+''' and '''+ convert(nvarchar(100),@RangoFechaHastaValue,121)+'''' ,'')
	
	-----------< BUSQUEDA PRIORIDAD >-------------.
		
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.IdPrioridad IN ('+@PrioridadValue +')','')
	
	----------< BUSQUEDA STATUS DEL ASUNTO >---------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.IdStatusAsunto IN ('+@StatusAsuntoValue +')','')
		
	-----------< BUSQUEDA FOLIO>-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Folio LIKE '''+'%'+RTRIM(@FolioValue)+'%'+'''','')
	
	-----------< BUSQUEDA POR TITULO DEL ASUNTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Titulo LIKE '''+'%'+RTRIM(@TituloValue)+'%'+'''','')
	
	-----------< BUSQUEDA POR DESCRIPCION DEL ASUNTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND a.Descripcion LIKE '''+'%'+RTRIM(@DescripcionValue)+'%'+'''','')
	
	-----------< BUSQUEDA POR NOMBRE DEL DOCUMENTO >-----------.
	
	SELECT @BusquedaConds = @BusquedaConds + coalesce( ' AND doc.DocumentoName LIKE '''+'%'+RTRIM(@DocumentoNameValue)+'%'+'''','')
	
	-----------------< ----ASUNTO---- >---------------------.
	SET DATEFORMAT ymd;
	
	DECLARE @Asunto nvarchar(max)
	
	SELECT @Asunto = 
		'SELECT DISTINCT a.IdAsunto, a.Titulo,a.Folio,a.FechaRecibido,a.FechaVencimiento, h.PrioridadName,g.DeterminanteName,e.JerarquiaName
		FROM GET_ASUNTO as a
		JOIN GET_TURNO as b on a.IdAsunto = b.IdAsunto
		LEFT JOIN REL_DESTINATARIO as c on b.IdRol = c.IdRol
		LEFT JOIN APP_ROL as d on c.IdRol = d.IdRol
		LEFT JOIN CAT_ORGANIGRAMA as e on d.IdRol = e.IdRol
		LEFT JOIN REL_SIGNATARIO as f on a.IdAsunto = f.IdAsunto
		LEFT JOIN CAT_DETERMINANTE as g on f.IdDeterminante = g.IdDeterminante
		JOIN CAT_PRIORIDAD as h on a.IdPrioridad = h.IdPrioridad
		JOIN GET_EXPEDIENTE AS ex on a.IdAsunto = ex.IdAsunto
		JOIN GET_DOCUMENTOS as doc on ex.IdExpediente = doc.IdExpediente
		where 1=1' +' '+ @BusquedaConds
	 	 	 
	PRINT @Asunto
	EXEC (@Asunto)    
	 
END
GO
