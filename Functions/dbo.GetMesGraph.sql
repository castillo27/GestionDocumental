SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMesGraph](@int int)
RETURNS varchar(50)
AS
BEGIN	
	DECLARE @mes VARCHAR(50)	
	SELECT @mes= CASE @int
				WHEN 1 THEN 'ENERO ' 
				WHEN 2 THEN 'FEBRERO ' 
				WHEN 3 THEN 'MARZO ' 
				WHEN 4 THEN 'ABRIL ' 
				WHEN 5 THEN 'MAYO ' 
				WHEN 6 THEN 'JUNIO ' 
				WHEN 7 THEN 'JULIO ' 
				WHEN 8 THEN 'AGOSTO ' 
				WHEN 9 THEN 'SEPTIEMBRE ' 
				WHEN 10 THEN 'OCTUBRE ' 
				WHEN 11 THEN 'NOVIEMBRE ' 
				WHEN 12 THEN 'DICIEMBRE ' 
				ELSE 'MES NO VALIDO'
	END
RETURN @mes
END
GO