SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetMax]
 @Tabla NVARCHAR(max)
 AS
DECLARE @max NVARCHAR(max)=
'SELECT 
 case when LastModifiedDate is not null then MAX(LastModifiedDate) else 0 end AS LastModifiedDate,
 case when ServerLastModifiedDate is not null then MAX(ServerLastModifiedDate) else 0 end AS ServerLastModifiedDate 
 FROM @@Tabla
 GROUP BY LastModifiedDate,ServerLastModifiedDate'
 
 --SET @Tabla='GET_ASUNTO' 
 SET @max=REPLACE(@max,'@@Tabla',@Tabla)  
 DECLARE @Datos TABLE
 (
 LastModifiedDate NVARCHAR(max),
 ServerLastModifiedDate NVARCHAR(max)
 )
 
 PRINT @max
 INSERT INTO @Datos
  EXEC(@max)

if not exists(select * from @Datos)
begin
	INSERT INTO @Datos values(0,0)
end

DECLARE @json NVARCHAR(MAX)=''
SELECT @json='[{LastModifiedDate:'''+ LastModifiedDate+ ''', ServerLastModifiedDate:'''+ ServerLastModifiedDate+'''}]' FROM @Datos 
select @json AS json
GO
