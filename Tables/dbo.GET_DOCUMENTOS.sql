CREATE TABLE [dbo].[GET_DOCUMENTOS]
(
[IdDocumento] [bigint] NOT NULL,
[DocumentoName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[DocumentoPath] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[Extencion] [nvarchar] (16) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[IdTurno] [bigint] NULL,
[Fecha] [datetime] NULL,
[IdExpediente] [bigint] NOT NULL,
[IdTipoDocumento] [bigint] NOT NULL,
[IsDocumentoOriginal] [bit] NULL,
[ServerLastModifiedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_DOCUMENTOS] ADD CONSTRAINT [GET_DOCUMENTOS_PK] PRIMARY KEY CLUSTERED  ([IdDocumento]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_DOCUMENTOS] ADD CONSTRAINT [GET_EXPEDIENTE_GET_DOCUMENTOS_FK1] FOREIGN KEY ([IdExpediente]) REFERENCES [dbo].[GET_EXPEDIENTE] ([IdExpediente])
GO
ALTER TABLE [dbo].[GET_DOCUMENTOS] ADD CONSTRAINT [CAT_TIPO_DOCUMENTO_GET_DOCUMENTOS_FK1] FOREIGN KEY ([IdTipoDocumento]) REFERENCES [dbo].[CAT_TIPO_DOCUMENTO] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[GET_DOCUMENTOS] ADD CONSTRAINT [GET_TURNO_GET_DOCUMENTOS_FK1] FOREIGN KEY ([IdTurno]) REFERENCES [dbo].[GET_TURNO] ([IdTurno])
GO
