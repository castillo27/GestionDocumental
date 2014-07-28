CREATE TABLE [dbo].[INF_INFODOC]
(
[IdInfoDoc] [bigint] NOT NULL,
[IdRol] [bigint] NOT NULL,
[IdUsuario] [bigint] NOT NULL,
[IdForm] [bigint] NOT NULL,
[IdAccion] [bigint] NOT NULL,
[Fecha] [bigint] NOT NULL,
[IdRef] [bigint] NOT NULL,
[IpAddress] [nvarchar] (60) COLLATE Modern_Spanish_CI_AS NULL,
[MacAdress] [nvarchar] (120) COLLATE Modern_Spanish_CI_AS NULL,
[PcName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[IsModified] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_INFODOC] ADD CONSTRAINT [INF_INFODOC_PK] PRIMARY KEY CLUSTERED  ([IdInfoDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_INFODOC] ADD CONSTRAINT [INF_ACCION_INF_INFODOC_FK1] FOREIGN KEY ([IdAccion]) REFERENCES [dbo].[INF_ACCION] ([IdAccion])
GO
ALTER TABLE [dbo].[INF_INFODOC] ADD CONSTRAINT [INF_FORM_INF_INFODOC_FK1] FOREIGN KEY ([IdForm]) REFERENCES [dbo].[INF_FORM] ([IdForm])
GO
ALTER TABLE [dbo].[INF_INFODOC] ADD CONSTRAINT [APP_ROL_INF_INFODOC_FK1] FOREIGN KEY ([IdRol]) REFERENCES [dbo].[APP_ROL] ([IdRol])
GO
ALTER TABLE [dbo].[INF_INFODOC] ADD CONSTRAINT [APP_USUARIO_INF_INFODOC_FK1] FOREIGN KEY ([IdUsuario]) REFERENCES [dbo].[APP_USUARIO] ([IdUsuario])
GO