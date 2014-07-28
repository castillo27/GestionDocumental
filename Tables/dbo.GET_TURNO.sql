CREATE TABLE [dbo].[GET_TURNO]
(
[IdTurno] [bigint] NOT NULL,
[IdTurnoAnt] [bigint] NULL,
[FechaCreacion] [datetime] NOT NULL,
[FechaEnvio] [datetime] NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[IdAsunto] [bigint] NOT NULL,
[IdStatusTurno] [bigint] NOT NULL,
[IdRol] [bigint] NULL,
[IdUsuario] [bigint] NULL,
[Comentario] [nvarchar] (2000) COLLATE Modern_Spanish_CI_AS NULL,
[Respuesta] [nvarchar] (2000) COLLATE Modern_Spanish_CI_AS NULL,
[ServerLastModifiedDate] [bigint] NULL,
[IsAtendido] [bit] NOT NULL,
[IsTurnado] [bit] NOT NULL,
[IsBorrador] [bit] NOT NULL CONSTRAINT [DF__GET_TURNO__IsBor__571DF1D5] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_TURNO] ADD CONSTRAINT [GET_TURNO_PK] PRIMARY KEY CLUSTERED  ([IdTurno]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_TURNO] ADD CONSTRAINT [GET_ASUNTO_GET_TURNO_FK1] FOREIGN KEY ([IdAsunto]) REFERENCES [dbo].[GET_ASUNTO] ([IdAsunto])
GO
ALTER TABLE [dbo].[GET_TURNO] ADD CONSTRAINT [APP_ROL_GET_TURNO_FK1] FOREIGN KEY ([IdRol]) REFERENCES [dbo].[APP_ROL] ([IdRol])
GO
ALTER TABLE [dbo].[GET_TURNO] ADD CONSTRAINT [CAT_STATUS_TURNO_GET_TURNO_FK1] FOREIGN KEY ([IdStatusTurno]) REFERENCES [dbo].[CAT_STATUS_TURNO] ([IdStatusTurno])
GO
ALTER TABLE [dbo].[GET_TURNO] ADD CONSTRAINT [APP_USUARIO_GET_TURNO_FK1] FOREIGN KEY ([IdUsuario]) REFERENCES [dbo].[APP_USUARIO] ([IdUsuario])
GO
