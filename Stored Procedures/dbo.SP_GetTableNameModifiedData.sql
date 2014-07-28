SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetTableNameModifiedData]
  @JsonTable NVARCHAR(MAX)
AS

--SET @JsonTable='[{IdModifiedData:''1'',IdSincTable:''1'',isModified:''1'',ServerModifiedDate:''0''}]'--'[{IdModifiedData:''1'',IdSincTable:''1'',IsLocalModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''2'',IdSincTable:''2'',IsLocalModified:''0'',ServerModifiedDate:''1''},{IdModifiedData:''3'',IdSincTable:''3'',IsLocalModified:''0'',ServerModifiedDate:''20130618184734760''},{IdModifiedData:''4'',IdSincTable:''4'',IsLocalModified:''0'',ServerModifiedDate:''20130619131931783''}]'

--SELECT * FROM dbo.MODIFIEDDATA
--SELECT * FROM dbo.SYNCTABLE
SELECT @JsonTable= REPLACE(REPLACE(REPLACE( REPLACE(REPLACE( REPLACE( 
REPLACE( REPLACE(@JsonTable,
	'[','<root>') , ']','</root>') 
	,'{','<data ') ,'},','"/>') 
	,'}','"/>') 
	,':','="')
	,',','" ')
	,'''', '')

--SELECT(@json)
declare @sql nvarchar(max) = ' '+
'DECLARE @xml XML;'+
'SET @xml = ''_[json]_'';'+
'SELECT 
	_[cols]_ 
into #mytable
FROM @xml.nodes(''/root/data'')  Tab(Col);'
 
--Generar cadena de columnas
declare @tmpCols nvarchar(max) = 
'Tab.Col.value(''@IdModifiedData'', ''BIGINT'') AS IdModifiedData , 
Tab.Col.value(''@IdSincTable'', ''BIGINT'') AS IdSincTable, 
Tab.Col.value(''@isModified'',''bit'') AS isModified,
Tab.Col.value(''@ServerModifiedDate'',''bigint'') AS ServerModifiedDate ';



--Generar cadena final de "deserealizacion"
select @sql=replace(replace(@sql,'_[json]_',@JsonTable),'_[cols]_',@tmpCols);

--EXEC(@sql)

DECLARE @Comparar NVARCHAR(MAX)= 
' SELECT sync.SincTableName FROM MODIFIEDDATA as l 
join #myTable as s on s.IdSincTable=l.IdSincTable
join synctable as sync on sync.IdSincTable=l.IdSincTable
WHERE s.ServerModifiedDate > l.ServerModifiedDate'


SELECT @sql=@sql+'
'+@Comparar

PRINT @sql
DECLARE @lstNombre TABLE
(
nombreTabla NVARCHAR(max)
)
INSERT INTO @lstNombre
EXEC(@sql)

SELECT * FROM @lstNombre
GO
