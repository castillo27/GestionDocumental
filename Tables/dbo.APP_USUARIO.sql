CREATE TABLE [dbo].[APP_USUARIO]
(
[IdUsuario] [bigint] NOT NULL,
[UsuarioCorreo] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[UsuarioPwd] [nvarchar] (12) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Apellido] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Area] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[Puesto] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[IsNuevoUsuario] [bit] NOT NULL,
[IsActivado] [bit] NOT NULL,
[IsFlag] [bit] NULL,
[IsFlagPass] [bit] NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_USUARIO] ADD CONSTRAINT [APP_USUARIO_PK] PRIMARY KEY CLUSTERED  ([IdUsuario]) ON [PRIMARY]
GO
