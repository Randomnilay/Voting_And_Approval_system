USE [master]
GO
/****** Object:  Database [Voting_And_Approval_System]    Script Date: 23-02-2023 2.49.36 PM ******/
CREATE DATABASE [Voting_And_Approval_System]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Voting_And_Approval_System', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Voting_And_Approval_System.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Voting_And_Approval_System_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Voting_And_Approval_System_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Voting_And_Approval_System] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Voting_And_Approval_System].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Voting_And_Approval_System] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET ARITHABORT OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Voting_And_Approval_System] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Voting_And_Approval_System] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Voting_And_Approval_System] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Voting_And_Approval_System] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Voting_And_Approval_System] SET  MULTI_USER 
GO
ALTER DATABASE [Voting_And_Approval_System] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Voting_And_Approval_System] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Voting_And_Approval_System] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Voting_And_Approval_System] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Voting_And_Approval_System] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Voting_And_Approval_System] SET QUERY_STORE = OFF
GO
USE [Voting_And_Approval_System]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Voting_And_Approval_System]
GO
/****** Object:  UserDefinedFunction [dbo].[get_vote_percentage]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_vote_percentage](@issue_id INT, @option_id INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @total_votes INT;
    DECLARE @option_votes INT;
    DECLARE @vote_percentage FLOAT;
 
    SELECT @total_votes = COUNT(*)
    FROM dbo.tbl_votes
    WHERE issue_id = @issue_id;
 
    SELECT @option_votes = COUNT(*)
    FROM dbo.tbl_votes
    WHERE issue_id = @issue_id AND option_id = @option_id;
 
    IF @total_votes = 0
        SET @vote_percentage = 0;
    ELSE
        SET @vote_percentage = (@option_votes * 1.0 / @total_votes) * 100;
 
    RETURN @vote_percentage;
END;
GO
/****** Object:  Table [dbo].[tbl_options]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_options](
	[option_id] [int] IDENTITY(1,1) NOT NULL,
	[option_title] [varchar](80) NOT NULL,
	[option_description] [varchar](500) NOT NULL,
	[option_created_date] [datetime] NOT NULL,
	[option_updated_date] [datetime] NOT NULL,
	[status] [bit] NOT NULL,
	[issue_id] [int] NOT NULL,
	[option_attachment] [varchar](500) NULL,
 CONSTRAINT [PK_tbl_option] PRIMARY KEY CLUSTERED 
(
	[option_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_votes]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_votes](
	[vote_id] [int] IDENTITY(1,1) NOT NULL,
	[issue_id] [int] NOT NULL,
	[option_id] [int] NOT NULL,
	[vote_time] [datetime] NOT NULL,
 CONSTRAINT [PK_tbl_votes] PRIMARY KEY CLUSTERED 
(
	[vote_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_result]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_result](@issue_id int) RETURNS TABLE AS
RETURN(
	select option_title from tbl_options where option_id in (select max(option_id) from tbl_votes where issue_id = @issue_id group by option_id)
	)
GO
/****** Object:  Table [dbo].[tbl_issue]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_issue](
	[issue_id] [int] IDENTITY(1,1) NOT NULL,
	[issue_title] [varchar](80) NOT NULL,
	[issue_description] [varchar](500) NOT NULL,
	[issue_created_date] [datetime] NOT NULL,
	[issue_updated_date] [datetime] NOT NULL,
	[issue_status] [bit] NOT NULL,
	[prop_id] [int] NOT NULL,
	[issue_attachment] [varchar](500) NULL,
	[user_id] [int] NULL,
 CONSTRAINT [PK_tbl_issue] PRIMARY KEY CLUSTERED 
(
	[issue_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_poll]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[get_poll](@issue_id int) returns table as
return(
select tbl_issue.issue_title,tbl_options.option_title,count(tbl_votes.option_id) as votes_count from tbl_votes,tbl_options,tbl_issue 
where tbl_votes.option_id = tbl_options.option_id and tbl_options.issue_id = tbl_issue.issue_id and tbl_votes.issue_id = @issue_id group by tbl_options.option_title, tbl_issue.issue_title
	)
GO
/****** Object:  View [dbo].[display_issue_and_options]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[display_issue_and_options] as 
select tbl_issue.issue_title,option_title from tbl_options,tbl_issue where tbl_issue.issue_id = tbl_options.issue_id group by tbl_issue.issue_title,tbl_options.option_title
GO
/****** Object:  Table [dbo].[tbl_announcements]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_announcements](
	[announcement_id] [int] IDENTITY(1,1) NOT NULL,
	[announcement_title] [varchar](80) NOT NULL,
	[announcement_description] [varchar](500) NOT NULL,
	[announcement_created_date] [datetime] NOT NULL,
	[announcement_updated_date] [datetime] NOT NULL,
	[announcement_status] [bit] NOT NULL,
	[user_id] [int] NOT NULL,
	[prop_id] [int] NOT NULL,
 CONSTRAINT [PK_tbl_announcements] PRIMARY KEY CLUSTERED 
(
	[announcement_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_announcements_track]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_announcements_track](
	[announcement_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[seen_time] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[active_announcements]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[active_announcements] AS
SELECT 
    a.announcement_id, 
    a.announcement_title, 
    a.announcement_description, 
    a.announcement_created_date, 
    a.announcement_updated_date, 
    a.user_id, 
    COUNT(t.user_id) AS num_users_seen
FROM 
    dbo.tbl_announcements a
LEFT JOIN 
    dbo.tbl_announcements_track t ON a.announcement_id = t.announcement_id
WHERE 
    a.announcement_status = 1
GROUP BY 
    a.announcement_id, 
    a.announcement_title, 
    a.announcement_description, 
    a.announcement_created_date, 
    a.announcement_updated_date, 
    a.user_id;
 
GO
/****** Object:  Table [dbo].[tbl_properties]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_properties](
	[prop_id] [int] IDENTITY(1,1) NOT NULL,
	[prop_name] [varchar](50) NOT NULL,
	[prop_description] [varchar](100) NOT NULL,
	[prop_created_date] [datetime] NOT NULL,
	[status] [bit] NOT NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[prop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[properties_with_activity]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[properties_with_activity] AS
SELECT 
    p.prop_id, 
    p.prop_name, 
    p.prop_description, 
    p.prop_created_date, 
    COUNT(DISTINCT i.issue_id) AS num_active_issues, 
    COUNT(DISTINCT a.announcement_id) AS num_active_announcements
FROM 
    dbo.tbl_properties p
LEFT JOIN 
    dbo.tbl_issue i ON p.prop_id = i.prop_id AND i.issue_status = 1
LEFT JOIN 
    dbo.tbl_announcements a ON p.prop_id = a.prop_id AND a.announcement_status = 1
WHERE 
    p.status = 1
GROUP BY 
    p.prop_id, 
    p.prop_name, 
    p.prop_description, 
    p.prop_created_date;
GO
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_roles](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_title] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_roles] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_users]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[password] [varchar](20) NOT NULL,
	[email] [varchar](40) NOT NULL,
	[phno] [varchar](10) NOT NULL,
	[unit_no] [varchar](6) NOT NULL,
	[user_created_date] [datetime] NOT NULL,
	[user_updated_date] [datetime] NOT NULL,
	[status] [bit] NOT NULL,
	[role_id] [int] NOT NULL,
 CONSTRAINT [PK_tbl_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_votes_tracking]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_votes_tracking](
	[issue_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[vote_id] [int] NULL,
	[vote_time] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_announcements]  WITH CHECK ADD FOREIGN KEY([prop_id])
REFERENCES [dbo].[tbl_properties] ([prop_id])
GO
ALTER TABLE [dbo].[tbl_announcements]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[tbl_users] ([user_id])
GO
ALTER TABLE [dbo].[tbl_announcements_track]  WITH CHECK ADD FOREIGN KEY([announcement_id])
REFERENCES [dbo].[tbl_announcements] ([announcement_id])
GO
ALTER TABLE [dbo].[tbl_announcements_track]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[tbl_users] ([user_id])
GO
ALTER TABLE [dbo].[tbl_issue]  WITH CHECK ADD FOREIGN KEY([prop_id])
REFERENCES [dbo].[tbl_properties] ([prop_id])
GO
ALTER TABLE [dbo].[tbl_issue]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[tbl_users] ([user_id])
GO
ALTER TABLE [dbo].[tbl_options]  WITH CHECK ADD FOREIGN KEY([issue_id])
REFERENCES [dbo].[tbl_issue] ([issue_id])
GO
ALTER TABLE [dbo].[tbl_properties]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[tbl_users] ([user_id])
GO
ALTER TABLE [dbo].[tbl_users]  WITH CHECK ADD FOREIGN KEY([role_id])
REFERENCES [dbo].[tbl_roles] ([role_id])
GO
ALTER TABLE [dbo].[tbl_votes]  WITH CHECK ADD FOREIGN KEY([issue_id])
REFERENCES [dbo].[tbl_issue] ([issue_id])
GO
ALTER TABLE [dbo].[tbl_votes]  WITH CHECK ADD FOREIGN KEY([option_id])
REFERENCES [dbo].[tbl_options] ([option_id])
GO
ALTER TABLE [dbo].[tbl_votes_tracking]  WITH CHECK ADD FOREIGN KEY([issue_id])
REFERENCES [dbo].[tbl_issue] ([issue_id])
GO
ALTER TABLE [dbo].[tbl_votes_tracking]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[tbl_users] ([user_id])
GO
ALTER TABLE [dbo].[tbl_votes_tracking]  WITH CHECK ADD FOREIGN KEY([vote_id])
REFERENCES [dbo].[tbl_votes] ([vote_id])
GO
/****** Object:  StoredProcedure [dbo].[check_revoting]    Script Date: 23-02-2023 2.49.36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[check_revoting](@issue_id int) as begin
declare @vote_percentage float, @tot_user int, @user_vote int 

	select @tot_user = count(user_id) from tbl_users 

	select @user_vote = count(user_id) from tbl_votes_tracking where issue_id = @issue_id group by issue_id

	set @vote_percentage = @user_vote * 100 / @tot_user

	--print @vote_percentage

	if @vote_percentage < 50
	begin
		delete from tbl_votes where issue_id = @issue_id

		delete from tbl_votes_tracking where issue_id = @issue_id
	end
	else
	begin
		print 'No Action Taken';
	end
end
GO
USE [master]
GO
ALTER DATABASE [Voting_And_Approval_System] SET  READ_WRITE 
GO
