CREATE TABLE [dbo].[CAT_TIPO_DETERMINANTE]
(
[IdTipoDeterminante] [bigint] NOT NULL,
[TipoDeterminanteName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_TIPO_DETERMINANTE] ADD CONSTRAINT [CAT_TIPO_DETERMINANTE_PK] PRIMARY KEY CLUSTERED  ([IdTipoDeterminante]) ON [PRIMARY]
GO
