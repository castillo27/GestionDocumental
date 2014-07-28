CREATE TABLE [dbo].[CAT_PRIORIDAD]
(
[IdPrioridad] [bigint] NOT NULL,
[PrioridadName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[PathImagen] [nvarchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_PRIORIDAD] ADD CONSTRAINT [CAT_PRIORIDAD_PK] PRIMARY KEY CLUSTERED  ([IdPrioridad]) ON [PRIMARY]
GO
