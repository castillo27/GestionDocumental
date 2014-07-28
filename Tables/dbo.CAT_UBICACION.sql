CREATE TABLE [dbo].[CAT_UBICACION]
(
[IdUbicacion] [bigint] NOT NULL,
[UbicacionName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_UBICACION] ADD CONSTRAINT [CAT_UBICACION_PK] PRIMARY KEY CLUSTERED  ([IdUbicacion]) ON [PRIMARY]
GO
