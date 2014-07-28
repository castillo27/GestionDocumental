SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpConfirmSincRows]
 @JSON NVARCHAR(MAX),
@nomTbl NVARCHAR(MAX)
AS


declare @sqlUpdate nvarchar(max)
SELECT @JSON= REPLACE(REPLACE(REPLACE( REPLACE(REPLACE( REPLACE( 
REPLACE( REPLACE(@JSON,
	'[','<root>') , ']','</root>') 
	,'{','<data ') ,'},','"/>') 
	,'}','"/>') 
	,':','="')
	,',','" ')
	,'''', '')
	
	
declare @sql nvarchar(max) = ' '+
'DECLARE @xml XML;'+
'SET @xml = ''_[json]_'';'+
'SELECT 
	_[cols]_ 
into #mytable
FROM @xml.nodes(''/root/data'')  Tab(Col);
'

--Generar cadena de columnas
declare @tmpCols nvarchar(max) = 'Tab.Col.value(''@[attr]'',''@@datatype'') AS [attr],';
declare @xmlCols nvarchar(max)= ''

Declare @tblColumns table(
		ColName nvarchar(max)
		,DataType nvarchar(max)
	)


DECLARE @CampoLlave table
(
IdTabla nvarchar(max)
)
insert into @CampoLlave (IdTabla)(SELECT
	ccu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON tc.CONSTRAINT_NAME = ccu.Constraint_name
WHERE tc.CONSTRAINT_TYPE = 'Primary Key'
	and tc.TABLE_NAME = @nomTbl)	


insert into @tblColumns (ColName,DataType) 
select
	COLUMN_NAME
	,DATA_TYPE
	+
	coalesce(
		(
			'('+ cast(character_maximum_length as nvarchar(100)) + ')'
		)
		,''
	)
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME like @nomTbl
 AND (COLUMN_NAME=(SELECT TOP(1)IdTabla FROM @CampoLlave) OR  COLUMN_NAME='LastModifiedDate')
order by ORDINAL_POSITION

--SELECT * FROM @tblColumns

select
	@xmlCols = @xmlCols + REPLACE(REPLACE(@tmpCols,'[attr]',ColName),'@@datatype',DataType)
from @tblColumns

--print @tmpCols

--SELECT * FROM @tblColumns
SELECT @xmlCols=LEFT(@xmlCols,LEN(@xmlCols)-1)


--Generar cadena final de "deserealizacion"
select @sql=replace(replace(@sql,'_[json]_',@json),'_[cols]_',@xmlCols);

--PRINT @sql


set @sqlUpdate=
'
UPDATE d
SET   @@COLSUPDTE ,d.isModified=0
FROM @@tableDest d
	INNER JOIN #mytable o
	on 1=1 and @@primaryKeyCond
WHERE d.LastModifiedDate<=o.LastModifiedDate
'

declare @id nvarchar(max)=''
select 
	@id=@id + 'd.'+t.ColName+'= o.'+t.ColName +','
from @tblColumns as t
where t.ColName  in (select IdTabla from @CampoLlave)

declare @tmpstr06 nvarchar(max) = ''
select 
	@tmpstr06=@tmpstr06 + 'd.'+t.ColName+'= o.'+t.ColName +','
from @tblColumns as t
where t.ColName not in (select IdTabla from @CampoLlave)

set @tmpstr06=LEFT(@tmpstr06,LEN(@tmpstr06)-1)
set @id=LEFT(@id,LEN(@id)-1)


SET @sqlUpdate=REPLACE(REPLACE(REPLACE(@sqlUpdate,'@@COLSUPDTE',@tmpstr06),'@@primaryKeyCond',@id),'@@tableDest',@nomTbl)




Select @sql =  
@sql + ' 
'+@sqlupdate

print @sql
PRINT @sqlUpdate	
EXEC(@sql)
SELECT 'ok'
GO
