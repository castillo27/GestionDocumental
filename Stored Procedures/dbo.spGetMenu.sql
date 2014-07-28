SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spGetMenu]
	@IdRol BIGINT
AS
	SELECT 
	M.IdMenu,
	M.IdMenuParent,
	M.MenuName,
	M.PathMenu,
	(CASE WHEN M.IdMenu=3 THEN '( '+(
		SELECT DISTINCT CAST(COUNT(*) AS VARCHAR(10)) FROM dbo.GET_TURNO
			WHERE 1=1
					and IsBorrador =1 
					AND IdRol=@IdRol) +' )' ELSE NULL END )AS Count
FROM dbo.APP_MENU M
	INNER JOIN dbo.APP_ROL_MENU RM
		ON RM.IdMenu = M.IdMenu
	INNER JOIN dbo.APP_ROL R
		ON R.IdRol = RM.IdRol
	WHERE RM.IsActive=1
		AND R.IdRol=@IdRol
	
GO
