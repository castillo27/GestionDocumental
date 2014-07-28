CREATE TABLE [dbo].[CAT_STATUS_TURNO]
(
[IdStatusTurno] [bigint] NOT NULL,
[StatusName] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL,
[IsModified] [bit] NOT NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_STATUS_TURNO] ADD CONSTRAINT [CAT_STATUS_TURNO_PK] PRIMARY KEY CLUSTERED  ([IdStatusTurno]) ON [PRIMARY]
GO
