/****** Object:  Database [KETOAN24]    Script Date: 4/22/2016 4:01:40 PM ******/
CREATE DATABASE [KETOAN24]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EV_TEST_Data', FILENAME = N'D:\Thientm\Ketoan24\RUNDB\KETOAN24.mdf' , SIZE = 96896KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'EV_TEST_Log', FILENAME = N'D:\Thientm\Ketoan24\RUNDB\KETOAN24_1.ldf' , SIZE = 1024KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [KETOAN24] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [KETOAN24].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [KETOAN24] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KETOAN24] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KETOAN24] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KETOAN24] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KETOAN24] SET ARITHABORT OFF 
GO
ALTER DATABASE [KETOAN24] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [KETOAN24] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [KETOAN24] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [KETOAN24] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KETOAN24] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KETOAN24] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KETOAN24] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KETOAN24] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KETOAN24] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KETOAN24] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KETOAN24] SET  DISABLE_BROKER 
GO
ALTER DATABASE [KETOAN24] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KETOAN24] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KETOAN24] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [KETOAN24] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [KETOAN24] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KETOAN24] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KETOAN24] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [KETOAN24] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [KETOAN24] SET  MULTI_USER 
GO
ALTER DATABASE [KETOAN24] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [KETOAN24] SET DB_CHAINING OFF 
GO
ALTER DATABASE [KETOAN24] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [KETOAN24] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
/****** Object:  User [nexsoft]    Script Date: 4/22/2016 4:01:40 PM ******/
CREATE USER [nexsoft] FOR LOGIN [nexsoft] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Guests]    Script Date: 4/22/2016 4:01:40 PM ******/
CREATE USER [Guests] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[Guests]
GO
/****** Object:  User [gsoftCRM]    Script Date: 4/22/2016 4:01:40 PM ******/
CREATE USER [gsoftCRM] FOR LOGIN [gsoftCRM] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [nexsoft]
GO
ALTER ROLE [db_owner] ADD MEMBER [Guests]
GO
ALTER ROLE [db_owner] ADD MEMBER [gsoftCRM]
GO
/****** Object:  Schema [Guests]    Script Date: 4/22/2016 4:01:40 PM ******/
CREATE SCHEMA [Guests]
GO
/****** Object:  StoredProcedure [dbo].[CongTo_GetCongTo]    Script Date: 4/22/2016 4:01:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure


/*
exec CongTo_GetCongTo 'PCCN','EV01'
exec CongTo_GetCongTo 'PCCN','G2000'
*/
CREATE Procedure [dbo].[CongTo_GetCongTo]
(
	@MaCongTo nvarchar(50),
	@SiteID nvarchar(50)
)
--with encryption --JBViet 13/01/2011 11:04
AS
begin

	declare @SiteID1 nvarchar(50)
	set @SiteID1=isnull(dbo.E00F_GetChuoiCoVitri(@SiteID,1,'|'),'')

	set @MaCongTo=isnull((select top 1 MaCongToSuDung from CongTo_SuDung where MaCongTo=@MaCongTo and SiteID=@SiteID1),@MaCongTo)

----------------------------------------------
--Lấy dữ liệu
----------------------------------------------
	declare @Key nvarchar(50),@Sign varchar(50), @Suffix int, @nLen smallInt,@IsUse  bit

	Select @Sign= KyHieu,	@Suffix= SoCuoi , @nLen= ChieuDaiSo, @IsUse = SuDung
	from CongTo_ 
	where MaCongTo=@MaCongTo and SiteID = @SiteID1

	if( @Sign is Null )BEGIN
		raisError(N'CongTo_GetCongTo: Không có mã công tơ này %d',18,1, @MaCongTo )
		with SETERROR, LOG


		Return 
	END
	set @Suffix = @Suffix + 1
----------------------------------------------
--Ghep cac thanh phan lai de co dang 'KyHieu-SoCuoi'
----------------------------------------------
	set @Key =  @Sign + right('0000000000' + rtrim(lTrim(str(@Suffix))),@nLen)
	set @Key = replace(@Key,' ','')
----------------------------------------------
--- Kết quả
----------------------------------------------	
	select MaCongTo=@Key,SuDung = @IsUse
	return @@rowcount
end





GO
/****** Object:  StoredProcedure [dbo].[CongTo_GetCongTo_New]    Script Date: 4/22/2016 4:01:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec CongTo_GetCongTo_New @MaCongTo=N'PCT_S1D',@SiteID=N'NX01',@NgayThang=N'08/14/2012'
CREATE Procedure [dbo].[CongTo_GetCongTo_New]
(
	@MaCongTo nvarchar(50),
	@SiteID nvarchar(50),
	@NgayThang datetime
)
--with encryption --JBViet 13/01/2011 11:04
AS
begin

	declare @SiteID1 nvarchar(50)
	set @SiteID1=isnull(dbo.E00F_GetChuoiCoVitri(@SiteID,1,'|'),'')

	set @MaCongTo=isnull((select top 1 MaCongToSuDung from CongTo_SuDung where MaCongTo=@MaCongTo and SiteID=@SiteID1),@MaCongTo)

----------------------------------------------
--Lấy dữ liệu
----------------------------------------------
	declare @Key nvarchar(50),@IsUse  bit
	set @Key=''
	Select @IsUse = SuDung
	from CongTo_ 
	where MaCongTo=@MaCongTo and SiteID = @SiteID1
		
	if not exists( select top 1 * from CongTo_ 	where MaCongTo=@MaCongTo and SiteID = @SiteID1)
	BEGIN
		raisError(N'CongTo_GetCongTo: Không có mã công tơ này %s',18,1, @MaCongTo )
			
		with SETERROR, LOG
		Return 
	END
	set @Key =  [dbo].[CongTo_fn_GetSoChungTu](@MaCongTo,@SiteID,'','',@Ngaythang,1)
----------------------------------------------
--- Kết quả
----------------------------------------------	
	select MaCongTo=@Key,SuDung = @IsUse
	return @@rowcount
end







GO
/****** Object:  StoredProcedure [dbo].[CongTo_GetInfoData]    Script Date: 4/22/2016 4:01:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[CongTo_GetInfoData]
(@SiteID nvarchar(50),
@Lang nvarchar(10)
)
as
begin
SELECT [MaCongTo], 
[TenCongTo], 
[KyHieu], 
[SoCuoi], 
[ChieuDaiSo], 
[SuDung], 
[Wait], 
[SiteID] 
FROM [dbo].[Congto_]
where (SiteID =@SiteID or @SiteID ='')
end

GO
/****** Object:  StoredProcedure [dbo].[CongTo_GetNextCode]    Script Date: 4/22/2016 4:01:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
declare @p nvarchar(50)
exec CongTo_GetNextCode @MaCongTo='PNK',@SiteID='EV01',@key=@p output,@UserID='admin'
select @p
select * from congto_ where wait=1
update congto_ set wait=0 where wait=1
*/
CREATE  Procedure [dbo].[CongTo_GetNextCode]
(
	@MaCongTo nvarchar(50),
	@SiteID nvarchar(50),
	@Key nvarchar(50) output,
	@UserID nvarchar(50)=''
	--@NgayThang datetime
)
--with encryption --JBViet 07/01/2011 18:46
AS
SET NOCOUNT ON

	declare @SiteID1 nvarchar(50)
	set @SiteID1=isnull(dbo.E00F_GetChuoiCoVitri(@SiteID,1,'|'),'')

	set @MaCongTo=isnull((select top 1 MaCongToSuDung from CongTo_SuDung where MaCongTo=@MaCongTo and SiteID=@SiteID1),@MaCongTo)

	set @Key = ''
	declare @fLayCongTo int
	create table #tbkq(kq int)
/*
----------------------------------------------
--Nếu có công tơ trong bảng tạm thì lấy mã và xóa
----------------------------------------------	
	if exists (select top 1 * 
		from Congto__
		where MaCongTo = @MaCongTo and SiteID = @SiteID1)
	begin
		set @fLayCongTo=0

		select top 1 @Key = Congto from Congto__
		where MaCongTo= @MaCongTo and SiteID =@SiteID1
		order by Congto 
		
		--Bổ sung theo danh sách trong lệnh select:
		--select * from Congto_ where siteid='EV01' and MaCongTo not in('THEVIP','PTT','PTHNCC','PTHKH','PTCN','Promotion','PROD','PCT','PNKK','PNK','PXK','PCK','PCCN','NhomKM','NV','KH','KHTH','NCC','HDMH','HDBL','HDBH','DDHM','DDHB','CTKM','CHINHSACH','BGBARCODE','BGB','BGM','BGS') order by macongto


		delete #tbkq
		insert into #tbkq(kq) exec evCongTo_CheckExists @SiteID1,@MaCongTo,@Key
		set @fLayCongTo=isnull((select top 1 kq from #tbkq),0)



		delete dbo.Congto__
		where MaCongTo = @MaCongTo and SiteID = @SiteID1 and Congto = @Key

		if @fLayCongTo=1 goto LayCongTo
		Return 1
	end
	*/
----------------------------------------------
--Lấy dữ liệu
----------------------------------------------
LayCongTo:
	declare @Sign nvarchar(50), @Suffix int, @nLen smallInt

	Select @Sign= KyHieu,	@Suffix= SoCuoi , @nLen= ChieuDaiSo
	from CongTo_
	where MaCongTo=@MaCongTo and SiteID = @SiteID1

	if( @Sign is Null )BEGIN
		set @Key = '# Sign is NULL #'
		raisError(N'GetNextCode: không tìm thấy %d',18,1, @MaCongTo )
		with SETERROR, LOG
		Return 1
	END
	set @Suffix = @Suffix + 1
----------------------------------------------
--Ghep cac thanh phan lai de co dang 'KyHieu-SoCuoi'
----------------------------------------------
	set @Key =  @Sign + right('0000000000' + rtrim(lTrim(str(@Suffix))),@nLen)
	set @Key = replace(@Key,' ','')

--set @Key =  [dbo].[CongTo_fn_GetSoChungTu](@MaCongTo,@SiteID,'',@UserID,@Ngaythang,0)


----------------------------------------------
--Kiểm tra tồn tại
----------------------------------------------	
set @fLayCongTo=0
delete #tbkq
insert into #tbkq(kq) exec evCongTo_CheckExists @SiteID1,@MaCongTo,@Key
set @fLayCongTo=isnull((select top 1 kq from #tbkq),0)
if @fLayCongTo=1 
begin
	if not exists (select top 1 * 
			from Congto_
			where MaCongTo = @MaCongTo and SiteID = @SiteID1 and Wait = 0)
	begin
		goto CoDangBat
	end
	else
	begin
		update dbo.Congto_ 
		set SoCuoi = SoCuoi + 1--, Wait = 1 
		where MaCongTo = @MaCongTo and SiteID = @SiteID1 
	
		goto LayCongTo
	end
end

----------------------------------------------
--Nếu get công tơ thành công thì bật cờ và tăng công tơ
----------------------------------------------	
	if exists (select top 1 * 
			from Congto_
			where MaCongTo = @MaCongTo and SiteID = @SiteID1 and Wait = 0)
		update dbo.Congto_ set SoCuoi = SoCuoi + 1, Wait = 1 where MaCongTo = @MaCongTo and SiteID = @SiteID1 
	else 
	   begin
CoDangBat:
		set @Key = '# Sign is NULL #'
		raisError(N'GetNextCode: Cờ đang bật, không được phép lấy công tơ %d',18,1, @MaCongTo )
		with SETERROR, LOG
		Return 1		
	   end
KetThuc:
	return


GO
/****** Object:  StoredProcedure [dbo].[CongTo_GetNextCode_New]    Script Date: 4/22/2016 4:01:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec CongTo_GetNextCode_New @MaCongTo=N'PTT_SD',@SiteID=N'EV01',@Key='123',@UserID='admin',@NgayThang=N'08/17/2012'
create Procedure [dbo].[CongTo_GetNextCode_New]
(
	@MaCongTo nvarchar(50),
	@SiteID nvarchar(50),
	@Key nvarchar(50) output,
	@UserID nvarchar(50)='',	
	@NgayThang datetime
)

AS
SET NOCOUNT ON
----------------------------------------------
-- B00: Khai báo
----------------------------------------------
	declare @SiteID1 nvarchar(50)
	set @SiteID1=isnull(dbo.E00F_GetChuoiCoVitri(@SiteID,1,'|'),'')

	set @MaCongTo=isnull((select top 1 MaCongToSuDung from CongTo_SuDung where MaCongTo=@MaCongTo and SiteID=@SiteID1),@MaCongTo)

	set @Key = ''
	declare @fLayCongTo int
	create table #tbkq(kq int)

----------------------------------------------
-- B01: Lấy mã công tơ
----------------------------------------------
	LayCongTo:
	set @Key =  [dbo].[CongTo_fn_GetSoChungTu](@MaCongTo,@SiteID,'',@UserID,@Ngaythang,1)

----------------------------------------------
-- B02: Kiểm tra mã công tơ vừa lấy đã tồn tại?
----------------------------------------------	
	set @fLayCongTo=0
	delete #tbkq
	insert into #tbkq(kq) exec evCongTo_CheckExists @SiteID1,@MaCongTo,@Key
	set @fLayCongTo=isnull((select top 1 kq from #tbkq),0)
	
----------------------------------------------
-- B02.1: Nếu mã công tơ đã tồn tại thì tăng số cuối lên và get lại Công tơ
----------------------------------------------		
	if @fLayCongTo=1 
	begin
		if not exists (select top 1 * from Congto_	where MaCongTo = @MaCongTo and SiteID = @SiteID1 and Wait = 0)
		begin
			goto CoDangBat
		end
		else begin
			update dbo.Congto_ 
			set SoCuoi = SoCuoi + 1
			where MaCongTo = @MaCongTo and SiteID = @SiteID1 
		
			goto LayCongTo
		end
	end

----------------------------------------------
--B03: Nếu get công tơ thành công thì bật cờ và tăng công tơ
----------------------------------------------	
	if exists (select top 1 * 
				from Congto_
				where MaCongTo = @MaCongTo and SiteID = @SiteID1 and Wait = 0)
		update dbo.Congto_ set SoCTHienHanh=@Key, SoCuoi = SoCuoi + 1, Wait = 0 where MaCongTo = @MaCongTo and SiteID = @SiteID1 
	else 
	   begin
			CoDangBat:
			set @Key = '# Sign is NULL #'
			raisError(N'GetNextCode: Cờ đang bật, không được phép lấy công tơ %d',18,1, @MaCongTo )
			with SETERROR, LOG
			Return 1		
	   end
KetThuc:
	return


GO
