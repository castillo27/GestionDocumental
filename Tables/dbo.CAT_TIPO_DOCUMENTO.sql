CREATE TABLE [dbo].[CAT_TIPO_DOCUMENTO]
(
[IdTipoDocumento] [bigint] NOT NULL,
[TipoDocumentoName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NULL,
[LastModifiedDate] [bigint] NULL,
[IsModified] [bit] NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_TIPO_DOCUMENTO] ADD CONSTRAINT [CAT_TIPO_DOCUMENTO_PK] PRIMARY KEY CLUSTERED  ([IdTipoDocumento]) ON [PRIMARY]
GO
