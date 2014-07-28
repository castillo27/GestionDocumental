SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertChar](@campo nvarchar(max))
returns nvarchar(max)
as
begin
--declare @campo nvarchar(max)
--declare @char int=0
	set @campo= replace(replace(REPLACE(replace(replace(REPLACE(REPLACE(REPLACE(replace(@campo,'char(44)',','),'char(34)','"'),'char(58)',':'),'char(123)','{'),'char(125)','}'),'char(91)','['),'char(93)',']'),'char(38)','&'),'','''')
	--print @campo
	--print @char
	return @campo
 end
 
--select @campo
--end

--set @campo='Coordinación de Proyectos Transversales - ;  .  , :  !  # $  %    /  =  ?    ¿  ¡ _  {  } [  ] Transparencia e  Innovación'
GO
