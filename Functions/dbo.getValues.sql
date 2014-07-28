SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[getValues] (@Valores NVARCHAR(max))
RETURNS
 
@Tabla TABLE
(
    VALOR VARCHAR(MAX)
)
AS
BEGIN
 
    DECLARE @strlist NVARCHAR(max), @pos INT, @delim CHAR, @lstr NVARCHAR(max)
    SET @strlist = ISNULL(@Valores,'')
    SET @delim = ','
 
    WHILE ((len(@strlist) > 0) and (@strlist <> ''))
    BEGIN
        SET @pos = charindex(@delim, @strlist)
       
        IF @pos > 0
           BEGIN
              SET @lstr = substring(@strlist, 1, @pos-1)
              SET @strlist = ltrim(substring(@strlist,charindex(@delim, @strlist)+1, 8000))
           END
        ELSE
           BEGIN
              SET @lstr = @strlist
              SET @strlist = ''
           END
 
        INSERT @Tabla VALUES (@lstr)
    END
        RETURN
    END
GO
