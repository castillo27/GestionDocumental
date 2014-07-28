SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateModifiedDataLocal]
 @nomTable nvarchar (MAX),
@JsonTableModifiedData nvarchar(MAX)
AS
--SET @nomTable='GET_ASUNTO'
--SET @JsonTableModifiedData='[{IdModifiedData:''1'',IdSincTable:''1'',IsModified:''0'',ServerModifiedDate:''20130705111758123''},{IdModifiedData:''2'',IdSincTable:''2'',IsModified:''0'',ServerModifiedDate:''20130705111758297''},{IdModifiedData:''3'',IdSincTable:''3'',IsModified:''0'',ServerModifiedDate:''20130705111758487''},{IdModifiedData:''4'',IdSincTable:''4'',IsModified:''0'',ServerModifiedDate:''20130705111758630''},{IdModifiedData:''5'',IdSincTable:''5'',IsModified:''0'',ServerModifiedDate:''20130705111758753''},{IdModifiedData:''6'',IdSincTable:''6'',IsModified:''0'',ServerModifiedDate:''20130705111758930''},{IdModifiedData:''7'',IdSincTable:''7'',IsModified:''0'',ServerModifiedDate:''20130705111759060''},{IdModifiedData:''8'',IdSincTable:''8'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''9'',IdSincTable:''9'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''10'',IdSincTable:''10'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''11'',IdSincTable:''11'',IsModified:''0'',ServerModifiedDate:''20130705111759320''},{IdModifiedData:''12'',IdSincTable:''12'',IsModified:''0'',ServerModifiedDate:''20130705111759587''},{IdModifiedData:''13'',IdSincTable:''13'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''14'',IdSincTable:''14'',IsModified:''0'',ServerModifiedDate:''20130705111759820''},{IdModifiedData:''15'',IdSincTable:''15'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''16'',IdSincTable:''16'',IsModified:''0'',ServerModifiedDate:''20130705125144460''},{IdModifiedData:''17'',IdSincTable:''17'',IsModified:''0'',ServerModifiedDate:''20130705111800250''},{IdModifiedData:''18'',IdSincTable:''18'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''19'',IdSincTable:''19'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''20'',IdSincTable:''20'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''21'',IdSincTable:''21'',IsModified:''0'',ServerModifiedDate:''0''},{IdModifiedData:''22'',IdSincTable:''22'',IsModified:''0'',ServerModifiedDate:''0''}]"}'
SELECT @JsonTableModifiedData= REPLACE(REPLACE(REPLACE( REPLACE(REPLACE( REPLACE( 
REPLACE( REPLACE(@JsonTableModifiedData,
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
Tab.Col.value(''@IsModified'',''bit'') AS isModified,
Tab.Col.value(''@ServerModifiedDate'',''bigint'') AS ServerModifiedDate ';


select @sql=replace(replace(@sql,'_[json]_',@JsonTableModifiedData),'_[cols]_',@tmpCols);

--EXEC(@sql)

DECLARE @Update NVARCHAR(MAX)= 
'UPDATE md set md.ServerModifiedDate=s.ServerModifiedDate
from MODIFIEDDATA as md
join #myTable as s on s.IdSincTable=md.IdSincTable
join synctable as sync on sync.IdSincTable=md.IdSincTable
WHERE sync.SincTableName=''@@NOMBRE'''

SET @Update=REPLACE(@Update,'@@NOMBRE',@nomTable)


SELECT @sql=@sql+'
'+@Update

EXEC (@sql)
SELECT 'ok'
GO
