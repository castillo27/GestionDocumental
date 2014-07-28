SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ReporteDetalle]
--declare 
@Signatario nvarchar(max),
@Destinatario nvarchar(max),
@Turnos nvarchar(max),
@Prioridad nvarchar(max),
@FechaInicio nvarchar(max),
@FechaFin nvarchar(max)
AS
set @Signatario=@Signatario+','
set @Signatario=REPLACE(@Signatario,',',' _[-_-]_ ,')
--print @Signatario

;with asunto (
	IdAsunto,
	Titulo,
	Descripcion,
	signatarios,
	FechaDocumento,
	IdPrioridad,
	PrioridadName,
	FechaRecibido,
	FechaVencimiento,
	IdStatusAsunto,
	StatusName,Folio
) as (
select
	a.IdAsunto,
	a.Titulo,
	a.Descripcion,
	(
		select  DeterminanteName + ' _[-_-]_ '
		from REL_SIGNATARIO as relsig
			inner join CAT_DETERMINANTE as det
				on det.IdDeterminante=relsig.IdDeterminante
		where 1=1
			and  relsig.IdAsunto=a.IdAsunto
		for xml path('')
	) as signatarios,
	Convert(nvarchar(max), a.FechaDocumento ,103) as FechaDocumento,
	p.IdPrioridad,
	p.PrioridadName,
	Convert(nvarchar(max), a.FechaRecibido,103) as FechaRecibido,
	Convert(nvarchar(max), a.FechaVencimiento,103) as FechaVencimiento,
	stsas.IdStatusAsunto,
	stsas.StatusName,
	a.Folio
from GET_ASUNTO as a
	inner join CAT_PRIORIDAD as p
		on p.IdPrioridad=a.IdPrioridad
	inner join CAT_STATUS_ASUNTO as stsas
		on stsas.IdStatusAsunto=a.IdStatusAsunto
	INNER JOIN GET_EXPEDIENTE expe 
		on expe.IdAsunto=a.IdAsunto
	
),Documentos
as(

select t.IdTurno, COUNT(d.IdTurno) as Total
FROM GET_DOCUMENTOS d 
JOIN GET_TURNO t on t.IdTurno=d.IdTurno
GROUP BY t.IdTurno

)

,TurnoNivel (IdTurno, IdTurnoAnt,De,Para,RolName, Comentario,Respuesta,IdAsunto,Atendido,FechaAtencion, Level)
AS
(
    
    SELECT 
    
    e.IdTurno, e.IdTurnoAnt,
    CASE WHEN e.IdTurnoAnt is null THEN rol.RolName 
		WHEN e.IdTurnoAnt is not null then
		(SELECT R.RolName FROM GET_TURNO T
		JOIN APP_ROL R ON R.IdRol=T.IdRol
		WHERE T.IdTurno=e.IdTurnoAnt)
    else ' ' end 
    as De
    
    ,CASE WHEN e.IdTurnoAnt is not  null THEN rol.RolName 
		 WHEN e.IdTurnoAnt IS NOT NULL
		THEN (SELECT R.RolName FROM GET_TURNO T
		JOIN APP_ROL R ON R.IdRol=T.IdRol
		WHERE T.IdTurnoAnt=e.IdTurno)
    else ' ' end as Para
    
    ,rol.RolName , e.Comentario,e.Respuesta, e.IdAsunto,
	CASE WHEN  e.IsAtendido=1 OR e.IsTurnado=1 then 'SI' ELSE 'NO' END AS Atendido,
		COnvert(varchar(12),e.FechaEnvio,103) as FechaAtencion,		
        0 AS Level
    FROM dbo.GET_TURNO AS e    
    INNER JOIN APP_ROL ROL 
			ON ROL.IdRol=e.IdRol						
    WHERE IdTurnoAnt IS NULL
    
    UNION ALL
-- Recursive member definition
    SELECT e.IdTurno, e.IdTurnoAnt,
    --CASE WHEN e.IdTurnoAnt is  null THEN 'De:' else 'Para:' end as Tipo
    CASE WHEN e.IdTurnoAnt is null THEN rol.RolName 
		WHEN e.IdTurnoAnt is not null then
		(SELECT R.RolName FROM GET_TURNO T
		JOIN APP_ROL R ON R.IdRol=T.IdRol
		WHERE T.IdTurno=e.IdTurnoAnt)
    else ' ' end 
    as De
    ,CASE WHEN e.IdTurnoAnt is not  null THEN rol.RolName 
		 WHEN e.IdTurnoAnt IS NOT NULL
		THEN (SELECT R.RolName FROM GET_TURNO T
		JOIN APP_ROL R ON R.IdRol=T.IdRol
		WHERE T.IdTurnoAnt=e.IdTurno)
    else ' ' end as Para
    --,CASE WHEN e.IdTurnoAnt is not  null THEN rol.RolName else ' ' end as Para
    
    ,rol.RolName, e.Comentario,e.Respuesta, e.idAsunto,
		CASE WHEN  e.IsAtendido=1 OR e.IsTurnado=1 then 'SI' ELSE 'NO' END as Atendido,
		COnvert(varchar(12),e.FechaEnvio,103) as FechaAtencion,
        Level +1 AS Level
    FROM dbo.GET_TURNO AS e
		INNER JOIN TurnoNivel AS d
			on e.IdTurnoAnt= d.IdTurno 
		INNER JOIN APP_ROL ROL 
			ON ROL.IdRol=e.IdRol
)
,res(
ID,
	IdAsunto,
	Titulo,
	Descripcion,
	signatarios,
	FechaDocumento,
	IdPrioridad,
	PrioridadName,
	FechaRecibido,
	FechaVencimiento,
	IdStatusAsunto,
	StatusName,	
	Folio, 
	IdTurno, IdTurnoAnt,De,Para,RolName, Comentario,Respuesta, Atendido,FechaAtencion,Documento, Level
)
as (
	select ROW_NUMBER() OVER(order by a.IdAsunto asc)as ID, a.*,
		tn.IdTurno, tn.IdTurnoAnt,tn.De,tn.Para ,tn.RolName,tn.Comentario,tn.Respuesta, tn.Atendido,tn.FechaAtencion,
		CASE WHEN doc.total IS NOT NULL THEN doc.total ELSE '0' END AS Documento, 
		tn.Level
	from asunto  as a
		inner join TurnoNivel as tn
			on a.IdASunto=tn.IdASunto
		left join Documentos as doc
			on doc.IdTurno=tn.IdTurno
)


--Signatario
--Destinatario
--Turnos finalizados
--Prioridad

select * from res
where (signatarios in (select * from dbo.getValues(@Signatario))
or RolName in (select * from dbo.getValues(@Destinatario)))
AND (Atendido in (select * from dbo.getValues(@Turnos)))
OR (PrioridadName in (select * from dbo.getValues(@Prioridad)))
and  (FechaRecibido BETWEEN @FechaInicio AND @FechaFin)
GO
