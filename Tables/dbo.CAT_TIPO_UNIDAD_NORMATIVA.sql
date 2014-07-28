CREATE TABLE [dbo].[CAT_TIPO_UNIDAD_NORMATIVA]
(
[IdTipoUnidadNormativa] [bigint] NOT NULL,
[TipoUnidadNormativaName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_TIPO_UNIDAD_NORMATIVA] ADD CONSTRAINT [PK_CAT_TIPO_UNIDAD_NORMATIVA] PRIMARY KEY CLUSTERED  ([IdTipoUnidadNormativa]) ON [PRIMARY]
GO
