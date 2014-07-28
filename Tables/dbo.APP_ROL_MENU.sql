CREATE TABLE [dbo].[APP_ROL_MENU]
(
[IdRolMenu] [bigint] NOT NULL,
[IdRol] [bigint] NOT NULL,
[IdMenu] [bigint] NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_ROL_MENU] ADD CONSTRAINT [APP_ROL_MENU_PK] PRIMARY KEY CLUSTERED  ([IdRolMenu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_ROL_MENU] ADD CONSTRAINT [APP_MENU_APP_ROL_MENU_FK1] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[APP_MENU] ([IdMenu])
GO
