CREATE TABLE [dbo].[REL_DESTINATARIO]
(
[IdRol] [bigint] NOT NULL,
[IdTurno] [bigint] NOT NULL,
[IdDestinatario] [bigint] NOT NULL,
[IsPrincipal] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[REL_DESTINATARIO] ADD CONSTRAINT [REL_DESTINATARIO_PK] PRIMARY KEY CLUSTERED  ([IdDestinatario]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[REL_DESTINATARIO] ADD CONSTRAINT [APP_ROL_REL_DESTINATARIO_FK1] FOREIGN KEY ([IdRol]) REFERENCES [dbo].[APP_ROL] ([IdRol])
GO
ALTER TABLE [dbo].[REL_DESTINATARIO] ADD CONSTRAINT [GET_TURNO_REL_DESTINATARIO_FK1] FOREIGN KEY ([IdTurno]) REFERENCES [dbo].[GET_TURNO] ([IdTurno])
GO