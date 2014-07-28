CREATE TABLE [dbo].[APP_MENU]
(
[IdMenu] [bigint] NOT NULL,
[IdMenuParent] [bigint] NULL,
[MenuName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NULL,
[PathMenu] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_MENU] ADD CONSTRAINT [APP_MENU_PK] PRIMARY KEY CLUSTERED  ([IdMenu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_MENU] ADD CONSTRAINT [APP_MENU_APP_MENU_FK1] FOREIGN KEY ([IdMenuParent]) REFERENCES [dbo].[APP_MENU] ([IdMenu])
GO
