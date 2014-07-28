CREATE TABLE [dbo].[CAT_SESION]
(
[IdUsuario] [bigint] NOT NULL,
[IdSesion] [bigint] NOT NULL,
[IsSaveSesion] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_SESION] ADD CONSTRAINT [CAT_SESION_PK] PRIMARY KEY CLUSTERED  ([IdSesion]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_SESION] ADD CONSTRAINT [APP_USUARIO_CAT_SESION_FK1] FOREIGN KEY ([IdUsuario]) REFERENCES [dbo].[APP_USUARIO] ([IdUsuario])
GO
