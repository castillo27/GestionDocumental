CREATE TABLE [dbo].[APP_ROL]
(
[IdRol] [bigint] NOT NULL,
[RolName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_ROL] ADD CONSTRAINT [APP_ROL_PK] PRIMARY KEY CLUSTERED  ([IdRol]) ON [PRIMARY]
GO
