CREATE TABLE [dbo].[INF_ACCION]
(
[IdAccion] [bigint] NOT NULL,
[AccionName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[IsModified] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_ACCION] ADD CONSTRAINT [INF_ACCION_PK] PRIMARY KEY CLUSTERED  ([IdAccion]) ON [PRIMARY]
GO
