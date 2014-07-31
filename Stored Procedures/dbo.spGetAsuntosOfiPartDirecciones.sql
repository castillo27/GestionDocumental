SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spGetAsuntosOfiPartDirecciones]

 @TipoAsunto VARCHAR (50),
 @IdRol BIGINT
AS
	--DECLARE @IdRol BIGINT=10
	
	
		
	IF @TipoAsunto = 'Asuntos Urgentes'
	BEGIN
	/*ASUNTOS URGENTES*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
					--AND asunto.IsBorrador=0	
					--AND asunto.IdStatusAsunto<> 20130611180608439		
							
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
				AND ASUNTO.IdPrioridad = 20130611175650143
			AND ASUNTO.IdStatusAsunto = 1
			
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Pendientes'
	BEGIN
	/*ASUNTOS PENDIENTES*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
					--AND asunto.IsBorrador=0	
					--AND asunto.IdStatusAsunto=20130611180545475				
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
				AND ROL.IdRol = @IdRol
			AND ASUNTO.IsActive = 1
			AND TURNO.IdStatusTurno = 1	
			--AND TURNO.IdStatusTurno = 1
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Prioritarios'
	BEGIN
	/*ASUNTOS PRIORITARIOS*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
					--AND asunto.IsBorrador=0	
					--AND asunto.IdStatusAsunto<>20130611180608439	
					--AND asunto.IdPrioridad=20130611175702903				
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
					AND ROL.IdRol=@IdRol
			AND ASUNTO.IdPrioridad = 20130611175702903
			AND TURNO.IdStatusTurno = 1
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Ordinarios'
	BEGIN
	/*ASUNTOS ORDINARIOS*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
					--AND asunto.IsBorrador=0	
					--AND asunto.IdStatusAsunto<>20130611180608439	
					--AND asunto.IdPrioridad=20130611175614758					
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
				AND ROL.IdRol= @IdRol
			AND ASUNTO.IdPrioridad = 20130611175614758
			AND TURNO.IdStatusTurno = 1
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Atendidos'
	BEGIN
	/*ASUNTOS ORDINARIOS*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
				--AND ASUNTO.IdStatusAsunto=20130611180608439
				--AND asunto.IsBorrador=0						
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
				AND ROL.IdRol =@IdRol
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
			AND ROL.IdRol =@IdRol
			AND TURNO.IsTurnado = 1
			OR TURNO.IsAtendido = 1
			AND ASUNTO.IsActive = 1	

	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Atendidos Dentro de Fecha'
	BEGIN
	/*ASUNTOS ATENDIDOS DENTRO DE FECHA*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive=1
					--AND asunto.IsBorrador=0	
					--AND asunto.IdStatusAsunto<> 20130611180608439			
					AND TURNO.IdRol = @IdRol	
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
					AND TURNO.IsActive=1
				--AND ROL.IdRol=@IdRol
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
			--AND ASUNTO.IsActive=1		
			AND ASUNTO.FechaVencimiento >=TURNO.FechaEnvio
			AND (TURNO.IsTurnado = 1 OR TURNO.IsAtendido = 1)	
				--AND asunto.IsBorrador=0	
				--AND ASUNTO.FechaAtendido IS NOT NULL	
				--AND ASUNTO.IdStatusAsunto=20130611180608439		
				--AND ASUNTO.FechaVencimiento>=ASUNTO.FechaAtendido
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Asuntos Atendidos Fuera de Fecha'
	BEGIN
	/*ASUNTOS ATENDIDOS FUERA DE FECHA*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
					AND ASUNTO.IsActive = 1		
			INNER JOIN dbo.APP_ROL ROL 
				ON ROL.IdRol = TURNO.IdRol				
						AND TURNO.IsActive=1			
			AND ROL.IdRol =@IdRol
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
		AND ASUNTO.FechaVencimiento < TURNO.FechaEnvio AND (TURNO.IsTurnado = 1 OR TURNO.IsAtendido = 1)
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
	
	IF @TipoAsunto = 'Todos los Asuntos'
	BEGIN
	/*TODOS LOS ASUNTOS*/
	;WITH Asuntos AS
	(	
		SELECT DISTINCT		
			 ASUNTO.IdAsunto,
			 PRI.PrioridadName,
			 PRI.PathImagen,
			 ASUNTO.Titulo,
			 ASUNTO.Folio,		 
			 (
				SELECT DISTINCT det.DeterminanteName + ','
				from REL_SIGNATARIO as relsig
					inner join CAT_DETERMINANTE as det
						on det.IdDeterminante=relsig.IdDeterminante					
				where 1=1
					and  relsig.IdAsunto=ASUNTO.IdAsunto
				for xml path('')
			 )AS Signatarios,
			 (
				SELECT DISTINCT O.JerarquiaName+',' 
				FROM dbo.REL_DESTINATARIO  RD
					INNER JOIN dbo.CAT_ORGANIGRAMA O
						ON O.IdRol = RD.IdRol
						AND RD.IdTurno=TURNO.IdTurno
						AND TURNO.IdAsunto=ASUNTO.IdAsunto
				FOR XML PATH('')
			)AS Destinatarios,
			 '' AS Respuesta,
			 ASUNTO.FechaRecibido,
			 ASUNTO.FechaVencimiento
		FROM dbo.GET_ASUNTO ASUNTO
			INNER JOIN dbo.GET_TURNO TURNO
				ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND asunto.IsBorrador=0						
			INNER JOIN dbo.APP_ROL ROL 
					ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
			INNER JOIN dbo.CAT_ORGANIGRAMA ORG
				ON ORG.IdRol = ROL.IdRol
			INNER JOIN dbo.CAT_PRIORIDAD PRI
				ON PRI.IdPrioridad = ASUNTO.IdPrioridad
			WHERE 1=1			
				AND ROL.IdRol = @IdRol	
	)
	SELECT 
		IdAsunto,
		PrioridadName,
		PathImagen,
		Titulo,
		Folio,
		LEFT(Signatarios,LEN(Signatarios)-1) AS Signatarios,
		LEFT(Destinatarios,LEN(Destinatarios)-1) AS Destinatarios,
		Respuesta,
		FechaRecibido,
		FechaVencimiento
	FROM Asuntos
	ORDER BY IdAsunto DESC
	END
GO
