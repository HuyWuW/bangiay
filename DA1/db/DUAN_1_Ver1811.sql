CREATE DATABASE DA1
GO
USE DA1
GO

--Drop database DA1

CREATE TABLE Size(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten INT NOT NULL

	CONSTRAINT [PK_KichThuoc] PRIMARY KEY (ID)
)
GO


CREATE TABLE MauSac(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_MauSac] PRIMARY KEY (ID)
)
GO

CREATE TABLE ChatLieu(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_ChatLieu] PRIMARY KEY (ID)
)
GO

CREATE TABLE ThuongHieu(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_ThuongHieu] PRIMARY KEY (ID)
)
GO

CREATE TABLE DanhMuc(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_DanhMuc] PRIMARY KEY (ID)
)
GO


CREATE TABLE KhachHang(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgaySinh DATE  NULL,
	GioiTinh BIT  NULL,
	SDT VARCHAR(10) NOT NULL, -- review

	CONSTRAINT [PK_KhachHang] PRIMARY KEY (ID)
)
GO

CREATE TABLE NhanVien(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Passwords VARCHAR (15) NOT NULL,
	Ten NVARCHAR(30) NOT NULL,
	SDT VARCHAR(10) NOT NULL,
	Email VARCHAR(30) NOT NULL,
	Anh NVARCHAR(MAX) NULL,
	ChucVu BIT NOT NULL,
	TrangThai BIT NOT NULL,
	Luong MONEY NOT NULL,
	NgaySinh DATE NOT NULL,
	DiaChi NVARCHAR(max) NOT NULL
	CONSTRAINT [PK_NhanVien] PRIMARY KEY (ID)
)
GO

CREATE TABLE SanPham(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgayThem DATETIME DEFAULT GETDATE(),
	ID_ThuongHieu INT  NULL,
	ID_DanhMuc INT  NULL,
	ID_NhanVien INT NOT NULL,


	CONSTRAINT [PK_SanPham] PRIMARY KEY (ID),
	CONSTRAINT [FK_SanPham_ThuongHieu] FOREIGN KEY(ID_ThuongHieu) REFERENCES ThuongHieu(ID),
	CONSTRAINT [FK_SanPham_DanhMuc] FOREIGN KEY(ID_DanhMuc) REFERENCES DanhMuc(ID),
	CONSTRAINT [FK_SanPham_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID)
)
GO

CREATE TABLE SanPhamChiTiet(
	ID INT IDENTITY(1,1) NOT NULL,
	Gia FLOAT NOT NULL,
	SoLuong INT NOT NULL,
	MaSP VARCHAR(10) NOT NULL,
	TrangThai BIT NOT NULL DEFAULT 1, -- mặc định true
	ID_SP INT  NULL,
	ID_Size INT NOT NULL,
	ID_MauSac INT NOT NULL,
	ID_ChatLieu INT NOT NULL,

	CONSTRAINT [FK_CTSP_SanPham] FOREIGN KEY(ID_SP) REFERENCES SanPham (ID), 
	CONSTRAINT [FK_CTSP_Size] FOREIGN KEY(ID_Size) REFERENCES Size(ID),
	CONSTRAINT [FK_CTSP_MauSac] FOREIGN KEY(ID_MauSac) REFERENCES MauSac(ID),
	CONSTRAINT [FK_CTSP_ChatLieu] FOREIGN KEY(ID_ChatLieu) REFERENCES ChatLieu(ID),
	CONSTRAINT [PK_SanPhamChiTiet] PRIMARY KEY (ID)
)
GO
CREATE TABLE Voucher(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgayTao DATETIME DEFAULT GETDATE(),
	ID_NhanVien INT NOT NULL,
	NgayBatDau DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    SoLuong INT NOT NULL,
    KieuGiam Bit NOT NULL,
	GiaTri FLOAT NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 1, -- Đặt mặc định TrangThai là True
	CONSTRAINT [PK_Voucher] PRIMARY KEY (ID),
	CONSTRAINT [FK_Voucher_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID)
)
GO


CREATE TABLE HoaDon(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	NgayTao DATETIME DEFAULT GETDATE(),
	TongTien FLOAT NULL,
	TrangThai INT NOT NULL DEFAULT 2, 
	ID_NhanVien INT NULL,
	ID_KhachHang INT  NULL,
	ID_Voucher int  null,
	CONSTRAINT [FK_CTHD_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID),
	CONSTRAINT [FK_CTHD_KhachHang] FOREIGN KEY(ID_KhachHang) REFERENCES KhachHang(ID),
	CONSTRAINT [PK_HoaDon] PRIMARY KEY (ID),
	-- khoá ngoại vc
	CONSTRAINT [FK_Voucher] FOREIGN KEY(ID_Voucher) REFERENCES Voucher(ID),
)
GO

CREATE TABLE HoaDonChiTiet(
	ID INT IDENTITY(1,1) NOT NULL,
	GiaBan FLOAT NOT NULL,
	SoLuongSP INT NOT NULL,
	TongTien FLOAT NOT NULL,
	ID_SanPhamCT INT NOT NULL,
	ID_HoaDon INT NOT NULL,
	ID_Voucher INT NULL,

	CONSTRAINT [FK_CTHD_SanPhamCT] FOREIGN KEY(ID_SanPhamCT) REFERENCES SanPhamChiTiet(ID),
	CONSTRAINT [FK_CTHD_HoaDon] FOREIGN KEY(ID_HoaDon) REFERENCES HoaDon(ID),
	CONSTRAINT [FK_CTHD_Voucher] FOREIGN KEY(ID_Voucher) REFERENCES Voucher(ID),

	CONSTRAINT [PK_HoaDonChiTiet] PRIMARY KEY (ID)
)
GO

-- Trigger để tự động sinh mã khi thêm dữ liệu mới
CREATE TRIGGER Tr_Generate_MaHD ON HoaDon
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HoaDon (Ma, NgayTao, TongTien, ID_NhanVien, ID_KhachHang, ID_Voucher)
    SELECT 
        COALESCE(Ma, 'HD' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        NgayTao, TongTien, ID_NhanVien, ID_KhachHang, ID_Voucher
    FROM inserted;
END
GO

--INSERT INTO [dbo].[NhanVien] ([Ma], [Passwords], [Ten], [SDT], [Email], [ChucVu], [TrangThai], [Luong],[NgaySinh],[DiaChi])
--VALUES

CREATE TRIGGER Tr_Generate_MaNV ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO NhanVien([Ma], [Passwords], [Ten], [SDT], [Email], [ChucVu], [TrangThai], [Luong],[NgaySinh],[DiaChi])
    SELECT 
        COALESCE(Ma, 'PH' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        [Passwords], [Ten], [SDT], [Email], [ChucVu], [TrangThai], [Luong],[NgaySinh],[DiaChi]
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaKH ON KhachHang
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO KhachHang(Ma, Ten, NgaySinh, GioiTinh, SDT)
    SELECT 
        COALESCE(Ma, 'KH' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Ten, NgaySinh, GioiTinh, SDT
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaSP ON SanPham
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SanPham(Ma, Ten, NgayThem, ID_ThuongHieu, ID_DanhMuc, ID_NhanVien)
    SELECT 
        COALESCE(Ma, 'SP' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Ten, NgayThem, ID_ThuongHieu, ID_DanhMuc, ID_NhanVien
    FROM inserted;
END
GO
--([Ma], [Ten], [NgayTao], [ID_NhanVien],[NgayBatDau], [NgayHetHan], [SoLuong], [KieuGiam],[GiaTri], [TrangThai])
CREATE TRIGGER Tr_Generate_MaVC ON Voucher
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    --INSERT INTO Voucher(Ma, Ten, NgayTao, ID_NhanVien)
	 INSERT INTO Voucher([Ma], [Ten], [NgayTao], [ID_NhanVien],[NgayBatDau], [NgayHetHan], [SoLuong], [KieuGiam],[GiaTri], [TrangThai])
    SELECT 
        COALESCE(Ma, 'VC' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        [Ten], [NgayTao], [ID_NhanVien],[NgayBatDau], [NgayHetHan], [SoLuong], [KieuGiam],[GiaTri], [TrangThai]
    FROM inserted;
END
GO

INSERT INTO [dbo].[Size] ([Ten]) 
VALUES  (N'35'),
		(N'36'),
		(N'37'),
		(N'38'),
		(N'39'),
		(N'40'),
		(N'41'),
		(N'42'),
		(N'43');
GO
--Dữ liệu MauSac
INSERT INTO [dbo].[MauSac] ([Ten]) 
VALUES  (N'Đỏ'),
		(N'Trắng'),
		(N'Đen'),
		(N'Hồng');
GO
--Dữ liệu ChatLieu
INSERT INTO [dbo].[ChatLieu] ([Ten]) 
VALUES  (N'Da'),
		(N'Vải');
GO

--Dữ liệu ThuongHieu
INSERT INTO [dbo].[ThuongHieu] ([Ten]) 
VALUES  (N'Nike'),
		(N'Puma'),
		(N'Asics'),
		(N'Balance'),
		(N'Adidas');
GO
--Dữ liệu DanhMuc
INSERT INTO [dbo].[DanhMuc] ([Ten]) 
VALUES  (N'Giày đôi'),
		(N'Giày nam'),
		(N'Giày nữ'),
		(N'Giày thể thao'),
		(N'Giày thời trang');
GO
--Dữ liệu KhachHang
INSERT INTO [dbo].[KhachHang]([Ma], [Ten], [NgaySinh], [GioiTinh], [SDT])
VALUES		(NULL, N'Vũ Văn Nguyên', '2004-11-20', 1, '0987234141'),
			(NULL, N'Chu Thị Ngân', '2004-11-20', 0, '0987234141'),
			(NULL, N'Nguyễn Văn Tèo', '2004-11-20', 1, '0987234141'),
			(NULL, N'Nguyễn Thúy Hằng', '2004-11-20', 0, '0987234141'),
			(NULL, N'Nguyễn Anh Dũng', '2004-11-20', 1, '0987234141');
GO
use DA1
--Dữ liệu nhân viên
select * from NhanVien
INSERT INTO [dbo].[NhanVien] ([Ma], [Passwords], [Ten], [SDT], [Email], [ChucVu], [TrangThai], [Luong],[NgaySinh],[DiaChi])
VALUES		('PH12345', '123', N'Nguyễn Thanh Tùng', '0367439572', 'tung123@gmail.com', 1, 1, 200000,'2004-11-11',N'Chùa Láng'),
			('PH36590', '123', N'Phạm Thanh Hiếu', '0123456789', 'ahieu5377@gmail.com', 1, 1, 200000,'2004-11-11',N'HN'),
			('PH36591', '123', N'Nguyễn Vãn Tèo', '0932432422', 'huyldph40152@fpt.edu.vn', 1, 1, 3500000,'2004-11-11',N'Nguyên Xá');
go
--Dữ liệu SanPham
select * from NhanVien
INSERT INTO [dbo].[SanPham] ([Ma], [Ten], [NgayThem], [ID_ThuongHieu], [ID_DanhMuc], [ID_NhanVien])
VALUES			(NULL, N'Giày Nike nam', DEFAULT, 1, 4, 1),
				(NULL, N'Giày Nike nữ', DEFAULT, 1, 2, 3),
				(NULL, N'Giày đôi', DEFAULT, 2, 3, 1),
				(NULL, N'Giày Thể thao Hàn Quốc', DEFAULT, 4, 1, 1),
				(NULL, N'Giày Thời trang nam', DEFAULT, 4, 2, 2);

GO

--dữ liệu sản phẩm chi tiết
INSERT INTO [dbo].[SanPhamChiTiet] ([Gia], [SoLuong], [MaSP], [TrangThai], [ID_SP], [ID_Size], ID_MauSac, ID_ChatLieu)
VALUES			(100, 50, 'SP86615', 1, 1, 1, 1, 1),
				(200, 50, 'SP24906', 1, 2, 2, 2, 2),
				(300, 50, 'SP13164', 1, 3, 3, 3, 1),
				(400, 50, 'SP81048', 1, 4, 2, 2, 2),
				(500, 50, 'SP08464', 1, 5, 2, 4, 2);
GO

--Dữ liệu Voucher
select *from SanPhamChiTiet
select * from NhanVien
INSERT INTO [dbo].[Voucher] ([Ma], [Ten], [NgayTao], [ID_NhanVien],[NgayBatDau], [NgayHetHan], [SoLuong], [KieuGiam],[GiaTri], [TrangThai])
VALUES			(NULL, N'Giảm giá 8/4', DEFAULT, 1,'2023-10-20', '2023-10-25', 100, 1, 20, 1),
				(NULL, N'Giảm giá 20/11', DEFAULT, 3,'2023-10-20', '2023-10-25', 100, 1, 10, 1),
				(NULL, N'Giảm giá Halloween', DEFAULT, 1, '2023-10-20', '2023-10-25', 100, 0, 40,0),
				(NULL, N'Giảm giá Valentine', DEFAULT, 2, '2023-10-20', '2023-10-25', 100, 1,15, 1),
				('VCTET', N'Giảm giá Tết', DEFAULT, 2, '2023-10-20', '2023-10-25', 100, 1,10,  0);



--Dữ liệu HoaDon
select * from HoaDon
INSERT INTO [dbo].[HoaDon] ([Ma], [NgayTao], [TongTien], TrangThai, ID_NhanVien, ID_KhachHang, ID_Voucher)
VALUES			(NULL, DEFAULT, 0, 1, 1, 1,1)

--Dữ liệu HDCT
INSERT INTO [dbo].[HoaDonChiTiet] ([GiaBan], [SoLuongSP], [TongTien], [ID_SanPhamCT], [ID_HoaDon], [ID_Voucher])
VALUES			(100, 2, 200, 4, 1, 1),
