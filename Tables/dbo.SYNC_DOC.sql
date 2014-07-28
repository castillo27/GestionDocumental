CREATE TABLE [dbo].[SYNC_DOC]
(
[IdDocumento] [bigint] NOT NULL,
[BanderaStatus] [bit] NOT NULL,
[FechaCarga] [datetime] NULL,
[Exception] [nvarchar] (max) COLLATE Modern_Spanish_CI_AS NULL,
[LastModifiedDate] [bigint] NOT NULL,
[StatusDoc] [nvarchar] (125) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Extencion] [nvarchar] (16) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYNC_DOC] ADD CONSTRAINT [PK_SYNC_DOC] PRIMARY KEY CLUSTERED  ([IdDocumento]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYNC_DOC] ADD CONSTRAINT [FK_SYNC_DOC_GET_DOCUMENTOS] FOREIGN KEY ([IdDocumento]) REFERENCES [dbo].[GET_DOCUMENTOS] ([IdDocumento])
GO
