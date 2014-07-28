CREATE TABLE [dbo].[CAT_ORGANIGRAMA]
(
[IdJerarquia] [bigint] NOT NULL,
[IdJerarquiaParent] [bigint] NULL,
[JerarquiaName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NULL,
[LastModifiedDate] [bigint] NULL,
[IsModified] [bit] NULL,
[IdRol] [bigint] NOT NULL,
[ServerLastModifiedDate] [bigint] NULL,
[IdTipoUnidadNormativa] [bigint] NULL,
[JerarquiaTitular] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_ORGANIGRAMA] ADD CONSTRAINT [CAT_ORGANIGRAMA_PK] PRIMARY KEY CLUSTERED  ([IdJerarquia], [IdRol]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_ORGANIGRAMA] ADD CONSTRAINT [FK_CAT_ORGANIGRAMA_CAT_TIPO_UNIDAD_NORMATIVA] FOREIGN KEY ([IdTipoUnidadNormativa]) REFERENCES [dbo].[CAT_TIPO_UNIDAD_NORMATIVA] ([IdTipoUnidadNormativa])
GO
