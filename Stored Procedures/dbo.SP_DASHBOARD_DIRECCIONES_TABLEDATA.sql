SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		jsalazar@inmeta.com.mx
-- Create date: 20130827
-- Description:	Obtiene los datos para las tablas del tablero por direcciones filtrado por id de signatarios (determinantes) y ids de prioridades.
-- Parameters:
--			@anio int: Año con el que se van a calcular los datos
--			@mes int: Mes calendario, numero entre 1 y 12
--			@fltIdSignatarios nvarchar: Cadena con los ids de los signatarios separados por coma.
--			@@fltIdPrioridades nvarchar: Cadena con los ids de las prioridades separados por coma.
-- =============================================
CREATE PROCEDURE [dbo].[SP_DASHBOARD_DIRECCIONES_TABLEDATA]
	@anio int =null,@mes int=null,@fltIdSignatarios nvarchar(max) = null,@fltIdPrioridades nvarchar(max) = null
as
begin	
	--Parametros
	--declare @anio int = 2013
	--	,@mes int = 9
	--	,@fltIdSignatarios nvarchar(max)=''

	select 
		@anio=coalesce(@anio,year(getdate())),
		@mes=coalesce(@mes,month(getdate()))
		

	declare @sqlStmt nvarchar(max)=''
	select @sqlStmt='
	declare @anio int = '+cast(@anio as nvarchar(100))+'
		,@mes int = '+cast(@mes as nvarchar(100))+';
		
	--Constantes
	declare @TIPO_UNIDAD_NORMATIVA int = 2
		,@RANGO_MAYOR float = 0.750
		,@RANGO_MEDIO_L1 float = 0.500
		,@RANGO_MEDIO_L2 float = 0.749
		,@RANGO_MENOR float = 0.499
		,@RUTA_IMAGEN_1 nvarchar(500) = ''../Imagenes/semaforo_verde.png''
		,@RUTA_IMAGEN_2 nvarchar(500) = ''../Imagenes/semaforo_amarillo.png''
		,@RUTA_IMAGEN_3 nvarchar(500) = ''../Imagenes/semaforo_rojo.png''
		,@RUTA_IMAGEN_NOIMG nvarchar(500) = ''../images/sm_noimg.png'';

	;with Asuntos as (
	select
		rol.IdRol,
		rol.RolName,
		o.IdTipoUnidadNormativa,
		COUNT(distinct 
			(case 
				when YEAR(coalesce(asu.FechaVencimiento,getdate()))=@anio
					 and MONTH(coalesce(asu.FechaVencimiento,getdate()))<=@mes
					then asu.IdAsunto 
				else null 
			end
			)
		) as Asuntos,
		COUNT(distinct 
			(case 
				when (gt.IsTurnado!=0
						or gt.IsAtendido!=0)
					then asu.IdAsunto 
				else null 
			end
			)
		) as Atendidos,
		COUNT(distinct 
			(case 
				when (gt.IsTurnado!=0
						or gt.IsAtendido!=0)
					and cast(asu.FechaVencimiento as date)>cast(gt.FechaEnvio  as date)
					then asu.IdAsunto 
				else null 
			end
			)
		) as AtendidosFT
	from GET_TURNO as gt
		inner join APP_ROL as rol
			on gt.IdRol=rol.IdRol
		inner join CAT_ORGANIGRAMA as o
			on o.IdTipoUnidadNormativa=@TIPO_UNIDAD_NORMATIVA
			and o.IdJerarquia=rol.IdRol
		inner join GET_ASUNTO as asu
			on asu.IdAsunto=gt.IdAsunto
			and YEAR(coalesce(asu.FechaVencimiento,getdate()))=@anio
			and MONTH(coalesce(asu.FechaVencimiento,getdate()))<=@mes
	where 1=1
		and exists(
			select *
			from REL_SIGNATARIO as rs
				inner join CAT_DETERMINANTE as det
					on det.IdDeterminante=rs.IdDeterminante
					'+case when coalesce(@fltIdSignatarios,'')='' then '' else ' and det.IdDeterminante in ('+@fltIdSignatarios+') ' end+'
			where rs.IdAsunto=asu.IdAsunto
		)
		'+case when coalesce(@fltIdPrioridades,'')='' then '' else ' and asu.IdPrioridad in ('+@fltIdPrioridades+') ' end+'
	group by 
		rol.IdRol,
		rol.RolName,
		o.IdTipoUnidadNormativa
	)



	select
		a.IdRol,
		a.RolName,
		case when coalesce(a.Asuntos,0)=0 then 0 else cast(a.Atendidos as float) / cast(a.Asuntos as float) end as Productividad,
		case when coalesce(a.Asuntos,0)=0 then 0 else (cast(a.Atendidos as float)-cast(a.AtendidosFT as float)) / cast(a.Asuntos as float) end as Eficiencia,
		case
			when 
			(case when coalesce(a.Asuntos,0)=0 then 0 else (cast(a.Atendidos as float)-cast(a.AtendidosFT as float)) / cast(a.Asuntos as float) end) >= @RANGO_MAYOR
				then @RUTA_IMAGEN_1
			when 
			(case when coalesce(a.Asuntos,0)=0 then 0 else (cast(a.Atendidos as float)-cast(a.AtendidosFT as float))/ cast(a.Asuntos as float) end) between @RANGO_MEDIO_L1 and @RANGO_MEDIO_L2
				then @RUTA_IMAGEN_2
			when 
			(case when coalesce(a.Asuntos,0)=0 then 0 else (cast(a.Atendidos as float)-cast(a.AtendidosFT as float)) / cast(a.Asuntos as float) end) <= @RANGO_MENOR
				then @RUTA_IMAGEN_3
			else
				@RUTA_IMAGEN_NOIMG
		end as RutaSemaforo
	from Asuntos as a
	order by Productividad desc
	';
	print @sqlStmt
	--select @sqlStmt

	exec (@sqlStmt)
end
GO
