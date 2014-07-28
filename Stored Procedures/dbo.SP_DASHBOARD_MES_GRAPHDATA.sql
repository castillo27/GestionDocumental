SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DASHBOARD_MES_GRAPHDATA]
	@anio int = null,@mes int = null,@fltIdSignatarios nvarchar(max) = null,@fltIdPrioridades nvarchar(max) = null,@fltIdOrganigrama nvarchar(max) = null
as
begin	
select 
		@anio=coalesce(@anio,year(getdate())),
		@mes=coalesce(@mes,month(getdate()))
		
	declare @sqlStmt nvarchar(max)=''
	select @sqlStmt='	
	--Parametros
	declare @anio int = '+cast(@anio as nvarchar(100))+'
		,@mes int = '+cast(@mes as nvarchar(100))+';


	--Constantes
	declare @TIPO_UNIDAD_NORMATIVA int = 2 --Para solo traer las direcciones
		,@RANGO_MAYOR float = 0.750
		,@RANGO_MEDIO_L1 float = 0.500
		,@RANGO_MEDIO_L2 float = 0.749
		,@RANGO_MENOR float = 0.499
		,@RUTA_IMAGEN_1 nvarchar(500) = ''../images/sm1.png''
		,@RUTA_IMAGEN_2 nvarchar(500) = ''../images/sm2.png''
		,@RUTA_IMAGEN_3 nvarchar(500) = ''../images/sm3.png''
		,@RUTA_IMAGEN_NOIMG nvarchar(500) = ''../images/sm_noimg.png''

	--Llenar tabla con los meses del anio
	declare @tbl as table (
		idAnio int
		,idMes int
		,MesName varchar(50)
	);
	declare @i int
		,@diasAtencionMeta int

	select @i=1

	while (@i<=12)
	begin
		insert into @tbl
		select @anio,@i,dbo.GetMesGraph(@i)		
		select @i=@i+1
	end

	;with Asuntos as (
	select
		t.idMes,
		t.MesName,
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
			'+case when coalesce(@fltIdOrganigrama,'')='' then '' else ' and o.IdJerarquia in ('+@fltIdOrganigrama+') ' end+'
		inner join GET_ASUNTO as asu
			on asu.IdAsunto=gt.IdAsunto
			and YEAR(coalesce(asu.FechaVencimiento,getdate()))=@anio
			and MONTH(coalesce(asu.FechaVencimiento,getdate()))<=@mes
			and exists(
				select *
				from REL_SIGNATARIO as rs
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=rs.IdDeterminante
						'+case when coalesce(@fltIdSignatarios,'')='' then '' else ' and det.IdDeterminante in ('+@fltIdSignatarios+') ' end+'
				where rs.IdAsunto=asu.IdAsunto
			)
			'+case when coalesce(@fltIdPrioridades,'')='' then '' else ' and asu.IdPrioridad in ('+@fltIdPrioridades+') ' end+'
		right outer join @tbl as t
			on t.idAnio=YEAR(coalesce(asu.FechaVencimiento,getdate()))
			and t.idMes=MONTH(coalesce(asu.FechaVencimiento,getdate()))
	where 1=1
		and t.idMes<=@mes
	group by 
		t.idMes,t.MesName
	)
	,AsuntosAcum as (
		select 
			IdMes,
			MesName,
			(
				select SUM(a0.Asuntos)
				from Asuntos as a0
				where a0.idMes<=a.IdMes
			) as Asuntos,
			(
				select SUM(a0.Atendidos)
				from Asuntos as a0
				where a0.idMes<=a.IdMes
			) as Atendidos,
			(
				select SUM(a0.AtendidosFT)
				from Asuntos as a0
				where a0.idMes<=a.IdMes
			) as AtendidosFT
		from Asuntos as a
	)


	select
		a.IdMes,
		a.MesName,
		case when coalesce(a.Asuntos,0)=0 then 0 else cast(a.Atendidos as float) / cast(a.Asuntos as float) end as Productividad,
		case when coalesce(a.Asuntos,0)=0 then 0 else (cast(a.Atendidos as float)-cast(a.AtendidosFT as float)) / cast(a.Asuntos as float) end as Eficiencia
	from AsuntosAcum as a
	';
	
	print @sqlStmt


	exec (@sqlStmt)
end
GO
