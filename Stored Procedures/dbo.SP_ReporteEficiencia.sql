SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ReporteEficiencia] 

@Destinatario NVARCHAR(max),--or
@Signatario NVARCHAR(max),--or
@fechaInicio varchar(max),--and
@fechaFinal varchar(max)--andAS
as


if not OBJECT_ID('dbo.test','U') is null begin
	insert into test(txt)
	select 'entro ';
	
	insert into test(txt)
	select 'parametro destinatario :'+@Destinatario union all
	select 'parametro @Signatario :'+@Signatario union all
	select 'parametro @@fechaInicio :'+@fechaInicio union all
	select 'parametro @@@fechaFinal :'+@fechaFinal 
end



print @fechaInicio
print @fechaFinal
;WITH EFICIENCIA
AS(
SELECT DISTINCT
dbo.GetMesWithNumber(ASUNTO.FechaRecibido) MES,
ASUNTO.IdAsunto,
ASUNTO.Titulo,
TURNO.IdTurno,
PRIORIDAD.PrioridadName,
DETERMINANTE.DeterminanteName,
EDOASUNTO.StatusName,
ROL.RolName,
ASUNTO.IsBorrador,
Convert(nvarchar(max),ASUNTO.FechaRecibido,103)as FechaRecibido,
Convert(nvarchar(max),ASUNTO.FechaVencimiento,103)as FechaVencimiento,
Convert(nvarchar(max),ASUNTO.FechaAtendido,103)as FechaAtendido
FROM GET_ASUNTO ASUNTO
LEFT JOIN GET_TURNO TURNO
	ON TURNO.IdAsunto=ASUNTO.IdAsunto
LEFT JOIN CAT_PRIORIDAD PRIORIDAD
	ON PRIORIDAD.IdPrioridad=ASUNTO.IdPrioridad
LEFT JOIN REL_SIGNATARIO SIGNATARIO
	ON SIGNATARIO.IdAsunto=ASUNTO.IdAsunto
LEFT JOIN CAT_DETERMINANTE DETERMINANTE
	ON DETERMINANTE.IdDeterminante=SIGNATARIO.IdDeterminante
LEFT JOIN CAT_STATUS_ASUNTO EDOASUNTO
	ON EDOASUNTO.IdStatusAsunto=ASUNTO.IdStatusAsunto
LEFT JOIN APP_ROL ROL 
	ON ROL.IdRol=TURNO.IdRol	
	
WHERE 
(ROL.IdRol IN (SELECT * FROM dbo.getValues(@Destinatario))
or DETERMINANTE.IdDeterminante in (SELECT * FROM dbo.getValues(@Signatario)))
and  (FechaRecibido between @fechaInicio and  @fechaFinal)
)

--select * from EFICIENCIA

,Resultado
as( 
--ASUNTOS TURNADOS
	select MES,
	Count(IdAsunto) AS Turnados,
	NULL AS Finalizados,
	NULL AS PENDIENTES,
	NULL AS Prioritarios, 
	NULL AS A_TIEMPO,
	NULL AS A_DESTIEMPO,
	NULL AS PRIORITARIO_A_TIEMPO 
	from  EFICIENCIA
		--where IsBorrador=0
		group by IdAsunto,MES	
	union all	
	--ASUNTOS FINALIZADOS
	select MES,
	NULL AS Turnados,
	Count(idAsunto)AS Finalizados,
	NULL AS PENDIENTES, 
	NULL AS Prioritarios ,
	NULL AS A_TIEMPO,
	NULL AS A_DESTIEMPO ,
	NULL AS PRIORITARIO_A_TIEMPO
	from Eficiencia	
		WHERE StatusName='ATENDIDO'
		GROUP BY IdAsunto,MES												
	UNION ALL
	--ASUNTOS NO ATENDIDOS
	SELECT MES,
	NULL AS Turnados,
	null AS Finalizados,
	Count(idAsunto)AS PENDIENTES,
	NULL AS Prioritarios ,
	NULL AS A_TIEMPO,
	NULL AS A_DESTIEMPO ,
	NULL AS PRIORITARIO_A_TIEMPO
	from EFICIENCIA
		where StatusName='PENDIENTE'
		GROUP BY IdAsunto,MES	
	UNION ALL
	--ASUNTOS PRIORITARIOS
	SELECT MES,
	NULL AS Turnados,
	null AS Finalizados,
	NULL AS PENDIENTES,
	Count(IdAsunto)AS Prioritarios ,
	NULL AS A_TIEMPO,
	NULL AS A_DESTIEMPO ,
	NULL AS PRIORITARIO_A_TIEMPO
	from EFICIENCIA
		where PrioridadName='URGENTE'
		GROUP BY IdAsunto,MES	
	UNION ALL
	--ASUNTOS FINALIZADOS A TIEMPO
	SELECT MES,
	NULL AS Turnados,
	null AS Finalizados,
	NULL AS PENDIENTES,
	NULL AS Prioritarios,
	COUNT(IdAsunto)AS A_TIEMPO ,
	NULL AS A_DESTIEMPO ,
	NULL AS PRIORITARIO_A_TIEMPO
	from EFICIENCIA
		where StatusName='ATENDIDO'
		AND Convert(nvarchar(max),FechaAtendido,121)<= Convert(nvarchar(max),FechaVencimiento,121)
		GROUP BY IdAsunto,MES	
	UNION ALL
	--ASUNTOS FINALIZADOS A DESTIEMPO
	SELECT MES,
	NULL AS Turnados,
	null AS Finalizados,
	NULL AS PENDIENTES,
	NULL AS Prioritarios,
	NULL AS A_TIEMPO ,
	COUNT(IdAsunto)AS A_DESTIEMPO ,
	NULL AS PRIORITARIO_A_TIEMPO
	from EFICIENCIA
		where StatusName='ATENDIDO'
		AND Convert(nvarchar(max),FechaAtendido,121)> Convert(nvarchar(max),FechaVencimiento,121)
		GROUP BY IdAsunto,MES
	UNION ALL
	--ASUNTOS PRIORITARIOS FINALIZADOS A TIEMPO
	SELECT MES,
	NULL AS Turnados,
	null AS Finalizados,
	NULL AS PENDIENTES,
	NULL AS Prioritarios,
	NULL AS A_TIEMPO ,
	NULL AS A_DESTIEMPO ,
	COUNT(IdAsunto)AS PRIORITARIO_A_TIEMPO 
	from EFICIENCIA
		where StatusName='ATENDIDO'
		AND PrioridadName='URGENTE'
		AND Convert(nvarchar(max),FechaAtendido,121)> Convert(nvarchar(max),FechaVencimiento,121)
		GROUP BY IdAsunto,MES	
)


select  
RIGHT(Resultado.MES,LEN(Resultado.MES)-3) AS MES,
count(turnados)AS trunados,
COUNT(Finalizados)AS finalizados,
COUNT(PENDIENTES)AS PENDIENTES ,
COUNT(Prioritarios)AS Prioritarios,
COUNT(A_TIEMPO)AS A_TIEMPO,
COUNT(A_DESTIEMPO)AS A_DESTIEMPO ,
COUNT(PRIORITARIO_A_TIEMPO) AS PRIORITARIO_A_TIEMPO
from Resultado
GROUP BY Resultado.MES
ORDER BY Resultado.MES

GO
