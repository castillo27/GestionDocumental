SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***
Stored procedure para Recepcion de Datos Servidor

Parms
@json - Cadena tipo json de los datos de la tabla
@nomTbl - Nombre de la tabla

Retuns
@idsJson

Restrictions
-La cadena de JSON (los atributos) deben de venir en el mismo orden de las columnas de la tabla a sinc.
-No estan soportados tipos de datos decimales ni reales (los que tengan este format (10,2) )
-Seguir standar de nombres de columnas IsModified, LastModifiedDate, IsActive, ServerLastData
-Deben estar definidas Primary Keys
-No va funcionar con columnas tipo Identity
***/


--1) Obtener columnas de la tabla a sincronizar
--2) Des- Serializar JSON a una Tabla
--3) Actualizar / Insertar datos
--3.1) Identificar Primary keys
--3.2) Query de update en base a primary keys y comparando fechas
--
--4) Retornar Ids

CREATE PROCEDURE [dbo].[SpUpsertServerRows]
 @json nvarchar(max)
	,@nomTbl nvarchar(128)
--	,@jsonModified NVARCHAR(max)
	AS
Declare @tblColumns table(
		ColName nvarchar(128)
		,DataType nvarchar(128)
	)
	

--set @nomTbl='GET_ASUNTO'
--Convertir JSON a XML
SELECT @json= REPLACE(REPLACE(REPLACE( REPLACE(REPLACE( REPLACE( 
REPLACE( REPLACE(@json,
	'[','<root>') , ']','</root>') 
	,'{','<data ') ,'},','"/>') 
	,'}','"/>') 
	,':','="')
	,',','" ')
	,'''', '')

	
--Cadena dinamica para convertir a tabla

--SELECT(@json)
declare @sql nvarchar(max) = ' '+
'DECLARE @xml XML;'+
'SET @xml = ''_[json]_'';'+
'SELECT 
	_[cols]_ 
into #mytable
FROM @xml.nodes(''/root/data'')  Tab(Col);'

--Generar cadena de columnas
declare @tmpCols nvarchar(max) = 'Tab.Col.value(''@[attr]'',''@@datatype'') AS [attr],';
declare @xmlCols nvarchar(max)= ''




--Obtener Columnas de la tabla
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
order by ORDINAL_POSITION




--Concatenar las columnas para el query de Deserealizacion
select
	@xmlCols = @xmlCols + REPLACE(REPLACE(@tmpCols,'[attr]',ColName),'@@datatype',DataType)
from @tblColumns

--print @tmpCols

--SELECT * FROM @tblColumns
SELECT @xmlCols=LEFT(@xmlCols,LEN(@xmlCols)-1)


--Generar cadena final de "deserealizacion"
select @sql=replace(replace(@sql,'_[json]_',@json),'_[cols]_',@xmlCols);


--print @sql

--*******************************************************************
--Generar Cadenas para update / insert


--Generar string para update
declare @sqlUpdate nvarchar(max)
	,@sqlInsert nvarchar(max)
	,@sqlUpdateMyTable NVARCHAR(max)

set @sqlUpdate=
'
UPDATE d
SET @@COLSUPDTE
FROM @@tableDest d
	INNER JOIN #mytable o
	on 1=1 and @@primaryKeyCond
WHERE d.LastModifiedDate<o.LastModifiedDate
'

--Quitar columnas llaves (PK)
DECLARE @CampoLlave table
(
IdTabla nvarchar(max)
)
insert into @CampoLlave (IdTabla)(SELECT top 1
	ccu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON tc.CONSTRAINT_NAME = ccu.Constraint_name
    join INFORMATION_SCHEMA.COLUMNS c on c.COLUMN_NAME=ccu.COLUMN_NAME AND c.TABLE_NAME=tc.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'Primary Key'
	and c.TABLE_NAME = @nomTbl
	)	

--select *  from CAT_ORGANIGRAMA
declare @id nvarchar(max)=''
select 
	@id=@id + 'd.'+t.ColName+'= o.'+t.ColName +' and '
from @tblColumns as t
where t.ColName in (select IdTabla from @CampoLlave)

declare @idSelect nvarchar(max)=''
select @idSelect=@idSelect+t.ColName+','
from @tblColumns as t
where t.ColName in (select IdTabla from @CampoLlave)
print @idSelect
 
declare @tmpstr06 nvarchar(max) = ''
select 
	@tmpstr06=@tmpstr06 + 'd.'+t.ColName+'= o.'+t.ColName +','
from @tblColumns as t
where t.ColName not in (select IdTabla from @CampoLlave)

set @tmpstr06=LEFT(@tmpstr06,LEN(@tmpstr06)-1)
set @id=LEFT(@id,LEN(@id)-3)
set @idSelect=LEFT(@idSelect,len(@idSelect)-1)

--select @id
--select * from @tblColumns 
--select * from @CampoLlave
 

SET @sqlUpdate=REPLACE(REPLACE(REPLACE(@sqlUpdate,'@@COLSUPDTE',@tmpstr06),'@@primaryKeyCond',@id),'@@tableDest',@nomTbl)
PRINT @sqlUpdate	
	
--***********************************************

--Generar las cadenas para el insert
select @sqlInsert=
'insert into @@tableDest (@@insertCols)
select @@insertcols
from #mytable as o
where not exists( 
	select * 
	from @@tableDest as d
	where 1=1
		and @@primaryKeyCond
)'



DECLARE @INSERT NVARCHAR(MAX)=''
SELECT 
	@INSERT =@INSERT+ t.ColName+',' FROM @tblColumns as t
SET @INSERT=LEFT(@INSERT,LEN(@INSERT)-1)	
SET @sqlInsert= REPLACE(REPLACE(REPLACE(@sqlInsert,'@@tableDest',@nomTbl),'@@insertCols',@INSERT),'@@primaryKeyCond',@id)
PRINT @sqlInsert 


---*************************
DECLARE @JSONTABLE TABLE(
json NVARCHAR(max)
)

declare @ids nvarchar(max)=
'select  ''{'+(select TOP(1)IdTabla from @CampoLlave)+':'' +CHAR(39)+CHAR(39)+CAST('+ (select IdTabla from @CampoLlave) +' AS NVARCHAR(MAX)) +CHAR(39)+CHAR(39)+ '' , LastModifiedDate:'' +CHAR(39)+CHAR(39)+ CAST(LastModifiedDate AS NVARCHAR(MAX))+CHAR(39)+CHAR(39) +''}''  from #mytable
'
DECLARE @ServerLastData NVARCHAR(32)=''
SET @ServerLastData= (SELECT DBO.UDF_NEWUNID() )

 


--DECLARE @sqlUpdateModifiedData NVARCHAR(max)='EXEC dbo.SP_UpdateModifiedDataLocal '''+@nomTbl+''','''+@jsonModified+''''

--SET @sqlUpdateModifiedData= REPLACE(REPLACE(@sqlUpdateModifiedData,'@@TABLE',@nomTbl),'@@ServerModifiedDate',@ServerLastData)


PRINT '*************+'
PRINT @sql
PRINT @sqlupdate
PRINT @sqlinsert
print @ids



SELECT @sql =  
@sql + ' 
'+@sqlupdate+'
'+@sqlinsert+'
'+@ids



INSERT INTO @JSONTABLE
EXEC(@sql)

PRINT @ids
SET @json=''
SELECT @json=@json+ json+' , ' FROM @JSONTABLE
SET @json ='['+ LEFT(@json,LEN(@json)-1)+']'
SELECT @json
GO
