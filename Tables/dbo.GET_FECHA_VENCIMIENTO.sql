CREATE TABLE [dbo].[GET_FECHA_VENCIMIENTO]
(
[IdFechaVencimiento] [bigint] NOT NULL,
[IdAsunto] [bigint] NOT NULL,
[FechaVencimiento] [datetime] NOT NULL,
[FechaCreacion] [datetime] NOT NULL,
[IsActual] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[IsModified] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_FECHA_VENCIMIENTO] ADD CONSTRAINT [GET_FECHA_VENCIMIENTO_PK] PRIMARY KEY CLUSTERED  ([IdFechaVencimiento]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GET_FECHA_VENCIMIENTO] ADD CONSTRAINT [GET_ASUNTO_GET_FECHA_VENCIMIENTO_FK1] FOREIGN KEY ([IdAsunto]) REFERENCES [dbo].[GET_ASUNTO] ([IdAsunto])
GO
