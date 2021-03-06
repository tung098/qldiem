
/****** Object:  Database [QLDiem_SV]    Script Date: 13/03/2019 20:20:43 ******/
CREATE DATABASE [QLDiem_SV]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLDiem_SV', FILENAME = N'F:\HVKTQS\Ky_8\CONG_NGHE_Client-server\BTL\QLDiem_SV.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLDiem_SV_log', FILENAME = N'F:\HVKTQS\Ky_8\CONG_NGHE_Client-server\BTL\QLDiem_SV_log.LDF' , SIZE = 768KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QLDiem_SV] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLDiem_SV].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLDiem_SV] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLDiem_SV] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLDiem_SV] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLDiem_SV] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLDiem_SV] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLDiem_SV] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QLDiem_SV] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLDiem_SV] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLDiem_SV] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLDiem_SV] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLDiem_SV] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLDiem_SV] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLDiem_SV] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLDiem_SV] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLDiem_SV] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QLDiem_SV] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLDiem_SV] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLDiem_SV] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLDiem_SV] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLDiem_SV] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLDiem_SV] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLDiem_SV] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLDiem_SV] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QLDiem_SV] SET  MULTI_USER 
GO
ALTER DATABASE [QLDiem_SV] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLDiem_SV] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLDiem_SV] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLDiem_SV] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QLDiem_SV] SET DELAYED_DURABILITY = DISABLED 
GO
USE [QLDiem_SV]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DiemTB]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_DiemTB](
	@CC FLOAT,
	@TX FLOAT,
	@DT FLOAT
)
RETURNS FLOAT
BEGIN
	DECLARE @TB FLOAT
	SET @TB = @CC*0.1 + @TX*0.3 + @DT*0.6
	RETURN @TB
END


GO
/****** Object:  UserDefinedFunction [dbo].[fn_DiemTB_Ky]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_DiemTB_Ky](
	@maHK CHAR(10),
	@maSV CHAR(10)
)
RETURNS FLOAT
BEGIN
	DECLARE @i INT = 1
	DECLARE @diem4 FLOAT
	DECLARE @soTC INT 
	DECLARE @tongTC INT = (SELECT SUM(SoTC) 
							FROM dbo.LopHocPhan JOIN dbo.KetQuaLHP ON KetQuaLHP.MaLopHP = LopHocPhan.MaLopHP
							JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
							WHERE MaHK = @maHK AND MaSV = @maSV )
	DECLARE @tong FLOAT = 0
	DECLARE @TB FLOAT
	DECLARE @count INT = (SELECT COUNT(*) 
							FROM dbo.LopHocPhan JOIN dbo.KetQuaLHP ON KetQuaLHP.MaLopHP = LopHocPhan.MaLopHP
							JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
							WHERE MaHK = @maHK AND MaSV = @maSV ) 
	WHILE @i < @count +1
	BEGIN
		SELECT TOP (@i) @diem4 = DiemHeBon FROM dbo.LopHocPhan JOIN dbo.KetQuaLHP ON KetQuaLHP.MaLopHP = LopHocPhan.MaLopHP
							JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
							WHERE MaHK = @maHK AND MaSV = @maSV
							ORDER BY LopHocPhan.MaLopHP DESC
		SELECT TOP (@i) @soTC = SoTC FROM dbo.LopHocPhan JOIN dbo.KetQuaLHP ON KetQuaLHP.MaLopHP = LopHocPhan.MaLopHP
							JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
							WHERE MaHK = @maHK AND MaSV = @maSV
							ORDER BY LopHocPhan.MaLopHP DESC
		SET @tong = @tong + @diem4*@soTC
		SET @TB = @tong/SUM(@tongTC)
		SET @i = @i + 1
	END
	RETURN @TB
END


GO
/****** Object:  UserDefinedFunction [dbo].[fn_PhanChiaXepLoai_TheoKy]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_PhanChiaXepLoai_TheoKy](
	@diemTBC FLOAT 
)
RETURNS NVARCHAR(50)
BEGIN
	
	DECLARE @xepLoai NVARCHAR(50)
	IF @diemTBC < 1 
		SET @xepLoai = N'Yếu'
	ELSE
	IF @diemTBC >= 1 AND @diemTBC < 1.5
		SET @xepLoai =N'Trung Bình'
	ELSE
	IF @diemTBC >= 1.5 AND @diemTBC < 2
		SET @xepLoai = N'Trung Bình Khá'
	ELSE
	IF @diemTBC >= 2 AND @diemTBC < 2.5
		SET @xepLoai = N'Khá'
	ELSE
	IF @diemTBC >= 2.5 AND @diemTBC < 3.5
		SET @xepLoai = N'Giỏi'
	ELSE
	IF @diemTBC >= 2.5 AND @diemTBC <= 4
		SET @xepLoai = N'Xuất Sắc'
	RETURN @xepLoai
END


GO
/****** Object:  UserDefinedFunction [dbo].[fn_updateDiem4]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_updateDiem4](@diem10 FLOAT)
RETURNS FLOAT
BEGIN
	DECLARE @diem4 FLOAT
	IF @diem10 < 4
		SET @diem4 = 0
	ELSE
    IF @diem10 >= 4 AND @diem10 < 5
		SET @diem4 = 1
	ELSE	
	IF @diem10 >5 AND @diem10 < 6
		SET @diem4 = 1.5
	ELSE
	IF @diem10 >=6 AND @diem10 < 6.5
		SET @diem4 = 2
	IF @diem10 >= 6.5 AND @diem10 < 7
		SET @diem4 = 2.5
	ELSE
	IF @diem10 >=7 AND @diem10 < 8
		SET @diem4 = 3
	ELSE
	IF @diem10 >= 8 AND @diem10 < 8.5
		SET @diem4 = 3.5
	ELSE
	IF @diem10 >= 8.5 AND @diem10 < 9.5
		SET @diem4 = 3.8
	ELSE
	IF @diem10 >= 9.5 AND @diem10 < =10
		SET @diem4 = 4
	RETURN @diem4
END


GO
/****** Object:  UserDefinedFunction [dbo].[fn_updateDiemChu]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_updateDiemChu](@diem4 FLOAT)
RETURNS CHAR(10)
BEGIN
	DECLARE @diemChu CHAR(10)
	IF @diem4 < 0
		SET @diemChu = 'F'
	ELSE
    IF @diem4 = 1
		SET @diemChu = 'D'
	ELSE	
	IF @diem4 = 1.5
		SET @diemChu = 'D+'
	ELSE
	IF @diem4 = 2
		SET @diemChu = 'C'
	ELSE
	IF @diem4 = 2.5
		SET @diemChu = 'C+'
	ELSE
	IF @diem4 =3
		SET @diemChu = 'B'
	ELSE
	IF @diem4 =3.5
		SET @diemChu = 'B+'
	ELSE
	IF @diem4 = 3.8
		SET @diemChu = 'A'
	ELSE
	IF @diem4 = 4
		SET @diemChu = 'A+'
	RETURN @diemChu
END


GO
/****** Object:  UserDefinedFunction [dbo].[FUN_AUTO_MaSV]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FUN_AUTO_MaSV]()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(4)
	IF (SELECT COUNT(MaSV) FROM SinhVien) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(RTRIM(LTRIM(MaSV)), 2)) FROM SinhVien
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'SV0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'SV' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END

GO
/****** Object:  Table [dbo].[GiangVien]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GiangVien](
	[MaGV] [char](10) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[SDT] [char](20) NULL,
	[HocVi] [nchar](10) NULL,
	[MaKhoa] [char](10) NULL,
 CONSTRAINT [PK_GiangVien] PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HocKy]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HocKy](
	[MaHK] [char](10) NOT NULL,
	[TimeBatDau] [date] NULL,
	[TimeKetThuc] [date] NULL,
 CONSTRAINT [PK_HocKy] PRIMARY KEY CLUSTERED 
(
	[MaHK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HocPhan]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HocPhan](
	[MaHP] [char](10) NOT NULL,
	[TenHP] [nvarchar](200) NULL,
	[SoTC] [int] NULL,
 CONSTRAINT [PK_HocPhan] PRIMARY KEY CLUSTERED 
(
	[MaHP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KetQuaHP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KetQuaHP](
	[MaHP] [char](10) NOT NULL,
	[MaSV] [char](10) NOT NULL,
	[DiemCC] [float] NULL,
	[DiemTX] [float] NULL,
	[DiemThi] [float] NULL,
	[DiemHe10] [float] NULL,
	[DiemHeBon] [float] NULL,
	[DiemChu] [char](10) NULL,
 CONSTRAINT [PK_KetQuaHP] PRIMARY KEY CLUSTERED 
(
	[MaHP] ASC,
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KetQuaLHP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KetQuaLHP](
	[MaLopHP] [char](10) NOT NULL,
	[MaSV] [char](10) NOT NULL,
	[DiemCC] [float] NULL,
	[DiemTX] [float] NULL,
	[DiemThi] [float] NULL,
	[DiemHe10] [float] NULL,
	[DiemHeBon] [float] NULL,
	[DiemChu] [char](10) NULL,
 CONSTRAINT [PK_KetQuaLHP] PRIMARY KEY CLUSTERED 
(
	[MaLopHP] ASC,
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Khoa]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Khoa](
	[MaKhoa] [char](10) NOT NULL,
	[TenKhoa] [nvarchar](200) NULL,
 CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED 
(
	[MaKhoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lop]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lop](
	[MaLop] [char](10) NOT NULL,
	[TenLop] [nvarchar](200) NULL,
	[SiSo] [int] NULL,
	[MaKhoa] [char](10) NULL,
	[NienKhoa] [nvarchar](50) NULL,
 CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LopHocPhan]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LopHocPhan](
	[MaLopHP] [char](10) NOT NULL,
	[PhongHoc] [nvarchar](50) NULL,
	[TongSoSV] [nchar](10) NULL,
	[TietBatDau] [int] NULL,
	[TietKetThuc] [int] NULL,
	[Thu] [nvarchar](50) NULL,
	[MaHP] [char](10) NULL,
	[MaGV] [char](10) NULL,
	[MaHK] [char](10) NULL,
 CONSTRAINT [PK_LopHocPhan] PRIMARY KEY CLUSTERED 
(
	[MaLopHP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SinhVien]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SinhVien](
	[MaSV] [char](10) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[NgaySinh] [datetime] NULL,
	[GioiTinh] [nvarchar](20) NULL,
	[QueQuan] [nvarchar](200) NULL,
	[DiaChiHT] [nvarchar](200) NULL,
	[MaLop] [char](10) NULL,
	[SoTinChiDaDat] [int] NULL,
	[DiemTichLuy] [float] NULL,
	[SoTinChiDaDKi] [int] NULL,
 CONSTRAINT [PK_SinhVien] PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TongKetKy]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TongKetKy](
	[MaKy] [char](10) NOT NULL,
	[MaSV] [char](10) NOT NULL,
	[DiemTBC] [float] NULL,
	[XepLoai] [nvarchar](50) NULL,
 CONSTRAINT [PK_TongKetKy] PRIMARY KEY CLUSTERED 
(
	[MaKy] ASC,
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV01      ', N'Cao Tuấn Anh', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV02      ', N'Nguyễn Mậu Uyên', N'123456789           ', N'Th?c Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV03      ', N'Nguyễn Hoài Anh', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV04      ', N'Nguyễn Quốc Khánh', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV05      ', N'Phan Nguyên Hải', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV06      ', N'Nguyễn Vân Trường', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV07      ', N'Nguyễn Văn Quân', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV08      ', N'Nguyễn Văn Lợi', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTen], [SDT], [HocVi], [MaKhoa]) VALUES (N'GV09      ', N'Nguyễn Hữu Nội', N'123456789           ', N'Ti?n Si   ', N'K01       ')
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK1       ', CAST(N'2015-08-15' AS Date), CAST(N'2016-01-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK2       ', CAST(N'2016-01-20' AS Date), CAST(N'2016-06-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK3       ', CAST(N'2016-08-15' AS Date), CAST(N'2017-01-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK4       ', CAST(N'2017-01-20' AS Date), CAST(N'2017-06-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK5       ', CAST(N'2017-08-15' AS Date), CAST(N'2018-01-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK6       ', CAST(N'2018-01-20' AS Date), CAST(N'2018-06-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK7       ', CAST(N'2018-08-15' AS Date), CAST(N'2019-01-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK8       ', CAST(N'2019-01-20' AS Date), CAST(N'2019-06-10' AS Date))
INSERT [dbo].[HocKy] ([MaHK], [TimeBatDau], [TimeKetThuc]) VALUES (N'HK9       ', CAST(N'2019-08-15' AS Date), CAST(N'2020-01-10' AS Date))
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP1       ', N'Lập trình cơ bản', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP10      ', N'Thực tập nhóm', 2)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP11      ', N'Công nghệ phần mềm', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP12      ', N'Công nghệ Web', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP13      ', N'Phương phấp nghiên cứu IT', 2)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP14      ', N'Tiếng Anh', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP15      ', N'Lập trình tích hợp', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP16      ', N'Lập trình nâng cao', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP17      ', N'Phân tích thiết kế giải thuật', 2)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP18      ', N'Hệ thống Client-Server', 4)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP2       ', N'Kĩ thuật lập trình', 4)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP3       ', N'Ngôn ngữ lập trình', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP4       ', N'Cấu trúc máy tính', 2)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP5       ', N'Mạng máy tính', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP6       ', N'Lý thuyết hệ điều hành', 3)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP7       ', N'Cơ sở dữ liệu', 4)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP8       ', N'Thực tập kĩ thuật lập trình', 4)
INSERT [dbo].[HocPhan] ([MaHP], [TenHP], [SoTC]) VALUES (N'HP9       ', N'Thực tập cơ sở dữ liệu', 2)
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV01      ', 8, 6, 10, 8.6, 3.8, N'A         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV02      ', 7, 8, 9, 8.5, 3.8, N'A         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV03      ', 9, 7, 10, 9, 3.8, N'A         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV04      ', 7.5, 7, 10, 8.85, 3.8, N'A         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV07      ', 6, 8, 7, 7.2, 3, N'B         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV18      ', 4, 6.5, 6, 5.9499999999999993, 1.5, N'D+        ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP1       ', N'SV20      ', 6, 8, 7.5, 7.5, 3, N'B         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP11      ', N'SV15      ', 9, 9, 9, 9, 3.8, N'A         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP2       ', N'SV01      ', 5.5, 7.5, 9, 8.2, 3.5, N'B+        ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP2       ', N'SV02      ', 8, 9, 6.5, 7.4, 3, N'B         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP3       ', N'sv01      ', 0, 4, 6, 4.8, 1, N'D         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP5       ', N'SV01      ', 6, 8, 6.5, 6.9, 2.5, N'C+        ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP5       ', N'SV09      ', 5, 7, 5, 5.6, 1.5, N'D+        ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP5       ', N'SV16      ', 6, 7.5, 8, 7.65, 3, N'B         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP6       ', N'SV02      ', 7, 8, 7.5, 7.6, 3, N'B         ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP6       ', N'SV06      ', 7, 8.5, 6, 6.85, 2.5, N'C+        ')
INSERT [dbo].[KetQuaHP] ([MaHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'HP6       ', N'SV10      ', 5, 6, 7, 6.5, 2.5, N'C+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV01      ', 8, 6, 10, 8.6, 3.8, N'A         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV02      ', 7, 8, 9, 8.5, 3.8, N'A         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV03      ', 9, 7, 10, 9, 3.8, N'A         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV04      ', 7.5, 7, 10, 8.85, 3.8, N'A         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV07      ', 6, 8, 7, 7.2, 3, N'B         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP1      ', N'SV20      ', 6, 8, 7.5, 7.5, 3, N'B         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP10     ', N'SV02      ', 7, 8, 7.5, 7.6, 3, N'B         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP10     ', N'SV06      ', 7, 8.5, 6, 6.85, 2.5, N'C+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP10     ', N'SV10      ', 5, 6, 7, 6.5, 2.5, N'C+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP11     ', N'SV09      ', 5, 7, 5, 5.6, 1.5, N'D+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP2      ', N'SV01      ', 7, 6.5, 6, 6.25, 2, N'C         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP21     ', N'SV15      ', 9, 9, 9, 9, 3.8, N'A         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP3      ', N'SV01      ', 5.5, 7.5, 9, 8.2, 3.5, N'B+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP4      ', N'SV02      ', 8, 9, 6.5, 7.4, 3, N'B         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP5      ', N'SV01      ', 0, 4, 6, 4.8, 1, N'D         ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP9      ', N'SV01      ', 6, 8, 6.5, 6.9, 2.5, N'C+        ')
INSERT [dbo].[KetQuaLHP] ([MaLopHP], [MaSV], [DiemCC], [DiemTX], [DiemThi], [DiemHe10], [DiemHeBon], [DiemChu]) VALUES (N'LHP9      ', N'SV16      ', 6, 7.5, 8, 7.65, 3, N'B         ')
INSERT [dbo].[Khoa] ([MaKhoa], [TenKhoa]) VALUES (N'K01       ', N'Công nghệ thông tin')
INSERT [dbo].[Khoa] ([MaKhoa], [TenKhoa]) VALUES (N'K02       ', N'Tự động hóa')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L01       ', N'CNTT', 7, N'K01       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L02       ', N'KTPM', 3, N'K01       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L03       ', N'HTTT', 1, N'K01       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L04       ', N'MMT', 2, N'K01       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L05       ', N'KHMT', 7, N'K01       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L06       ', N'CDT14', 0, N'K02       ', N'2015-2020')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [SiSo], [MaKhoa], [NienKhoa]) VALUES (N'L07       ', N'TDH15', 0, N'K02       ', N'2016-2021')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP1      ', N'H9101', N'50        ', 1, 3, N'Thứ 2', N'HP1       ', N'GV01      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP10     ', N'H9101', N'50        ', 1, 3, N'Thứ 3', N'HP6       ', N'GV05      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP11     ', N'H9102', N'50        ', 3, 6, N'Thứ 2', N'HP5       ', N'GV06      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP12     ', N'H9102', N'50        ', 3, 6, N'Thứ 3', N'HP6       ', N'GV06      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP13     ', N'H9103', N'50        ', 1, 3, N'Thứ 4', N'HP7       ', N'GV07      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP14     ', N'H9103', N'50        ', 1, 3, N'Thứ 5', N'HP7       ', N'GV07      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP15     ', N'H9104', N'50        ', 4, 6, N'Thứ 4', N'HP8       ', N'GV08      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP16     ', N'H9104', N'50        ', 4, 6, N'Thứ 5', N'HP8       ', N'GV08      ', N'HK2       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP17     ', N'H9101', N'50        ', 1, 3, N'Thứ 3', N'HP9       ', N'GV09      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP18     ', N'H9102', N'50        ', 3, 6, N'Thứ 2', N'HP10      ', N'GV02      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP19     ', N'H9102', N'50        ', 3, 6, N'Thứ 3', N'HP10      ', N'GV02      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP2      ', N'H9101', N'50        ', 1, 3, N'Thứ 3', N'HP1       ', N'GV01      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP20     ', N'H9103', N'50        ', 1, 3, N'Thứ 4', N'HP11      ', N'GV03      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP21     ', N'H9103', N'50        ', 1, 3, N'Thứ 5', N'HP11      ', N'GV03      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP22     ', N'H9104', N'50        ', 4, 6, N'Thứ 4', N'HP12      ', N'GV04      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP23     ', N'H9104', N'50        ', 4, 6, N'Thứ 5', N'HP12      ', N'GV04      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP24     ', N'H9101', N'50        ', 1, 3, N'Thứ 2', N'HP9       ', N'GV09      ', N'HK3       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP3      ', N'H9102', N'50        ', 3, 6, N'Thứ 2', N'HP2       ', N'GV02      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP4      ', N'H9102', N'50        ', 3, 6, N'Thứ 3', N'HP2       ', N'GV02      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP5      ', N'H9103', N'50        ', 1, 3, N'Thứ 4', N'HP3       ', N'GV03      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP6      ', N'H9103', N'50        ', 1, 3, N'Thứ 5', N'HP3       ', N'GV03      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP7      ', N'H9104', N'50        ', 4, 6, N'Thứ 4', N'HP4       ', N'GV04      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP8      ', N'H9104', N'50        ', 4, 6, N'Thứ 5', N'HP4       ', N'GV04      ', N'HK1       ')
INSERT [dbo].[LopHocPhan] ([MaLopHP], [PhongHoc], [TongSoSV], [TietBatDau], [TietKetThuc], [Thu], [MaHP], [MaGV], [MaHK]) VALUES (N'LHP9      ', N'H9101', N'50        ', 1, 3, N'Thứ 2', N'HP5       ', N'GV05      ', N'HK2       ')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV01      ', N'Đặng Văn Đức', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L01       ', 13, 2.5730769230769228, 13)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV02      ', N'Nguyễn Sỹ Khánh', CAST(N'1996-01-27 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L02       ', 10, 3.1714285714285713, 10)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV03      ', N'Đặng Văn Quyết', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L01       ', 3, 3.7999999999999994, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV04      ', N'Vũ Công Minh', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Phú Thọ', N'Hà Nội', N'L01       ', 3, 3.7999999999999994, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV06      ', N'Nguyễn Ngọc Trinh', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Bắc Giang', N'Hà Nội', N'L01       ', 0, 0, 0)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV07      ', N'Mai Phương Thúy', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Yên Bái', N'Hà Nội', N'L03       ', 3, 3, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV08      ', N'Đặng Văn Lâm', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L05       ', 0, 0, 0)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV09      ', N'Nguyễn Công Phượng', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L02       ', 3, 1.5, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV10      ', N'Đỗ Hồng Ngọc', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Hà Nội', N'Hà Nội', N'L02       ', 3, 2.5, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV11      ', N'Giang Văn Minh', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nam', N'Thanh Hóa', N'Hà Nội', N'L04       ', NULL, 3, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV12      ', N'Lâm Vĩnh Hằng', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Ninh Bình', N'Hà Nội', N'L04       ', NULL, 2.4, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV13      ', N'Trình Uyển Nhi', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Khánh Hòa', N'Hà Nội', N'L05       ', NULL, 2.4, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV14      ', N'Dạ Minh Châu', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Nghệ An', N'Hà Nội', N'L05       ', NULL, 3, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV15      ', N'Diệp Hoàng Trúc Mai', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Quảng Bình', N'Hà Nội', N'L05       ', 3, 3.7999999999999994, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV16      ', N'Nguyễn Khả Vy', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Huế', N'Hà Nội', N'L05       ', 3, 3, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV17      ', N'Trần Thu Sương', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Nghệ An', N'Hà Nội', N'L05       ', NULL, 2, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV18      ', N'Trần Diễm Trân', CAST(N'1997-11-25 00:00:00.000' AS DateTime), N'Nữ', N'Quảng Bình', N'Hà Nội', N'L01       ', 3, 2.4, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV19      ', N'Nguyễn Văn Nam', CAST(N'1996-01-27 00:00:00.000' AS DateTime), N'Nam', N'Nghệ An', N'Hà Nội', N'L01       ', NULL, 2.4, NULL)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV20      ', N'Trần Ngọc Diễm', CAST(N'1996-12-20 00:00:00.000' AS DateTime), N'Nữ', N'Nghệ An', N'Hà Nội', N'L05       ', 3, 3, 3)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [DiaChiHT], [MaLop], [SoTinChiDaDat], [DiemTichLuy], [SoTinChiDaDKi]) VALUES (N'SV21      ', N'Asdnn Nnnnn Jjjj', CAST(N'2019-03-13 00:00:00.000' AS DateTime), N'Nữ', N'', N'', N'L01       ', 0, 0, 0)
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV01      ', 2.6461538461538461, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV02      ', 3.3428571428571425, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV03      ', 3.7999999999999994, N'Xuất Sắc')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV04      ', 3.7999999999999994, N'Xuất Sắc')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV07      ', 3, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK1       ', N'SV20      ', 3, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV01      ', 2.5, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV02      ', 3, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV06      ', 2.5, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV09      ', 1.5, N'Trung Bình Khá')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV10      ', 2.5, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK2       ', N'SV16      ', 3, N'Giỏi')
INSERT [dbo].[TongKetKy] ([MaKy], [MaSV], [DiemTBC], [XepLoai]) VALUES (N'HK3       ', N'SV15      ', 3.7999999999999994, N'Xuất Sắc')
ALTER TABLE [dbo].[GiangVien]  WITH CHECK ADD  CONSTRAINT [FK_GiangVien_Khoa] FOREIGN KEY([MaKhoa])
REFERENCES [dbo].[Khoa] ([MaKhoa])
GO
ALTER TABLE [dbo].[GiangVien] CHECK CONSTRAINT [FK_GiangVien_Khoa]
GO
ALTER TABLE [dbo].[KetQuaHP]  WITH CHECK ADD  CONSTRAINT [FK_KetQuaHP_HocPhan] FOREIGN KEY([MaHP])
REFERENCES [dbo].[HocPhan] ([MaHP])
GO
ALTER TABLE [dbo].[KetQuaHP] CHECK CONSTRAINT [FK_KetQuaHP_HocPhan]
GO
ALTER TABLE [dbo].[KetQuaHP]  WITH CHECK ADD  CONSTRAINT [FK_KetQuaHP_SinhVien] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SinhVien] ([MaSV])
GO
ALTER TABLE [dbo].[KetQuaHP] CHECK CONSTRAINT [FK_KetQuaHP_SinhVien]
GO
ALTER TABLE [dbo].[KetQuaLHP]  WITH CHECK ADD  CONSTRAINT [FK_KetQuaLHP_LopHocPhan] FOREIGN KEY([MaLopHP])
REFERENCES [dbo].[LopHocPhan] ([MaLopHP])
GO
ALTER TABLE [dbo].[KetQuaLHP] CHECK CONSTRAINT [FK_KetQuaLHP_LopHocPhan]
GO
ALTER TABLE [dbo].[KetQuaLHP]  WITH CHECK ADD  CONSTRAINT [FK_KetQuaLHP_SinhVien] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SinhVien] ([MaSV])
GO
ALTER TABLE [dbo].[KetQuaLHP] CHECK CONSTRAINT [FK_KetQuaLHP_SinhVien]
GO
ALTER TABLE [dbo].[Lop]  WITH CHECK ADD  CONSTRAINT [FK_Lop_Khoa] FOREIGN KEY([MaKhoa])
REFERENCES [dbo].[Khoa] ([MaKhoa])
GO
ALTER TABLE [dbo].[Lop] CHECK CONSTRAINT [FK_Lop_Khoa]
GO
ALTER TABLE [dbo].[LopHocPhan]  WITH CHECK ADD  CONSTRAINT [FK_LopHocPhan_GiangVien] FOREIGN KEY([MaGV])
REFERENCES [dbo].[GiangVien] ([MaGV])
GO
ALTER TABLE [dbo].[LopHocPhan] CHECK CONSTRAINT [FK_LopHocPhan_GiangVien]
GO
ALTER TABLE [dbo].[LopHocPhan]  WITH CHECK ADD  CONSTRAINT [FK_LopHocPhan_HocKy] FOREIGN KEY([MaHK])
REFERENCES [dbo].[HocKy] ([MaHK])
GO
ALTER TABLE [dbo].[LopHocPhan] CHECK CONSTRAINT [FK_LopHocPhan_HocKy]
GO
ALTER TABLE [dbo].[LopHocPhan]  WITH CHECK ADD  CONSTRAINT [FK_LopHocPhan_HocPhan] FOREIGN KEY([MaHP])
REFERENCES [dbo].[HocPhan] ([MaHP])
GO
ALTER TABLE [dbo].[LopHocPhan] CHECK CONSTRAINT [FK_LopHocPhan_HocPhan]
GO
ALTER TABLE [dbo].[SinhVien]  WITH CHECK ADD  CONSTRAINT [FK_SinhVien_Lop] FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop] ([MaLop])
GO
ALTER TABLE [dbo].[SinhVien] CHECK CONSTRAINT [FK_SinhVien_Lop]
GO
ALTER TABLE [dbo].[TongKetKy]  WITH CHECK ADD  CONSTRAINT [FK_TongKetKy_HocKy] FOREIGN KEY([MaKy])
REFERENCES [dbo].[HocKy] ([MaHK])
GO
ALTER TABLE [dbo].[TongKetKy] CHECK CONSTRAINT [FK_TongKetKy_HocKy]
GO
ALTER TABLE [dbo].[TongKetKy]  WITH CHECK ADD  CONSTRAINT [FK_TongKetKy_SinhVien] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SinhVien] ([MaSV])
GO
ALTER TABLE [dbo].[TongKetKy] CHECK CONSTRAINT [FK_TongKetKy_SinhVien]
GO
/****** Object:  StoredProcedure [dbo].[ChuanHoaHoTen]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ChuanHoaHoTen](
	@chuoivao NVARCHAR(MAX)
) 
AS
	BEGIN
	    DECLARE @start INT, @end INT
		DECLARE @chuoi NVARCHAR(MAX)
		SET @chuoi = LOWER(RTRIM(LTRIM(@chuoivao)))
		SELECT @start = 1, @end = CHARINDEX(' ', @chuoi)
		DECLARE @kq NVARCHAR(MAX)
		WHILE @start < LEN(@chuoi) +1 
		BEGIN
		    IF @end = 0
				SET @end = LEN(@chuoi) +1
			IF SUBSTRING(@chuoi, @start, @end - @start) != ' '
				SET @kq =  CONCAT(@kq, SUBSTRING(UPPER(@chuoi), @start, 1), SUBSTRING(@chuoi, @start+1, @end-@start))
			SET @start = @end + 1
			SET @end = CHARINDEX(' ', @chuoi, @start)
		END
		RETURN @kq
	END

GO
/****** Object:  StoredProcedure [dbo].[pr_DanhSachDiemLHP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_DanhSachDiemLHP]
AS
BEGIN 
	SELECT KetQuaLHP.MaLopHP,TenHP,dbo.SinhVien.MaSV, HoTen,DiemCC,DiemTX,DiemThi,DiemHe10,DiemHeBon,DiemChu
	FROM dbo.KetQuaLHP JOIN dbo.LopHocPhan ON LopHocPhan.MaLopHP = KetQuaLHP.MaLopHP
	JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
	JOIN dbo.SinhVien ON SinhVien.MaSV = KetQuaLHP.MaSV
END


GO
/****** Object:  StoredProcedure [dbo].[pr_DanhSachDiemLHP_Khoa]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_DanhSachDiemLHP_Khoa]
(
	@maKhoa CHAR(10)
)
AS
BEGIN 
	SELECT KetQuaLHP.MaLopHP,TenHP,dbo.SinhVien.MaSV, HoTen,DiemCC,DiemTX,DiemThi,DiemHe10,DiemHeBon,DiemChu
	FROM dbo.KetQuaLHP JOIN dbo.LopHocPhan ON LopHocPhan.MaLopHP = KetQuaLHP.MaLopHP
	JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
	JOIN dbo.SinhVien ON SinhVien.MaSV = KetQuaLHP.MaSV
	JOIN dbo.Lop ON Lop.MaLop = SinhVien.MaLop
	JOIN dbo.Khoa ON Khoa.MaKhoa = Lop.MaKhoa
	WHERE Khoa.MaKhoa = @maKhoa
END

GO
/****** Object:  StoredProcedure [dbo].[pr_DiemSV_Ky]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_DiemSV_Ky](
	@maKy CHAR(10),
	@maSV CHAR(10)
)
AS
BEGIN
	SELECT HocPhan.MaHP,TenHP,SoTC,DiemCC,DiemTX,DiemThi,DiemHe10,DiemHeBon
	FROM  dbo.KetQuaLHP JOIN dbo.LopHocPhan ON LopHocPhan.MaLopHP = KetQuaLHP.MaLopHP
	JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
	WHERE MaSV = @maSV AND MaHK = @maKy
END


GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_Delete]
	@MaGV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[GiangVien]
WHERE
	[MaGV] = @MaGV

GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_Insert]
	@MaGV char(10),
	@HoTen nvarchar(50),
	@SDT char(20),
	@HocVi nchar(10),
	@MaKhoa char(10)
AS
SET NOCOUNT ON
INSERT [dbo].[GiangVien]
(
	[MaGV],
	[HoTen],
	[SDT],
	[HocVi],
	[MaKhoa]
)
VALUES
(
	@MaGV,
	@HoTen,
	@SDT,
	@HocVi,
	@MaKhoa
)

GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaGV],
	[HoTen],
	[SDT],
	[HocVi],
	[MaKhoa]
FROM [dbo].[GiangVien]
ORDER BY 
	[MaGV] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_SelectAllWMaKhoaLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_SelectAllWMaKhoaLogic]
	@MaKhoa char(10)
AS
SET NOCOUNT ON
SELECT
	[MaGV],
	[HoTen],
	[SDT],
	[HocVi],
	[MaKhoa]
FROM [dbo].[GiangVien]
WHERE
	[MaKhoa] = @MaKhoa

GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_SelectOne]
	@MaGV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaGV],
	[HoTen],
	[SDT],
	[HocVi],
	[MaKhoa]
FROM [dbo].[GiangVien]
WHERE
	[MaGV] = @MaGV

GO
/****** Object:  StoredProcedure [dbo].[pr_GiangVien_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GiangVien_Update]
	@MaGV char(10),
	@HoTen nvarchar(50),
	@SDT char(20),
	@HocVi nchar(10),
	@MaKhoa char(10)
AS
SET NOCOUNT ON
UPDATE [dbo].[GiangVien]
SET 
	[HoTen] = @HoTen,
	[SDT] = @SDT,
	[HocVi] = @HocVi,
	[MaKhoa] = @MaKhoa
WHERE
	[MaGV] = @MaGV

GO
/****** Object:  StoredProcedure [dbo].[pr_HocKy_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocKy_Delete]
	@MaHK char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[HocKy]
WHERE
	[MaHK] = @MaHK

GO
/****** Object:  StoredProcedure [dbo].[pr_HocKy_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocKy_Insert]
	@MaHK char(10),
	@TimeBatDau date,
	@TimeKetThuc date
AS
SET NOCOUNT ON
INSERT [dbo].[HocKy]
(
	[MaHK],
	[TimeBatDau],
	[TimeKetThuc]
)
VALUES
(
	@MaHK,
	@TimeBatDau,
	@TimeKetThuc
)

GO
/****** Object:  StoredProcedure [dbo].[pr_HocKy_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocKy_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaHK],
	[TimeBatDau],
	[TimeKetThuc]
FROM [dbo].[HocKy]
ORDER BY 
	[MaHK] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_HocKy_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocKy_SelectOne]
	@MaHK char(10)
AS
SET NOCOUNT ON
SELECT
	[MaHK],
	[TimeBatDau],
	[TimeKetThuc]
FROM [dbo].[HocKy]
WHERE
	[MaHK] = @MaHK

GO
/****** Object:  StoredProcedure [dbo].[pr_HocKy_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocKy_Update]
	@MaHK char(10),
	@TimeBatDau date,
	@TimeKetThuc date
AS
SET NOCOUNT ON
UPDATE [dbo].[HocKy]
SET 
	[TimeBatDau] = @TimeBatDau,
	[TimeKetThuc] = @TimeKetThuc
WHERE
	[MaHK] = @MaHK

GO
/****** Object:  StoredProcedure [dbo].[pr_HocPhan_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocPhan_Delete]
	@MaHP char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[HocPhan]
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_HocPhan_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocPhan_Insert]
	@MaHP char(10),
	@TenHP nvarchar(200),
	@SoTC int
AS
SET NOCOUNT ON
INSERT [dbo].[HocPhan]
(
	[MaHP],
	[TenHP],
	[SoTC]
)
VALUES
(
	@MaHP,
	@TenHP,
	@SoTC
)

GO
/****** Object:  StoredProcedure [dbo].[pr_HocPhan_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocPhan_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[TenHP],
	[SoTC]
FROM [dbo].[HocPhan]
ORDER BY 
	[MaHP] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_HocPhan_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocPhan_SelectOne]
	@MaHP char(10)
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[TenHP],
	[SoTC]
FROM [dbo].[HocPhan]
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_HocPhan_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HocPhan_Update]
	@MaHP char(10),
	@TenHP nvarchar(200),
	@SoTC int
AS
SET NOCOUNT ON
UPDATE [dbo].[HocPhan]
SET 
	[TenHP] = @TenHP,
	[SoTC] = @SoTC
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_Delete]
	@MaHP char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaHP]
WHERE
	[MaHP] = @MaHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_DeleteWMaHPLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_DeleteWMaHPLogic]
	@MaHP char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaHP]
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_DeleteWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_DeleteWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaHP]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_Insert]
	@MaHP char(10),
	@MaSV char(10),
	@DiemCC float(53),
	@DiemTX float(53),
	@DiemThi float(53),
	@DiemHe10 float(53),
	@DiemHeBon float(53),
	@DiemChu char(10)
AS
SET NOCOUNT ON
INSERT [dbo].[KetQuaHP]
(
	[MaHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
)
VALUES
(
	@MaHP,
	@MaSV,
	@DiemCC,
	@DiemTX,
	@DiemThi,
	@DiemHe10,
	@DiemHeBon,
	@DiemChu
)

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaHP]
ORDER BY 
	[MaHP] ASC
	, [MaSV] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_SelectAllWMaHPLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_SelectAllWMaHPLogic]
	@MaHP char(10)
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaHP]
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_SelectAllWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_SelectAllWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaHP]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_SelectOne]
	@MaHP char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaHP]
WHERE
	[MaHP] = @MaHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaHP_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaHP_Update]
	@MaHP char(10),
	@MaSV char(10),
	@DiemCC float(53),
	@DiemTX float(53),
	@DiemThi float(53),
	@DiemHe10 float(53),
	@DiemHeBon float(53),
	@DiemChu char(10)
AS
SET NOCOUNT ON
UPDATE [dbo].[KetQuaHP]
SET 
	[DiemCC] = @DiemCC,
	[DiemTX] = @DiemTX,
	[DiemThi] = @DiemThi,
	[DiemHe10] = @DiemHe10,
	[DiemHeBon] = @DiemHeBon,
	[DiemChu] = @DiemChu
WHERE
	[MaHP] = @MaHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_Delete]
	@MaLopHP char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaLHP]
WHERE
	[MaLopHP] = @MaLopHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_DeleteWMaLopHPLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_DeleteWMaLopHPLogic]
	@MaLopHP char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaLHP]
WHERE
	[MaLopHP] = @MaLopHP

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_DeleteWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_DeleteWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[KetQuaLHP]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_Insert]
	@MaLopHP char(10),
	@MaSV char(10),
	@DiemCC float(53),
	@DiemTX float(53),
	@DiemThi float(53),
	@DiemHe10 float(53),
	@DiemHeBon float(53),
	@DiemChu char(10)
AS
SET NOCOUNT ON
INSERT [dbo].[KetQuaLHP]
(
	[MaLopHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
)
VALUES
(
	@MaLopHP,
	@MaSV,
	@DiemCC,
	@DiemTX,
	@DiemThi,
	@DiemHe10,
	@DiemHeBon,
	@DiemChu
)

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaLHP]
ORDER BY 
	[MaLopHP] ASC
	, [MaSV] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_SelectAllWMaLopHPLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_SelectAllWMaLopHPLogic]
	@MaLopHP char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaLHP]
WHERE
	[MaLopHP] = @MaLopHP

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_SelectAllWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_SelectAllWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaLHP]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_SelectOne]
	@MaLopHP char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[MaSV],
	[DiemCC],
	[DiemTX],
	[DiemThi],
	[DiemHe10],
	[DiemHeBon],
	[DiemChu]
FROM [dbo].[KetQuaLHP]
WHERE
	[MaLopHP] = @MaLopHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_KetQuaLHP_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_KetQuaLHP_Update]
	@MaLopHP char(10),
	@MaSV char(10),
	@DiemCC float(53),
	@DiemTX float(53),
	@DiemThi float(53),
	@DiemHe10 float(53),
	@DiemHeBon float(53),
	@DiemChu char(10)
AS
SET NOCOUNT ON
UPDATE [dbo].[KetQuaLHP]
SET 
	[DiemCC] = @DiemCC,
	[DiemTX] = @DiemTX,
	[DiemThi] = @DiemThi,
	[DiemHe10] = @DiemHe10,
	[DiemHeBon] = @DiemHeBon,
	[DiemChu] = @DiemChu
WHERE
	[MaLopHP] = @MaLopHP
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_Khoa_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Khoa_Delete]
	@MaKhoa char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[Khoa]
WHERE
	[MaKhoa] = @MaKhoa

GO
/****** Object:  StoredProcedure [dbo].[pr_Khoa_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Khoa_Insert]
	@MaKhoa char(10),
	@TenKhoa nvarchar(200)
AS
SET NOCOUNT ON
INSERT [dbo].[Khoa]
(
	[MaKhoa],
	[TenKhoa]
)
VALUES
(
	@MaKhoa,
	@TenKhoa
)

GO
/****** Object:  StoredProcedure [dbo].[pr_Khoa_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Khoa_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaKhoa],
	[TenKhoa]
FROM [dbo].[Khoa]
ORDER BY 
	[MaKhoa] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_Khoa_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Khoa_SelectOne]
	@MaKhoa char(10)
AS
SET NOCOUNT ON
SELECT
	[MaKhoa],
	[TenKhoa]
FROM [dbo].[Khoa]
WHERE
	[MaKhoa] = @MaKhoa

GO
/****** Object:  StoredProcedure [dbo].[pr_Khoa_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Khoa_Update]
	@MaKhoa char(10),
	@TenKhoa nvarchar(200)
AS
SET NOCOUNT ON
UPDATE [dbo].[Khoa]
SET 
	[TenKhoa] = @TenKhoa
WHERE
	[MaKhoa] = @MaKhoa

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_Delete]
	@MaLop char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[Lop]
WHERE
	[MaLop] = @MaLop

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_Insert]
	@MaLop char(10),
	@TenLop nvarchar(200),
	@SiSo int,
	@MaKhoa char(10),
	@NienKhoa nvarchar(50)
AS
SET NOCOUNT ON
INSERT [dbo].[Lop]
(
	[MaLop],
	[TenLop],
	[SiSo],
	[MaKhoa],
	[NienKhoa]
)
VALUES
(
	@MaLop,
	@TenLop,
	@SiSo,
	@MaKhoa,
	@NienKhoa
)

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaLop],
	[TenLop],
	[SiSo],
	[MaKhoa],
	[NienKhoa]
FROM [dbo].[Lop]
ORDER BY 
	[MaLop] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_SelectAll_Khoa]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_Lop_SelectAll_Khoa] @MaKhoa CHAR(10)
AS
BEGIN
	SELECT * FROM LOP where MaKhoa = @MaKhoa
END

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_SelectAllWMaKhoaLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_SelectAllWMaKhoaLogic]
	@MaKhoa char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLop],
	[TenLop],
	[SiSo],
	[MaKhoa],
	[NienKhoa]
FROM [dbo].[Lop]
WHERE
	[MaKhoa] = @MaKhoa

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_SelectOne]
	@MaLop char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLop],
	[TenLop],
	[SiSo],
	[MaKhoa],
	[NienKhoa]
FROM [dbo].[Lop]
WHERE
	[MaLop] = @MaLop

GO
/****** Object:  StoredProcedure [dbo].[pr_Lop_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Lop_Update]
	@MaLop char(10),
	@TenLop nvarchar(200),
	@SiSo int,
	@MaKhoa char(10),
	@NienKhoa nvarchar(50)
AS
SET NOCOUNT ON
UPDATE [dbo].[Lop]
SET 
	[TenLop] = @TenLop,
	[SiSo] = @SiSo,
	[MaKhoa] = @MaKhoa,
	[NienKhoa] = @NienKhoa
WHERE
	[MaLop] = @MaLop

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_Delete]
	@MaLopHP char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[LopHocPhan]
WHERE
	[MaLopHP] = @MaLopHP

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_Insert]
	@MaLopHP char(10),
	@PhongHoc nvarchar(50),
	@TongSoSV nchar(10),
	@TietBatDau int,
	@TietKetThuc int,
	@Thu nvarchar(10),
	@MaHP char(10),
	@MaGV char(10),
	@MaHK char(10)
AS
SET NOCOUNT ON
INSERT [dbo].[LopHocPhan]
(
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
)
VALUES
(
	@MaLopHP,
	@PhongHoc,
	@TongSoSV,
	@TietBatDau,
	@TietKetThuc,
	@Thu,
	@MaHP,
	@MaGV,
	@MaHK
)

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
FROM [dbo].[LopHocPhan]
ORDER BY 
	[MaLopHP] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_SelectAllWMaGVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_SelectAllWMaGVLogic]
	@MaGV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
FROM [dbo].[LopHocPhan]
WHERE
	[MaGV] = @MaGV

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_SelectAllWMaHKLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_SelectAllWMaHKLogic]
	@MaHK char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
FROM [dbo].[LopHocPhan]
WHERE
	[MaHK] = @MaHK

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_SelectAllWMaHPLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_SelectAllWMaHPLogic]
	@MaHP char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
FROM [dbo].[LopHocPhan]
WHERE
	[MaHP] = @MaHP

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_SelectOne]
	@MaLopHP char(10)
AS
SET NOCOUNT ON
SELECT
	[MaLopHP],
	[PhongHoc],
	[TongSoSV],
	[TietBatDau],
	[TietKetThuc],
	[Thu],
	[MaHP],
	[MaGV],
	[MaHK]
FROM [dbo].[LopHocPhan]
WHERE
	[MaLopHP] = @MaLopHP

GO
/****** Object:  StoredProcedure [dbo].[pr_LopHocPhan_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_LopHocPhan_Update]
	@MaLopHP char(10),
	@PhongHoc nvarchar(50),
	@TongSoSV nchar(10),
	@TietBatDau int,
	@TietKetThuc int,
	@Thu nvarchar(10),
	@MaHP char(10),
	@MaGV char(10),
	@MaHK char(10)
AS
SET NOCOUNT ON
UPDATE [dbo].[LopHocPhan]
SET 
	[PhongHoc] = @PhongHoc,
	[TongSoSV] = @TongSoSV,
	[TietBatDau] = @TietBatDau,
	[TietKetThuc] = @TietKetThuc,
	[Thu] = @Thu,
	[MaHP] = @MaHP,
	[MaGV] = @MaGV,
	[MaHK] = @MaHK
WHERE
	[MaLopHP] = @MaLopHP

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_Delete]
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[SinhVien]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_Diem]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- đưa ra sinh viên thuộc lớp và học phần nào đó

CREATE PROC [dbo].[pr_SinhVien_Diem](
	@MaLop CHAR(10),
	@MaHP CHAR(10)
)
AS
BEGIN
	SELECT SinhVien.MaSV, HoTen, NgaySinh, QueQuan,DiaChiHT,DiemCC,DiemTX,DiemThi,DiemHe10,DiemHeBon,DiemChu,TenHP,SoTC
	FROM dbo.SinhVien JOIN dbo.KetQuaHP ON KetQuaHP.MaSV = SinhVien.MaSV
	JOIN dbo.HocPhan ON HocPhan.MaHP = KetQuaHP.MaHP
	WHERE MaLop = @MaLop AND HocPhan.MaHP = @MaHP
END


GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_Insert]
	@MaSV char(10),
	@HoTen nvarchar(50),
	@NgaySinh datetime,
	@GioiTinh nvarchar(20),
	@QueQuan nvarchar(200),
	@DiaChiHT nvarchar(200),
	@MaLop char(10),
	@SoTinChiDaDat int,
	@DiemTichLuy float(53),
	@SoTinChiDaDKi int
AS
SET NOCOUNT ON
INSERT [dbo].[SinhVien]
(
	[MaSV],
	[HoTen],
	[NgaySinh],
	[GioiTinh],
	[QueQuan],
	[DiaChiHT],
	[MaLop],
	[SoTinChiDaDat],
	[DiemTichLuy],
	[SoTinChiDaDKi]
)
VALUES
(
	@MaSV,
	@HoTen,
	@NgaySinh,
	@GioiTinh,
	@QueQuan,
	@DiaChiHT,
	@MaLop,
	@SoTinChiDaDat,
	@DiemTichLuy,
	@SoTinChiDaDKi
)

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaSV],
	[HoTen],
	[NgaySinh],
	[GioiTinh],
	[QueQuan],
	[DiaChiHT],
	[MaLop],
	[SoTinChiDaDat],
	[DiemTichLuy],
	[SoTinChiDaDKi]
FROM [dbo].[SinhVien]
ORDER BY 
	[MaSV] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_SelectAll_Khoa]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_SinhVien_SelectAll_Khoa] @MaKhoa CHAR(10)
AS
BEGIN
	SELECT MaSV,HoTen,NgaySinh,GioiTinh,QueQuan,DiaChiHT,SinhVien.MaLop,SoTinChiDaDat,DiemTichLuy,SoTinChiDaDKi FROM SinhVien JOIN Lop ON SinhVien.MaLop = Lop.MaLop WHERE MaKhoa = @MaKhoa
END

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_SelectAll_Lop]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[pr_SinhVien_SelectAll_Lop] @MaLop CHAR(10)
AS
BEGIN
	SELECT * FROM SinhVien WHERE MaLop = @MaLop
END

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_SelectAllWMaLopLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_SelectAllWMaLopLogic]
	@MaLop char(10)
AS
SET NOCOUNT ON
SELECT
	[MaSV],
	[HoTen],
	[NgaySinh],
	[GioiTinh],
	[QueQuan],
	[DiaChiHT],
	[MaLop],
	[SoTinChiDaDat],
	[DiemTichLuy],
	[SoTinChiDaDKi]
FROM [dbo].[SinhVien]
WHERE
	[MaLop] = @MaLop

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_SelectOne]
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaSV],
	[HoTen],
	[NgaySinh],
	[GioiTinh],
	[QueQuan],
	[DiaChiHT],
	[MaLop],
	[SoTinChiDaDat],
	[DiemTichLuy],
	[SoTinChiDaDKi]
FROM [dbo].[SinhVien]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_SinhVien_Update]
	@MaSV char(10),
	@HoTen nvarchar(50),
	@NgaySinh datetime,
	@GioiTinh nvarchar(20),
	@QueQuan nvarchar(200),
	@DiaChiHT nvarchar(200),
	@MaLop char(10),
	@SoTinChiDaDat int,
	@DiemTichLuy float(53),
	@SoTinChiDaDKi int
AS
SET NOCOUNT ON
UPDATE [dbo].[SinhVien]
SET 
	[HoTen] = @HoTen,
	[NgaySinh] = @NgaySinh,
	[GioiTinh] = @GioiTinh,
	[QueQuan] = @QueQuan,
	[DiaChiHT] = @DiaChiHT,
	[MaLop] = @MaLop,
	[SoTinChiDaDat] = @SoTinChiDaDat,
	[DiemTichLuy] = @DiemTichLuy,
	[SoTinChiDaDKi] = @SoTinChiDaDKi
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_SinhVien_UpdateSoTC]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- cập nhật số tín chỉ đã đăng ký và số tín chỉ đã đạt

CREATE PROC [dbo].[pr_SinhVien_UpdateSoTC]
AS 
BEGIN
	DECLARE @maSV CHAR(10)
	DECLARE @soTCDangKy INT
	DECLARE @soTCDaDat INT
	DECLARE @count INT = (SELECT COUNT(*) FROM dbo.SinhVien)
	DECLARE @i INT = 1
	WHILE @i < @count +1
	BEGIN
		SELECT TOP(@i) @maSV = MaSV FROM dbo.SinhVien
		SELECT @soTCDangKy = SUM(SoTC) FROM dbo.KetQuaHP JOIN dbo.HocPhan ON HocPhan.MaHP = KetQuaHP.MaHP WHERE MaSV = @maSV
		SELECT @soTCDaDat = SUM(SoTC) FROM dbo.KetQuaHP JOIN dbo.HocPhan ON HocPhan.MaHP = KetQuaHP.MaHP WHERE MaSV = @maSV AND DiemHeBon >= 1
		UPDATE dbo.SinhVien
		SET SoTinChiDaDKi = @soTCDangKy, SoTinChiDaDat = @soTCDaDat
		WHERE MaSV = @maSV
		SET @i = @i + 1
	END 
END


GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_Delete]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_Delete]
	@MaKy char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[TongKetKy]
WHERE
	[MaKy] = @MaKy
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_DeleteWMaKyLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_DeleteWMaKyLogic]
	@MaKy char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[TongKetKy]
WHERE
	[MaKy] = @MaKy

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_DeleteWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_DeleteWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
DELETE FROM [dbo].[TongKetKy]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_Insert]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_Insert]
	@MaKy char(10),
	@MaSV char(10),
	@DiemTBC float(53),
	@XepLoai nvarchar(50)
AS
SET NOCOUNT ON
INSERT [dbo].[TongKetKy]
(
	[MaKy],
	[MaSV],
	[DiemTBC],
	[XepLoai]
)
VALUES
(
	@MaKy,
	@MaSV,
	@DiemTBC,
	@XepLoai
)

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_SelectAll]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_SelectAll]
AS
SET NOCOUNT ON
SELECT
	[MaKy],
	[MaSV],
	[DiemTBC],
	[XepLoai]
FROM [dbo].[TongKetKy]
ORDER BY 
	[MaKy] ASC
	, [MaSV] ASC

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_SelectAllWMaKyLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_SelectAllWMaKyLogic]
	@MaKy char(10)
AS
SET NOCOUNT ON
SELECT
	[MaKy],
	[MaSV],
	[DiemTBC],
	[XepLoai]
FROM [dbo].[TongKetKy]
WHERE
	[MaKy] = @MaKy

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_SelectAllWMaSVLogic]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_SelectAllWMaSVLogic]
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaKy],
	[MaSV],
	[DiemTBC],
	[XepLoai]
FROM [dbo].[TongKetKy]
WHERE
	[MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_SelectOne]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_SelectOne]
	@MaKy char(10),
	@MaSV char(10)
AS
SET NOCOUNT ON
SELECT
	[MaKy],
	[MaSV],
	[DiemTBC],
	[XepLoai]
FROM [dbo].[TongKetKy]
WHERE
	[MaKy] = @MaKy
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_TongKetKy_Update]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_TongKetKy_Update]
	@MaKy char(10),
	@MaSV char(10),
	@DiemTBC float(53),
	@XepLoai nvarchar(50)
AS
SET NOCOUNT ON
UPDATE [dbo].[TongKetKy]
SET 
	[DiemTBC] = @DiemTBC,
	[XepLoai] = @XepLoai
WHERE
	[MaKy] = @MaKy
	AND [MaSV] = @MaSV

GO
/****** Object:  StoredProcedure [dbo].[pr_UpdateDiemTB_KQ_HP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- update ketquaHP
CREATE PROCEDURE [dbo].[pr_UpdateDiemTB_KQ_HP]
AS 
BEGIN
	DECLARE @TX FLOAT
	DECLARE @CC FLOAT
	DECLARE @DT FLOAT
	DECLARE @count INT = (SELECT COUNT(*) FROM dbo.KetQuaHP)
	DECLARE @maSV CHAR(10)
	DECLARE @maHP CHAR(10)
	DECLARE @i INT = 1
	WHILE(@i < @count + 1)
	BEGIN
		 SELECT TOP (@i) @maSV =  MaSV FROM dbo.KetQuaHP ORDER BY MaSV DESC 
		 SELECT TOP (@i)@maHP = MaHP FROM dbo.KetQuaHP WHERE MaSV = @maSV ORDER BY MaSV DESC
		SET @CC = (SELECT DiemCC FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		SET @TX = (SELECT DiemTX FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		SET @DT = (SELECT DiemThi FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemHe10 = (SELECT dbo.fn_DiemTB(@CC,@TX,@DT))
		WHERE MaSV = @maSV AND MaHP = @maHP
		DECLARE @diem10 FLOAT = (SELECT DiemHe10 FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemHeBon = (SELECT dbo.fn_updateDiem4(@diem10))
		WHERE MaSV = @maSV AND MaHP = @maHP
		DECLARE @diem4 FLOAT = (SELECT DiemHeBon FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemChu = (SELECT dbo.fn_updateDiemChu(@diem4))
		WHERE MaSV = @maSV AND MaHP = @maHP
		SET @i = @i + 1
	END 
END


GO
/****** Object:  StoredProcedure [dbo].[pr_UpdateDiemTB_KQ_LHP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--update ketquaLHP

CREATE PROCEDURE [dbo].[pr_UpdateDiemTB_KQ_LHP]
AS 
BEGIN
	DECLARE @TX FLOAT
	DECLARE @CC FLOAT
	DECLARE @DT FLOAT
	DECLARE @count INT = (SELECT COUNT(*) FROM dbo.KetQuaLHP)
	DECLARE @maSV CHAR(10)
	DECLARE @maLHP CHAR(10)
	DECLARE @i INT = 1
	WHILE(@i < @count + 1)
	BEGIN
		 SELECT TOP (@i) @maSV =  MaSV FROM dbo.KetQuaLHP ORDER BY MaSV DESC 
		 SELECT TOP (@i)@maLHP = MaLopHP FROM dbo.KetQuaLHP WHERE MaSV = @maSV ORDER BY MaSV DESC
		SET @CC = (SELECT DiemCC FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		SET @TX = (SELECT DiemTX FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		SET @DT = (SELECT DiemThi FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemHe10 = (SELECT dbo.fn_DiemTB(@CC,@TX,@DT))
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		DECLARE @diem10 FLOAT = (SELECT DiemHe10 FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemHeBon = (SELECT dbo.fn_updateDiem4(@diem10))
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		DECLARE @diem4 FLOAT = (SELECT DiemHeBon FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemChu = (SELECT dbo.fn_updateDiemChu(@diem4))
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		SET @i = @i + 1
	END 
END


GO
/****** Object:  Trigger [dbo].[tr_SinhVien_updateSoTC]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[tr_SinhVien_updateSoTC] ON [dbo].[KetQuaHP]
AFTER INSERT,UPDATE
AS 
BEGIN
	DECLARE @maSV CHAR(10)
	DECLARE @soTCDangKy INT
	DECLARE @soTCDaDat INT
	SELECT @maSV = MaSV FROM Inserted
	SELECT @soTCDangKy = SUM(SoTC) FROM dbo.KetQuaHP JOIN dbo.HocPhan ON HocPhan.MaHP = KetQuaHP.MaHP WHERE MaSV = @maSV
	SELECT @soTCDaDat = SUM(SoTC) FROM dbo.KetQuaHP JOIN dbo.HocPhan ON HocPhan.MaHP = KetQuaHP.MaHP WHERE MaSV = @maSV AND DiemHeBon >= 1
	UPDATE dbo.SinhVien
	SET SoTinChiDaDKi = @soTCDangKy, SoTinChiDaDat = @soTCDaDat
	WHERE MaSV = @maSV
END


GO
/****** Object:  Trigger [dbo].[tr_UpdateDiemTB_KQ_HP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- trigger update điểm học phần

CREATE TRIGGER [dbo].[tr_UpdateDiemTB_KQ_HP] ON [dbo].[KetQuaHP] AFTER INSERT, UPDATE
AS  
BEGIN
	DECLARE @TX FLOAT
	DECLARE @CC FLOAT
	DECLARE @DT FLOAT
	DECLARE @count INT = (SELECT COUNT(*) FROM Inserted)
	DECLARE @i INT = 1
	WHILE(@i < @count + 1)
	BEGIN
		DECLARE @maSV CHAR(10) = (SELECT MaSV FROM Inserted)
		DECLARE @maHP CHAR(10) = (SELECT MaHP FROM Inserted)
		SET @CC = (SELECT DiemCC FROM Inserted WHERE MaSV = @maSV AND MaHP = @maHP)
		SET @TX = (SELECT DiemTX FROM Inserted WHERE MaSV = @maSV AND MaHP = @maHP)
		SET @DT = (SELECT DiemThi FROM Inserted WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemHe10 = dbo.fn_DiemTB(@CC,@TX,@DT)
		WHERE MaSV = @maSV AND MaHP = @maHP
		DECLARE @diem10 FLOAT = (SELECT DiemHe10 FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemHeBon = (SELECT dbo.fn_updateDiem4(@diem10))
		WHERE MaSV = @maSV AND MaHP = @maHP
		DECLARE @diem4 FLOAT = (SELECT DiemHeBon FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP = @maHP)
		UPDATE dbo.KetQuaHP
		SET DiemChu = (SELECT dbo.fn_updateDiemChu(@diem4))
		WHERE MaSV = @maSV AND MaHP = @maHP
		SET @i = @i + 1
	END 
END


GO
/****** Object:  Trigger [dbo].[tr_TongKetKy_UpdateDiemTBC]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dbo.LopHocPhan JOIN dbo.KetQuaLHP ON KetQuaLHP.MaLopHP = LopHocPhan.MaLopHP
--JOIN dbo.HocPhan ON HocPhan.MaHP = LopHocPhan.MaHP
--WHERE MaHK = 'HK1' AND MaSV = 'SV01'

-- trigger cập nhật điểm trung bình kỳ của sinh viên
CREATE TRIGGER [dbo].[tr_TongKetKy_UpdateDiemTBC] ON [dbo].[KetQuaLHP] AFTER INSERT,UPDATE
AS
BEGIN
	
	DECLARE @maSV CHAR(10) = (SELECT Inserted.MaSV FROM Inserted)
	DECLARE @maLHP CHAR(10) = (SELECT Inserted.MaLopHP FROM Inserted)
	DECLARE @maHK CHAR(10) = (SELECT MaHK FROM dbo.LopHocPhan WHERE MaLopHP = @maLHP)
	DECLARE @checkTonTai INT = (SELECT COUNT(*) FROM dbo.TongKetKy WHERE MaSV = @maSV AND MaKy = @maHK)
	IF @checkTonTai = 1
	BEGIN
		UPDATE dbo.TongKetKy
		SET DiemTBC = (SELECT dbo.fn_DiemTB_Ky(@maHK,@maSV))
		WHERE MaSV = @maSV AND MaKy = @maHK
		DECLARE @diemTBC FLOAT = (SELECT DiemTBC FROM dbo.TongKetKy WHERE MaSV =@maSV AND MaKy = @maHK)
		UPDATE dbo.TongKetKy
		SET XepLoai = (SELECT dbo.fn_PhanChiaXepLoai_TheoKy(@diemTBC))
		WHERE MaSV = @maSV AND MaKy = @maHK
	END
    ELSE
	BEGIN
		INSERT INTO dbo.TongKetKy
		        ( MaKy, MaSV, DiemTBC, XepLoai )
		VALUES  ( @maHK, -- MaKy - char(10)
		          @maSV, -- MaSV - char(10)
		          dbo.fn_DiemTB_Ky(@maHK,@maSV), -- DiemTBC - float
		          dbo.fn_PhanChiaXepLoai_TheoKy(@diemTBC)  -- XepLoai - nvarchar(50)
		          )
	END 
END


GO
/****** Object:  Trigger [dbo].[tr_TongKetKy_UpdateXepLoai]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- trigger update xếp loại học sinh theo kỳ
CREATE TRIGGER [dbo].[tr_TongKetKy_UpdateXepLoai] ON [dbo].[KetQuaLHP] AFTER INSERT,UPDATE
AS
BEGIN
	
	DECLARE @maSV CHAR(10) = (SELECT Inserted.MaSV FROM Inserted)
	DECLARE @maLHP CHAR(10) = (SELECT Inserted.MaLopHP FROM Inserted)
	DECLARE @maHK CHAR(10) = (SELECT MaHK FROM dbo.LopHocPhan WHERE MaLopHP = @maLHP)
	DECLARE @diemTBC FLOAT = (SELECT DiemTBC FROM dbo.TongKetKy WHERE MaSV =@maSV AND MaKy = @maHK)
	UPDATE dbo.TongKetKy
	SET XepLoai = (SELECT dbo.fn_PhanChiaXepLoai_TheoKy(@diemTBC))
	WHERE MaSV = @maSV AND MaKy = @maHK
END


GO
/****** Object:  Trigger [dbo].[tr_UpdateDiemTB_KQ_LHP]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- trigger update điểm của lớp học phần
CREATE TRIGGER [dbo].[tr_UpdateDiemTB_KQ_LHP] ON [dbo].[KetQuaLHP] AFTER INSERT, UPDATE
AS  
BEGIN
	DECLARE @TX FLOAT
	DECLARE @CC FLOAT
	DECLARE @DT FLOAT
	DECLARE @count INT = (SELECT COUNT(*) FROM Inserted)
	DECLARE @i INT = 1
	WHILE(@i < @count + 1)
	BEGIN
		DECLARE @maSV CHAR(10) = (SELECT MaSV FROM Inserted)
		DECLARE @maLHP CHAR(10) = (SELECT MaLopHP FROM Inserted)
		SET @CC = (SELECT DiemCC FROM Inserted WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		SET @TX = (SELECT DiemTX FROM Inserted WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		SET @DT = (SELECT DiemThi FROM Inserted WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemHe10 = dbo.fn_DiemTB(@CC,@TX,@DT)
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		DECLARE @diem10 FLOAT = (SELECT DiemHe10 FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemHeBon = (SELECT dbo.fn_updateDiem4(@diem10))
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		DECLARE @diem4 FLOAT = (SELECT DiemHeBon FROM dbo.KetQuaLHP WHERE MaSV = @maSV AND MaLopHP = @maLHP)
		UPDATE dbo.KetQuaLHP
		SET DiemChu = (SELECT dbo.fn_updateDiemChu(@diem4))
		WHERE MaSV = @maSV AND MaLopHP = @maLHP
		SET @i = @i + 1
	END 
END


GO
/****** Object:  Trigger [dbo].[trg_KetQuaHP_UpdateDiemCao]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_KetQuaHP_UpdateDiemCao] ON [dbo].[KetQuaLHP]
AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @maSV CHAR(10) = (SELECT Inserted.MaSV FROM Inserted)
	DECLARE @maLHP CHAR(10) = (SELECT MaLopHP FROM Inserted)
	DECLARE @maHP CHAR(10) = (SELECT MaHP FROM dbo.LopHocPhan WHERE MaLopHP = @maLHP)
	DECLARE @CC FLOAT, @TX FLOAT, @DT FLOAT,@diem10 FLOAT,@diem4 FLOAT,@diemChu CHAR(10) 
	SELECT TOP 1 @CC=KetQuaLHP.DiemCC,@TX=KetQuaLHP.DiemTX,@DT=KetQuaLHP.DiemThi,@diem10= MAX(KetQuaLHP.DiemHe10)  ,@diem4=MAX(KetQuaLHP.DiemHeBon) ,@diemChu =KetQuaLHP.DiemChu
							FROM dbo.KetQuaLHP JOIN dbo.LopHocPhan ON LopHocPhan.MaLopHP = KetQuaLHP.MaLopHP
							JOIN dbo.KetQuaHP ON KetQuaHP.MaHP = LopHocPhan.MaHP
							WHERE dbo.LopHocPhan.MaHP = @maHP AND KetQuaHP.MaSV = @maSV AND KetQuaHP.MaSV = KetQuaLHP.MaSV 
							GROUP BY KetQuaLHP.MaSV, KetQuaLHP.DiemCC,KetQuaLHP.DiemTX,KetQuaLHP.DiemThi,KetQuaLHP.DiemChu
							ORDER BY MAX(KetQuaLHP.DiemHe10)  DESC
	DECLARE @checkTonTai INT = (SELECT COUNT(*) FROM dbo.KetQuaHP WHERE MaSV = @maSV AND MaHP= @maHP)
	IF @checkTonTai = 1
		BEGIN
			UPDATE dbo.KetQuaHP
			SET DiemCC = @CC,DiemTX = @TX,DiemThi = @DT,DiemHe10 = @diem10,DiemHeBon = @diem4,DiemChu = @diemChu
			WHERE MaSV = @maSV AND MaHP = @maHP
		END 
	ELSE
		BEGIN
			INSERT INTO dbo.KetQuaHP( MaHP ,MaSV ,DiemCC , DiemTX ,DiemThi ,DiemHe10 ,DiemHeBon , DiemChu)
			VALUES  ( @maHP , -- MaHP - char(10)
					  @maSV , -- MaSV - char(10)
					  @CC , -- DiemCC - float
					  @TX , -- DiemTX - float
					  @DT , -- DiemThi - float
					  @diem10 , -- DiemHe10 - float
					  @diem4 , -- DiemHeBon - float
					  @diemChu  -- DiemChu - char(10)
					)
		END 
END


GO
/****** Object:  Trigger [dbo].[tg_CapNhatSiSoLop]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_CapNhatSiSoLop] ON [dbo].[Lop] AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @MA CHAR(10), @siso INT
	SELECT @MA = MaLop FROM inserted;
	SELECT @siso=COUNT(*) FROM SINHVIEN WHERE MALOP =@MA
	UPDATE LOP SET SiSo = @siso WHERE MaLop = @MA
END

GO
/****** Object:  Trigger [dbo].[tg_AutoMaSV]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_AutoMaSV] on [dbo].[SinhVien]
for INSERT
AS
    BEGIN
        DECLARE @lastid char(10)
        SET @lastid  = (SELECT dbo.FUN_AUTO_MaSV())
        UPDATE dbo.SinhVien set MaSV = @lastid where MaSV = ''
    END


GO
/****** Object:  Trigger [dbo].[tg_ChuanHoaHoTen]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_ChuanHoaHoTen] ON [dbo].[SinhVien] AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @MA CHAR(10), @TEN NVARCHAR(50)
	SELECT @MA =MaSV FROM inserted
	SELECT @TEN = HoTen FROM inserted WHERE MaSV = @MA
	--DECLARE @Tench NVARCHAR(MAX) 
	--SET @Tench = ChuanHoaHoTen @TEN
	--UPDATE SinhVien SET HoTen = @Tench WHERE MASV = inserted.MaSV

	DECLARE @start INT, @end INT
	DECLARE @chuoi NVARCHAR(MAX)
	SET @chuoi = LOWER(RTRIM(LTRIM(@TEN)))
	SELECT @start = 1, @end = CHARINDEX(' ', @chuoi)
	DECLARE @kq NVARCHAR(MAX)
	WHILE @start < LEN(@chuoi) +1 
	BEGIN
		IF @end = 0
			SET @end = LEN(@chuoi) +1
		IF SUBSTRING(@chuoi, @start, @end - @start) != ' '
			SET @kq =  CONCAT(@kq, SUBSTRING(UPPER(@chuoi), @start, 1), SUBSTRING(@chuoi, @start+1, @end-@start))
		SET @start = @end + 1
		SET @end = CHARINDEX(' ', @chuoi, @start)
	END
	--RETURN @kq
	UPDATE SinhVien SET HoTen = @kq WHERE MASV = @MA
END

GO
/****** Object:  Trigger [dbo].[tg_SuaMaLopSV]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_SuaMaLopSV] ON [dbo].[SinhVien] FOR INSERT,UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		UPDATE Lop SET SiSo = SiSo+1 FROM LOP, Inserted WHERE Inserted.MaLop = LOP.MaLop
	END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		UPDATE Lop SET SiSo = SiSo+1 FROM Lop, Inserted WHERE Inserted.MaLop = Lop.MaLop
		UPDATE Lop SET SiSo = SiSo-1 FROM Lop, Deleted WHERE Deleted.MaLop = Lop.MaLop
	END
END

GO
/****** Object:  Trigger [dbo].[tg_XOASV]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_XOASV] ON [dbo].[SinhVien] INSTEAD OF DELETE
AS
DECLARE @MA CHAR(10)
--DECLARE @SiSo INT
BEGIN
	SELECT @MA=MaSV FROM DELETED
	--SELECT @SiSo = SiSo FROM Lop,deleted WHERE LOP.MaLop = deleted.MaLop
	DELETE KetQuaLHP WHERE MASV = @MA
	DELETE KetQuaHP WHERE MASV = @MA
	DELETE TongKetKy WHERE MASV = @MA
	UPDATE Lop 
	SET SiSo = (SiSo -1) WHERE MaLop IN (SELECT MALOP FROM SinhVien WHERE MASV =@MA)
	DELETE SinhVien	WHERE MASV=@MA
END

GO
/****** Object:  Trigger [dbo].[tr_SinhVien_UpdateDiemTichLuy]    Script Date: 13/03/2019 20:20:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- tự động cập nhật điểm tích lũy cho sinh viên

CREATE TRIGGER [dbo].[tr_SinhVien_UpdateDiemTichLuy] ON [dbo].[TongKetKy]
AFTER INSERT,UPDATE
AS 
BEGIN
	DECLARE @maSV CHAR(10) = (SELECT Inserted.MaSV FROM Inserted)
	DECLARE @count INT = (SELECT COUNT(*) FROM dbo.TongKetKy WHERE MaSV = @maSV)
	DECLARE @Tb FLOAT = (SELECT SUM(DiemTBC)/@count FROM dbo.TongKetKy WHERE MaSV = @maSV)
	UPDATE dbo.SinhVien
	SET DiemTichLuy = @Tb
	WHERE MaSV = @maSV
END


GO
USE [master]
GO
ALTER DATABASE [QLDiem_SV] SET  READ_WRITE 
GO
