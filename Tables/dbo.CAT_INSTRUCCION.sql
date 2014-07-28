CREATE TABLE [dbo].[CAT_INSTRUCCION]
(
[IdInstruccion] [bigint] NOT NULL,
[CveInstruccion] [int] NOT NULL,
[InstruccionName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_INSTRUCCION] ADD CONSTRAINT [CAT_INSTRUCCION_PK] PRIMARY KEY CLUSTERED  ([IdInstruccion]) ON [PRIMARY]
GO
