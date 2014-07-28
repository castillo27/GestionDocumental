CREATE TABLE [dbo].[CAT_TIPO_EXTENCION]
(
[IdTipoExtencion] [bigint] NOT NULL,
[Extencion] [nvarchar] (16) COLLATE Modern_Spanish_CI_AS NULL,
[Path] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_TIPO_EXTENCION] ADD CONSTRAINT [PK_CAT_TIPO_EXTENCION] PRIMARY KEY CLUSTERED  ([IdTipoExtencion]) ON [PRIMARY]
GO
