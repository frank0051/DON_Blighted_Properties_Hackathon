USE [master]
GO
/****** Object:  Database [DON]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE DATABASE [DON]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DON', FILENAME = N'F:\data\DON.mdf' , SIZE = 867328KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DON_log', FILENAME = N'F:\data\DON_log.ldf' , SIZE = 199296KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DON] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DON].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DON] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DON] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DON] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DON] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DON] SET ARITHABORT OFF 
GO
ALTER DATABASE [DON] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DON] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DON] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DON] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DON] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DON] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DON] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DON] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DON] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DON] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DON] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DON] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DON] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DON] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DON] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DON] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DON] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DON] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DON] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DON] SET  MULTI_USER 
GO
ALTER DATABASE [DON] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DON] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DON] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DON] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DON', N'ON'
GO
USE [DON]
GO
/****** Object:  Table [dbo].[HCAD_LATLONG]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HCAD_LATLONG](
	[NPPRJId] [int] NULL,
	[HCAD] [nvarchar](25) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[inspections]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inspections](
	[NPPRJID] [int] NULL,
	[Sr_Request_Num] [nvarchar](12) NULL,
	[ViolationSubId] [int] NULL,
	[Action_Level] [nvarchar](25) NULL,
	[Action_Type] [nvarchar](25) NULL,
	[Action_Id] [nvarchar](25) NULL,
	[Date] [datetime] NULL,
	[Action] [nvarchar](50) NULL,
	[Comments] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[project_actions]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[project_actions](
	[NPPRJID] [int] NULL,
	[Sr_Request_Num] [nvarchar](12) NULL,
	[ViolationSubId] [int] NULL,
	[Action_Level] [nvarchar](25) NULL,
	[Action_Type] [nvarchar](25) NULL,
	[Action_Id] [nvarchar](25) NULL,
	[Date] [datetime] NULL,
	[Action] [nvarchar](50) NULL,
	[Comments] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[projects]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[projects](
	[NPPRJId] [int] NULL,
	[Sr_Request_Num] [nvarchar](12) NULL,
	[RecordCreateDate] [datetime] NULL,
	[HCAD] [nvarchar](16) NULL,
	[Merged_Situs] [nvarchar](255) NULL,
	[Space] [nvarchar](50) NULL,
	[ZipCode] [nvarchar](12) NULL,
	[Council District] [nvarchar](5) NULL,
	[Subdivision] [nvarchar](80) NULL,
	[Legal 1] [nvarchar](max) NULL,
	[Legal 2] [nvarchar](max) NULL,
	[Received_Method] [nvarchar](50) NULL,
	[Project_Status] [nvarchar](12) NULL,
	[Comment311upd] [nvarchar](max) NULL,
	[Count_of_Violations] [int] NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[violationActions]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[violationActions](
	[NPPRJID] [int] NULL,
	[Sr_Request_Num] [nvarchar](12) NULL,
	[ViolationSubId] [int] NULL,
	[Action_Level] [nvarchar](25) NULL,
	[Action_Type] [nvarchar](25) NULL,
	[Action_Id] [nvarchar](25) NULL,
	[Date] [datetime] NULL,
	[Action] [nvarchar](50) NULL,
	[Comments] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[violations]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[violations](
	[NPPRJId] [int] NULL,
	[Sr_Request_Num] [nvarchar](12) NULL,
	[RecordCreateDate] [datetime] NULL,
	[HCAD] [nvarchar](16) NULL,
	[Merged_Situs] [nvarchar](255) NULL,
	[Space] [nvarchar](50) NULL,
	[ZipCode] [nvarchar](12) NULL,
	[Council District] [nvarchar](50) NULL,
	[Subdivision] [nvarchar](80) NULL,
	[Legal 1] [nvarchar](max) NULL,
	[Legal 2] [nvarchar](max) NULL,
	[Received_Method] [nvarchar](50) NULL,
	[Project_Status] [nvarchar](12) NULL,
	[Comment311upd] [nvarchar](max) NULL,
	[Violation_Category] [nvarchar](50) NULL,
	[ViolationSubId] [int] NULL,
	[Ordno] [nvarchar](20) NULL,
	[ShortDes] [nvarchar](max) NULL,
	[DeadLineDate] [datetime] NULL,
	[CheckBackDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[actions]    Script Date: 6/1/2014 7:18:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[actions] as
SELECT * FROM [dbo].[inspections]

union all

SELECT * FROM [dbo].[project_actions]
GO
/****** Object:  Index [IX_inspections_NPPRJID]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE NONCLUSTERED INDEX [IX_inspections_NPPRJID] ON [dbo].[inspections]
(
	[NPPRJID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_project_actions_NPPRJID]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE NONCLUSTERED INDEX [IX_project_actions_NPPRJID] ON [dbo].[project_actions]
(
	[NPPRJID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_projects]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE NONCLUSTERED INDEX [IX_projects] ON [dbo].[projects]
(
	[HCAD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_projects_NPPJRId]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE NONCLUSTERED INDEX [IX_projects_NPPJRId] ON [dbo].[projects]
(
	[NPPRJId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_violations_NPPRJId]    Script Date: 6/1/2014 7:18:59 AM ******/
CREATE NONCLUSTERED INDEX [IX_violations_NPPRJId] ON [dbo].[violations]
(
	[NPPRJId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [DON] SET  READ_WRITE 
GO
