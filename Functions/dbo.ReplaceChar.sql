SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ReplaceChar](@campo nvarchar(max))
returns nvarchar(max)
as
begin
--declare @campo nvarchar(max)                                                                        !  "  #$%  &\/()=?¡
--declare @char int=0
	set @campo= REPLACE(REPLACE(replace(replace(REPLACE(replace(replace(REPLACE(REPLACE(REPLACE(replace(@campo,'&','&#38;'),'"','&#34;'),':','&#58;'),'{','&#123;'),'}','&#125;'),'[','&#91;'),']','&#93;'),',','&#44;'),'''','&#39;'),'/','&#47;'),'\','&#92;')
	--print @campo
	--print @char
	return @campo
 end
 
 
 
--select @campo
--end

--set @campo='Coordinación de Proyectos Transversales - ;  .  , :  !  # $  %    /  =  ?    ¿  ¡ _  {  } [  ] Transparencia e  Innovación'
GO
