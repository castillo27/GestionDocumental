SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDetalleAsuntoPorID]

	-- Add the parameters for the stored procedure here

	@IdAsunto BIGINT,
	@IdRol BIGINT

AS

BEGIN
	SELECT * FROM dbo.GET_ASUNTO as a
	WHERE 1=1
	AND IdAsunto = @IdAsunto
	AND 
	(
		EXISTS
		(
			SELECT * FROM GET_TURNO as t
			WHERE 1=1
				AND t.IdASunto=a.IdASunto
				AND t.idRol=@IdRol
		)
		OR
		EXISTS
		(
			SELECT * FROM REL_DESTINATARIO_CCP as ccp
			WHERE 1=1
				AND ccp.IdASunto=a.IdASunto
				AND ccp.IdRol=@IdRol
				AND ccp.IsActive =1
		)
	)
END
GO
