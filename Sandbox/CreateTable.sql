/*--------------------------------------------------*/

/* Delete all tables */
DROP TABLE [dbo].Training_QuestionnaireTable
DROP TABLE [dbo].Training_UserRegistrationTable
DROP TABLE [dbo].Training_ClassTable
DROP TABLE [dbo].Training_PlanTable

DROP TABLE [dbo].Exam_UserRegistrationTable
DROP TABLE [dbo].Exam_InstanceTable
DROP TABLE [dbo].Exam_PaperInfoTable
DROP TABLE [dbo].Exam_PaperDescTable
DROP TABLE [dbo].Exam_QuestionTable

DROP TABLE [dbo].Lab_UserRegistrationTable
DROP TABLE [dbo].Lab_InstanceTable

DROP TABLE [dbo].Course_UserRegistrationTable
DROP TABLE [dbo].Course_LeturerTable
DROP TABLE [dbo].Course_ResourceTable
DROP TABLE [dbo].Course_InfoTable

DROP TABLE [dbo].KDB_UserFollowTable
DROP TABLE [dbo].KDB_KnowledgTable

DROP TABLE [dbo].Reward_AssignTable
DROP TABLE [dbo].Reward_RuleTable


DROP TABLE [dbo].Account_UserInfoTable
DROP TABLE [dbo].Account_AdminInfoTable

DROP TABLE [dbo].Sys_LogTable
DROP TABLE [dbo].Sys_ConstantTable
DROP TABLE [dbo].Sys_MailTable

DROP TABLE [dbo].Sys_AccountTable

DROP TABLE [dbo].Sys_AccAuthRuleTable 
DROP TABLE [dbo].Sys_AccAuthTable

/*--------------------------------------------------*/

/*System Table*/
/* 小型表, 存储权限条目, 比如	[ID: 1, Desc: 读取日志文件] */
/* 							[ID: 2, Desc: 删除日志文件] */
CREATE TABLE [dbo].Sys_AccAuthTable
(
	[AA_ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Desc] TEXT NULL DEFAULT '',
)

/* 小型表, 存储访问规则, 每条规则可包含多个条目, 比如	[ID: 1, RuleID: 1, AA_ID: 1] */
/* 													[ID: 2, RuleID: 1, AA_ID: 1] */
/* 1号条目就定义了一个拥有该规则的用户可以读取和修改系统日志文件						 */
CREATE TABLE [dbo].Sys_AccAuthRuleTable 
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Rule_ID] INT NOT NULL,
	[AA_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccAuthTable(AA_ID),
)

CREATE TABLE [dbo].Sys_AccountTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account] TEXT NOT NULL,
	[Password] BINARY(512) NOT NULL, /*Hash Value, 存储密码哈希值*/
	[Rule_ID] INT NOT NULL, /*其实可以改成文本, 一个用户拥有多个规则, 如: [1;2]*/
)

/* 大型表, Message为TEXT类型可能会占用过多存储空间 */
CREATE TABLE [dbo].Sys_LogTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Action] INT NOT NULL,
	[Message] TEXT DEFAULT '',
	[Code] INT DEFAULT 0,
	[IP_Address] INT DEFAULT 0,
	[MediaType] INT, /*Chrome, IE, iOS， 具体类型存储于常量表*/
	[TimeStamp] DATETIME NOT NULL DEFAULT GETDATE(),
)

/* 小型表, 系统常量表, 键-值 对形式， 比如	[ID: 10, Key: 20, Value: Chrome] */
/*										[ID: 11, Key: 21, Value: IE]	 */
/*										[ID: 12, Key: 22, Value: Safari] */
CREATE TABLE [dbo].Sys_ConstantTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Key] INT NOT NULL,
	[Value] TEXT NOT NULL,
	[Desc] NVARCHAR(64) NULL DEFAULT '',
)

CREATE TABLE [dbo].Sys_MailTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[PrevMail_ID] INT DEFAULT 0,
	[Src_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Dest_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[TimeStamp] DATETIME NOT NULL DEFAULT GETDATE(),
	[Title] TEXT NOT NULL,
	[Message] TEXT NOT NULL,
)

/*--------------------------------------------------*/

CREATE TABLE [dbo].Account_UserInfoTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Name] NCHAR(64) NOT NULL,
	[Gender] BIT NOT NULL,
	[Nation] INT NOT NULL,
	[IdentityNumber] NCHAR(32) NOT NULL, /* 证件编号 */
	[Email] CHAR(64) NOT NULL,
	[Phone] CHAR(16) NOT NULL,
	[Avater_URL] TEXT NOT NULL DEFAULT '',
	[EmployeeType] INT NOT NULL,
	[Section] INT NOT NULL, /* 序列 */
	[Department] INT NOT NULL, /* 部门 */
	[Position] INT NOT NULL, /* 岗位 */
	[Duties] INT NOT NULL, /* 职务 */
	[HR_ID] INT NOT NULL,
)

CREATE TABLE [dbo].Account_AdminInfoTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Name] NCHAR(64) NOT NULL,
	[Email] CHAR(63) NOT NULL,
	[Phone] CHAR(16) NOT NULL,
)

/*--------------------------------------------------*/

/* 小型表, 积分规则表 */
CREATE TABLE [dbo].Reward_RuleTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[ActionName] TEXT NOT NULL,
	[Credit] INT NOT NULL, /* 积分可正可负 */
)

/* 大型表, 积分分配表 (用户积分日志表) */
CREATE TABLE [dbo].Reward_AssignTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Reward_ID] INT NOT NULL FOREIGN KEY REFERENCES Reward_RuleTable(ID),
	[Credit] INT NOT NULL,
	[Message] TEXT NOT NULL, /* 附加消息, 可忽略 */
	[TimeStamp] DATETIME NOT NULL DEFAULT GETDATE(),
)

/*--------------------------------------------------*/

CREATE TABLE [dbo].KDB_KnowledgTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,
	[CreateTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[AccessCode] BINARY(512) NULL, /* Hashed */
	[Private] BIT NOT NULL, /* BOOL */
	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[FileType] INT NOT NULL, /* ContaintTable */
	[Category] INT NOT NULL, /* ContaintTable */
	[Department] INT NOT NULL, /* ContaintTable */
	[SectionType] INT NOT NULL, /* ContaintTable */
	[DownloadTimes] INT NOT NULL,
	[AccessTimes] INT NOT NULL,
	[Rate] FLOAT NOT NULL, /* 评分, 可运行时统计 */
	[Downloadable] BIT NOT NULL, /* BOOL */
	[Desc] TEXT NULL,
	[Att_URL] TEXT NULL,
)

/* KDB_CommentsTable */

CREATE TABLE [dbo].KDB_UserFollowTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[K_ID] INT NOT NULL FOREIGN KEY REFERENCES KDB_KnowledgTable(ID),
	[Follow] BIT NOT NULL, /* BOOL */
	[Rate] INT NULL, /* -1, No Rate */
)

/*--------------------------------------------------*/

CREATE TABLE [dbo].Course_InfoTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,
	[Desc] TEXT NOT NULL,

	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[CreateTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),

	[Category] INT NOT NULL,
	[Department] INT NOT NULL,
	[SectionType] INT NOT NULL,

	[CourseHour] TIME NOT NULL,
	[Credict] INT NOT NULL,

	[Lecturer] TEXT NOT NULL,
)

CREATE TABLE [dbo].Course_ResourceTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Course_ID] INT NOT NULL FOREIGN KEY REFERENCES Course_InfoTable(ID),
	[Type] INT NOT NULL,
	[Resource_ID] INT NOT NULL,
	[AddTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[Assignment] BIT NOT NULL,
)

CREATE TABLE [dbo].Course_UserRegistrationTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[User_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Course_ID] INt NOT NULL FOREIGN KEY REFERENCES Course_InfoTable(ID),
	[Time] DATETIME NOT NULL DEFAULT GETDATE(),
	[Progress] INT NOT NULL,
	[Score] FLOAT NOT NULL,
	[Credict] INT NOT NULL,
	[AssignmentMark] TEXT NOT NULL,
)

CREATE TABLE [dbo].Course_LeturerTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Account_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Desc] TEXT NOT NULL,
	[Staff] BIT NOT NULL,
	[SectionType] TEXT NOT NULL,
)

/*--------------------------------------------------*/

CREATE TABLE [dbo].Exam_QuestionTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Type] INT NOT NULL,
	[Content] TEXT NOT NULL,
	[Answer] TEXT NOT NULL,
	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
)

CREATE TABLE [dbo].Exam_PaperDescTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,
	[Desc] TEXT NOT NULL,
	[Score] INT NOT NULL,
	[Level] INt NOT NULL,
	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
)

CREATE TABLE [dbo].Exam_PaperInfoTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Paper_ID] INT NOT NULL FOREIGN KEY REFERENCES Exam_PaperDescTable(ID),
	[Question_ID] INT NOT NULL FOREIGN KEY REFERENCES Exam_QuestionTable(ID),
	[Score] FLOAT NOT NULL,
)

/* 可以和试卷描述表合成一个表 */
CREATE TABLE [dbo].Exam_InstanceTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Paper_ID] INT NOT NULL FOREIGN KEY REFERENCES Exam_PaperDescTable(ID),
	[StartTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[Duration] TIME NOT NULL,
	[Reviewer] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID), /* Grader */
	[Private] BIT NOT NULL, /* BOOL */
)

CREATE TABLE [dbo].Exam_UserRegistrationTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[User_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Course_ID] INt NOT NULL FOREIGN KEY REFERENCES Course_InfoTable(ID),
	[Instance_ID] INT NOT NULL FOREIGN KEY REFERENCES Exam_InstanceTable(ID),
	[StartTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[SubmitTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[UserAnswer] TEXT NOT NULL DEFAULT '',
	[FinalScore] FLOAT NOt NULL,
)

/*--------------------------------------------------*/

CREATE TABLE [dbo].Lab_InstanceTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,
	[Desc] TEXT NOT NULL,
	[Score] FLOAT NOT NULL,
	[Level] INt NOT NULL,
	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[StartTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[Duration] TIME NOT NULL,
	[Reviewer] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Private] BIT NOT NULL, /* BOOL */
	[Type] INT NOT NULL,
	[Content] TEXT NOT NULL,
)

CREATE TABLE [dbo].Lab_UserRegistrationTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[User_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Course_ID] INt NOT NULL FOREIGN KEY REFERENCES Course_InfoTable(ID),
	[Lab_ID] INT NOT NULL FOREIGN KEY REFERENCES Lab_InstanceTable(ID),
	[StartTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[SubmitTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[FinalScore] FLOAT NOt NULL,
)

/*--------------------------------------------------*/

/* 培训计划表 */
CREATE TABLE [dbo].Training_PlanTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,

	[Holder_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),

	[Year] INT NOT NULL,
	[SuperviseDept] INT NOT NULL,
	[HolderDept] INT NOT NULL,
	[AssentDept] INT NULL,

	[NumOfSeasons] INT NOT NULL,
	[NumOfRemain] INT NOT NULL,
	[DayPerS] INT NOT NULL,
	[QuotaPerS] INT NOT NULL,
	[ExecuteDate] TEXT NOT NULL,

	[CreateTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),

	[Target] TEXT NOT NULL,
	[TargetType] INT NOT NULL,
	[TargetDesc] TEXT NULL,
	[CourseDesc] TEXT NULL,
	[AimDesc] TEXT NULL,
	[MethodDesc] TEXT NULL,
	[Location] INT NOT NULL,
	[SectionType] INT NOT NULL,

	[Lecturer] TEXT NOT NULL, /* 多人 */

	[AverageCost] FLOAT NULL,

	[ApprovalStatus] INT NOT NULL,

)

/* 培训班表 */
CREATE TABLE [dbo].Training_ClassTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] TEXT NOT NULL,

	[Plan_ID] INT NOT NULL FOREIGN KEY REFERENCES Training_PlanTable(ID),
	[Holder_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Creater_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),

	[Year] INT NOT NULL,
	[SuperviseDept] INT NOT NULL,
	[HolderDept] INT NOT NULL,
	[AssentDept] INT NULL,

	[DayPerS] INT NOT NULL,
	[QuotaPerS] INT NOT NULL,
	[ExecuteDate] TEXT NOT NULL,

	[CreateTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[ExpireTime] DATETIME NOT NULL DEFAULT GETDATE(),

	[Target] TEXT NOT NULL,
	[TargetType] INT NOT NULL,
	[TargetDesc] TEXT NULL,
	[CourseDesc] TEXT NULL,
	[AimDesc] TEXT NULL,
	[MethodDesc] TEXT NULL,
	[Location] INt NOT NULL,
	[SectionType] INT NOT NULL,

	[Lecturer] TEXT NOT NULL,
	[AverageCost] FLOAT NULL,

	[ClassType] BIT NOT NULL,
	[Course_ID] INT NOT NULL FOREIGN KEY REFERENCES Course_InfoTable(ID),
	[TrainingAddress] INt NOT NULL,
	[Cost] FLOAT NULL,
	[Requirement] TEXT NULL,
	[Memo] TEXT NULL,

	[CheckInTime] DATETIME NOT NULL DEFAULT GETDATE(),
	[TrainingContent] TEXT NULL,

	[ApprovalStatus] INT NOT NULL,

)

CREATE TABLE [dbo].Training_UserRegistrationTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[User_ID] INT NOT NULL FOREIGN KEY REFERENCES Sys_AccountTable(ID),
	[Class_ID] INt NOT NULL FOREIGN KEY REFERENCES Training_ClassTable(ID),
	[Time] DATETIME NOT NULL DEFAULT GETDATE(),
)

CREATE TABLE [dbo].Training_QuestionnaireTable
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Test_ID] INT NOT NULL FOREIGN KEY REFERENCES Exam_InstanceTable(ID),
)

/*--------------------------------------------------*/

/* Fill Database */
SET IDENTITY_INSERT [dbo].[Sys_AccAuthTable] ON
INSERT INTO [dbo].[Sys_AccAuthTable] ([AA_ID], [Desc]) VALUES (1, N'"Login"')
INSERT INTO [dbo].[Sys_AccAuthTable] ([AA_ID], [Desc]) VALUES (2, N'"Logout"')
INSERT INTO [dbo].[Sys_AccAuthTable] ([AA_ID], [Desc]) VALUES (3, N'"Admin Access"')
INSERT INTO [dbo].[Sys_AccAuthTable] ([AA_ID], [Desc]) VALUES (4, N'"User Access"')
SET IDENTITY_INSERT [dbo].[Sys_AccAuthTable] OFF

SET IDENTITY_INSERT [dbo].[Sys_AccAuthRuleTable] ON
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (1, 1, 1)
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (2, 1, 2)
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (3, 1, 3)
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (4, 2, 1)
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (5, 2, 2)
INSERT INTO [dbo].[Sys_AccAuthRuleTable] ([ID], [Rule_ID], [AA_ID]) VALUES (6, 2, 4)
SET IDENTITY_INSERT [dbo].[Sys_AccAuthRuleTable] OFF


SET IDENTITY_INSERT [dbo].[Sys_AccountTable] ON
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (1, 'Admin', HASHBYTES('SHA2_512','Password'), 1)
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (2, 'User1', HASHBYTES('SHA2_512','U1'), 2)
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (3, 'User2', HASHBYTES('SHA2_512','U2'), 2)
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (4, 'User3', HASHBYTES('SHA2_512','U3'), 2)
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (5, 'User4', HASHBYTES('SHA2_512','U4'), 2)
INSERT INTO [dbo].[Sys_AccountTable] ([ID], [Account], [Password], [Rule_ID]) VALUES (6, 'User5', HASHBYTES('SHA2_512','U5'), 2)
SET IDENTITY_INSERT [dbo].[Sys_AccountTable] OFF

SET IDENTITY_INSERT [dbo].[Sys_ConstantTable] ON
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (1, 1, N'2;3;4;5', N'MediaType')
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (2, 2, N'Chrome', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (3, 3, N'IE', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (4, 4, N'Firefox', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (5, 5, N'Safari', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (6, 6, N'7;8;9;10', N'Department')
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (7, 7, N'Dep1', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (8, 8, N'Dep2', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (9, 9, N'Dep3', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (10, 10, N'Dep4', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (11, 15, N'Login', NULL)
INSERT INTO [dbo].[Sys_ConstantTable] ([ID], [Key], [Value], [Desc]) VALUES (12, 16, N'Logout', NULL)
SET IDENTITY_INSERT [dbo].[Sys_ConstantTable] OFF

SET IDENTITY_INSERT [dbo].[Sys_LogTable] ON
INSERT INTO [dbo].[Sys_LogTable] ([ID], [Account_ID], [Action], [Message], [Code], [IP_Address], [MediaType]) VALUES (1, 1, 15, N'"Msg: Account - Admin Login"', 0, 0, 2)
INSERT INTO [dbo].[Sys_LogTable] ([ID], [Account_ID], [Action], [Message], [Code], [IP_Address], [MediaType]) VALUES (2, 1, 16, N'"Msg: Account - Admin Logout"', 0, 0, 2)
SET IDENTITY_INSERT [dbo].[Sys_LogTable] OFF

SET IDENTITY_INSERT [dbo].[Sys_MailTable] ON
INSERT INTO [dbo].[Sys_MailTable] ([ID], [PrevMail_ID], [Src_ID], [Dest_ID], [Title], [Message]) VALUES (1, 0, 1, 2, N'Test Mail', N'Hi, this is a test mail. Admin')
INSERT INTO [dbo].[Sys_MailTable] ([ID], [PrevMail_ID], [Src_ID], [Dest_ID], [Title], [Message]) VALUES (2, 1, 2, 1, N'Test Mail', N'Reply. User')
SET IDENTITY_INSERT [dbo].[Sys_MailTable] OFF
