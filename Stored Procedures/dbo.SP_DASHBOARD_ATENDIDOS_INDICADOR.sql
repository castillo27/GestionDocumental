SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		jsalazar@inmeta.com.mx
-- Create date: 20130828
-- Description:	Obtiene el conteo de los Asuntos atendidos dentro y fuera de tiempo
-- Parameters:
-- =============================================
CREATE PROCEDURE [dbo].[SP_DASHBOARD_ATENDIDOS_INDICADOR](
	@fltIdSignatarios nvarchar(max) = null
)
as
begin
	declare @sqlStmt nvarchar(max)=''
	select @sqlStmt='
	declare @STATUS_ATENDIDO bigint

	select @STATUS_ATENDIDO=IdStatusAsunto
	from CAT_STATUS_ASUNTO
	where StatusName like ''ATENDIDO''

	select
		COUNT(distinct
			(case
				when asu.FechaAtendido>asu.FechaVencimiento then asu.IdAsunto
				else null
			end)
		) as AtendidosFueraVencimiento,
		COUNT(distinct
			(case
				when asu.FechaAtendido<=asu.FechaVencimiento then asu.IdAsunto
				else null
			end)
		) as AtendidosDentroVencimiento
	from GET_ASUNTO as asu
	where asu.IdStatusAsunto=@STATUS_ATENDIDO
	and exists(
				select *
				from REL_SIGNATARIO as rs
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=rs.IdDeterminante
						'+case when coalesce(@fltIdSignatarios,'')='' then '' else ' and det.IdDeterminante in ('+@fltIdSignatarios+') ' end+'
				where rs.IdAsunto=asu.IdAsunto
			)
	';
	
	exec(@sqlStmt)
end
GO
