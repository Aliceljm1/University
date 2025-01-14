USE [master]
GO
/****** Object:  Database [QUANLYINTERNET]    Script Date: 29/06/2014 10:50:30 PM ******/
CREATE DATABASE [QUANLYINTERNET]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QUANLYINTERNET', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QUANLYINTERNET.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QUANLYINTERNET_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QUANLYINTERNET_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QUANLYINTERNET] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QUANLYINTERNET].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QUANLYINTERNET] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET ARITHABORT OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QUANLYINTERNET] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYINTERNET] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYINTERNET] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QUANLYINTERNET] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QUANLYINTERNET] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QUANLYINTERNET] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QUANLYINTERNET] SET  MULTI_USER 
GO
ALTER DATABASE [QUANLYINTERNET] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QUANLYINTERNET] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QUANLYINTERNET] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QUANLYINTERNET] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QUANLYINTERNET]
GO
/****** Object:  StoredProcedure [dbo].[DICHVU_CatMangChoDichVuChuaNopTien]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_CatMangChoDichVuChuaNopTien]
as
begin
	declare @t1 table (MaHDTT nvarchar(50) , MaDV int , CuocPhi money , SoNgayTre int)
	insert into @t1(MaHDTT,MaDV , CuocPhi,SoNgayTre) (select MaHDTT , MaDV , CuocPhi,Datediff(day , CuocDenNgay , GetDate()) as TinhToan  from HOADONTHANHTOAN where TinhTrangThanhToan ='0')
	Update DICHVU set TinhTrangDichVu = '0' where MaDV in(select MaDV from @t1 where SoNgayTre >= 30)
end
GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Delete]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Delete] (
 @MaDV int
 )
 as
 begin
	delete from CT_LLL_LSDV where MaLSDV in ( select MaLSDV from LICHSUDICHVU where MaDV = @MaDV) 
	delete from LICHSUDICHVU where MaDV = @MaDV
	delete from TAIKHOANDANGNHAP where  MaDV = @MaDV
	delete from HOADONTHANHTOAN where MaDV = @MaDV
	delete from DICHVU where MaDV = @MaDV

 end
GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Insert]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DICHVU_Insert]( @MaDV int , @MaGoiCuoc nvarchar(50) , @MaHopDong int , @DiaChiCaiDat nvarchar(50), @DiaChiHoaDon nvarchar(50), @TenDichVu nvarchar(50), @TinhTrangDichVu nvarchar(50), @SoLuongTaiKhoan nvarchar(50), @NgayLapDat date, @TinhTrangThanhToan bit, @NgayDangKy date, @MaModem nvarchar(50), @MaKieuCaiDat nvarchar(50) ) as begin declare @MaDichVuCuoi int, @return int select top(1) @MaDichVuCuoi = MaDV from DICHVU order by MaDV desc if(@MaDichVuCuoi is null) select @return = 0; else begin select @return = @MaDichVuCuoi +1 end declare @PhiLapDat int , @PhiModem int , @PhiKieuCaiDat int select @PhiModem = GiaModem from MODEM where MaModem = @MaModem select @PhiKieuCaiDat = GiaKieuCaiDat from KIEUCAIDAT where MaKieuCaiDat = @MaKieuCaiDat select @PhiLapDat = @PhiModem + @PhiKieuCaiDat Insert into DICHVU(MaDV,MaGoiCuoc , MaHopDong,DiaChiCaiDat , DiaChiHoaDon ,TenDichVu , TinhTrangDichVu,SoLuongTaiKhoan, NgayLapDat, PhiLapDat,TinhTrangThanhToan,NgayDangKy,MaModem,MaKieuCaiDat) values (@return , @MaGoiCuoc, @MaHopDong,@DiaChiCaiDat,@DiaChiHoaDon,@TenDichVu,@TinhTrangDichVu,@SoLuongTaiKhoan,@NgayLapDat,@PhiLapDat,@TinhTrangThanhToan,@NgayDangKy,@MaModem , @MaKieuCaiDat) end
GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Select]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Select]
(
@MaDV int ,
@MaGoiCuoc nvarchar(50) ,
@MaHopDong int ,
@DiaChiCaiDat nvarchar(50),
@DiaChiHoaDon nvarchar(50),
@TenDichVu nvarchar(50)
)
as
begin
	
	declare @sql nvarchar(1000) , @sql1 nvarchar(1000)

	set @MaGoiCuoc = '%' + @MaGoiCuoc + '%'
	set @DiaChiCaiDat = '%' + @DiaChiCaiDat + '%'
	set @DiaChiHoaDon = '%' + @DiaChiHoaDon + '%'
	set @TenDichVu = '%' + @TenDichVu + '%'

	if(@MaDV <> '' )
		select * from DICHVU where MaDV = @MaDV
	else
		select * from DICHVU where MaGoiCuoc like @MaGoiCuoc and MaHopDong like @MaHopDong and DiaChiCaiDat like @DiaChiCaiDat and
	DiaChiHoaDon like @DiaChiHoaDon and TenDichVu like @TenDichVu
	
end
GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Select_TheoTinhTrangThanhToan]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Select_TheoTinhTrangThanhToan]
(
	@MaHopDong int,
	@TinhTrangThanhToan bit
)
as
begin
	select * from DICHVU where MaHopDong = @MaHopDong and TinhTrangThanhToan = @TinhTrangThanhToan
end

GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Select_TinhTrangDichVu]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Select_TinhTrangDichVu]
as 
begin
	select * from DICHVU where TinhTrangDichVu ='1'
end

GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Select_TinhTrangDichVu_ThanhToan]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Select_TinhTrangDichVu_ThanhToan]
as 
begin
	select * from DICHVU where TinhTrangThanhToan = '1' and TinhTrangDichVu ='0'
end

GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Update_TinhTrangDichVu]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Update_TinhTrangDichVu](
@MaDV int,
@TinhTrangDichVu bit
)
as 
begin
	update DICHVU set  TinhTrangDichVu = @TinhTrangDichVu where MaDV = @MaDV 
end

GO
/****** Object:  StoredProcedure [dbo].[DICHVU_Update_TinhTrangThanhToan]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DICHVU_Update_TinhTrangThanhToan]
(
	@MaDV int,
	@TinhTrangThanhToan bit
)
as
begin
	update DICHVU set TinhTrangThanhToan = @TinhTrangThanhToan where MaDV = @MaDV
end

GO
/****** Object:  StoredProcedure [dbo].[GOICUOC_Insert]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GOICUOC_Insert]
(
	@MaGoiCuoc nvarchar(50),
	@TenGoiCuoc nvarchar(50),
	@GiaTronGoi int
)
as
begin
	insert into GOICUOC values (@MaGoiCuoc,@TenGoiCuoc,@GiaTronGoi)
end

GO
/****** Object:  StoredProcedure [dbo].[GOICUOC_Select]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GOICUOC_Select](
	@MaGoiCuoc nvarchar(50),
	@TenGoiCuoc nvarchar(50)
)
as
begin

	set @MaGoiCuoc = '%' + @MaGoiCuoc + '%'
	set @TenGoiCuoc = '%' + @TenGoiCuoc + '%'

	select * from GOICUOC where MaGoiCuoc like @MaGoiCuoc and TenGoiCuoc like @TenGoiCuoc 
end

GO
/****** Object:  StoredProcedure [dbo].[GOICUOC_SelectAll]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GOICUOC_SelectAll]
as
begin
	select * from GOICUOC
end
GO
/****** Object:  StoredProcedure [dbo].[HOADONTHANHTOAN_DichVuQuaHanThanhToan]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[HOADONTHANHTOAN_DichVuQuaHanThanhToan]
as
begin
	declare @t1 table (MaHDTT nvarchar(50) , MaDV int , CuocPhi money , SoNgayTre int)
	insert into @t1(MaHDTT,MaDV , CuocPhi,SoNgayTre) (select MaHDTT , MaDV , CuocPhi,Datediff(day , CuocDenNgay , GetDate()) as TinhToan  from HOADONTHANHTOAN where TinhTrangThanhToan ='0')
	select * from @t1 where SoNgayTre >= 30
end
GO
/****** Object:  StoredProcedure [dbo].[HOADONTHANHTOAN_Insert]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[HOADONTHANHTOAN_Insert](
@MaHDTT nvarchar(50),
@MaDV nvarchar(50),
@TinhTrangThanhToan bit,
@CuocPhi money,
@CuocTuNgay date,
@CuocDenNgay date
)
as
begin
	declare @return nvarchar(50) , @MaHDCuoi nvarchar(50) ,@TempNumber  nvarchar(50) ,@tempLen int , @nextnum int
	
	select top(1) @MaHDCuoi = MaHDTT from HOADONTHANHTOAN  order by MaHDTT desc  
	
	if(@MaHDCuoi is null)
		select @return = 'HD1'
	else
	begin			
			select @tempLen  = LEN(@MaHDCuoi)
			select @TempNumber = SUBSTRING(@MaHDCuoi,3,@tempLen-2)
			select @nextnum = CONVERT(int,@TempNumber) +1 			
			select @return = 'HS' + convert(nvarchar,@nextnum)
	end
	Insert into HOADONTHANHTOAN(MaHDTT , MaDV , TInhTrangThanhToan , CuocPhi , CuocTuNgay , CuocDenNgay ) values (@return , @MaDV ,@TinhTrangThanhToan,@CuocPhi,@CuocTuNgay ,@CuocDenNgay)
end

GO
/****** Object:  StoredProcedure [dbo].[HOADONTHANHTOAN_Select_DichVuThanhToanTre]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[HOADONTHANHTOAN_Select_DichVuThanhToanTre]
as
begin
	declare @t1 table (MaHDTT nvarchar(50) , MaDV int , CuocPhi money , SoNgayTre int)
	insert into @t1(MaHDTT,MaDV , CuocPhi,SoNgayTre) (select MaHDTT , MaDV , CuocPhi,Datediff(day , CuocDenNgay , GetDate()) as TinhToan  from HOADONTHANHTOAN where TinhTrangThanhToan ='0')
	select * from @t1
	
end
GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_Delete]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HOPDONG_Delete](
 @MaHopDong int
 )
 as
 begin
	declare @MaDV int , @MaLSDV nvarchar(50)
	select @MaDV
	select @MaLSDV = MaLSDV from LICHSUDICHVU where MaDV = @MaDV
		
	delete from CT_LLL_LSDV where MaLSDV in ( select MaLSDV from LICHSUDICHVU where MaDV in (select MaDV from DICHVU where MaHopDong = @MaHopDong)) 
	delete from LICHSUDICHVU where MaDV in ( select MaDV from DICHVU where MaHopDong = @MaHopDong)
	delete from TAIKHOANDANGNHAP where  MaDV in ( select MaDV from DICHVU where MaHopDong = @MaHopDong)
	delete from HOADONTHANHTOAN where MaDV in ( select MaDV from DICHVU where MaHopDong = @MaHopDong)
	delete from DICHVU where MaHopDong = @MaHopDong
	delete from HOPDONG where MaHopDong = @MaHopDong
 end

GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_Insert]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HOPDONG_Insert](
@NgayDangKy date,
@HoTen nvarchar(50),
@CMND nvarchar(10),
@NgheNghiep nvarchar(50),
@Email nvarchar(50),
@ChucVu nvarchar(50),
@DiaChi nvarchar(50),
@DienThoai nvarchar(50)
)
as
begin
	declare @MaHopDongCuoi int, @return int
	select top(1) @MaHopDongCuoi = MaHopDong from HOPDONG  order by MaHopDong desc
	if(@MaHopDongCuoi is null)
		select @return = 0;
	else
		begin
			select @return = @MaHopDongCuoi +1
		end
	Insert into HOPDONG(MaHopDong , NgayDangKy,HoTen, CMND, NgheNghiep, Email , ChucVu , DiaChi ,DienThoai) values (@return , @NgayDangKy,@HoTen,@CMND,@NgheNghiep,@Email,@ChucVu,@DiaChi,
	@DienThoai)
end

GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_Select]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HOPDONG_Select]
(
	@HoTen nvarchar(50),
	@CMND nvarchar(10),
	@NgheNghiep nvarchar(50),
	@Email nvarchar(50),
	@ChucVu nvarchar(50),
	@DiaChi nvarchar(50),
	@DienThoai nvarchar(50)
)
as
begin
	set @HoTen = '%' + @HoTen + '%' 
	set @CMND  = '%' + @CMND + '%'
	set @NgheNghiep = '%' + @NgheNghiep + '%'
	set @Email = '%' + @Email + '%'
	set @ChucVu = '%' +@ChucVu +'%'
	set @DiaChi = '%' +@DiaChi + '%'
	set @DienThoai = '%' + @DienThoai + '%'

	 select * from HOPDONG where HoTen like @HoTen and CMND like @CMND and NgheNghiep like @NgheNghiep and Email like @Email
	 and ChucVu like @ChucVu and DiaChi like @DiaChi and DienThoai like @DienThoai
end	

GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_Select_Lucky]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[HOPDONG_Select_Lucky] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	SELECT * From HOPDONG
END

GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_SelectAll]    Script Date: 29/06/2014 10:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[HOPDONG_SelectAll] as begin select * from HOPDONG end
GO
/****** Object:  StoredProcedure [dbo].[HOPDONG_Update]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[HOPDONG_Update](
@MaHopDong int ,
@NgayDangKy date,
@HoTen nvarchar(50),
@CMND nvarchar(10),
@NgheNghiep nvarchar(50),
@Email nvarchar(50),
@ChucVu nvarchar(50),
@DiaChi nvarchar(50),
@DienThoai nvarchar(50)
)
as
begin
	Update HOPDONG set NgayDangKy = @NgayDangKy , HoTen = @HoTen , CMND= @CMND , NgheNghiep =@NgheNghiep,
	Email = @Email , ChucVu = @ChucVu , DiaChi = @DiaChi , DienThoai = @DienThoai where MaHopDong = @MaHopDong
end

GO
/****** Object:  StoredProcedure [dbo].[KHUYENMAI_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KHUYENMAI_Insert](
@MaKhuyenMai nvarchar(50),
@TenKhuyenMai nvarchar(50),
@KhuyenMaiTuNgay date,
@KhuyenMaiDenNgay date,
@NoiDungKhuyenMai nvarchar(50)
)
as
begin
	Insert into KHUYENMAI(MaKhuyenMai , TenKhuyenMai,KhuyenMaiTuNgay, KhuyenMaiDenNgay , NoiDungKhuyenMai) values (@MaKhuyenMai , @TenKhuyenMai,@KhuyenMaiTuNgay,@KhuyenMaiDenNgay,@NoiDungKhuyenMai)
end

GO
/****** Object:  StoredProcedure [dbo].[KIEUCAIDAT_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[KIEUCAIDAT_Insert](
@MaKieuCaiDat nvarchar(50),
@TenKieuCaiDat nvarchar(50),
@GiaKieuCaiDat int
)
as
begin
	Insert into KIEUCAIDAT(MaKieuCaiDat, TenKieuCaiDat,GiaKieuCaiDat) values (@MaKieuCaiDat ,@TenKieuCaiDat,@GiaKieuCaiDat) 
end

GO
/****** Object:  StoredProcedure [dbo].[KIEUCAIDAT_Select]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KIEUCAIDAT_Select] 
as
begin
	select * from KIEUCAIDAT
end
GO
/****** Object:  StoredProcedure [dbo].[LOAINGUOIDUNG_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[LOAINGUOIDUNG_Insert] (
@MaLoaiNguoiDung nvarchar(50),
@TenLoaiNguoiDung nvarchar(50)
)
as
begin
	Insert into LOAINGUOIDUNG(MaLoaiNguoiDung,TenLoaiNguoiDung) values (@MaLoaiNguoiDung,@TenLoaiNguoiDung)
end

GO
/****** Object:  StoredProcedure [dbo].[MODEM_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[MODEM_Insert](
@MaModem nvarchar(50),
@TenModem nvarchar(50),
@GiaModem int
)
as
begin
	Insert into MODEM(MaModem, TenModem,GiaModem) values (@MaModem,@TenModem,@GiaModem) 
end
GO
/****** Object:  StoredProcedure [dbo].[MODEM_SelectAll]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[MODEM_SelectAll] as begin select * from MODEM end --==================== create proc GOICUOC_SelectAll as begin select * from GOICUOC end
GO
/****** Object:  StoredProcedure [dbo].[NGUOIDUNG_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[NGUOIDUNG_Insert] (
@MaNguoiDung nvarchar(50),
@MaLoaiNguoiDung nvarchar(50),
@Username nvarchar(50),
@Password nvarchar(50)
)
as
begin
	Insert into NGUOIDUNG(MaNguoiDung,MaLoaiNguoiDung,Username ,Pass) values (@MaNguoiDung,@MaLoaiNguoiDung,@Username,@Password)
end

GO
/****** Object:  StoredProcedure [dbo].[NGUOIDUNG_SelectDangNhap]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[NGUOIDUNG_SelectDangNhap](
@Username nvarchar(50),
@Pass nvarchar(50)
)
as
begin
	Select * from NGUOIDUNG where Username = @Username and Pass = @Pass
end

GO
/****** Object:  StoredProcedure [dbo].[TAIKHOANDANGNHAP_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[TAIKHOANDANGNHAP_Insert]
(
	@MaDV int ,
	@UserName nvarchar(50),
	@Password nvarchar(50)
)
as
begin
		declare @return nvarchar(10) , @MaTKCuoi nvarchar(10) ,@TempNumber  nvarchar(10) ,@tempLen int , @nextnum int
	
	select top(1) @MaTKCuoi = MaTaiKhoan from TAIKHOANDANGNHAP  order by MaTaiKhoan desc  /* Lay Ma Tai Khoan cuoi*/
	
	if(@MaTKCuoi is null)
		select @return = 'TK0000001'
	else
	begin
			select @tempLen  = LEN(@MaTKCuoi)
			select @TempNumber = SUBSTRING(@MaTKCuoi,3,@tempLen-2) /*Lay chuoi so trong chuoi MaTaiKhoan*/
			select @nextnum = CONVERT(int,@TempNumber) +1 
			
			select @return = case 
			when LEN(convert(nvarchar,@nextnum))=1  then 'TK000000' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=2  then 'TK00000' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=3  then 'TK0000' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=4  then 'TK000' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=5  then 'TK00' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=6  then 'TK0' + convert(nvarchar,@nextnum)
			when LEN(convert(nvarchar,@nextnum))=7  then 'TK' + convert(nvarchar,@nextnum)	
	end
	end

	insert into TAIKHOANDANGNHAP values (@return , @MaDV,@UserName , @Password)
end

GO
/****** Object:  StoredProcedure [dbo].[THAMSO_Insert]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[THAMSO_Insert](
@MaThamSo nvarchar(50),
@TenThamSo nvarchar(50),
@GiaTri numeric(18,0)
)
as
begin
	Insert into THAMSO(MaThamSo , TenThamSo , GiaTri) values (@MaThamSo , @TenThamSo , @GiaTri)
end

GO
/****** Object:  Table [dbo].[CHITIETTRUYCAP]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETTRUYCAP](
	[MaCTTC] [nvarchar](50) NOT NULL,
	[MaDV] [int] NOT NULL,
	[DiaChiTruyCap] [nvarchar](50) NOT NULL,
	[ThoiDiemTruyCap] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CHITIETTRUYCAP] PRIMARY KEY CLUSTERED 
(
	[MaCTTC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CT_LLL_LSDV]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_LLL_LSDV](
	[MaLLL] [nvarchar](50) NOT NULL,
	[MaLSDV] [nvarchar](50) NOT NULL,
	[LuuLuongSuDung] [float] NULL,
 CONSTRAINT [PK_CT_LLL_LSDV] PRIMARY KEY CLUSTERED 
(
	[MaLLL] ASC,
	[MaLSDV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CT_LOAILUULUONG]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_LOAILUULUONG](
	[MaGoiCuoc] [nvarchar](50) NOT NULL,
	[MaLLL] [nvarchar](50) NOT NULL,
	[GiaCuocTrenMB] [money] NULL,
 CONSTRAINT [PK_CT_LOAILUULUONG] PRIMARY KEY CLUSTERED 
(
	[MaGoiCuoc] ASC,
	[MaLLL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DICHVU]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DICHVU](
	[MaDV] [int] NOT NULL,
	[MaGoiCuoc] [nvarchar](50) NOT NULL,
	[MaHopDong] [int] NOT NULL,
	[DiaChiCaiDat] [nvarchar](50) NOT NULL,
	[DiaChiHoaDon] [nvarchar](50) NOT NULL,
	[TenDichVu] [nvarchar](50) NOT NULL,
	[TinhTrangDichVu] [bit] NOT NULL,
	[SoLuongTaiKhoan] [int] NOT NULL,
	[NgayLapDat] [date] NOT NULL,
	[PhiLapDat] [money] NOT NULL,
	[TinhTrangThanhToan] [bit] NOT NULL,
	[NgayDangKy] [date] NOT NULL,
	[MaModem] [nvarchar](50) NOT NULL,
	[MaKieuCaiDat] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DICHVU] PRIMARY KEY CLUSTERED 
(
	[MaDV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GOICUOC]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GOICUOC](
	[MaGoiCuoc] [nvarchar](50) NOT NULL,
	[TenGoiCuoc] [nvarchar](50) NULL,
	[GiaTronGoi] [int] NULL,
 CONSTRAINT [PK_GOICUOC] PRIMARY KEY CLUSTERED 
(
	[MaGoiCuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HOADONTHANHTOAN]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADONTHANHTOAN](
	[MaHDTT] [nvarchar](50) NOT NULL,
	[MaDV] [int] NOT NULL,
	[TInhTrangThanhToan] [bit] NOT NULL,
	[CuocPhi] [money] NOT NULL,
	[CuocTuNgay] [date] NOT NULL,
	[CuocDenNgay] [date] NOT NULL,
 CONSTRAINT [PK_HOADONTHANHTOAN] PRIMARY KEY CLUSTERED 
(
	[MaHDTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HOPDONG]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOPDONG](
	[MaHopDong] [int] NOT NULL,
	[NgayDangKy] [date] NOT NULL,
	[HoTen] [nvarchar](50) NOT NULL,
	[CMND] [nvarchar](10) NOT NULL,
	[NgheNghiep] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[ChucVu] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NOT NULL,
	[DienThoai] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HOPDONG] PRIMARY KEY CLUSTERED 
(
	[MaHopDong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KHUYENMAI]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHUYENMAI](
	[MaKhuyenMai] [nvarchar](20) NOT NULL,
	[TenKhuyenMai] [nvarchar](50) NULL,
	[KhuyenMaiTuNgay] [date] NULL,
	[KhuyenMaiDenNgay] [date] NULL,
	[NoiDungKhuyenMai] [nvarchar](50) NULL,
 CONSTRAINT [PK_KHUYENMAI] PRIMARY KEY CLUSTERED 
(
	[MaKhuyenMai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KIEUCAIDAT]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KIEUCAIDAT](
	[MaKieuCaiDat] [nvarchar](50) NOT NULL,
	[TenKieuCaiDat] [nvarchar](50) NULL,
	[GiaKieuCaiDat] [int] NOT NULL,
 CONSTRAINT [PK_KIEUCAIDAT] PRIMARY KEY CLUSTERED 
(
	[MaKieuCaiDat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUDICHVU]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUDICHVU](
	[MaLSDV] [nvarchar](50) NOT NULL,
	[MaDV] [int] NULL,
	[Thang] [int] NULL,
	[Nam] [date] NULL,
 CONSTRAINT [PK_LICHSUDICHVU] PRIMARY KEY CLUSTERED 
(
	[MaLSDV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAILUULUONG]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAILUULUONG](
	[MaLLL] [nvarchar](50) NOT NULL,
	[TenLLL] [nvarchar](50) NULL,
 CONSTRAINT [PK_LOAILUULUONG] PRIMARY KEY CLUSTERED 
(
	[MaLLL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAINGUOIDUNG]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAINGUOIDUNG](
	[MaLoaiNguoiDung] [nvarchar](50) NOT NULL,
	[TenLoaiNguoiDung] [nvarchar](50) NULL,
 CONSTRAINT [PK_LOAINGUOIDUNG] PRIMARY KEY CLUSTERED 
(
	[MaLoaiNguoiDung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MODEM]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MODEM](
	[MaModem] [nvarchar](50) NOT NULL,
	[TenModem] [nvarchar](50) NULL,
	[GiaModem] [int] NOT NULL,
 CONSTRAINT [PK_MODEM] PRIMARY KEY CLUSTERED 
(
	[MaModem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NGUOIDUNG]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGUOIDUNG](
	[MaNguoiDung] [nvarchar](20) NOT NULL,
	[MaLoaiNguoiDung] [nvarchar](50) NULL,
	[Username] [nvarchar](50) NULL,
	[Pass] [nvarchar](50) NULL,
 CONSTRAINT [PK_NGÙODUNG] PRIMARY KEY CLUSTERED 
(
	[MaNguoiDung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAIKHOANDANGNHAP]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TAIKHOANDANGNHAP](
	[MaTaiKhoan] [varchar](20) NOT NULL,
	[MaDV] [int] NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
 CONSTRAINT [PK_TAIKHOANDANGNHAP] PRIMARY KEY CLUSTERED 
(
	[MaTaiKhoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[THAMSO]    Script Date: 29/06/2014 10:50:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THAMSO](
	[MaThamSo] [nvarchar](50) NOT NULL,
	[TenThamSo] [nvarchar](50) NULL,
	[GiaTri] [numeric](18, 0) NULL,
 CONSTRAINT [PK_THAMSO] PRIMARY KEY CLUSTERED 
(
	[MaThamSo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CHITIETTRUYCAP]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTRUYCAP_DICHVU] FOREIGN KEY([MaDV])
REFERENCES [dbo].[DICHVU] ([MaDV])
GO
ALTER TABLE [dbo].[CHITIETTRUYCAP] CHECK CONSTRAINT [FK_CHITIETTRUYCAP_DICHVU]
GO
ALTER TABLE [dbo].[CT_LLL_LSDV]  WITH CHECK ADD  CONSTRAINT [FK_CT_LLL_LSDV_LICHSUDICHVU] FOREIGN KEY([MaLSDV])
REFERENCES [dbo].[LICHSUDICHVU] ([MaLSDV])
GO
ALTER TABLE [dbo].[CT_LLL_LSDV] CHECK CONSTRAINT [FK_CT_LLL_LSDV_LICHSUDICHVU]
GO
ALTER TABLE [dbo].[CT_LLL_LSDV]  WITH CHECK ADD  CONSTRAINT [FK_CT_LLL_LSDV_LOAILUULUONG] FOREIGN KEY([MaLLL])
REFERENCES [dbo].[LOAILUULUONG] ([MaLLL])
GO
ALTER TABLE [dbo].[CT_LLL_LSDV] CHECK CONSTRAINT [FK_CT_LLL_LSDV_LOAILUULUONG]
GO
ALTER TABLE [dbo].[CT_LOAILUULUONG]  WITH CHECK ADD  CONSTRAINT [FK_CT_LOAILUULUONG_GOICUOC] FOREIGN KEY([MaGoiCuoc])
REFERENCES [dbo].[GOICUOC] ([MaGoiCuoc])
GO
ALTER TABLE [dbo].[CT_LOAILUULUONG] CHECK CONSTRAINT [FK_CT_LOAILUULUONG_GOICUOC]
GO
ALTER TABLE [dbo].[CT_LOAILUULUONG]  WITH CHECK ADD  CONSTRAINT [FK_CT_LOAILUULUONG_LOAILUULUONG] FOREIGN KEY([MaLLL])
REFERENCES [dbo].[LOAILUULUONG] ([MaLLL])
GO
ALTER TABLE [dbo].[CT_LOAILUULUONG] CHECK CONSTRAINT [FK_CT_LOAILUULUONG_LOAILUULUONG]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_GOICUOC] FOREIGN KEY([MaGoiCuoc])
REFERENCES [dbo].[GOICUOC] ([MaGoiCuoc])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_GOICUOC]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_HOPDONG] FOREIGN KEY([MaHopDong])
REFERENCES [dbo].[HOPDONG] ([MaHopDong])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_HOPDONG]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_KIEUCAIDAT] FOREIGN KEY([MaKieuCaiDat])
REFERENCES [dbo].[KIEUCAIDAT] ([MaKieuCaiDat])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_KIEUCAIDAT]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_MODEM] FOREIGN KEY([MaModem])
REFERENCES [dbo].[MODEM] ([MaModem])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_MODEM]
GO
ALTER TABLE [dbo].[HOADONTHANHTOAN]  WITH CHECK ADD  CONSTRAINT [FK_HOADONTHANHTOAN_DICHVU] FOREIGN KEY([MaDV])
REFERENCES [dbo].[DICHVU] ([MaDV])
GO
ALTER TABLE [dbo].[HOADONTHANHTOAN] CHECK CONSTRAINT [FK_HOADONTHANHTOAN_DICHVU]
GO
ALTER TABLE [dbo].[LICHSUDICHVU]  WITH CHECK ADD  CONSTRAINT [FK_LICHSUDICHVU_DICHVU] FOREIGN KEY([MaDV])
REFERENCES [dbo].[DICHVU] ([MaDV])
GO
ALTER TABLE [dbo].[LICHSUDICHVU] CHECK CONSTRAINT [FK_LICHSUDICHVU_DICHVU]
GO
ALTER TABLE [dbo].[NGUOIDUNG]  WITH CHECK ADD  CONSTRAINT [FK_NGÙODUNG_LOAINGUOIDUNG] FOREIGN KEY([MaLoaiNguoiDung])
REFERENCES [dbo].[LOAINGUOIDUNG] ([MaLoaiNguoiDung])
GO
ALTER TABLE [dbo].[NGUOIDUNG] CHECK CONSTRAINT [FK_NGÙODUNG_LOAINGUOIDUNG]
GO
ALTER TABLE [dbo].[TAIKHOANDANGNHAP]  WITH CHECK ADD  CONSTRAINT [FK_TAIKHOANDANGNHAP_DICHVU] FOREIGN KEY([MaDV])
REFERENCES [dbo].[DICHVU] ([MaDV])
GO
ALTER TABLE [dbo].[TAIKHOANDANGNHAP] CHECK CONSTRAINT [FK_TAIKHOANDANGNHAP_DICHVU]
GO
USE [master]
GO
ALTER DATABASE [QUANLYINTERNET] SET  READ_WRITE 
GO
