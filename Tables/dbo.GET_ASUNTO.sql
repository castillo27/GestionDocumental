CREATE TABLE [dbo].[GET_ASUNTO]
(
[IdAsunto] [bigint] NOT NULL,
[FechaCreacion] [datetime] NULL,
[FechaRecibido] [datetime] NULL,
[FechaDocumento] [datetime] NULL,
[ReferenciaDocumento] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[Titulo] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descripcion] [nvarchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Alcance] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IdUbicacion] [bigint] NULL,
[IdInstruccion] [bigint] NULL,
[IdPrioridad] [bigint] NULL,
[IdStatusAsunto] [bigint] NULL,
[FechaVencimiento] [datetime] NOT NULL,
[Folio] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[ServerLastModifiedDate] [bigint] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__GET_ASUNT__IsAct__534D60F1] DEFAULT ((0)),
[LastModifiedDate] [bigint] NOT NULL CONSTRAINT [DF__GET_ASUNT__LastM__5441852A] DEFAULT ((1)),
[IsModified] [bit] NOT NULL CONSTRAINT [DF__GET_ASUNT__IsMod__5535A963] DEFAULT ((0)),
[FechaAtendido] [datetime] NULL,
[Ubicacion] [nvarchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IsBorrador] [bit] NOT NULL CONSTRAINT [DF__GET_ASUNT__IsBor__5629CD9C] DEFAULT ((0)),
[Contacto] [nvarchar] (1000) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Anexos] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [GET_ASUNTO_PK] PRIMARY KEY CLUSTERED  ([IdAsunto]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [FK_GET_ASUNTO_GET_ASUNTO] FOREIGN KEY ([IdAsunto]) REFERENCES [dbo].[GET_ASUNTO] ([IdAsunto])
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [CAT_INSTRUCCION_GET_ASUNTO_FK1] FOREIGN KEY ([IdInstruccion]) REFERENCES [dbo].[CAT_INSTRUCCION] ([IdInstruccion])
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [CAT_PRIORIDAD_GET_ASUNTO_FK1] FOREIGN KEY ([IdPrioridad]) REFERENCES [dbo].[CAT_PRIORIDAD] ([IdPrioridad])
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [CAT_STATUS_ASUNTO_GET_ASUNTO_FK1] FOREIGN KEY ([IdStatusAsunto]) REFERENCES [dbo].[CAT_STATUS_ASUNTO] ([IdStatusAsunto])
GO
ALTER TABLE [dbo].[GET_ASUNTO] ADD CONSTRAINT [CAT_UBICACION_GET_ASUNTO_FK1] FOREIGN KEY ([IdUbicacion]) REFERENCES [dbo].[CAT_UBICACION] ([IdUbicacion])
GO
