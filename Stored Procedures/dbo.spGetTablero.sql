SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spGetTablero]
(
	@IdRol BIGINT
)
AS
BEGIN
	--SELECT * FROM dbo.APP_ROL
	/*ASUNTOS URGENTES*/
	SELECT DISTINCT
		1 AS IdTablero,
		'ASUNTOS URGENTES' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND asunto.IsBorrador=0	
				AND asunto.IdStatusAsunto<> 20130611180608439				
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
		WHERE 1=1			
			AND ASUNTO.IdPrioridad=20130611175650143
			AND ROL.IdRol=@IdRol
	UNION ALL
	/*TODOS LOS ASUNTOS*/
	SELECT
		2 AS IdTablero,
		'TODOS LOS ASUNTOS' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND asunto.IsBorrador=0							
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
		WHERE 1=1					
			AND ROL.IdRol=@IdRol	
			
	UNION ALL
	/*ASUNTOS PENDIENTES*/
	SELECT
		3 AS IdTablero,
		'ASUNTOS PENDIENTES' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1	
				AND ASUNTO.IdStatusAsunto=20130611180545475	
				AND ASUNTO.IsBorrador=0		
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1			
		WHERE 1=1					
			AND ROL.IdRol=@IdRol	
			--AND ASUNTO.IdStatusAsunto=1	
			
			
			
				
	UNION ALL
	/*ASUNTOS ATENDIDOS*/
	SELECT
		4 AS IdTablero,
		'ASUNTOS ATENDIDOS' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND ASUNTO.IdStatusAsunto=20130611180608439
				AND asunto.IsBorrador=0							
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
		WHERE 1=1					
			AND ROL.IdRol=@IdRol	



	UNION ALL
	/*ASUNTOS PRIORITARIOS*/
	SELECT
		5 AS IdTablero,
		'ASUNTOS PRIORITARIOS' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND ASUNTO.IdStatusAsunto<>20130611180608439
				AND asunto.IsBorrador=0	
				AND ASUNTO.IdPrioridad=20130611175702903						
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
		WHERE 1=1					
			AND ROL.IdRol=@IdRol	
			
			
	UNION ALL
	/*ASUNTOS ORDINARIOS*/
	SELECT
		6 AS IdTablero,
		'ASUNTOS ORDINARIOS' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				AND ASUNTO.IsActive=1
				AND ASUNTO.IdStatusAsunto<>20130611180608439
				AND asunto.IsBorrador=0	
				AND ASUNTO.IdPrioridad=20130611175614758						
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
		WHERE 1=1					
			AND ROL.IdRol=@IdRol	
			
			
	UNION ALL
	/*ASUNTOS DENTRO DE LIMITE*/
	SELECT DISTINCT
		7 AS IdTablero,
		'ASUNTOS DENTRO DE FECHA LIMITE' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto
				
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
				AND ROL.IdRol=@IdRol	
		WHERE 1=1					
			AND ASUNTO.IsActive=1			
				AND asunto.IsBorrador=0	
				AND ASUNTO.FechaAtendido IS NOT NULL	
				AND ASUNTO.IdStatusAsunto=20130611180608439		
				AND ASUNTO.FechaVencimiento>=ASUNTO.FechaAtendido


	UNION ALL
	/*ASUNTOS FUERA DE LIMITE*/
	SELECT DISTINCT
		8 AS IdTablero,
		'ASUNTOS FUERA DE FECHA LIMITE' AS CATEGORIA, 
		 COUNT(ASUNTO.IdAsunto) AS TOTAL	 
	FROM dbo.GET_ASUNTO ASUNTO
		INNER JOIN dbo.GET_TURNO TURNO
			ON TURNO.IdAsunto = ASUNTO.IdAsunto			
		INNER JOIN dbo.APP_ROL ROL 
			ON ROL.IdRol = TURNO.IdRol				
				AND TURNO.IsActive=1
				AND ROL.IdRol=@IdRol	
		WHERE 1=1					
			AND ASUNTO.IsActive=1			
				AND asunto.IsBorrador=0	
				AND ASUNTO.FechaAtendido IS NOT NULL	
				AND ASUNTO.IdStatusAsunto=20130611180608439		
				AND ASUNTO.FechaVencimiento<ASUNTO.FechaAtendido
			
END

GO
