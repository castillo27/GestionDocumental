CREATE TABLE [dbo].[CAT_DETERMINANTE]
(
[IdDeterminante] [bigint] NOT NULL,
[CveDeterminante] [int] NOT NULL,
[Area] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[PrefijoFolio] [nvarchar] (64) COLLATE Modern_Spanish_CI_AS NULL,
[DeterminanteName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[IdTipoDeterminante] [bigint] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_DETERMINANTE] ADD CONSTRAINT [CAT_DETERMINANTE_PK] PRIMARY KEY CLUSTERED  ([IdDeterminante]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_DETERMINANTE] ADD CONSTRAINT [CAT_TIPO_DETERMINANTE_CAT_DETERMINANTE_FK1] FOREIGN KEY ([IdTipoDeterminante]) REFERENCES [dbo].[CAT_TIPO_DETERMINANTE] ([IdTipoDeterminante])
GO
