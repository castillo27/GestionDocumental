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
CREATE PROCEDURE [dbo].[SP_DASHBOARD_PENDIENTES_INDICADOR](
	@fltIdSignatarios nvarchar(max) = null
)
as
begin
	declare @sqlStmt nvarchar(max)=''
	select @sqlStmt='
	set dateformat ymd;
	declare @STATUS_ATENDIDO bigint
	declare @FECHA_ACTUAL datetime = getdate()

	select @STATUS_ATENDIDO=IdStatusAsunto
	from CAT_STATUS_ASUNTO
	where StatusName like ''ATENDIDO''

	select
		COUNT(distinct
			(case
				when @FECHA_ACTUAL >asu.FechaVencimiento then asu.IdAsunto
				else null
			end)
		) as Vencidos,
		COUNT(distinct
			(case
				when @FECHA_ACTUAL between 
					dateadd(dd,-7,cast(left(cast(asu.FechaVencimiento as nvarchar(100)),8) as datetime))
					and asu.FechaVencimiento then asu.IdAsunto
				else null
			end)
		) as PorVencer
	from GET_ASUNTO as asu
	where asu.IdStatusAsunto!=@STATUS_ATENDIDO
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
