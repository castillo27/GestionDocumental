SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMesWithNumber](@fecha DATETIME)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @mes NVARCHAR(max)=''
	DECLARE @dia NVARCHAR(MAX)=''
	SET @mes=CAST(MONTH(@fecha) AS nvarchar(MAX))
	SET @dia=CAST(YEAR(@fecha) AS NVARCHAR(MAX))
	SELECT @mes= CASE @mes
				WHEN 1 THEN '01 ENERO ' 
				WHEN 2 THEN '02 FEBRERO ' 
				WHEN 3 THEN '03 MARZO ' 
				WHEN 4 THEN '04 ABRIL ' 
				WHEN 5 THEN '05 MAYO ' 
				WHEN 6 THEN '06 JUNIO ' 
				WHEN 7 THEN '07 JULIO ' 
				WHEN 8 THEN '08 AGOSTO ' 
				WHEN 9 THEN '09 SEPTIEMBRE ' 
				WHEN 10 THEN '10 OCTUBRE ' 
				WHEN 11 THEN '11 NOVIEMBRE ' 
				WHEN 12 THEN '12 DICIEMBRE ' 
				ELSE 'MES NO VALIDO'
	END
RETURN @mes + @dia
END
GO
