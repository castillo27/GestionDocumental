SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TABLE_JSON]
 @Tabla nvarchar(max)
as
--declare @Tabla nvarchar(max)='GET_ASUNTO'
SET NOCOUNT ON;
DECLARE @JSON NVARCHAR(MAX)=''
declare @tmpCampos table(
Campo nvarchar(max),
tipoDato nvarchar(max)
)
DECLARE @tmpstr01 nvarchar(max) = ''
--SET @Tabla='app_rol'

DECLARE @tmp nvarchar(max)='SELECT ''{''+ @@CAMPOS +''@}'' FROM '+ @TABLA + ' WHERE isModified=1'
 

	DECLARE @tmpCols NVARCHAR(MAX)=''
	SELECT @tmpCols=@tmpCols+ COLUMN_NAME+' , ' FROM INFORMATION_SCHEMA.COLUMNS
							WHERE TABLE_NAME=@Tabla ORDER BY ORDINAL_POSITION ASC							
						--PRINT @tmpCols	
						INSERT INTO @tmpCampos (Campo,tipoDato)
						SELECT COLUMN_NAME, DATA_TYPE +  
						coalesce(( '('+ cast(character_maximum_length as nvarchar(100)) + ')'),'') FROM INFORMATION_SCHEMA.COLUMNS
						WHERE TABLE_NAME=@Tabla 
						ORDER BY ORDINAL_POSITION ASC
							
							
select @tmpstr01=@tmpstr01+
	    --'case when '+Campo+ ' is not null then ('''+campo +':'' + char(39)+char(39)+ dbo.ReplaceChar(cast( (case when '+  campo +' is null then '''' else CAST('+ campo +' AS NVARCHAR(MAX)) end) as nvarchar(max))) + char(39)+char(39) +'','') else '''' end +' 
'case 
	when '+Campo+' is not null 
		then (
			'''+Campo+':'''''' 
				+ dbo.ReplaceChar(
					CASE 
						WHEN  '''+tipoDato+''' LIKE ''DATETIME'' 
							THEN  CONVERT(NVARCHAR(MAX),'+Campo+',120)
						ELSE
							CAST('+Campo+' AS NVARCHAR(MAX))
					END
				) + '''''',''
		) 
	else ''''
end +'    
from @tmpCampos

--SELECT @tmpstr01


SELECT @tmp= REPLACE(@tmp,'@@CAMPOS', @tmpstr01)
--select  @tmp


-------------------------
DELETE FROM @tmpCampos

INSERT INTO @tmpCampos(Campo)
EXEC(@tmp)

IF EXISTS(SELECT * FROM @tmpCampos) begin
SELECT @JSON=@JSON+Campo+',' FROM @tmpCampos
SET @JSON=LEFT(@JSON,LEN(@JSON)-1)
set @JSON='['+REPLACE(@JSON,',@}','}')+']'
SELECT @JSON AS RESULT
END
ELSE BEGIN
	SELECT '' AS RESULT
end
GO
