CREATE TABLE [dbo].[INF_FORM]
(
[IdForm] [bigint] NOT NULL,
[FormName] [nvarchar] (250) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[IsModified] [bit] NOT NULL,
[LastModifiedDate] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_FORM] ADD CONSTRAINT [INF_FORM_PK] PRIMARY KEY CLUSTERED  ([IdForm]) ON [PRIMARY]
GO
