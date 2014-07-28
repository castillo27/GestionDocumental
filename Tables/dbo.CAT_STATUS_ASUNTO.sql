CREATE TABLE [dbo].[CAT_STATUS_ASUNTO]
(
[IdStatusAsunto] [bigint] NOT NULL,
[StatusName] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IsActive] [bit] NULL,
[LastModifiedDate] [bigint] NULL,
[IsModified] [bit] NULL,
[ServerLastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CAT_STATUS_ASUNTO] ADD CONSTRAINT [CAT_STATUS_ASUNTO_PK] PRIMARY KEY CLUSTERED  ([IdStatusAsunto]) ON [PRIMARY]
GO
