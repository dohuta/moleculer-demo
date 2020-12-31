-- Drop the database 'Moleshop'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.
-- ALTER DATABASE Moleshop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
    SELECT [name]
FROM sys.databases
WHERE [name] = N'Moleshop'
)
DROP DATABASE Moleshop
GO

-- Create a new database called 'Moleshop'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
FROM sys.databases
WHERE [name] = N'Moleshop'
)
CREATE DATABASE Moleshop
GO

USE Moleshop
GO

CREATE TABLE [Permission]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(20) UNIQUE NOT NULL,
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT permission_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Role]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(20) UNIQUE NOT NULL,
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT role_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Role_Permission]
(
  [role_id] INT NOT NULL,
  [permission_id] INT NOT NULL
    PRIMARY KEY ([role_id], [permission_id])
)
GO

CREATE TABLE [Assignment]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [user] INT NOT NULL,
  [role] INT NOT NULL,
  [createdAt] DATETIME2(3) CONSTRAINT assignment_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [User]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [phone] NVARCHAR(20) UNIQUE NOT NULL,
  [password] NVARCHAR(255),
  [full_name] NVARCHAR(255),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT user_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Address]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] INT NOT NULL,
  [address_line_1] NVARCHAR(511),
  [address_line_2] NVARCHAR(511),
  [ward_add] INT,
  [district_add] INT,
  [city_add] INT,
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT address_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Ward]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(64),
  [district_ward] INT,
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT ward_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [District]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(64),
  [city_dist] INT,
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT district_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [City]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(64),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT city_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Orderline]
(
  [_version] INT DEFAULT (1),
  [order_id] INT NOT NULL,
  [product_variant_id] INT NOT NULL,
  [quantity] INT DEFAULT (1),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT orderline_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Order]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] INT NOT NULL,
  [status] NVARCHAR(20) NOT NULL CHECK ([status] IN ('WAITING', 'PACKAGING', 'DELIVERING', 'DELIVERED', 'CANCELLED')),
  [paid] BIT DEFAULT(0),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT order_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Product_Variant]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [product_id] INT NOT NULL,
  [name] NVARCHAR(511),
  [price] INT,
  [in_stock] INT,
  [status] NVARCHAR(20) NOT NULL CHECK ([status] IN ('OUT_OF_STOCK', 'IN_STOCK', 'RUNNING_LOW')),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT productsVariant_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Product]
(
  [_version] INT DEFAULT (1),
  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(511),
  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT product_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

CREATE TABLE [Product_Media]
(
  [product_id] INT NOT NULL,
  [media_id] INT NOT NULL,
  PRIMARY KEY ([product_id], [media_id])
)
GO


CREATE TABLE [Media]
(
  [_version] INT DEFAULT (1),

  [id] INT PRIMARY KEY IDENTITY(1, 1),
  [name] NVARCHAR(511),
  [uri] NVARCHAR(MAX),
  [ext] NVARCHAR(4),
  [mime] NVARCHAR(63),
  [size] INT,
  [hash] NVARCHAR(MAX),
  [sha256] NVARCHAR(MAX),

  [deletedAt] DATETIME2(3),
  [createdAt] DATETIME2(3) CONSTRAINT media_createdAt DEFAULT (SYSDATETIME()),
  [updatedAt] DATETIME2(3)
)
GO

ALTER TABLE [District] ADD CONSTRAINT FK_district_city FOREIGN KEY ([city_dist]) REFERENCES [City] ([id]) ON DELETE SET NULL
GO

ALTER TABLE [Ward] ADD CONSTRAINT FK_ward_district FOREIGN KEY ([district_ward]) REFERENCES [District] ([id]) ON DELETE SET NULL
GO

ALTER TABLE [Address] ADD CONSTRAINT FK_address_user FOREIGN KEY ([user_id]) REFERENCES [User] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Address] ADD CONSTRAINT FK_address_ward FOREIGN KEY ([ward_add]) REFERENCES [Ward] ([id]) ON DELETE SET NULL
GO

ALTER TABLE [Address] ADD CONSTRAINT FK_address_district FOREIGN KEY ([district_add]) REFERENCES [District] ([id]) ON DELETE SET NULL
GO

ALTER TABLE [Address] ADD CONSTRAINT FK_addresses_citites FOREIGN KEY ([city_add]) REFERENCES [City] ([id]) ON DELETE SET NULL
GO

ALTER TABLE [Order] ADD CONSTRAINT FK_order_user FOREIGN KEY ([user_id]) REFERENCES [User] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Product_Variant] ADD CONSTRAINT FK_product_variant_product FOREIGN KEY ([product_id]) REFERENCES [Product] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Orderline] ADD CONSTRAINT FK_orderline_product_variant FOREIGN KEY ([product_variant_id]) REFERENCES [Product_Variant] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Orderline] ADD CONSTRAINT FK_Orderline_Order FOREIGN KEY ([order_id]) REFERENCES [Order] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Product_Media] ADD CONSTRAINT FK_product_media_product FOREIGN KEY ([product_id]) REFERENCES [Product] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Product_Media] ADD CONSTRAINT FK_product_media_media FOREIGN KEY ([media_id]) REFERENCES [media] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Role_Permission] ADD CONSTRAINT FK_role_permission_role FOREIGN KEY ([role_id]) REFERENCES [role] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Role_Permission] ADD CONSTRAINT FK_Role_Permission_Permission FOREIGN KEY ([permission_id]) REFERENCES [Permission] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Assignment] ADD CONSTRAINT FK_Assignments_User FOREIGN KEY ([user]) REFERENCES [User] ([id]) ON DELETE CASCADE
GO

ALTER TABLE [Assignment] ADD CONSTRAINT FK_Assignments_Role FOREIGN KEY ([Role]) REFERENCES [Role] ([id]) ON DELETE CASCADE
GO

SET IDENTITY_INSERT [City] ON
GO

INSERT INTO City
  ( id, name )
VALUES
  ( 92, N'Cần Thơ' ),
  ( 95, N'Bạc Liêu' ),
  ( 27, N'Bắc Ninh' ),
  ( 83, N'Bến Tre' ),
  ( 52, N'Bình Định' ),
  ( 74, N'Bình Dương' ),
  ( 70, N'Bình Phước' ),
  ( 60, N'Bình Thuận' ),
  ( 96, N'Cà Mau' ),
  ( 04, N'Cao Bằng' ),
  ( 66, N'Đắk Lắk' ),
  ( 48, N'Đà Nẵng' ),
  ( 67, N'Đắk Nông' ),
  ( 11, N'Điện Biên' ),
  ( 75, N'Đồng Nai' ),
  ( 87, N'Đồng Tháp' ),
  ( 64, N'Gia Lai' ),
  ( 02, N'Hà Giang' ),
  ( 35, N'Hà Nam' ),
  ( 42, N'Hà Tĩnh' ),
  ( 30, N'Hải Dương' ),
  ( 93, N'Hậu Giang' ),
  ( 01, N'Hà Nội' ),
  ( 17, N'Hoà Bình' ),
  ( 33, N'Hưng Yên' ),
  ( 56, N'Khánh Hòa' ),
  ( 91, N'Kiên Giang' ),
  ( 62, N'Kon Tum' ),
  ( 12, N'Lai Châu' ),
  ( 68, N'Lâm Đồng' ),
  ( 20, N'Lạng Sơn' ),
  ( 10, N'Lào Cai' ),
  ( 80, N'Long An' ),
  ( 31, N'Hải Phòng' ),
  ( 36, N'Nam Định' ),
  ( 40, N'Nghệ An' ),
  ( 37, N'Ninh Bình' ),
  ( 58, N'Ninh Thuận' ),
  ( 25, N'Phú Thọ' ),
  ( 54, N'Phú Yên' ),
  ( 44, N'Quảng Bình' ),
  ( 49, N'Quảng Nam' ),
  ( 51, N'Quảng Ngãi' ),
  ( 22, N'Quảng Ninh' ),
  ( 79, N'Hồ Chí Minh' ),
  ( 45, N'Quảng Trị' ),
  ( 94, N'Sóc Trăng' ),
  ( 14, N'Sơn La' ),
  ( 72, N'Tây Ninh' ),
  ( 34, N'Thái Bình' ),
  ( 19, N'Thái Nguyên' ),
  ( 38, N'Thanh Hóa' ),
  ( 46, N'Thừa Thiên Huế' ),
  ( 82, N'Tiền Giang' ),
  ( 84, N'Trà Vinh' ),
  ( 89, N'An Giang' ),
  ( 08, N'Tuyên Quang' ),
  ( 86, N'Vĩnh Long' ),
  ( 26, N'Vĩnh Phúc' ),
  ( 15, N'Yên Bái' ),
  ( 77, N'Bà Rịa - Vũng Tàu' ),
  ( 24, N'Bắc Giang' ),
  ( 06, N'Bắc Kạn' )
GO

SET IDENTITY_INSERT [City] OFF
GO
SET IDENTITY_INSERT [District] ON
GO

INSERT INTO District
  ( id, name, city_dist )
VALUES
  (916, N'Ninh Kiều', 92 ),
  (917, N'Ô Môn', 92 ),
  (918, N'Bình Thuỷ', 92 ),
  (919, N'Cái Răng', 92 ),
  (923, N'Thốt Nốt', 92 ),
  (924, N'Vĩnh Thạnh', 92 ),
  (925, N'Cờ Đỏ', 92 ),
  (926, N'Phong Điền', 92 ),
  (927, N'Thới Lai', 92 ),
  (954, N'Bạc Liêu', 95 ),
  (956, N'Hồng Dân', 95 ),
  (957, N'Phước Long', 95 ),
  (958, N'Vĩnh Lợi', 95 ),
  (959, N'Giá Rai', 95 ),
  (960, N'Đông Hải', 95 ),
  (961, N'Hoà Bình', 95 ),
  (256, N'Bắc Ninh', 27 ),
  (258, N'Yên Phong', 27 ),
  (259, N'Quế Võ', 27 ),
  (260, N'Tiên Du', 27 ),
  (261, N'Từ Sơn', 27 ),
  (262, N'Thuận Thành', 27 ),
  (263, N'Gia Bình', 27 ),
  (264, N'Lương Tài', 27 ),
  (829, N'Bến Tre', 83 ),
  (831, N'Châu Thành', 83 ),
  (832, N'Chợ Lách', 83 ),
  (833, N'Mỏ Cày Nam', 83 ),
  (834, N'Giồng Trôm', 83 ),
  (835, N'Bình Đại', 83 ),
  (836, N'Ba Tri', 83 ),
  (837, N'Thạnh Phú', 83 ),
  (838, N'Mỏ Cày Bắc', 83 ),
  (540, N'Qui Nhơn', 52 ),
  (542, N'An Lão', 52 ),
  (543, N'Hoài Nhơn', 52 ),
  (544, N'Hoài Ân', 52 ),
  (545, N'Phù Mỹ', 52 ),
  (546, N'Vĩnh Thạnh', 52 ),
  (547, N'Tây Sơn', 52 ),
  (548, N'Phù Cát', 52 ),
  (549, N'An Nhơn', 52 ),
  (550, N'Tuy Phước', 52 ),
  (551, N'Vân Canh', 52 ),
  (718, N'Thủ Dầu Một', 74 ),
  (719, N'Bàu Bàng', 74 ),
  (720, N'Dầu Tiếng', 74 ),
  (721, N'Bến Cát', 74 ),
  (722, N'Phú Giáo', 74 ),
  (723, N'Tân Uyên', 74 ),
  (724, N'Dĩ An', 74 ),
  (725, N'Thuận An', 74 ),
  (726, N'Bắc Tân Uyên', 74 ),
  (688, N'Phước Long', 70 ),
  (689, N'Đồng Xoài', 70 ),
  (690, N'Bình Long', 70 ),
  (691, N'Bù Gia Mập', 70 ),
  (692, N'Lộc Ninh', 70 ),
  (693, N'Bù Đốp', 70 ),
  (694, N'Hớn Quản', 70 ),
  (695, N'Đồng Phú', 70 ),
  (696, N'Bù Đăng', 70 ),
  (697, N'Chơn Thành', 70 ),
  (698, N'Phú Riềng', 70 ),
  (593, N'Phan Thiết', 60 ),
  (594, N'La Gi', 60 ),
  (595, N'Tuy Phong', 60 ),
  (596, N'Bắc Bình', 60 ),
  (597, N'Hàm Thuận Bắc', 60 ),
  (598, N'Hàm Thuận Nam', 60 ),
  (599, N'Tánh Linh', 60 ),
  (600, N'Đức Linh', 60 ),
  (601, N'Hàm Tân', 60 ),
  (602, N'Phú Quí', 60 ),
  (964, N'Cà Mau', 96 ),
  (966, N'U Minh', 96 ),
  (967, N'Thới Bình', 96 ),
  (968, N'Trần Văn Thời', 96 ),
  (969, N'Cái Nước', 96 ),
  (970, N'Đầm Dơi', 96 ),
  (971, N'Năm Căn', 96 ),
  (972, N'Phú Tân', 96 ),
  (973, N'Ngọc Hiển', 96 ),
  (040, N'Cao Bằng', 04 ),
  (042, N'Bảo Lâm', 04 ),
  (043, N'Bảo Lạc', 04 ),
  (044, N'Thông Nông', 04 ),
  (045, N'Hà Quảng', 04 ),
  (046, N'Trà Lĩnh', 04 ),
  (047, N'Trùng Khánh', 04 ),
  (048, N'Hạ Lang', 04 ),
  (049, N'Quảng Uyên', 04 ),
  (050, N'Phục Hoà', 04 ),
  (051, N'Hoà An', 04 ),
  (052, N'Nguyên Bình', 04 ),
  (053, N'Thạch An', 04 ),
  (643, N'Buôn Ma Thuột', 66 ),
  (644, N'Buôn Hồ', 66 ),
  (645, N'Ea H''leo', 66 ),
  (646, N'Ea Súp', 66 ),
  (647, N'Buôn Đôn', 66 ),
  (648, N'Cư M''gar', 66 ),
  (649, N'Krông Búk', 66 ),
  (650, N'Krông Năng', 66 ),
  (651, N'Ea Kar', 66 ),
  (652, N'M''Đrắk', 66 ),
  (653, N'Krông Bông', 66 ),
  (654, N'Krông Pắc', 66 ),
  (655, N'Krông A Na', 66 ),
  (656, N'Lắk', 66 ),
  (657, N'Cư Kuin', 66 ),
  (490, N'Liên Chiểu', 48 ),
  (491, N'Thanh Khê', 48 ),
  (492, N'Hải Châu', 48 ),
  (493, N'Sơn Trà', 48 ),
  (494, N'Ngũ Hành Sơn', 48 ),
  (495, N'Cẩm Lệ', 48 ),
  (497, N'Hòa Vang', 48 ),
  (660, N'Gia Nghĩa', 67 ),
  (661, N'Đăk Glong', 67 ),
  (662, N'Cư Jút', 67 ),
  (663, N'Đắk Mil', 67 ),
  (664, N'Krông Nô', 67 ),
  (665, N'Đắk Song', 67 ),
  (666, N'Đắk R''Lấp', 67 ),
  (667, N'Tuy Đức', 67 ),
  (094, N'Điện Biên Phủ', 11 ),
  (095, N'Mường Lay', 11 ),
  (096, N'Mường Nhé', 11 ),
  (097, N'Mường Chà', 11 ),
  (098, N'Tủa Chùa', 11 ),
  (099, N'Tuần Giáo', 11 ),
  (100, N'Điện Biên', 11 ),
  (101, N'Điện Biên Đông', 11 ),
  (102, N'Mường Ảng', 11 ),
  (103, N'Nậm Pồ', 11 ),
  (731, N'Biên Hòa', 75 ),
  (732, N'Long Khánh', 75 ),
  (734, N'Tân Phú', 75 ),
  (735, N'Vĩnh Cửu', 75 ),
  (736, N'Định Quán', 75 ),
  (737, N'Trảng Bom', 75 ),
  (738, N'Thống Nhất', 75 ),
  (739, N'Cẩm Mỹ', 75 ),
  (740, N'Long Thành', 75 ),
  (741, N'Xuân Lộc', 75 ),
  (742, N'Nhơn Trạch', 75 ),
  (866, N'Cao Lãnh', 87 ),
  (867, N'Sa Đéc', 87 ),
  (868, N'Hồng Ngự', 87 ),
  (869, N'Tân Hồng', 87 ),
  (870, N'Hồng Ngự', 87 ),
  (871, N'Tam Nông', 87 ),
  (872, N'Tháp Mười', 87 ),
  (873, N'Cao Lãnh', 87 ),
  (874, N'Thanh Bình', 87 ),
  (875, N'Lấp Vò', 87 ),
  (876, N'Lai Vung', 87 ),
  (877, N'Châu Thành', 87 ),
  (622, N'Pleiku', 64 ),
  (623, N'An Khê', 64 ),
  (624, N'Ayun Pa', 64 ),
  (625, N'KBang', 64 ),
  (626, N'Đăk Đoa', 64 ),
  (627, N'Chư Păh', 64 ),
  (628, N'Ia Grai', 64 ),
  (629, N'Mang Yang', 64 ),
  (630, N'Kông Chro', 64 ),
  (631, N'Đức Cơ', 64 ),
  (632, N'Chư Prông', 64 ),
  (633, N'Chư Sê', 64 ),
  (634, N'Đăk Pơ', 64 ),
  (635, N'Ia Pa', 64 ),
  (637, N'Krông Pa', 64 ),
  (638, N'Phú Thiện', 64 ),
  (639, N'Chư Pưh', 64 ),
  (024, N'Hà Giang', 02 ),
  (026, N'Đồng Văn', 02 ),
  (027, N'Mèo Vạc', 02 ),
  (028, N'Yên Minh', 02 ),
  (029, N'Quản Bạ', 02 ),
  (030, N'Vị Xuyên', 02 ),
  (031, N'Bắc Mê', 02 ),
  (032, N'Hoàng Su Phì', 02 ),
  (033, N'Xín Mần', 02 ),
  (034, N'Bắc Quang', 02 ),
  (035, N'Quang Bình', 02 ),
  (347, N'Phủ Lý', 35 ),
  (349, N'Duy Tiên', 35 ),
  (350, N'Kim Bảng', 35 ),
  (351, N'Thanh Liêm', 35 ),
  (352, N'Bình Lục', 35 ),
  (353, N'Lý Nhân', 35 ),
  (436, N'Hà Tĩnh', 42 ),
  (437, N'Hồng Lĩnh', 42 ),
  (439, N'Hương Sơn', 42 ),
  (440, N'Đức Thọ', 42 ),
  (441, N'Vũ Quang', 42 ),
  (442, N'Nghi Xuân', 42 ),
  (443, N'Can Lộc', 42 ),
  (444, N'Hương Khê', 42 ),
  (445, N'Thạch Hà', 42 ),
  (446, N'Cẩm Xuyên', 42 ),
  (447, N'Kỳ Anh', 42 ),
  (448, N'Lộc Hà', 42 ),
  (449, N'Kỳ Anh', 42 ),
  (288, N'Hải Dương', 30 ),
  (290, N'Chí Linh', 30 ),
  (291, N'Nam Sách', 30 ),
  (292, N'Kinh Môn', 30 ),
  (293, N'Kim Thành', 30 ),
  (294, N'Thanh Hà', 30 ),
  (295, N'Cẩm Giàng', 30 ),
  (296, N'Bình Giang', 30 ),
  (297, N'Gia Lộc', 30 ),
  (298, N'Tứ Kỳ', 30 ),
  (299, N'Ninh Giang', 30 ),
  (300, N'Thanh Miện', 30 ),
  (930, N'Vị Thanh', 93 ),
  (931, N'Ngã Bảy', 93 ),
  (932, N'Châu Thành A', 93 ),
  (933, N'Châu Thành', 93 ),
  (934, N'Phụng Hiệp', 93 ),
  (935, N'Vị Thuỷ', 93 ),
  (936, N'Long Mỹ', 93 ),
  (937, N'Long Mỹ', 93 ),
  (001, N'Ba Đình', 01 ),
  (002, N'Hoàn Kiếm', 01 ),
  (003, N'Tây Hồ', 01 ),
  (004, N'Long Biên', 01 ),
  (005, N'Cầu Giấy', 01 ),
  (006, N'Đống Đa', 01 ),
  (007, N'Hai Bà Trưng', 01 ),
  (008, N'Hoàng Mai', 01 ),
  (009, N'Thanh Xuân', 01 ),
  (016, N'Sóc Sơn', 01 ),
  (017, N'Đông Anh', 01 ),
  (018, N'Gia Lâm', 01 ),
  (019, N'Nam Từ Liêm', 01 ),
  (020, N'Thanh Trì', 01 ),
  (021, N'Bắc Từ Liêm', 01 ),
  (250, N'Mê Linh', 01 ),
  (268, N'Hà Đông', 01 ),
  (269, N'Sơn Tây', 01 ),
  (271, N'Ba Vì', 01 ),
  (272, N'Phúc Thọ', 01 ),
  (273, N'Đan Phượng', 01 ),
  (274, N'Hoài Đức', 01 ),
  (275, N'Quốc Oai', 01 ),
  (276, N'Thạch Thất', 01 ),
  (277, N'Chương Mỹ', 01 ),
  (278, N'Thanh Oai', 01 ),
  (279, N'Thường Tín', 01 ),
  (280, N'Phú Xuyên', 01 ),
  (281, N'Ứng Hòa', 01 ),
  (282, N'Mỹ Đức', 01 ),
  (148, N'Hòa Bình', 17 ),
  (150, N'Đà Bắc', 17 ),
  (152, N'Lương Sơn', 17 ),
  (153, N'Kim Bôi', 17 ),
  (154, N'Cao Phong', 17 ),
  (155, N'Tân Lạc', 17 ),
  (156, N'Mai Châu', 17 ),
  (157, N'Lạc Sơn', 17 ),
  (158, N'Yên Thủy', 17 ),
  (159, N'Lạc Thủy', 17 ),
  (323, N'Hưng Yên', 33 ),
  (325, N'Văn Lâm', 33 ),
  (326, N'Văn Giang', 33 ),
  (327, N'Yên Mỹ', 33 ),
  (328, N'Mỹ Hào', 33 ),
  (329, N'Ân Thi', 33 ),
  (330, N'Khoái Châu', 33 ),
  (331, N'Kim Động', 33 ),
  (332, N'Tiên Lữ', 33 ),
  (333, N'Phù Cừ', 33 ),
  (568, N'Nha Trang', 56 ),
  (569, N'Cam Ranh', 56 ),
  (570, N'Cam Lâm', 56 ),
  (571, N'Vạn Ninh', 56 ),
  (572, N'Ninh Hòa', 56 ),
  (573, N'Khánh Vĩnh', 56 ),
  (574, N'Diên Khánh', 56 ),
  (575, N'Khánh Sơn', 56 ),
  (576, N'Trường Sa', 56 ),
  (899, N'Rạch Giá', 91 ),
  (900, N'Hà Tiên', 91 ),
  (902, N'Kiên Lương', 91 ),
  (903, N'Hòn Đất', 91 ),
  (904, N'Tân Hiệp', 91 ),
  (905, N'Châu Thành', 91 ),
  (906, N'Giồng Riềng', 91 ),
  (907, N'Gò Quao', 91 ),
  (908, N'An Biên', 91 ),
  (909, N'An Minh', 91 ),
  (910, N'Vĩnh Thuận', 91 ),
  (911, N'Phú Quốc', 91 ),
  (912, N'Kiên Hải', 91 ),
  (913, N'U Minh Thượng', 91 ),
  (914, N'Giang Thành', 91 ),
  (608, N'Kon Tum', 62 ),
  (610, N'Đắk Glei', 62 ),
  (611, N'Ngọc Hồi', 62 ),
  (612, N'Đắk Tô', 62 ),
  (613, N'Kon Plông', 62 ),
  (614, N'Kon Rẫy', 62 ),
  (615, N'Đắk Hà', 62 ),
  (616, N'Sa Thầy', 62 ),
  (617, N'Tu Mơ Rông', 62 ),
  (618, N'Ia H'' Drai', 62 ),
  (105, N'Lai Châu', 12 ),
  (106, N'Tam Đường', 12 ),
  (107, N'Mường Tè', 12 ),
  (108, N'Sìn Hồ', 12 ),
  (109, N'Phong Thổ', 12 ),
  (110, N'Than Uyên', 12 ),
  (111, N'Tân Uyên', 12 ),
  (112, N'Nậm Nhùn', 12 ),
  (672, N'Đà Lạt', 68 ),
  (673, N'Bảo Lộc', 68 ),
  (674, N'Đam Rông', 68 ),
  (675, N'Lạc Dương', 68 ),
  (676, N'Lâm Hà', 68 ),
  (677, N'Đơn Dương', 68 ),
  (678, N'Đức Trọng', 68 ),
  (679, N'Di Linh', 68 ),
  (680, N'Bảo Lâm', 68 ),
  (681, N'Đạ Huoai', 68 ),
  (682, N'Đạ Tẻh', 68 ),
  (683, N'Cát Tiên', 68 ),
  (178, N'Lạng Sơn', 20 ),
  (180, N'Tràng Định', 20 ),
  (181, N'Bình Gia', 20 ),
  (182, N'Văn Lãng', 20 ),
  (183, N'Cao Lộc', 20 ),
  (184, N'Văn Quan', 20 ),
  (185, N'Bắc Sơn', 20 ),
  (186, N'Hữu Lũng', 20 ),
  (187, N'Chi Lăng', 20 ),
  (188, N'Lộc Bình', 20 ),
  (189, N'Đình Lập', 20 ),
  (080, N'Lào Cai', 10 ),
  (082, N'Bát Xát', 10 ),
  (083, N'Mường Khương', 10 ),
  (084, N'Si Ma Cai', 10 ),
  (085, N'Bắc Hà', 10 ),
  (086, N'Bảo Thắng', 10 ),
  (087, N'Bảo Yên', 10 ),
  (088, N'Sa Pa', 10 ),
  (089, N'Văn Bàn', 10 ),
  (794, N'Tân An', 80 ),
  (795, N'Kiến Tường', 80 ),
  (796, N'Tân Hưng', 80 ),
  (797, N'Vĩnh Hưng', 80 ),
  (798, N'Mộc Hóa', 80 ),
  (799, N'Tân Thạnh', 80 ),
  (800, N'Thạnh Hóa', 80 ),
  (801, N'Đức Huệ', 80 ),
  (802, N'Đức Hòa', 80 ),
  (803, N'Bến Lức', 80 ),
  (804, N'Thủ Thừa', 80 ),
  (805, N'Tân Trụ', 80 ),
  (806, N'Cần Đước', 80 ),
  (807, N'Cần Giuộc', 80 ),
  (808, N'Châu Thành', 80 ),
  (303, N'Hồng Bàng', 31 ),
  (304, N'Ngô Quyền', 31 ),
  (305, N'Lê Chân', 31 ),
  (306, N'Hải An', 31 ),
  (307, N'Kiến An', 31 ),
  (308, N'Đồ Sơn', 31 ),
  (309, N'Dương Kinh', 31 ),
  (311, N'Thuỷ Nguyên', 31 ),
  (312, N'An Dương', 31 ),
  (313, N'An Lão', 31 ),
  (314, N'Kiến Thuỵ', 31 ),
  (315, N'Tiên Lãng', 31 ),
  (316, N'Vĩnh Bảo', 31 ),
  (317, N'Cát Hải', 31 ),
  (356, N'Nam Định', 36 ),
  (358, N'Mỹ Lộc', 36 ),
  (359, N'Vụ Bản', 36 ),
  (360, N'Ý Yên', 36 ),
  (361, N'Nghĩa Hưng', 36 ),
  (362, N'Nam Trực', 36 ),
  (363, N'Trực Ninh', 36 ),
  (364, N'Xuân Trường', 36 ),
  (365, N'Giao Thủy', 36 ),
  (366, N'Hải Hậu', 36 ),
  (412, N'Vinh', 40 ),
  (413, N'Cửa Lò', 40 ),
  (414, N'Thái Hoà', 40 ),
  (415, N'Quế Phong', 40 ),
  (416, N'Quỳ Châu', 40 ),
  (417, N'Kỳ Sơn', 40 ),
  (418, N'Tương Dương', 40 ),
  (419, N'Nghĩa Đàn', 40 ),
  (420, N'Quỳ Hợp', 40 ),
  (421, N'Quỳnh Lưu', 40 ),
  (422, N'Con Cuông', 40 ),
  (423, N'Tân Kỳ', 40 ),
  (424, N'Anh Sơn', 40 ),
  (425, N'Diễn Châu', 40 ),
  (426, N'Yên Thành', 40 ),
  (427, N'Đô Lương', 40 ),
  (428, N'Thanh Chương', 40 ),
  (429, N'Nghi Lộc', 40 ),
  (430, N'Nam Đàn', 40 ),
  (431, N'Hưng Nguyên', 40 ),
  (432, N'Hoàng Mai', 40 ),
  (369, N'Ninh Bình', 37 ),
  (370, N'Tam Điệp', 37 ),
  (372, N'Nho Quan', 37 ),
  (373, N'Gia Viễn', 37 ),
  (374, N'Hoa Lư', 37 ),
  (375, N'Yên Khánh', 37 ),
  (376, N'Kim Sơn', 37 ),
  (377, N'Yên Mô', 37 ),
  (582, N'Phan Rang-Tháp Chàm', 58 ),
  (584, N'Bác Ái', 58 ),
  (585, N'Ninh Sơn', 58 ),
  (586, N'Ninh Hải', 58 ),
  (587, N'Ninh Phước', 58 ),
  (588, N'Thuận Bắc', 58 ),
  (589, N'Thuận Nam', 58 ),
  (227, N'Việt Trì', 25 ),
  (228, N'Phú Thọ', 25 ),
  (230, N'Đoan Hùng', 25 ),
  (231, N'Hạ Hoà', 25 ),
  (232, N'Thanh Ba', 25 ),
  (233, N'Phù Ninh', 25 ),
  (234, N'Yên Lập', 25 ),
  (235, N'Cẩm Khê', 25 ),
  (236, N'Tam Nông', 25 ),
  (237, N'Lâm Thao', 25 ),
  (238, N'Thanh Sơn', 25 ),
  (239, N'Thanh Thuỷ', 25 ),
  (240, N'Tân Sơn', 25 ),
  (555, N'Tuy Hoà', 54 ),
  (557, N'Sông Cầu', 54 ),
  (558, N'Đồng Xuân', 54 ),
  (559, N'Tuy An', 54 ),
  (560, N'Sơn Hòa', 54 ),
  (561, N'Sông Hinh', 54 ),
  (562, N'Tây Hoà', 54 ),
  (563, N'Phú Hoà', 54 ),
  (564, N'Đông Hòa', 54 ),
  (450, N'Đồng Hới', 44 ),
  (452, N'Minh Hóa', 44 ),
  (453, N'Tuyên Hóa', 44 ),
  (454, N'Quảng Trạch', 44 ),
  (455, N'Bố Trạch', 44 ),
  (456, N'Quảng Ninh', 44 ),
  (457, N'Lệ Thủy', 44 ),
  (458, N'Ba Đồn', 44 ),
  (502, N'Tam Kỳ', 49 ),
  (503, N'Hội An', 49 ),
  (504, N'Tây Giang', 49 ),
  (505, N'Đông Giang', 49 ),
  (506, N'Đại Lộc', 49 ),
  (507, N'Điện Bàn', 49 ),
  (508, N'Duy Xuyên', 49 ),
  (509, N'Quế Sơn', 49 ),
  (510, N'Nam Giang', 49 ),
  (511, N'Phước Sơn', 49 ),
  (512, N'Hiệp Đức', 49 ),
  (513, N'Thăng Bình', 49 ),
  (514, N'Tiên Phước', 49 ),
  (515, N'Bắc Trà My', 49 ),
  (516, N'Nam Trà My', 49 ),
  (517, N'Núi Thành', 49 ),
  (518, N'Phú Ninh', 49 ),
  (519, N'Nông Sơn', 49 ),
  (522, N'Quảng Ngãi', 51 ),
  (524, N'Bình Sơn', 51 ),
  (525, N'Trà Bồng', 51 ),
  (526, N'Tây Trà', 51 ),
  (527, N'Sơn Tịnh', 51 ),
  (528, N'Tư Nghĩa', 51 ),
  (529, N'Sơn Hà', 51 ),
  (530, N'Sơn Tây', 51 ),
  (531, N'Minh Long', 51 ),
  (532, N'Nghĩa Hành', 51 ),
  (533, N'Mộ Đức', 51 ),
  (534, N'Đức Phổ', 51 ),
  (535, N'Ba Tơ', 51 ),
  (536, N'Lý Sơn', 51 ),
  (193, N'Hạ Long', 22 ),
  (194, N'Móng Cái', 22 ),
  (195, N'Cẩm Phả', 22 ),
  (196, N'Uông Bí', 22 ),
  (198, N'Bình Liêu', 22 ),
  (199, N'Tiên Yên', 22 ),
  (200, N'Đầm Hà', 22 ),
  (201, N'Hải Hà', 22 ),
  (202, N'Ba Chẽ', 22 ),
  (203, N'Vân Đồn', 22 ),
  (205, N'Đông Triều', 22 ),
  (206, N'Quảng Yên', 22 ),
  (207, N'Cô Tô', 22 ),
  (760, N'1', 79 ),
  (761, N'12', 79 ),
  (762, N'Thủ Đức', 79 ),
  (763, N'9', 79 ),
  (764, N'Gò Vấp', 79 ),
  (765, N'Bình Thạnh', 79 ),
  (766, N'Tân Bình', 79 ),
  (767, N'Tân Phú', 79 ),
  (768, N'Phú Nhuận', 79 ),
  (769, N'2', 79 ),
  (770, N'3', 79 ),
  (771, N'10', 79 ),
  (772, N'11', 79 ),
  (773, N'4', 79 ),
  (774, N'5', 79 ),
  (775, N'6', 79 ),
  (776, N'8', 79 ),
  (777, N'Bình Tân', 79 ),
  (778, N'7', 79 ),
  (783, N'Củ Chi', 79 ),
  (784, N'Hóc Môn', 79 ),
  (785, N'Bình Chánh', 79 ),
  (786, N'Nhà Bè', 79 ),
  (787, N'Cần Giờ', 79 ),
  (461, N'Đông Hà', 45 ),
  (462, N'Quảng Trị', 45 ),
  (464, N'Vĩnh Linh', 45 ),
  (465, N'Hướng Hóa', 45 ),
  (466, N'Gio Linh', 45 ),
  (467, N'Đa Krông', 45 ),
  (468, N'Cam Lộ', 45 ),
  (469, N'Triệu Phong', 45 ),
  (470, N'Hải Lăng', 45 ),
  (941, N'Sóc Trăng', 94 ),
  (942, N'Châu Thành', 94 ),
  (943, N'Kế Sách', 94 ),
  (944, N'Mỹ Tú', 94 ),
  (945, N'Cù Lao Dung', 94 ),
  (946, N'Long Phú', 94 ),
  (947, N'Mỹ Xuyên', 94 ),
  (948, N'Ngã Năm', 94 ),
  (949, N'Thạnh Trị', 94 ),
  (950, N'Vĩnh Châu', 94 ),
  (951, N'Trần Đề', 94 ),
  (116, N'Sơn La', 14 ),
  (118, N'Quỳnh Nhai', 14 ),
  (119, N'Thuận Châu', 14 ),
  (120, N'Mường La', 14 ),
  (121, N'Bắc Yên', 14 ),
  (122, N'Phù Yên', 14 ),
  (123, N'Mộc Châu', 14 ),
  (124, N'Yên Châu', 14 ),
  (125, N'Mai Sơn', 14 ),
  (126, N'Sông Mã', 14 ),
  (127, N'Sốp Cộp', 14 ),
  (128, N'Vân Hồ', 14 ),
  (703, N'Tây Ninh', 72 ),
  (705, N'Tân Biên', 72 ),
  (706, N'Tân Châu', 72 ),
  (707, N'Dương Minh Châu', 72 ),
  (708, N'Châu Thành', 72 ),
  (709, N'Hòa Thành', 72 ),
  (710, N'Gò Dầu', 72 ),
  (711, N'Bến Cầu', 72 ),
  (712, N'Trảng Bàng', 72 ),
  (336, N'Thái Bình', 34 ),
  (338, N'Quỳnh Phụ', 34 ),
  (339, N'Hưng Hà', 34 ),
  (340, N'Đông Hưng', 34 ),
  (341, N'Thái Thụy', 34 ),
  (342, N'Tiền Hải', 34 ),
  (343, N'Kiến Xương', 34 ),
  (344, N'Vũ Thư', 34 ),
  (164, N'Thái Nguyên', 19 ),
  (165, N'Sông Công', 19 ),
  (167, N'Định Hóa', 19 ),
  (168, N'Phú Lương', 19 ),
  (169, N'Đồng Hỷ', 19 ),
  (170, N'Võ Nhai', 19 ),
  (171, N'Đại Từ', 19 ),
  (172, N'Phổ Yên', 19 ),
  (173, N'Phú Bình', 19 ),
  (380, N'Thanh Hóa', 38 ),
  (381, N'Bỉm Sơn', 38 ),
  (382, N'Sầm Sơn', 38 ),
  (384, N'Mường Lát', 38 ),
  (385, N'Quan Hóa', 38 ),
  (386, N'Bá Thước', 38 ),
  (387, N'Quan Sơn', 38 ),
  (388, N'Lang Chánh', 38 ),
  (389, N'Ngọc Lặc', 38 ),
  (390, N'Cẩm Thủy', 38 ),
  (391, N'Thạch Thành', 38 ),
  (392, N'Hà Trung', 38 ),
  (393, N'Vĩnh Lộc', 38 ),
  (394, N'Yên Định', 38 ),
  (395, N'Thọ Xuân', 38 ),
  (396, N'Thường Xuân', 38 ),
  (397, N'Triệu Sơn', 38 ),
  (398, N'Thiệu Hóa', 38 ),
  (399, N'Hoằng Hóa', 38 ),
  (400, N'Hậu Lộc', 38 ),
  (401, N'Nga Sơn', 38 ),
  (402, N'Như Xuân', 38 ),
  (403, N'Như Thanh', 38 ),
  (404, N'Nông Cống', 38 ),
  (405, N'Đông Sơn', 38 ),
  (406, N'Quảng Xương', 38 ),
  (407, N'Tĩnh Gia', 38 ),
  (474, N'Huế', 46 ),
  (476, N'Phong Điền', 46 ),
  (477, N'Quảng Điền', 46 ),
  (478, N'Phú Vang', 46 ),
  (479, N'Hương Thủy', 46 ),
  (480, N'Hương Trà', 46 ),
  (481, N'A Lưới', 46 ),
  (482, N'Phú Lộc', 46 ),
  (483, N'Nam Đông', 46 ),
  (815, N'Mỹ Tho', 82 ),
  (816, N'Gò Công', 82 ),
  (817, N'Cai Lậy', 82 ),
  (818, N'Tân Phước', 82 ),
  (819, N'Cái Bè', 82 ),
  (820, N'Cai Lậy', 82 ),
  (821, N'Châu Thành', 82 ),
  (822, N'Chợ Gạo', 82 ),
  (823, N'Gò Công Tây', 82 ),
  (824, N'Gò Công Đông', 82 ),
  (825, N'Tân Phú Đông', 82 ),
  (842, N'Trà Vinh', 84 ),
  (844, N'Càng Long', 84 ),
  (845, N'Cầu Kè', 84 ),
  (846, N'Tiểu Cần', 84 ),
  (847, N'Châu Thành', 84 ),
  (848, N'Cầu Ngang', 84 ),
  (849, N'Trà Cú', 84 ),
  (850, N'Duyên Hải', 84 ),
  (851, N'Duyên Hải', 84 ),
  (883, N'Long Xuyên', 89 ),
  (884, N'Châu Đốc', 89 ),
  (886, N'An Phú', 89 ),
  (887, N'Tân Châu', 89 ),
  (888, N'Phú Tân', 89 ),
  (889, N'Châu Phú', 89 ),
  (890, N'Tịnh Biên', 89 ),
  (891, N'Tri Tôn', 89 ),
  (892, N'Châu Thành', 89 ),
  (893, N'Chợ Mới', 89 ),
  (894, N'Thoại Sơn', 89 ),
  (070, N'Tuyên Quang', 08 ),
  (071, N'Lâm Bình', 08 ),
  (072, N'Na Hang', 08 ),
  (073, N'Chiêm Hóa', 08 ),
  (074, N'Hàm Yên', 08 ),
  (075, N'Yên Sơn', 08 ),
  (076, N'Sơn Dương', 08 ),
  (855, N'Vĩnh Long', 86 ),
  (857, N'Long Hồ', 86 ),
  (858, N'Mang Thít', 86 ),
  (859, N'Vũng Liêm', 86 ),
  (860, N'Tam Bình', 86 ),
  (861, N'Bình Minh', 86 ),
  (862, N'Trà Ôn', 86 ),
  (863, N'Bình Tân', 86 ),
  (243, N'Vĩnh Yên', 26 ),
  (244, N'Phúc Yên', 26 ),
  (246, N'Lập Thạch', 26 ),
  (247, N'Tam Dương', 26 ),
  (248, N'Tam Đảo', 26 ),
  (249, N'Bình Xuyên', 26 ),
  (251, N'Yên Lạc', 26 ),
  (252, N'Vĩnh Tường', 26 ),
  (253, N'Sông Lô', 26 ),
  (132, N'Yên Bái', 15 ),
  (133, N'Nghĩa Lộ', 15 ),
  (135, N'Lục Yên', 15 ),
  (136, N'Văn Yên', 15 ),
  (137, N'Mù Căng Chải', 15 ),
  (138, N'Trấn Yên', 15 ),
  (139, N'Trạm Tấu', 15 ),
  (140, N'Văn Chấn', 15 ),
  (141, N'Yên Bình', 15 ),
  (747, N'Vũng Tàu', 77 ),
  (748, N'Bà Rịa', 77 ),
  (750, N'Châu Đức', 77 ),
  (751, N'Xuyên Mộc', 77 ),
  (752, N'Long Điền', 77 ),
  (753, N'Đất Đỏ', 77 ),
  (754, N'Phú Mỹ', 77 ),
  (213, N'Bắc Giang', 24 ),
  (215, N'Yên Thế', 24 ),
  (216, N'Tân Yên', 24 ),
  (217, N'Lạng Giang', 24 ),
  (218, N'Lục Nam', 24 ),
  (219, N'Lục Ngạn', 24 ),
  (220, N'Sơn Động', 24 ),
  (221, N'Yên Dũng', 24 ),
  (222, N'Việt Yên', 24 ),
  (223, N'Hiệp Hòa', 24 ),
  (058, N'Bắc Kạn', 06 ),
  (060, N'Pác Nặm', 06 ),
  (061, N'Ba Bể', 06 ),
  (062, N'Ngân Sơn', 06 ),
  (063, N'Bạch Thông', 06 ),
  (064, N'Chợ Đồn', 06 ),
  (065, N'Chợ Mới', 06 ),
  (066, N'Na Rì', 06 )
GO

SET IDENTITY_INSERT [District] OFF
GO

SET IDENTITY_INSERT [Ward] ON
GO


INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10000, N'Tân Xã', 276 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10003, N'Thạch Xá', 276 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10006, N'Bình Phú', 276 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10009, N'Hạ Bằng', 276 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10012, N'Đồng Trúc', 276 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10015, N'Chúc Sơn', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10018, N'Xuân Mai', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10021, N'Phụng Châu', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10024, N'Tiên Phương', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10027, N'Đông Sơn', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10030, N'Đông Phương Yên', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10033, N'Phú Nghĩa', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10039, N'Trường Yên', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10042, N'Ngọc Hòa', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10045, N'Thủy Xuân Tiên', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10048, N'Thanh Bình', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10051, N'Trung Hòa', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10054, N'Đại Yên', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10057, N'Thụy Hương', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10060, N'Tốt Động', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10063, N'Lam Điền', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10066, N'Tân Tiến', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10069, N'Nam Phương Tiến', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10072, N'Hợp Đồng', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10075, N'Hoàng Văn Thụ', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10078, N'Hoàng Diệu', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10081, N'Hữu Văn', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10084, N'Quảng Bị', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10087, N'Mỹ Lương', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10090, N'Thượng Vực', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10093, N'Hồng Phong', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10096, N'Đồng Phú', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10099, N'Trần Phú', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10102, N'Văn Võ', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10105, N'Đồng Lạc', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10108, N'Hòa Chính', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10111, N'Phú Nam An', 277 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10114, N'Kim Bài', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10117, N'Đồng Mai', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10120, N'Cự Khê', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10123, N'Biên Giang', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10126, N'Bích Hòa', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10129, N'Mỹ Hưng', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10132, N'Cao Viên', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10135, N'Bình Minh', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10138, N'Tam Hưng', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10141, N'Thanh Cao', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10144, N'Thanh Thùy', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10147, N'Thanh Mai', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10150, N'Thanh Văn', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10153, N'Đỗ Động', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10156, N'Kim An', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10159, N'Kim Thư', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10162, N'Phương Trung', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10165, N'Tân Ước', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10168, N'Dân Hòa', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10171, N'Liên Châu', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10174, N'Cao Dương', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10177, N'Xuân Dương', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10180, N'Hồng Dương', 278 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10183, N'Thường Tín', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10186, N'Ninh Sở', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10189, N'Nhị Khê', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10192, N'Duyên Thái', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10195, N'Khánh Hà', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10198, N'Hòa Bình', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10201, N'Văn Bình', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10204, N'Hiền Giang', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10207, N'Hồng Vân', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10210, N'Vân Tảo', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10213, N'Liên Phương', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10216, N'Văn Phú', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10219, N'Tự Nhiên', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10222, N'Tiền Phong', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10225, N'Hà Hồi', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10228, N'Thư Phú', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10231, N'Nguyễn Trãi', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10234, N'Quất Động', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10237, N'Chương Dương', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10240, N'Tân Minh', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10243, N'Lê Lợi', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10246, N'Thắng Lợi', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10249, N'Dũng Tiến', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10252, N'Thống Nhất', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10255, N'Nghiêm Xuyên', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10258, N'Tô Hiệu', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10261, N'Văn Tự', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10264, N'Vạn Điểm', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10267, N'Minh Cường', 279 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10270, N'Phú Minh', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10273, N'Phú Xuyên', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10276, N'Hồng Minh', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10279, N'Phượng Dực', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10282, N'Văn Nhân', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10285, N'Thụy Phú', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10288, N'Tri Trung', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10291, N'Đại Thắng', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10294, N'Phú Túc', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10297, N'Văn Hoàng', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10300, N'Hồng Thái', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10303, N'Hoàng Long', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10306, N'Quang Trung', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10309, N'Nam Phong', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10312, N'Nam Triều', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10315, N'Tân Dân', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10318, N'Sơn Hà', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10321, N'Chuyên Mỹ', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10324, N'Khai Thái', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10327, N'Phúc Tiến', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10330, N'Vân Từ', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10333, N'Tri Thủy', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10336, N'Đại Xuyên', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10339, N'Phú Yên', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10342, N'Bạch Hạ', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10345, N'Quang Lãng', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10348, N'Châu Can', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10351, N'Minh Tân', 280 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10354, N'Vân Đình', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10357, N'Viên An', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10360, N'Viên Nội', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10363, N'Hoa Sơn', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10366, N'Quảng Phú Cầu', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10369, N'Trường Thịnh', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10372, N'Cao Thành', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10375, N'Liên Bạt', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10378, N'Sơn Công', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10381, N'Đồng Tiến', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10384, N'Phương Tú', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10387, N'Trung Tú', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10390, N'Đồng Tân', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10393, N'Tảo Dương Văn', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10396, N'Vạn Thái', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10399, N'Minh Đức', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10402, N'Hòa Lâm', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10405, N'Hòa Xá', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10408, N'Trầm Lộng', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10411, N'Kim Đường', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10414, N'Hòa Nam', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10417, N'Hòa Phú', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10420, N'Đội Bình', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10423, N'Đại Hùng', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10426, N'Đông Lỗ', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10429, N'Phù Lưu', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10432, N'Đại Cường', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10435, N'Lưu Hoàng', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10438, N'Hồng Quang', 281 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10441, N'Đại Nghĩa', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10444, N'Đồng Tâm', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10447, N'Thượng Lâm', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10450, N'Tuy Lai', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10453, N'Phúc Lâm', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10456, N'Mỹ Thành', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10459, N'Bột Xuyên', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10462, N'An Mỹ', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10465, N'Hồng Sơn', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10468, N'Lê Thanh', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10471, N'Xuy Xá', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10474, N'Phùng Xá', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10477, N'Phù Lưu Tế', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10480, N'Đại Hưng', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10483, N'Vạn Kim', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10486, N'Đốc Tín', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10489, N'Hương Sơn', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10492, N'Hùng Tiến', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10495, N'An Tiến', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10498, N'Hợp Tiến', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10501, N'Hợp Thanh', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10504, N'An Phú', 282 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10507, N'Cẩm Thượng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10510, N'Bình Hàn', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10513, N'Ngọc Châu', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10514, N'Nhị Châu', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10516, N'Quang Trung', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10519, N'Nguyễn Trãi', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10522, N'Phạm Ngũ Lão', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10525, N'Trần Hưng Đạo', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10528, N'Trần Phú', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10531, N'Thanh Bình', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10532, N'Tân Bình', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10534, N'Lê Thanh Nghị', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10537, N'Hải Tân', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10540, N'Tứ Minh', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10543, N'Việt Hoà', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10546, N'Phả Lại', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10549, N'Sao Đỏ', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10552, N'Bến Tắm', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10555, N'Hoàng Hoa Thám', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10558, N'Bắc An', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10561, N'Hưng Đạo', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10564, N'Lê Lợi', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10567, N'Hoàng Tiến', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10570, N'Cộng Hoà', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10573, N'Hoàng Tân', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10576, N'Cổ Thành', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10579, N'Văn An', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10582, N'Chí Minh', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10585, N'Văn Đức', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10588, N'Thái Học', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10591, N'Nhân Huệ', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10594, N'An Lạc', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10600, N'Đồng Lạc', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10603, N'Tân Dân', 290 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10606, N'Nam Sách', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10609, N'Nam Hưng', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10612, N'Nam Tân', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10615, N'Hợp Tiến', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10618, N'Hiệp Cát', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10621, N'Thanh Quang', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10624, N'Quốc Tuấn', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10627, N'Nam Chính', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10630, N'An Bình', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10633, N'Nam Trung', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10636, N'An Sơn', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10639, N'Cộng Hòa', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10642, N'Thái Tân', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10645, N'An Lâm', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10648, N'Phú Điền', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10651, N'Nam Hồng', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10654, N'Hồng Phong', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10657, N'Đồng Lạc', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10660, N'Ái Quốc', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10663, N'An Thượng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10666, N'Minh Tân', 291 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10672, N'Nam Đồng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10675, N'An Lưu', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10678, N'Bạch Đằng', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10681, N'Thất Hùng', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10684, N'Lê Ninh', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10687, N'Hoành Sơn', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10693, N'Phạm Thái', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10696, N'Duy Tân', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10699, N'Tân Dân', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10702, N'Minh Tân', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10705, N'Quang Thành', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10708, N'Hiệp Hòa', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10714, N'Phú Thứ', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10717, N'Thăng Long', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10720, N'Lạc Long', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10723, N'An Sinh', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10726, N'Hiệp Sơn', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10729, N'Thượng Quận', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10732, N'An Phụ', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10735, N'Hiệp An', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10738, N'Long Xuyên', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10741, N'Thái Thịnh', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10744, N'Hiến Thành', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10747, N'Minh Hòa', 292 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10750, N'Phú Thái', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10753, N'Lai Vu', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10756, N'Cộng Hòa', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10759, N'Thượng Vũ', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10762, N'Cổ Dũng', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10768, N'Tuấn Việt', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10771, N'Kim Xuyên', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10774, N'Phúc Thành A', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10777, N'Ngũ Phúc', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10780, N'Kim Anh', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10783, N'Kim Liên', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10786, N'Kim Tân', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10792, N'Kim Đính', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10798, N'Bình Dân', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10801, N'Tam Kỳ', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10804, N'Đồng Cẩm', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10807, N'Liên Hòa', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10810, N'Đại Đức', 293 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10813, N'Thanh Hà', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10816, N'Hồng Lạc', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10819, N'Việt Hồng', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10822, N'Quyết Thắng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10825, N'Tân Việt', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10828, N'Cẩm Chế', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10831, N'Thanh An', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10834, N'Thanh Lang', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10837, N'Tiền Tiến', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10840, N'Tân An', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10843, N'Liên Mạc', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10846, N'Thanh Hải', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10849, N'Thanh Khê', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10852, N'Thanh Xá', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10855, N'Thanh Xuân', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10861, N'Thanh Thủy', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10864, N'An Phượng', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10867, N'Thanh Sơn', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10876, N'Thanh Quang', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10879, N'Thanh Hồng', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10882, N'Thanh Cường', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10885, N'Vĩnh Lập', 294 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10888, N'Cẩm Giang', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10891, N'Lai Cách', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10894, N'Cẩm Hưng', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10897, N'Cẩm Hoàng', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10900, N'Cẩm Văn', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10903, N'Ngọc Liên', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10906, N'Thạch Lỗi', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10909, N'Cẩm Vũ', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10912, N'Đức Chính', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10918, N'Định Sơn', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10924, N'Lương Điền', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10927, N'Cao An', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10930, N'Tân Trường', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10933, N'Cẩm Phúc', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10936, N'Cẩm Điền', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10939, N'Cẩm Đông', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10942, N'Cẩm Đoài', 295 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10945, N'Kẻ Sặt', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10951, N'Vĩnh Hưng', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10954, N'Hùng Thắng', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10960, N'Vĩnh Hồng', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10963, N'Long Xuyên', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10966, N'Tân Việt', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10969, N'Thúc Kháng', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10972, N'Tân Hồng', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10975, N'Bình Minh', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10978, N'Hồng Khê', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10981, N'Thái Học', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10984, N'Cổ Bì', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10987, N'Nhân Quyền', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10990, N'Thái Dương', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10993, N'Thái Hòa', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10996, N'Bình Xuyên', 296 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 10999, N'Gia Lộc', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11002, N'Thạch Khôi', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11005, N'Liên Hồng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11008, N'Thống Nhất', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11011, N'Tân Hưng', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11017, N'Gia Xuyên', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11020, N'Yết Kiêu', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11029, N'Gia Tân', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11032, N'Tân Tiến', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11035, N'Gia Khánh', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11038, N'Gia Lương', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11041, N'Lê Lợi', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11044, N'Toàn Thắng', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11047, N'Hoàng Diệu', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11050, N'Hồng Hưng', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11053, N'Phạm Trấn', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11056, N'Đoàn Thượng', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11059, N'Thống Kênh', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11062, N'Quang Minh', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11065, N'Đồng Quang', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11068, N'Nhật Tân', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11071, N'Đức Xương', 297 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11074, N'Tứ Kỳ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11077, N'Ngọc Sơn', 288 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11083, N'Đại Sơn', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11086, N'Hưng Đạo', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11089, N'Ngọc Kỳ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11092, N'Bình Lăng', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11095, N'Chí Minh', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11098, N'Tái Sơn', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11101, N'Quang Phục', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11110, N'Dân Chủ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11113, N'Tân Kỳ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11116, N'Quang Khải', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11119, N'Đại Hợp', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11122, N'Quảng Nghiệp', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11125, N'An Thanh', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11128, N'Minh Đức', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11131, N'Văn Tố', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11134, N'Quang Trung', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11137, N'Phượng Kỳ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11140, N'Cộng Lạc', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11143, N'Tiên Động', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11146, N'Nguyên Giáp', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11149, N'Hà Kỳ', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11152, N'Hà Thanh', 298 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11155, N'Ninh Giang', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11161, N'Ứng Hoè', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11164, N'Nghĩa An', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11167, N'Hồng Đức', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11173, N'An Đức', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11176, N'Vạn Phúc', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11179, N'Tân Hương', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11185, N'Vĩnh Hòa', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11188, N'Đông Xuyên', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11197, N'Tân Phong', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11200, N'Ninh Hải', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11203, N'Đồng Tâm', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11206, N'Tân Quang', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11209, N'Kiến Quốc', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11215, N'Hồng Dụ', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11218, N'Văn Hội', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11224, N'Hồng Phong', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11227, N'Hiệp Lực', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11230, N'Hồng Phúc', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11233, N'Hưng Long', 299 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11239, N'Thanh Miện', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11242, N'Thanh Tùng', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11245, N'Phạm Kha', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11248, N'Ngô Quyền', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11251, N'Đoàn Tùng', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11254, N'Hồng Quang', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11257, N'Tân Trào', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11260, N'Lam Sơn', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11263, N'Đoàn Kết', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11266, N'Lê Hồng', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11269, N'Tứ Cường', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11275, N'Ngũ Hùng', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11278, N'Cao Thắng', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11281, N'Chi Lăng Bắc', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11284, N'Chi Lăng Nam', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11287, N'Thanh Giang', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11293, N'Hồng Phong', 300 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11296, N'Quán Toan', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11299, N'Hùng Vương', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11302, N'Sở Dầu', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11305, N'Thượng Lý', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11308, N'Hạ Lý', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11311, N'Minh Khai', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11314, N'Trại Chuối', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11317, N'Quang Trung', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11320, N'Hoàng Văn Thụ', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11323, N'Phan Bội Châu', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11326, N'Phạm Hồng Thái', 303 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11329, N'Máy Chai', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11332, N'Máy Tơ', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11335, N'Vạn Mỹ', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11338, N'Cầu Tre', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11341, N'Lạc Viên', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11344, N'Lương Khánh Thiện', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11347, N'Gia Viên', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11350, N'Đông Khê', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11353, N'Cầu Đất', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11356, N'Lê Lợi', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11359, N'Đằng Giang', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11362, N'Lạch Tray', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11365, N'Đổng Quốc Bình', 304 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11368, N'Cát Dài', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11371, N'An Biên', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11374, N'Lam Sơn', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11377, N'An Dương', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11380, N'Trần Nguyên Hãn', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11383, N'Hồ Nam', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11386, N'Trại Cau', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11389, N'Dư Hàng', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11392, N'Hàng Kênh', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11395, N'Đông Hải', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11398, N'Niệm Nghĩa', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11401, N'Nghĩa Xá', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11404, N'Dư Hàng Kênh', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11405, N'Kênh Dương', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11407, N'Vĩnh Niệm', 305 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11410, N'Đông Hải 1', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11411, N'Đông Hải 2', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11413, N'Đằng Lâm', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11414, N'Thành Tô', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11416, N'Đằng Hải', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11419, N'Nam Hải', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11422, N'Cát Bi', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11425, N'Tràng Cát', 306 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11428, N'Quán Trữ', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11429, N'Lãm Hà', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11431, N'Đồng Hoà', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11434, N'Bắc Sơn', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11437, N'Nam Sơn', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11440, N'Ngọc Sơn', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11443, N'Trần Thành Ngọ', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11446, N'Văn Đẩu', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11449, N'Phù Liễn', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11452, N'Tràng Minh', 307 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11455, N'Ngọc Xuyên', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11458, N'Ngọc Hải', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11461, N'Vạn Hương', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11464, N'Vạn Sơn', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11465, N'Minh Đức', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11467, N'Bàng La', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11470, N'Núi Đèo', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11473, N'Minh Đức', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11476, N'Lại Xuân', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11479, N'An Sơn', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11482, N'Kỳ Sơn', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11485, N'Liên Khê', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11488, N'Lưu Kiếm', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11491, N'Lưu Kỳ', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11494, N'Gia Minh', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11497, N'Gia Đức', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11500, N'Minh Tân', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11503, N'Phù Ninh', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11506, N'Quảng Thanh', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11509, N'Chính Mỹ', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11512, N'Kênh Giang', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11515, N'Hợp Thành', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11518, N'Cao Nhân', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11521, N'Mỹ Đồng', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11524, N'Đông Sơn', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11527, N'Hoà Bình', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11530, N'Trung Hà', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11533, N'An Lư', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11536, N'Thuỷ Triều', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11539, N'Ngũ Lão', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11542, N'Phục Lễ', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11545, N'Tam Hưng', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11548, N'Phả Lễ', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11551, N'Lập Lễ', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11554, N'Kiền Bái', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11557, N'Thiên Hương', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11560, N'Thuỷ Sơn', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11563, N'Thuỷ Đường', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11566, N'Hoàng Động', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11569, N'Lâm Động', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11572, N'Hoa Động', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11575, N'Tân Dương', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11578, N'Dương Quan', 311 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11581, N'An Dương', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11584, N'Lê Thiện', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11587, N'Đại Bản', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11590, N'An Hoà', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11593, N'Hồng Phong', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11596, N'Tân Tiến', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11599, N'An Hưng', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11602, N'An Hồng', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11605, N'Bắc Sơn', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11608, N'Nam Sơn', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11611, N'Lê Lợi', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11614, N'Đặng Cương', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11617, N'Đồng Thái', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11620, N'Quốc Tuấn', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11623, N'An Đồng', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11626, N'Hồng Thái', 312 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11629, N'An Lão', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11632, N'Bát Trang', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11635, N'Trường Thọ', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11638, N'Trường Thành', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11641, N'An Tiến', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11644, N'Quang Hưng', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11647, N'Quang Trung', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11650, N'Quốc Tuấn', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11653, N'An Thắng', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11656, N'Trường Sơn', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11659, N'Tân Dân', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11662, N'Thái Sơn', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11665, N'Tân Viên', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11668, N'Mỹ Đức', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11671, N'Chiến Thắng', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11674, N'An Thọ', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11677, N'An Thái', 313 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11680, N'Núi Đối', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11683, N'Đa Phúc', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11686, N'Hưng Đạo', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11689, N'Anh Dũng', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11692, N'Hải Thành', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11695, N'Đông Phương', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11698, N'Thuận Thiên', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11701, N'Hữu Bằng', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11704, N'Đại Đồng', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11707, N'Hoà Nghĩa', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11710, N'Ngũ Phúc', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11713, N'Kiến Quốc', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11716, N'Du Lễ', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11719, N'Thuỵ Hương', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11722, N'Thanh Sơn', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11725, N'Minh Tân', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11728, N'Đại Hà', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11731, N'Ngũ Đoan', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11734, N'Tân Phong', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11737, N'Hợp Đức', 308 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11740, N'Tân Thành', 309 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11743, N'Tân Trào', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11746, N'Đoàn Xá', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11749, N'Tú Sơn', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11752, N'Đại Hợp', 314 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11755, N'Tiên Lãng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11758, N'Đại Thắng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11761, N'Tiên Cường', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11764, N'Tự Cường', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11767, N'Tiên Tiến', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11770, N'Quyết Tiến', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11773, N'Khởi Nghĩa', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11776, N'Tiên Thanh', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11779, N'Cấp Tiến', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11782, N'Kiến Thiết', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11785, N'Đoàn Lập', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11788, N'Bạch Đằng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11791, N'Quang Phục', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11794, N'Toàn Thắng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11797, N'Tiên Thắng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11800, N'Tiên Minh', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11803, N'Bắc Hưng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11806, N'Nam Hưng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11809, N'Hùng Thắng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11812, N'Tây Hưng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11815, N'Đông Hưng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11818, N'Tiên Hưng', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11821, N'Vinh Quang', 315 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11824, N'Vĩnh Bảo', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11827, N'Dũng Tiến', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11830, N'Giang Biên', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11833, N'Thắng Thuỷ', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11836, N'Trung Lập', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11839, N'Việt Tiến', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11842, N'Vĩnh An', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11845, N'Vĩnh Long', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11848, N'Hiệp Hoà', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11851, N'Hùng Tiến', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11854, N'An Hoà', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11857, N'Tân Hưng', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11860, N'Tân Liên', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11863, N'Nhân Hoà', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11866, N'Tam Đa', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11869, N'Hưng Nhân', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11872, N'Vinh Quang', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11875, N'Đồng Minh', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11878, N'Thanh Lương', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11881, N'Liên Am', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11884, N'Lý Học', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11887, N'Tam Cường', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11890, N'Hoà Bình', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11893, N'Tiền Phong', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11896, N'Vĩnh Phong', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11899, N'Cộng Hiền', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11902, N'Cao Minh', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11905, N'Cổ Am', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11908, N'Vĩnh Tiến', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11911, N'Trấn Dương', 316 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11914, N'Cát Bà', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11917, N'Cát Hải', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11920, N'Nghĩa Lộ', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11923, N'Đồng Bài', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11926, N'Hoàng Châu', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11929, N'Văn Phong', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11932, N'Phù Long', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11935, N'Gia Luận', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11938, N'Hiền Hào', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11941, N'Trân Châu', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11944, N'Việt Hải', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11947, N'Xuân Đám', 317 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11950, N'Lam Sơn', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11953, N'Hiến Nam', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11956, N'An Tảo', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11959, N'Lê Lợi', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11962, N'Minh Khai', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11965, N'Quang Trung', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11968, N'Hồng Châu', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11971, N'Trung Nghĩa', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11974, N'Liên Phương', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11977, N'Hồng Nam', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11980, N'Quảng Châu', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11983, N'Bảo Khê', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11986, N'Như Quỳnh', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11989, N'Lạc Đạo', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11992, N'Chỉ Đạo', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11995, N'Đại Đồng', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 11998, N'Việt Hưng', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12001, N'Tân Quang', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12004, N'Đình Dù', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12007, N'Minh Hải', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12010, N'Lương Tài', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12013, N'Trưng Trắc', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12016, N'Lạc Hồng', 325 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12019, N'Văn Giang', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12022, N'Xuân Quan', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12025, N'Cửu Cao', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12028, N'Phụng Công', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12031, N'Nghĩa Trụ', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12034, N'Long Hưng', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12037, N'Vĩnh Khúc', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12040, N'Liên Nghĩa', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12043, N'Tân Tiến', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12046, N'Thắng Lợi', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12049, N'Mễ Sở', 326 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12052, N'Yên Mỹ', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12055, N'Giai Phạm', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12058, N'Nghĩa Hiệp', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12061, N'Đồng Than', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12064, N'Ngọc Long', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12067, N'Liêu Xá', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12070, N'Hoàn Long', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12073, N'Tân Lập', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12076, N'Thanh Long', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12079, N'Yên Phú', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12082, N'Việt Cường', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12085, N'Trung Hòa', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12088, N'Yên Hòa', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12091, N'Minh Châu', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12094, N'Trung Hưng', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12097, N'Lý Thường Kiệt', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12100, N'Tân Việt', 327 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12103, N'Bần Yên Nhân', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12106, N'Phan Đình Phùng', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12109, N'Cẩm Xá', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12112, N'Dương Quang', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12115, N'Hòa Phong', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12118, N'Nhân Hòa', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12121, N'Dị Sử', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12124, N'Bạch Sam', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12127, N'Minh Đức', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12130, N'Phùng Chí Kiên', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12133, N'Xuân Dục', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12136, N'Ngọc Lâm', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12139, N'Hưng Long', 328 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12142, N'Ân Thi', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12145, N'Phù Ủng', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12148, N'Bắc Sơn', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12151, N'Bãi Sậy', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12154, N'Đào Dương', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12157, N'Tân Phúc', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12160, N'Vân Du', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12163, N'Quang Vinh', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12166, N'Xuân Trúc', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12169, N'Hoàng Hoa Thám', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12172, N'Quảng Lãng', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12175, N'Văn Nhuệ', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12178, N'Đặng Lễ', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12181, N'Cẩm Ninh', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12184, N'Nguyễn Trãi', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12187, N'Đa Lộc', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12190, N'Hồ Tùng Mậu', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12193, N'Tiền Phong', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12196, N'Hồng Vân', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12199, N'Hồng Quang', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12202, N'Hạ Lễ', 329 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12205, N'Khoái Châu', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12208, N'Đông Tảo', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12211, N'Bình Minh', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12214, N'Dạ Trạch', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12217, N'Hàm Tử', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12220, N'Ông Đình', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12223, N'Tân Dân', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12226, N'Tứ Dân', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12229, N'An Vĩ', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12232, N'Đông Kết', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12235, N'Bình Kiều', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12238, N'Dân Tiến', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12241, N'Đồng Tiến', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12244, N'Hồng Tiến', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12247, N'Tân Châu', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12250, N'Liên Khê', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12253, N'Phùng Hưng', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12256, N'Việt Hòa', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12259, N'Đông Ninh', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12262, N'Đại Tập', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12265, N'Chí Tân', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12268, N'Đại Hưng', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12271, N'Thuần Hưng', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12274, N'Thành Công', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12277, N'Nhuế Dương', 330 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12280, N'Lương Bằng', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12283, N'Nghĩa Dân', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12286, N'Toàn Thắng', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12289, N'Vĩnh Xá', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12292, N'Phạm Ngũ Lão', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12295, N'Thọ Vinh', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12298, N'Đồng Thanh', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12301, N'Song Mai', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12304, N'Chính Nghĩa', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12307, N'Nhân La', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12310, N'Phú Thịnh', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12313, N'Mai Động', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12316, N'Đức Hợp', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12319, N'Hùng An', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12322, N'Ngọc Thanh', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12325, N'Vũ Xá', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12328, N'Hiệp Cường', 331 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12331, N'Phú Cường', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12334, N'Hùng Cường', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12337, N'Vương', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12340, N'Hưng Đạo', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12343, N'Ngô Quyền', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12346, N'Nhật Tân', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12349, N'Dị Chế', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12352, N'Lệ Xá', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12355, N'An Viên', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12358, N'Đức Thắng', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12361, N'Trung Dũng', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12364, N'Hải Triều', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12367, N'Thủ Sỹ', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12370, N'Thiện Phiến', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12373, N'Thụy Lôi', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12376, N'Cương Chính', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12379, N'Minh Phượng', 332 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12382, N'Phương Chiểu', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12385, N'Tân Hưng', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12388, N'Hoàng Hanh', 323 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12391, N'Trần Cao', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12394, N'Minh Tân', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12397, N'Phan Sào Nam', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12400, N'Quang Hưng', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12403, N'Minh Hoàng', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12406, N'Đoàn Đào', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12409, N'Tống Phan', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12412, N'Đình Cao', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12415, N'Nhật Quang', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12418, N'Tiền Tiến', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12421, N'Tam Đa', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12424, N'Minh Tiến', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12427, N'Nguyên Hòa', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12430, N'Tống Trân', 333 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12433, N'Lê Hồng Phong', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12436, N'Bồ Xuyên', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12439, N'Đề Thám', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12442, N'Kỳ Bá', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12445, N'Quang Trung', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12448, N'Phú Khánh', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12451, N'Tiền Phong', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12452, N'Trần Hưng Đạo', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12454, N'Trần Lãm', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12457, N'Đông Hòa', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12460, N'Hoàng Diệu', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12463, N'Phú Xuân', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12466, N'Vũ Phúc', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12469, N'Vũ Chính', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12472, N'Quỳnh Côi', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12475, N'An Khê', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12478, N'An Đồng', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12481, N'Quỳnh Hoa', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12484, N'Quỳnh Lâm', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12487, N'Quỳnh Thọ', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12490, N'An Hiệp', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12493, N'Quỳnh Hoàng', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12496, N'Quỳnh Giao', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12499, N'An Thái', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12502, N'An Cầu', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12505, N'Quỳnh Hồng', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12508, N'Quỳnh Khê', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12511, N'Quỳnh Minh', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12514, N'An Ninh', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12517, N'Quỳnh Ngọc', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12520, N'Quỳnh Hải', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12523, N'An Bài', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12526, N'An Ấp', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12529, N'Quỳnh Hội', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12532, N'Quỳnh Sơn', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12535, N'Quỳnh Mỹ', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12538, N'An Quí', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12541, N'An Thanh', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12544, N'Quỳnh Châu', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12547, N'An Vũ', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12550, N'An Lễ', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12553, N'Quỳnh Hưng', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12556, N'Quỳnh Bảo', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12559, N'An Mỹ', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12562, N'Quỳnh Nguyên', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12565, N'An Vinh', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12568, N'Quỳnh Xá', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12571, N'An Dục', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12574, N'Đông Hải', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12577, N'Quỳnh Trang', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12580, N'An Tràng', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12583, N'Đồng Tiến', 338 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12586, N'Hưng Hà', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12589, N'Điệp Nông', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12592, N'Tân Lễ', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12595, N'Cộng Hòa', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12598, N'Dân Chủ', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12601, N'Canh Tân', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12604, N'Hòa Tiến', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12607, N'Hùng Dũng', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12610, N'Tân Tiến', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12613, N'Hưng Nhân', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12616, N'Đoan Hùng', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12619, N'Duyên Hải', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12622, N'Tân Hòa', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12625, N'Văn Cẩm', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12628, N'Bắc Sơn', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12631, N'Đông Đô', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12634, N'Phúc Khánh', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12637, N'Liên Hiệp', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12640, N'Tây Đô', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12643, N'Thống Nhất', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12646, N'Tiến Đức', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12649, N'Thái Hưng', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12652, N'Thái Phương', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12655, N'Hòa Bình', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12656, N'Chi Lăng', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12658, N'Minh Khai', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12661, N'Hồng An', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12664, N'Kim Chung', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12667, N'Hồng Lĩnh', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12670, N'Minh Tân', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12673, N'Văn Lang', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12676, N'Độc Lập', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12679, N'Chí Hòa', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12682, N'Minh Hòa', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12685, N'Hồng Minh', 339 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12688, N'Đông Hưng', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12691, N'Đô Lương', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12694, N'Đông Phương', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12697, N'Liên Giang', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12700, N'An Châu', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12703, N'Đông Sơn', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12706, N'Đông Cường', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12709, N'Phú Lương', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12712, N'Mê Linh', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12715, N'Lô Giang', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12718, N'Đông La', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12721, N'Minh Tân', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12724, N'Đông Xá', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12727, N'Chương Dương', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12730, N'Nguyên Xá', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12733, N'Phong Châu', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12736, N'Hợp Tiến', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12739, N'Hồng Việt', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12742, N'Đông Hà', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12745, N'Đông Giang', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12748, N'Đông Kinh', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12751, N'Đông Hợp', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12754, N'Thăng Long', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12757, N'Đông Các', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12760, N'Phú Châu', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12763, N'Hoa Lư', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12766, N'Minh Châu', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12769, N'Đông Tân', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12772, N'Đông Vinh', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12775, N'Đông Động', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12778, N'Hồng Châu', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12781, N'Bạch Đằng', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12784, N'Trọng Quan', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12787, N'Hoa Nam', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12790, N'Hồng Giang', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12793, N'Đông Phong', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12796, N'Đông Quang', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12799, N'Đông Xuân', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12802, N'Đông Á', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12805, N'Đông Lĩnh', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12808, N'Đông Hoàng', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12811, N'Đông Dương', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12814, N'Đông Huy', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12817, N'Đông Mỹ', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12820, N'Đông Thọ', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12823, N'Đồng Phú', 340 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12826, N'Diêm Điền', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12829, N'Thụy Tân', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12832, N'Thụy Trường', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12835, N'Hồng Quỳnh', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12838, N'Thụy Dũng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12841, N'Thụy Hồng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12844, N'Thụy Quỳnh', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12847, N'Thụy An', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12850, N'Thụy Ninh', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12853, N'Thụy Hưng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12856, N'Thụy Việt', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12859, N'Thụy Văn', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12862, N'Thụy Xuân', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12865, N'Thụy Dương', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12868, N'Thụy Trình', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12871, N'Thụy Bình', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12874, N'Thụy Chính', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12877, N'Thụy Dân', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12880, N'Thụy Hải', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12883, N'Thụy Phúc', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12886, N'Thụy Lương', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12889, N'Thụy Liên', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12892, N'Thụy Duyên', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12895, N'Thụy Hà', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12898, N'Thụy Thanh', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12901, N'Thụy Sơn', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12904, N'Thụy Phong', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12907, N'Thái Thượng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12910, N'Thái Nguyên', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12913, N'Thái Thủy', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12916, N'Thái Dương', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12919, N'Thái Giang', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12922, N'Thái Hòa', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12925, N'Thái Sơn', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12928, N'Thái Hồng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12931, N'Thái An', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12934, N'Thái Phúc', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12937, N'Thái Hưng', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12940, N'Thái Đô', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12943, N'Thái Xuyên', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12946, N'Thái Hà', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12949, N'Mỹ Lộc', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12952, N'Thái Tân', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12955, N'Thái Thuần', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12958, N'Thái Học', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12961, N'Thái Thịnh', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12964, N'Thái Thành', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12967, N'Thái Thọ', 341 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12970, N'Tiền Hải', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12973, N'Đông Hải', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12976, N'Đông Trà', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12979, N'Đông Long', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12982, N'Đông Quí', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12985, N'Vũ Lăng', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12988, N'Đông Xuyên', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12991, N'Tây Lương', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12994, N'Tây Ninh', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 12997, N'Đông Trung', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13000, N'Đông Hoàng', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13003, N'Đông Minh', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13006, N'Tây An', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13009, N'Đông Phong', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13012, N'An Ninh', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13015, N'Tây Sơn', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13018, N'Đông Cơ', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13021, N'Tây Giang', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13024, N'Đông Lâm', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13027, N'Phương Công', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13030, N'Tây Phong', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13033, N'Tây Tiến', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13036, N'Nam Cường', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13039, N'Vân Trường', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13042, N'Nam Thắng', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13045, N'Nam Chính', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13048, N'Bắc Hải', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13051, N'Nam Thịnh', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13054, N'Nam Hà', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13057, N'Nam Thanh', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13060, N'Nam Trung', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13063, N'Nam Hồng', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13066, N'Nam Hưng', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13069, N'Nam Hải', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13072, N'Nam Phú', 342 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13075, N'Thanh Nê', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13078, N'Trà Giang', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13081, N'Quốc Tuấn', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13084, N'Vũ Đông', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13087, N'An Bình', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13090, N'Vũ Tây', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13093, N'Hồng Thái', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13096, N'Bình Nguyên', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13099, N'Vũ Sơn', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13102, N'Lê Lợi', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13105, N'Quyết Tiến', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13108, N'Vũ Lạc', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13111, N'Vũ Lễ', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13114, N'Thanh Tân', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13117, N'Thượng Hiền', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13120, N'Nam Cao', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13123, N'Đình Phùng', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13126, N'Vũ Ninh', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13129, N'Vũ An', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13132, N'Quang Lịch', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13135, N'Hòa Bình', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13138, N'Bình Minh', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13141, N'Vũ Quí', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13144, N'Quang Bình', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13147, N'An Bồi', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13150, N'Vũ Trung', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13153, N'Vũ Thắng', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13156, N'Vũ Công', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13159, N'Vũ Hòa', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13162, N'Quang Minh', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13165, N'Quang Trung', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13168, N'Minh Hưng', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13171, N'Quang Hưng', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13174, N'Vũ Bình', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13177, N'Minh Tân', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13180, N'Nam Bình', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13183, N'Bình Thanh', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13186, N'Bình Định', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13189, N'Hồng Tiến', 343 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13192, N'Vũ Thư', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13195, N'Hồng Lý', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13198, N'Đồng Thanh', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13201, N'Xuân Hòa', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13204, N'Hiệp Hòa', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13207, N'Phúc Thành', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13210, N'Tân Phong', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13213, N'Song Lãng', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13216, N'Tân Hòa', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13219, N'Việt Hùng', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13222, N'Minh Lãng', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13225, N'Tân Bình', 336 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13228, N'Minh Khai', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13231, N'Dũng Nghĩa', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13234, N'Minh Quang', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13237, N'Tam Quang', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13240, N'Tân Lập', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13243, N'Bách Thuận', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13246, N'Tự Tân', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13249, N'Song An', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13252, N'Trung An', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13255, N'Vũ Hội', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13258, N'Hòa Bình', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13261, N'Nguyên Xá', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13264, N'Việt Thuận', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13267, N'Vũ Vinh', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13270, N'Vũ Đoài', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13273, N'Vũ Tiến', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13276, N'Vũ Vân', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13279, N'Duy Nhất', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13282, N'Hồng Phong', 344 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13285, N'Quang Trung', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13288, N'Lương Khánh Thiện', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13291, N'Lê Hồng Phong', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13294, N'Minh Khai', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13297, N'Hai Bà Trưng', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13300, N'Trần Hưng Đạo', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13303, N'Lam Hạ', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13306, N'Phù Vân', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13309, N'Liêm Chính', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13312, N'Liêm Chung', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13315, N'Thanh Châu', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13318, N'Châu Sơn', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13321, N'Đồng Văn', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13324, N'Hòa Mạc', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13327, N'Mộc Bắc', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13330, N'Châu Giang', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13333, N'Bạch Thượng', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13336, N'Duy Minh', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13339, N'Mộc Nam', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13342, N'Duy Hải', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13345, N'Chuyên Ngoại', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13348, N'Yên Bắc', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13351, N'Trác Văn', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13354, N'Tiên Nội', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13357, N'Hoàng Đông', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13360, N'Yên Nam', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13363, N'Tiên Ngoại', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13366, N'Tiên Tân', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13369, N'Tiên Sơn', 349 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13372, N'Tiên Hiệp', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13381, N'Tiên Hải', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13384, N'Quế', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13387, N'Nguyễn Úy', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13390, N'Đại Cương', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13393, N'Lê Hồ', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13396, N'Tượng Lĩnh', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13399, N'Nhật Tựu', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13402, N'Nhật Tân', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13405, N'Đồng Hóa', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13408, N'Hoàng Tây', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13411, N'Tân Sơn', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13414, N'Thụy Lôi', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13417, N'Văn Xá', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13420, N'Khả Phong', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13423, N'Ngọc Sơn', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13426, N'Kim Bình', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13429, N'Ba Sao', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13432, N'Liên Sơn', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13435, N'Thi Sơn', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13438, N'Thanh Sơn', 350 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13441, N'Kiện Khê', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13444, N'Liêm Tuyền', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13447, N'Liêm Tiết', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13450, N'Liêm Phong', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13453, N'Thanh Hà', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13456, N'Liêm Cần', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13459, N'Thanh Tuyền', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13465, N'Liêm Thuận', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13468, N'Thanh Thủy', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13471, N'Thanh Phong', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13474, N'Tân Thanh', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13477, N'Thanh Tân', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13480, N'Liêm Túc', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13483, N'Liêm Sơn', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13486, N'Thanh Hương', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13489, N'Thanh Nghị', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13492, N'Thanh Tâm', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13495, N'Thanh Nguyên', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13498, N'Thanh Hải', 351 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13501, N'Bình Mỹ', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13504, N'Bình Nghĩa', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13507, N'Đinh Xá', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13510, N'Tràng An', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13513, N'Trịnh Xá', 347 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13516, N'Đồng Du', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13519, N'Ngọc Lũ', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13522, N'Hưng Công', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13525, N'Đồn Xá', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13528, N'An Ninh', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13531, N'Bồ Đề', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13534, N'Bối Cầu', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13540, N'An Nội', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13543, N'Vũ Bản', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13546, N'Trung Lương', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13552, N'An Đổ', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13555, N'La Sơn', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13558, N'Tiêu Động', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13561, N'An Lão', 352 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13564, N'Vĩnh Trụ', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13567, N'Hợp Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13570, N'Nguyên Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13573, N'Chính Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13576, N'Chân Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13579, N'Đạo Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13582, N'Công Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13585, N'Văn Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13588, N'Bắc Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13591, N'Đức Lý', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13594, N'Trần Hưng Đạo', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13600, N'Nhân Thịnh', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13606, N'Nhân Khang', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13609, N'Nhân Mỹ', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13612, N'Nhân Nghĩa', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13615, N'Nhân Chính', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13618, N'Nhân Bình', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13621, N'Phú Phúc', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13624, N'Xuân Khê', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13627, N'Tiến Thắng', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13630, N'Hòa Hậu', 353 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13633, N'Hạ Long', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13636, N'Trần Tế Xương', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13639, N'Vị Hoàng', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13642, N'Vị Xuyên', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13645, N'Quang Trung', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13648, N'Cửa Bắc', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13651, N'Nguyễn Du', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13654, N'Bà Triệu', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13657, N'Trường Thi', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13660, N'Phan Đình Phùng', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13663, N'Ngô Quyền', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13666, N'Trần Hưng Đạo', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13669, N'Trần Đăng Ninh', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13672, N'Năng Tĩnh', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13675, N'Văn Miếu', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13678, N'Trần Quang Khải', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13681, N'Thống Nhất', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13684, N'Lộc Hạ', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13687, N'Lộc Vượng', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13690, N'Cửa Nam', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13693, N'Lộc Hòa', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13696, N'Nam Phong', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13699, N'Mỹ Xá', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13702, N'Lộc An', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13705, N'Nam Vân', 356 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13708, N'Mỹ Lộc', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13711, N'Mỹ Hà', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13714, N'Mỹ Tiến', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13717, N'Mỹ Thắng', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13720, N'Mỹ Trung', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13723, N'Mỹ Tân', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13726, N'Mỹ Phúc', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13729, N'Mỹ Hưng', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13732, N'Mỹ Thuận', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13735, N'Mỹ Thịnh', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13738, N'Mỹ Thành', 358 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13741, N'Gôi', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13744, N'Minh Thuận', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13747, N'Hiển Khánh', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13750, N'Tân Khánh', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13753, N'Hợp Hưng', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13756, N'Đại An', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13759, N'Tân Thành', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13762, N'Cộng Hòa', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13765, N'Trung Thành', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13768, N'Quang Trung', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13771, N'Minh Tân', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13774, N'Liên Bảo', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13777, N'Thành Lợi', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13780, N'Kim Thái', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13783, N'Liên Minh', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13786, N'Đại Thắng', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13789, N'Tam Thanh', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13792, N'Vĩnh Hào', 359 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13795, N'Lâm', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13798, N'Yên Trung', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13801, N'Yên Thành', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13804, N'Yên Tân', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13807, N'Yên Lợi', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13810, N'Yên Thọ', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13813, N'Yên Nghĩa', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13816, N'Yên Minh', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13819, N'Yên Phương', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13822, N'Yên Chính', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13825, N'Yên Bình', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13828, N'Yên Phú', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13831, N'Yên Mỹ', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13834, N'Yên Dương', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13837, N'Yên Xá', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13840, N'Yên Hưng', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13843, N'Yên Khánh', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13846, N'Yên Phong', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13849, N'Yên Ninh', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13852, N'Yên Lương', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13855, N'Yên Hồng', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13858, N'Yên Quang', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13861, N'Yên Tiến', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13864, N'Yên Thắng', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13867, N'Yên Phúc', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13870, N'Yên Cường', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13873, N'Yên Lộc', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13876, N'Yên Bằng', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13879, N'Yên Đồng', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13882, N'Yên Khang', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13885, N'Yên Nhân', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13888, N'Yên Trị', 360 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13891, N'Liễu Đề', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13894, N'Rạng Đông', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13897, N'Nghĩa Đồng', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13900, N'Nghĩa Thịnh', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13903, N'Nghĩa Minh', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13906, N'Nghĩa Thái', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13909, N'Hoàng Nam', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13912, N'Nghĩa Châu', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13915, N'Nghĩa Trung', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13918, N'Nghĩa Sơn', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13921, N'Nghĩa Lạc', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13924, N'Nghĩa Hồng', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13927, N'Nghĩa Phong', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13930, N'Nghĩa Phú', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13933, N'Nghĩa Bình', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13936, N'Quỹ Nhất', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13939, N'Nghĩa Tân', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13942, N'Nghĩa Hùng', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13945, N'Nghĩa Lâm', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13948, N'Nghĩa Thành', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13951, N'Nghĩa Thắng', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13954, N'Nghĩa Lợi', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13957, N'Nghĩa Hải', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13960, N'Nghĩa Phúc', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13963, N'Nam Điền', 361 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13966, N'Nam Giang', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13969, N'Nam Mỹ', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13972, N'Điền Xá', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13975, N'Nghĩa An', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13978, N'Nam Thắng', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13981, N'Nam Toàn', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13984, N'Hồng Quang', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13987, N'Tân Thịnh', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13990, N'Nam Cường', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13993, N'Nam Hồng', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13996, N'Nam Hùng', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 13999, N'Nam Hoa', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14002, N'Nam Dương', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14005, N'Nam Thanh', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14008, N'Nam Lợi', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14011, N'Bình Minh', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14014, N'Đồng Sơn', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14017, N'Nam Tiến', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14020, N'Nam Hải', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14023, N'Nam Thái', 362 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14026, N'Cổ Lễ', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14029, N'Phương Định', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14032, N'Trực Chính', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14035, N'Trung Đông', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14038, N'Liêm Hải', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14041, N'Trực Tuấn', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14044, N'Việt Hùng', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14047, N'Trực Đạo', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14050, N'Trực Hưng', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14053, N'Trực Nội', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14056, N'Cát Thành', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14059, N'Trực Thanh', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14062, N'Trực Khang', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14065, N'Trực Thuận', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14068, N'Trực Mỹ', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14071, N'Trực Đại', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14074, N'Trực Cường', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14077, N'Ninh Cường', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14080, N'Trực Thái', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14083, N'Trực Hùng', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14086, N'Trực Thắng', 363 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14089, N'Xuân Trường', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14092, N'Xuân Châu', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14095, N'Xuân Hồng', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14098, N'Xuân Thành', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14101, N'Xuân Thượng', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14104, N'Xuân Phong', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14107, N'Xuân Đài', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14110, N'Xuân Tân', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14113, N'Xuân Thủy', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14116, N'Xuân Ngọc', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14119, N'Xuân Bắc', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14122, N'Xuân Phương', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14125, N'Thọ Nghiệp', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14128, N'Xuân Phú', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14131, N'Xuân Trung', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14134, N'Xuân Vinh', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14137, N'Xuân Kiên', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14140, N'Xuân Tiến', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14143, N'Xuân Ninh', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14146, N'Xuân Hòa', 364 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14149, N'Ngô Đồng', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14152, N'Quất Lâm', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14155, N'Giao Hương', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14158, N'Hồng Thuận', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14161, N'Giao Thiện', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14164, N'Giao Thanh', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14167, N'Hoành Sơn', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14170, N'Bình Hòa', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14173, N'Giao Tiến', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14176, N'Giao Hà', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14179, N'Giao Nhân', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14182, N'Giao An', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14185, N'Giao Lạc', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14188, N'Giao Châu', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14191, N'Giao Tân', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14194, N'Giao Yến', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14197, N'Giao Xuân', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14200, N'Giao Thịnh', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14203, N'Giao Hải', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14206, N'Bạch Long', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14209, N'Giao Long', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14212, N'Giao Phong', 365 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14215, N'Yên Định', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14218, N'Cồn', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14221, N'Thịnh Long', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14224, N'Hải Nam', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14227, N'Hải Trung', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14230, N'Hải Vân', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14233, N'Hải Minh', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14236, N'Hải Anh', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14239, N'Hải Hưng', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14242, N'Hải Bắc', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14245, N'Hải Phúc', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14248, N'Hải Thanh', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14251, N'Hải Hà', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14254, N'Hải Long', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14257, N'Hải Phương', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14260, N'Hải Đường', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14263, N'Hải Lộc', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14266, N'Hải Quang', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14269, N'Hải Đông', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14272, N'Hải Sơn', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14275, N'Hải Tân', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14278, N'Hải Toàn', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14281, N'Hải Phong', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14284, N'Hải An', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14287, N'Hải Tây', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14290, N'Hải Lý', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14293, N'Hải Phú', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14296, N'Hải Giang', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14299, N'Hải Cường', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14302, N'Hải Ninh', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14305, N'Hải Chính', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14308, N'Hải Xuân', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14311, N'Hải Châu', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14314, N'Hải Triều', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14317, N'Hải Hòa', 366 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14320, N'Đông Thành', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14323, N'Tân Thành', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14326, N'Thanh Bình', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14329, N'Vân Giang', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14332, N'Bích Đào', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14335, N'Phúc Thành', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14338, N'Nam Bình', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14341, N'Nam Thành', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14344, N'Ninh Khánh', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14347, N'Ninh Nhất', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14350, N'Ninh Tiến', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14353, N'Ninh Phúc', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14356, N'Ninh Sơn', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14359, N'Ninh Phong', 369 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14362, N'Bắc Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14365, N'Trung Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14368, N'Nam Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14369, N'Tây Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14371, N'Yên Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14374, N'Yên Bình', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14375, N'Tân Bình', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14377, N'Quang Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14380, N'Đông Sơn', 370 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14383, N'Nho Quan', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14386, N'Xích Thổ', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14389, N'Gia Lâm', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14392, N'Gia Sơn', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14395, N'Thạch Bình', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14398, N'Gia Thủy', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14401, N'Gia Tường', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14404, N'Cúc Phương', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14407, N'Phú Sơn', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14410, N'Đức Long', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14413, N'Lạc Vân', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14416, N'Đồng Phong', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14419, N'Yên Quang', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14422, N'Lạng Phong', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14425, N'Thượng Hòa', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14428, N'Văn Phong', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14431, N'Văn Phương', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14434, N'Thanh Lạc', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14437, N'Sơn Lai', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14440, N'Sơn Thành', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14443, N'Văn Phú', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14446, N'Phú Lộc', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14449, N'Kỳ Phú', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14452, N'Quỳnh Lưu', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14455, N'Sơn Hà', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14458, N'Phú Long', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14461, N'Quảng Lạc', 372 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14464, N'Me', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14467, N'Gia Hòa', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14470, N'Gia Hưng', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14473, N'Liên Sơn', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14476, N'Gia Thanh', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14479, N'Gia Vân', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14482, N'Gia Phú', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14485, N'Gia Xuân', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14488, N'Gia Lập', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14491, N'Gia Vượng', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14494, N'Gia Trấn', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14497, N'Gia Thịnh', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14500, N'Gia Phương', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14503, N'Gia Tân', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14506, N'Gia Thắng', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14509, N'Gia Trung', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14512, N'Gia Minh', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14515, N'Gia Lạc', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14518, N'Gia Tiến', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14521, N'Gia Sinh', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14524, N'Gia Phong', 373 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14527, N'Thiên Tôn', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14530, N'Ninh Giang', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14533, N'Trường Yên', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14536, N'Ninh Khang', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14539, N'Ninh Mỹ', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14542, N'Ninh Hòa', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14545, N'Ninh Xuân', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14548, N'Ninh Hải', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14551, N'Ninh Thắng', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14554, N'Ninh Vân', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14557, N'Ninh An', 374 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14560, N'Yên Ninh', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14563, N'Khánh Tiên', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14566, N'Khánh Phú', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14569, N'Khánh Hòa', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14572, N'Khánh Lợi', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14575, N'Khánh An', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14578, N'Khánh Cường', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14581, N'Khánh Cư', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14584, N'Khánh Thiện', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14587, N'Khánh Hải', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14590, N'Khánh Trung', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14593, N'Khánh Mậu', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14596, N'Khánh Vân', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14599, N'Khánh Hội', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14602, N'Khánh Công', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14608, N'Khánh Thành', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14611, N'Khánh Nhạc', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14614, N'Khánh Thủy', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14617, N'Khánh Hồng', 375 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14620, N'Phát Diệm', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14623, N'Bình Minh', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14626, N'Xuân Thiện', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14629, N'Hồi Ninh', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14632, N'Chính Tâm', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14635, N'Kim Định', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14638, N'Ân Hòa', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14641, N'Hùng Tiến', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14644, N'Yên Mật', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14647, N'Quang Thiện', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14650, N'Như Hòa', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14653, N'Chất Bình', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14656, N'Đồng Hướng', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14659, N'Kim Chính', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14662, N'Thượng Kiệm', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14665, N'Lưu Phương', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14668, N'Tân Thành', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14671, N'Yên Lộc', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14674, N'Lai Thành', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14677, N'Định Hóa', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14680, N'Văn Hải', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14683, N'Kim Tân', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14686, N'Kim Mỹ', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14689, N'Cồn Thoi', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14692, N'Kim Hải', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14695, N'Kim Trung', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14698, N'Kim Đông', 376 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14701, N'Yên Thịnh', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14704, N'Khánh Thượng', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14707, N'Khánh Dương', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14710, N'Mai Sơn', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14713, N'Khánh Thịnh', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14719, N'Yên Phong', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14722, N'Yên Hòa', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14725, N'Yên Thắng', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14728, N'Yên Từ', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14731, N'Yên Hưng', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14734, N'Yên Thành', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14737, N'Yên Nhân', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14740, N'Yên Mỹ', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14743, N'Yên Mạc', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14746, N'Yên Đồng', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14749, N'Yên Thái', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14752, N'Yên Lâm', 377 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14755, N'Hàm Rồng', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14758, N'Đông Thọ', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14761, N'Nam Ngạn', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14764, N'Trường Thi', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14767, N'Điện Biên', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14770, N'Phú Sơn', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14773, N'Lam Sơn', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14776, N'Ba Đình', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14779, N'Ngọc Trạo', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14782, N'Đông Vệ', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14785, N'Đông Sơn', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14788, N'Tân Sơn', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14791, N'Đông Cương', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14794, N'Đông Hương', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14797, N'Đông Hải', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14800, N'Quảng Hưng', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14803, N'Quảng Thắng', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14806, N'Quảng Thành', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14809, N'Bắc Sơn', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14812, N'Ba Đình', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14815, N'Lam Sơn', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14818, N'Ngọc Trạo', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14821, N'Đông Sơn', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14823, N'Phú Sơn', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14824, N'Quang Trung', 381 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14830, N'Trung Sơn', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14833, N'Bắc Sơn', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14836, N'Trường Sơn', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14839, N'Quảng Cư', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14842, N'Quảng Tiến', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14845, N'Mường Lát', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14848, N'Tam Chung', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14854, N'Mường Lý', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14857, N'Trung Lý', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14860, N'Quang Chiểu', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14863, N'Pù Nhi', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14864, N'Nhi Sơn', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14866, N'Mường Chanh', 384 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14869, N'Hồi Xuân', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14872, N'Thành Sơn', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14875, N'Trung Sơn', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14878, N'Phú Thanh', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14881, N'Trung Thành', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14884, N'Phú Lệ', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14887, N'Phú Sơn', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14890, N'Phú Xuân', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14896, N'Hiền Chung', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14899, N'Hiền Kiệt', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14902, N'Nam Tiến', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14908, N'Thiên Phủ', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14911, N'Phú Nghiêm', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14914, N'Nam Xuân', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14917, N'Nam Động', 385 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14923, N'Cành Nàng', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14926, N'Điền Thượng', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14929, N'Điền Hạ', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14932, N'Điền Quang', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14935, N'Điền Trung', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14938, N'Thành Sơn', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14941, N'Lương Ngoại', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14944, N'Ái Thượng', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14947, N'Lương Nội', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14950, N'Điền Lư', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14953, N'Lương Trung', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14956, N'Lũng Niêm', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14959, N'Lũng Cao', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14962, N'Hạ Trung', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14965, N'Cổ Lũng', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14968, N'Thành Lâm', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14971, N'Ban Công', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14974, N'Kỳ Tân', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14977, N'Văn Nho', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14980, N'Thiết Ống', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14986, N'Thiết Kế', 386 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14992, N'Sơn Lư', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14995, N'Trung Xuân', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14998, N'Trung Thượng', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 14999, N'Trung Tiến', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15001, N'Trung Hạ', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15004, N'Sơn Hà', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15007, N'Tam Thanh', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15010, N'Sơn Thủy', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15013, N'Na Mèo', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15019, N'Tam Lư', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15022, N'Sơn Điện', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15025, N'Mường Mìn', 387 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15028, N'Lang Chánh', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15031, N'Yên Khương', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15034, N'Yên Thắng', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15037, N'Trí Nang', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15040, N'Giao An', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15043, N'Giao Thiện', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15046, N'Tân Phúc', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15049, N'Tam Văn', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15052, N'Lâm Phú', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15058, N'Đồng Lương', 388 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15061, N'Ngọc Lặc', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15064, N'Lam Sơn', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15067, N'Mỹ Tân', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15070, N'Thúy Sơn', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15073, N'Thạch Lập', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15076, N'Vân Âm', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15079, N'Cao Ngọc', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15085, N'Quang Trung', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15088, N'Đồng Thịnh', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15091, N'Ngọc Liên', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15094, N'Ngọc Sơn', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15097, N'Lộc Thịnh', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15100, N'Cao Thịnh', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15103, N'Ngọc Trung', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15106, N'Phùng Giáo', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15109, N'Phùng Minh', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15112, N'Phúc Thịnh', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15115, N'Nguyệt Ấn', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15118, N'Kiên Thọ', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15121, N'Minh Tiến', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15124, N'Minh Sơn', 389 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15127, N'Phong Sơn', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15133, N'Cẩm Thành', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15136, N'Cẩm Quý', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15139, N'Cẩm Lương', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15142, N'Cẩm Thạch', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15145, N'Cẩm Liên', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15148, N'Cẩm Giang', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15151, N'Cẩm Bình', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15154, N'Cẩm Tú', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15160, N'Cẩm Châu', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15163, N'Cẩm Tâm', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15169, N'Cẩm Ngọc', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15172, N'Cẩm Long', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15175, N'Cẩm Yên', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15178, N'Cẩm Tân', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15181, N'Cẩm Phú', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15184, N'Cẩm Vân', 390 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15187, N'Kim Tân', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15190, N'Vân Du', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15196, N'Thạch Lâm', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15199, N'Thạch Quảng', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15202, N'Thạch Tượng', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15205, N'Thạch Cẩm', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15208, N'Thạch Sơn', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15211, N'Thạch Bình', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15214, N'Thạch Định', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15217, N'Thạch Đồng', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15220, N'Thạch Long', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15223, N'Thành Mỹ', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15226, N'Thành Yên', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15229, N'Thành Vinh', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15232, N'Thành Minh', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15235, N'Thành Công', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15238, N'Thành Tân', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15241, N'Thành Trực', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15247, N'Thành Tâm', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15250, N'Thành An', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15253, N'Thành Thọ', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15256, N'Thành Tiến', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15259, N'Thành Long', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15265, N'Thành Hưng', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15268, N'Ngọc Trạo', 391 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15271, N'Hà Trung', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15274, N'Hà Long', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15277, N'Hà Vinh', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15280, N'Hà Bắc', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15283, N'Hoạt Giang', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15292, N'Hà Giang', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15295, N'Yên Dương', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15298, N'Lĩnh Toại', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15304, N'Hà Ngọc', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15307, N'Yến Sơn', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15313, N'Hà Sơn', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15316, N'Hà Lĩnh', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15319, N'Hà Đông', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15322, N'Hà Tân', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15325, N'Hà Tiến', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15328, N'Hà Bình', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15331, N'Hà Lai', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15334, N'Hà Châu', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15340, N'Hà Thái', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15343, N'Hà Hải', 392 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15346, N'Vĩnh Lộc', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15352, N'Vĩnh Quang', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15355, N'Vĩnh Yên', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15358, N'Vĩnh Tiến', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15361, N'Vĩnh Long', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15364, N'Vĩnh Phúc', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15367, N'Vĩnh Hưng', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15376, N'Vĩnh Hòa', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15379, N'Vĩnh Hùng', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15382, N'Minh Tân', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15385, N'Ninh Khang', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15388, N'Vĩnh Thịnh', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15391, N'Vĩnh An', 393 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15394, N'Quán Lào', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15397, N'Thống Nhất', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15400, N'Yên Phú', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15403, N'Yên Lâm', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15406, N'Yên Tâm', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15412, N'Quí Lộc', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15415, N'Yên Thọ', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15418, N'Yên Trung', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15421, N'Yên Trường', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15427, N'Yên Phong', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15430, N'Yên Thái', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15433, N'Yên Hùng', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15436, N'Yên Thịnh', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15439, N'Yên Ninh', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15442, N'Yên Lạc', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15445, N'Định Tăng', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15448, N'Định Hòa', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15451, N'Định Thành', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15454, N'Định Công', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15457, N'Định Tân', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15460, N'Định Tiến', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15463, N'Định Long', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15466, N'Định Liên', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15472, N'Định Hưng', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15475, N'Định Hải', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15478, N'Định Bình', 394 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15481, N'Thọ Xuân', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15484, N'Lam Sơn', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15487, N'Sao Vàng', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15493, N'Xuân Hồng', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15502, N'Bắc Lương', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15505, N'Nam Giang', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15508, N'Xuân Phong', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15511, N'Thọ Lộc', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15514, N'Xuân Trường', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15517, N'Xuân Hòa', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15520, N'Thọ Hải', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15523, N'Tây Hồ', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15526, N'Xuân Giang', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15532, N'Xuân Sinh', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15535, N'Xuân Hưng', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15538, N'Thọ Diên', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15541, N'Thọ Lâm', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15544, N'Thọ Xương', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15547, N'Xuân Bái', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15550, N'Xuân Phú', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15559, N'Xuân Thiên', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15565, N'Thuận Minh', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15568, N'Thọ Lập', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15571, N'Quảng Phú', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15574, N'Xuân Tín', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15577, N'Phú Xuân', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15583, N'Xuân Lai', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15586, N'Xuân Lập', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15592, N'Xuân Minh', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15598, N'Trường Xuân', 395 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15604, N'Thường Xuân', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15607, N'Bát Mọt', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15610, N'Yên Nhân', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15619, N'Xuân Lẹ', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15622, N'Vạn Xuân', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15628, N'Lương Sơn', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15631, N'Xuân Cao', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15634, N'Luận Thành', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15637, N'Luận Khê', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15640, N'Xuân Thắng', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15643, N'Xuân Lộc', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15649, N'Xuân Dương', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15652, N'Thọ Thanh', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15655, N'Ngọc Phụng', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15658, N'Xuân Chinh', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15661, N'Tân Thành', 396 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15664, N'Triệu Sơn', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15667, N'Thọ Sơn', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15670, N'Thọ Bình', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15673, N'Thọ Tiến', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15676, N'Hợp Lý', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15679, N'Hợp Tiến', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15682, N'Hợp Thành', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15685, N'Triệu Thành', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15688, N'Hợp Thắng', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15691, N'Minh Sơn', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15700, N'Dân Lực', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15703, N'Dân Lý', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15706, N'Dân Quyền', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15709, N'An Nông', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15712, N'Văn Sơn', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15715, N'Thái Hòa', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15718, N'Nưa', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15721, N'Đồng Lợi', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15724, N'Đồng Tiến', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15727, N'Đồng Thắng', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15730, N'Tiến Nông', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15733, N'Khuyến Nông', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15736, N'Xuân Thịnh', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15739, N'Xuân Lộc', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15742, N'Thọ Dân', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15745, N'Xuân Thọ', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15748, N'Thọ Tân', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15751, N'Thọ Ngọc', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15754, N'Thọ Cường', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15757, N'Thọ Phú', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15760, N'Thọ Vực', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15763, N'Thọ Thế', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15766, N'Nông Trường', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15769, N'Bình Sơn', 397 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15772, N'Thiệu Hóa', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15775, N'Thiệu Ngọc', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15778, N'Thiệu Vũ', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15781, N'Thiệu Phúc', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15784, N'Thiệu Tiến', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15787, N'Thiệu Công', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15790, N'Thiệu Phú', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15793, N'Thiệu Long', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15796, N'Thiệu Giang', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15799, N'Thiệu Duy', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15802, N'Thiệu Nguyên', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15805, N'Thiệu Hợp', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15808, N'Thiệu Thịnh', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15811, N'Thiệu Quang', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15814, N'Thiệu Thành', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15817, N'Thiệu Toán', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15820, N'Thiệu Chính', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15823, N'Thiệu Hòa', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15829, N'Minh Tâm', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15832, N'Thiệu Viên', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15835, N'Thiệu Lý', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15838, N'Thiệu Vận', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15841, N'Thiệu Trung', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15850, N'Thiệu Vân', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15853, N'Thiệu Giao', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15856, N'Thiệu Khánh', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15859, N'Thiệu Dương', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15862, N'Tân Châu', 398 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15865, N'Bút Sơn', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15868, N'Tào Xuyên', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15871, N'Hoằng Giang', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15874, N'Hoằng Xuân', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15880, N'Hoằng Phượng', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15883, N'Hoằng Phú', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15886, N'Hoằng Quỳ', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15889, N'Hoằng Kim', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15892, N'Hoằng Trung', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15895, N'Hoằng Trinh', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15898, N'Hoằng Sơn', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15904, N'Hoằng Xuyên', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15907, N'Hoằng Cát', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15916, N'Hoằng Quý', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15919, N'Hoằng Hợp', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15925, N'Hoằng Quang', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15934, N'Hoằng Đức', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15937, N'Hoằng Hà', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15940, N'Hoằng Đạt', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15946, N'Hoằng Đạo', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15949, N'Hoằng Thắng', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15952, N'Hoằng Đồng', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15955, N'Hoằng Thái', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15958, N'Hoằng Thịnh', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15961, N'Hoằng Thành', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15964, N'Hoằng Lộc', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15967, N'Hoằng Trạch', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15970, N'Hoằng Đại', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15973, N'Hoằng Phong', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15976, N'Hoằng Lưu', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15979, N'Hoằng Châu', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15982, N'Hoằng Tân', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15985, N'Hoằng Yến', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15988, N'Hoằng Tiến', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15991, N'Hoằng Hải', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15994, N'Hoằng Ngọc', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 15997, N'Hoằng Đông', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16000, N'Hoằng Thanh', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16003, N'Hoằng Phụ', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16006, N'Hoằng Trường', 399 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16009, N'Long Anh', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16012, N'Hậu Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16015, N'Đồng Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16018, N'Đại Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16021, N'Triệu Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16027, N'Tiến Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16030, N'Lộc Sơn', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16033, N'Cầu Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16036, N'Thành Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16039, N'Tuy Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16042, N'Phong Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16045, N'Mỹ Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16051, N'Thuần Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16057, N'Xuân Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16063, N'Hoa Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16066, N'Liên Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16069, N'Quang Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16072, N'Phú Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16075, N'Hòa Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16078, N'Minh Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16081, N'Hưng Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16084, N'Hải Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16087, N'Đa Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16090, N'Ngư Lộc', 400 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16093, N'Nga Sơn', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16096, N'Ba Đình', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16099, N'Nga Vịnh', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16102, N'Nga Văn', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16105, N'Nga Thiện', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16108, N'Nga Tiến', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16111, N'Nga Phượng', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16117, N'Nga Trung', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16120, N'Nga Bạch', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16123, N'Nga Thanh', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16132, N'Nga Yên', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16135, N'Nga Giáp', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16138, N'Nga Hải', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16141, N'Nga Thành', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16144, N'Nga An', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16147, N'Nga Phú', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16150, N'Nga Điền', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16153, N'Nga Tân', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16156, N'Nga Thủy', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16159, N'Nga Liên', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16162, N'Nga Thái', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16165, N'Nga Thạch', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16168, N'Nga Thắng', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16171, N'Nga Trường', 401 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16174, N'Yên Cát', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16177, N'Bãi Trành', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16180, N'Xuân Hòa', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16183, N'Xuân Bình', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16186, N'Hóa Quỳ', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16195, N'Cát Vân', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16198, N'Cát Tân', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16201, N'Tân Bình', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16204, N'Bình Lương', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16207, N'Thanh Quân', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16210, N'Thanh Xuân', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16213, N'Thanh Hòa', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16216, N'Thanh Phong', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16219, N'Thanh Lâm', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16222, N'Thanh Sơn', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16225, N'Thượng Ninh', 402 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16228, N'Bến Sung', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16231, N'Cán Khê', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16234, N'Xuân Du', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16240, N'Phượng Nghi', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16243, N'Mậu Lâm', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16246, N'Xuân Khang', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16249, N'Phú Nhuận', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16252, N'Hải Long', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16258, N'Xuân Thái', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16261, N'Xuân Phúc', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16264, N'Yên Thọ', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16267, N'Yên Lạc', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16273, N'Thanh Tân', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16276, N'Thanh Kỳ', 403 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16279, N'Nông Cống', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16282, N'Tân Phúc', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16285, N'Tân Thọ', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16288, N'Hoàng Sơn', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16291, N'Tân Khang', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16294, N'Hoàng Giang', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16297, N'Trung Chính', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16303, N'Trung Thành', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16309, N'Tế Thắng', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16315, N'Tế Lợi', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16318, N'Tế Nông', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16321, N'Minh Nghĩa', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16324, N'Minh Khôi', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16327, N'Vạn Hòa', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16330, N'Trường Trung', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16333, N'Vạn Thắng', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16336, N'Trường Giang', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16339, N'Vạn Thiện', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16342, N'Thăng Long', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16345, N'Trường Minh', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16348, N'Trường Sơn', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16351, N'Thăng Bình', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16354, N'Công Liêm', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16357, N'Tượng Văn', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16360, N'Thăng Thọ', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16363, N'Tượng Lĩnh', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16366, N'Tượng Sơn', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16369, N'Công Chính', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16375, N'Yên Mỹ', 404 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16378, N'Rừng Thông', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16379, N'An Hưng', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16381, N'Đông Hoàng', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16384, N'Đông Ninh', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16387, N'Đông Khê', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16390, N'Đông Hòa', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16393, N'Đông Yên', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16396, N'Đông Lĩnh', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16399, N'Đông Minh', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16402, N'Đông Thanh', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16405, N'Đông Tiến', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16414, N'Đông Thịnh', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16417, N'Đông Văn', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16420, N'Đông Phú', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16423, N'Đông Nam', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16426, N'Đông Quang', 405 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16429, N'Đông Vinh', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16432, N'Đông Tân', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16438, N'Tân Phong', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16441, N'Quảng Thịnh', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16447, N'Quảng Trạch', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16453, N'Quảng Đức', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16456, N'Quảng Định', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16459, N'Quảng Đông', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16462, N'Quảng Nhân', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16465, N'Quảng Ninh', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16468, N'Quảng Bình', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16471, N'Quảng Hợp', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16474, N'Quảng Văn', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16477, N'Quảng Long', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16480, N'Quảng Yên', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16483, N'Quảng Hòa', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16489, N'Quảng Khê', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16492, N'Quảng Trung', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16495, N'Quảng Chính', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16498, N'Quảng Ngọc', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16501, N'Quảng Trường', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16504, N'Quảng Phúc', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16507, N'Quảng Cát', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16513, N'Quảng Minh', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16516, N'Quảng Hùng', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16519, N'Quảng Giao', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16522, N'Quảng Phú', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16525, N'Quảng Tâm', 380 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16528, N'Quảng Thọ', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16531, N'Quảng Châu', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16534, N'Quảng Vinh', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16537, N'Quảng Đại', 382 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16540, N'Quảng Hải', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16543, N'Quảng Lưu', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16546, N'Quảng Lộc', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16549, N'Tiên Trang', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16552, N'Quảng Nham', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16555, N'Quảng Thạch', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16558, N'Quảng Thái', 406 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16561, N'Tĩnh Gia', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16564, N'Hải Châu', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16567, N'Thanh Thủy', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16570, N'Thanh Sơn', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16576, N'Hải Ninh', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16579, N'Anh Sơn', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16582, N'Ngọc Lĩnh', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16585, N'Hải An', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16591, N'Các Sơn', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16594, N'Tân Dân', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16597, N'Hải Lĩnh', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16600, N'Định Hải', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16603, N'Phú Sơn', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16606, N'Ninh Hải', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16609, N'Nguyên Bình', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16612, N'Hải Nhân', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16618, N'Bình Minh', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16621, N'Hải Thanh', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16624, N'Phú Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16627, N'Xuân Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16630, N'Trúc Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16633, N'Hải Bình', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16636, N'Tân Trường', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16639, N'Tùng Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16642, N'Tĩnh Hải', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16645, N'Mai Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16648, N'Trường Lâm', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16651, N'Hải Yến', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16654, N'Hải Thượng', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16657, N'Nghi Sơn', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16660, N'Hải Hà', 407 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16663, N'Đông Vĩnh', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16666, N'Hà Huy Tập', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16669, N'Lê Lợi', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16670, N'Quán Bàu', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16672, N'Hưng Bình', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16673, N'Hưng Phúc', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16675, N'Hưng Dũng', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16678, N'Cửa Nam', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16681, N'Quang Trung', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16684, N'Đội Cung', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16687, N'Lê Mao', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16690, N'Trường Thi', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16693, N'Bến Thủy', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16696, N'Hồng Sơn', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16699, N'Trung Đô', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16702, N'Nghi Phú', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16705, N'Hưng Đông', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16708, N'Hưng Lộc', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16711, N'Hưng Hòa', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16714, N'Vinh Tân', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16717, N'Nghi Thuỷ', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16720, N'Nghi Tân', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16723, N'Thu Thuỷ', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16726, N'Nghi Hòa', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16729, N'Nghi Hải', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16732, N'Nghi Hương', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16735, N'Nghi Thu', 413 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16738, N'Kim Sơn', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16741, N'Thông Thụ', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16744, N'Đồng Văn', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16747, N'Hạnh Dịch', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16750, N'Tiền Phong', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16753, N'Nậm Giải', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16756, N'Tri Lễ', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16759, N'Châu Kim', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16762, N'Mường Nọc', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16765, N'Châu Thôn', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16768, N'Nậm Nhoóng', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16771, N'Quang Phong', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16774, N'Căm Muộn', 415 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16777, N'Tân Lạc', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16780, N'Châu Bính', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16783, N'Châu Thuận', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16786, N'Châu Hội', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16789, N'Châu Nga', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16792, N'Châu Tiến', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16795, N'Châu Hạnh', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16798, N'Châu Thắng', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16801, N'Châu Phong', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16804, N'Châu Bình', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16807, N'Châu Hoàn', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16810, N'Diên Lãm', 416 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16813, N'Mường Xén', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16816, N'Mỹ Lý', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16819, N'Bắc Lý', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16822, N'Keng Đu', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16825, N'Đoọc Mạy', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16828, N'Huồi Tụ', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16831, N'Mường Lống', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16834, N'Na Loi', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16837, N'Nậm Cắn', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16840, N'Bảo Nam', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16843, N'Phà Đánh', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16846, N'Bảo Thắng', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16849, N'Hữu Lập', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16852, N'Tà Cạ', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16855, N'Chiêu Lưu', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16858, N'Mường Típ', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16861, N'Hữu Kiệm', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16864, N'Tây Sơn', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16867, N'Mường Ải', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16870, N'Na Ngoi', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16873, N'Nậm Càn', 417 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16876, N'Thạch Giám', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16879, N'Mai Sơn', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16882, N'Nhôn Mai', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16885, N'Hữu Khuông', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16900, N'Yên Tĩnh', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16903, N'Nga My', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16904, N'Xiêng My', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16906, N'Lưỡng Minh', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16909, N'Yên Hòa', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16912, N'Yên Na', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16915, N'Lưu Kiền', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16921, N'Xá Lượng', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16924, N'Tam Thái', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16927, N'Tam Đình', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16930, N'Yên Thắng', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16933, N'Tam Quang', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16936, N'Tam Hợp', 418 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16939, N'Hoà Hiếu', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16941, N'Nghĩa Đàn', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16942, N'Nghĩa Mai', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16945, N'Nghĩa Yên', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16948, N'Nghĩa Lạc', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16951, N'Nghĩa Lâm', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16954, N'Nghĩa Sơn', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16957, N'Nghĩa Lợi', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16960, N'Nghĩa Bình', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16963, N'Nghĩa Thọ', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16966, N'Nghĩa Minh', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16969, N'Nghĩa Phú', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16972, N'Nghĩa Hưng', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16975, N'Nghĩa Hồng', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16978, N'Nghĩa Thịnh', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16981, N'Nghĩa Trung', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16984, N'Nghĩa Hội', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16993, N'Quang Phong', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16994, N'Quang Tiến', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16996, N'Nghĩa Hiếu', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 16999, N'Nghĩa Thành', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17003, N'Long Sơn', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17005, N'Nghĩa Tiến', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17008, N'Nghĩa Mỹ', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17011, N'Tây Hiếu', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17014, N'Nghĩa Thuận', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17017, N'Đông Hiếu', 414 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17020, N'Nghĩa Đức', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17023, N'Nghĩa An', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17026, N'Nghĩa Long', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17029, N'Nghĩa Lộc', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17032, N'Nghĩa Khánh', 419 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17035, N'Quỳ Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17038, N'Yên Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17041, N'Châu Tiến', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17044, N'Châu Hồng', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17047, N'Đồng Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17050, N'Châu Thành', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17053, N'Liên Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17056, N'Châu Lộc', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17059, N'Tam Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17062, N'Châu Cường', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17065, N'Châu Quang', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17068, N'Thọ Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17071, N'Minh Hợp', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17074, N'Nghĩa Xuân', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17077, N'Châu Thái', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17080, N'Châu Đình', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17083, N'Văn Lợi', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17086, N'Nam Sơn', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17089, N'Châu Lý', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17092, N'Hạ Sơn', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17095, N'Bắc Sơn', 420 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17098, N'Cầu Giát', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17101, N'Quỳnh Thắng', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17104, N'Quỳnh Vinh', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17107, N'Quỳnh Lộc', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17110, N'Quỳnh Thiện', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17113, N'Quỳnh Lập', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17116, N'Quỳnh Trang', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17119, N'Quỳnh Tân', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17122, N'Quỳnh Châu', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17125, N'Mai Hùng', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17128, N'Quỳnh Dị', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17131, N'Quỳnh Xuân', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17134, N'Quỳnh Phương', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17137, N'Quỳnh Liên', 432 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17140, N'Tân Sơn', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17143, N'Quỳnh Văn', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17146, N'Ngọc Sơn', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17149, N'Quỳnh Tam', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17152, N'Quỳnh Hoa', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17155, N'Quỳnh Thạch', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17158, N'Quỳnh Bảng', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17161, N'Quỳnh Mỹ', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17164, N'Quỳnh Thanh', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17167, N'Quỳnh Hậu', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17170, N'Quỳnh Lâm', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17173, N'Quỳnh Đôi', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17176, N'Quỳnh Lương', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17179, N'Quỳnh Hồng', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17182, N'Quỳnh Yên', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17185, N'Quỳnh Bá', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17188, N'Quỳnh Minh', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17191, N'Quỳnh Diễn', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17194, N'Quỳnh Hưng', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17197, N'Quỳnh Giang', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17200, N'Quỳnh Ngọc', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17203, N'Quỳnh Nghĩa', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17206, N'An Hòa', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17209, N'Tiến Thủy', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17212, N'Sơn Hải', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17215, N'Quỳnh Thọ', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17218, N'Quỳnh Thuận', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17221, N'Quỳnh Long', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17224, N'Tân Thắng', 421 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17227, N'Con Cuông', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17230, N'Bình Chuẩn', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17233, N'Lạng Khê', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17236, N'Cam Lâm', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17239, N'Thạch Ngàn', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17242, N'Đôn Phục', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17245, N'Mậu Đức', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17248, N'Châu Khê', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17251, N'Chi Khê', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17254, N'Bồng Khê', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17257, N'Yên Khê', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17260, N'Lục Dạ', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17263, N'Môn Sơn', 422 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17266, N'Tân Kỳ', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17269, N'Tân Hợp', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17272, N'Tân Phú', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17275, N'Tân Xuân', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17278, N'Giai Xuân', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17281, N'Nghĩa Bình', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17284, N'Nghĩa Đồng', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17287, N'Đồng Văn', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17290, N'Nghĩa Thái', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17293, N'Nghĩa Hợp', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17296, N'Nghĩa Hoàn', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17299, N'Nghĩa Phúc', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17302, N'Tiên Kỳ', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17305, N'Tân An', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17308, N'Nghĩa Dũng', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17311, N'Tân Long', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17314, N'Kỳ Sơn', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17317, N'Hương Sơn', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17320, N'Kỳ Tân', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17323, N'Phú Sơn', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17325, N'Tân Hương', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17326, N'Nghĩa Hành', 423 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17329, N'Anh Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17332, N'Thọ Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17335, N'Thành Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17338, N'Bình Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17341, N'Tam Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17344, N'Đỉnh Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17347, N'Hùng Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17350, N'Cẩm Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17353, N'Đức Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17356, N'Tường Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17357, N'Hoa Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17359, N'Tào Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17362, N'Vĩnh Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17365, N'Lạng Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17368, N'Hội Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17371, N'Thạch Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17374, N'Phúc Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17377, N'Long Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17380, N'Khai Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17383, N'Lĩnh Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17386, N'Cao Sơn', 424 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17389, N'Diễn Châu', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17392, N'Diễn Lâm', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17395, N'Diễn Đoài', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17398, N'Diễn Trường', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17401, N'Diễn Yên', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17404, N'Diễn Hoàng', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17407, N'Diễn Hùng', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17410, N'Diễn Mỹ', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17413, N'Diễn Hồng', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17416, N'Diễn Phong', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17419, N'Diễn Hải', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17422, N'Diễn Tháp', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17425, N'Diễn Liên', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17428, N'Diễn Vạn', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17431, N'Diễn Kim', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17434, N'Diễn Kỷ', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17437, N'Diễn Xuân', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17440, N'Diễn Thái', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17443, N'Diễn Đồng', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17446, N'Diễn Bích', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17449, N'Diễn Hạnh', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17452, N'Diễn Ngọc', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17455, N'Diễn Quảng', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17458, N'Diễn Nguyên', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17461, N'Diễn Hoa', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17464, N'Diễn Thành', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17467, N'Diễn Phúc', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17476, N'Diễn Cát', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17479, N'Diễn Thịnh', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17482, N'Diễn Tân', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17485, N'Minh Châu', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17488, N'Diễn Thọ', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17491, N'Diễn Lợi', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17494, N'Diễn Lộc', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17497, N'Diễn Trung', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17500, N'Diễn An', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17503, N'Diễn Phú', 425 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17506, N'Yên Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17509, N'Mã Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17510, N'Tiến Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17512, N'Lăng Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17515, N'Tân Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17518, N'Đức Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17521, N'Kim Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17524, N'Hậu Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17525, N'Hùng Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17527, N'Đô Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17530, N'Thọ Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17533, N'Quang Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17536, N'Tây Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17539, N'Phúc Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17542, N'Hồng Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17545, N'Đồng Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17548, N'Phú Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17551, N'Hoa Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17554, N'Tăng Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17557, N'Văn Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17560, N'Thịnh Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17563, N'Hợp Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17566, N'Xuân Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17569, N'Bắc Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17572, N'Nhân Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17575, N'Trung Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17578, N'Long Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17581, N'Minh Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17584, N'Nam Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17587, N'Vĩnh Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17590, N'Lý Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17593, N'Khánh Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17596, N'Viên Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17599, N'Đại Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17602, N'Liên Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17605, N'Bảo Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17608, N'Mỹ Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17611, N'Công Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17614, N'Sơn Thành', 426 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17617, N'Đô Lương', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17619, N'Giang Sơn Đông', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17620, N'Giang Sơn Tây', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17623, N'Lam Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17626, N'Bồi Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17629, N'Hồng Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17632, N'Bài Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17635, N'Ngọc Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17638, N'Bắc Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17641, N'Tràng Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17644, N'Thượng Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17647, N'Hòa Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17650, N'Đặng Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17653, N'Đông Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17656, N'Nam Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17659, N'Lưu Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17662, N'Yên Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17665, N'Văn Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17668, N'Đà Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17671, N'Lạc Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17674, N'Tân Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17677, N'Thái Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17680, N'Quang Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17683, N'Thịnh Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17686, N'Trung Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17689, N'Xuân Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17692, N'Minh Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17695, N'Thuận Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17698, N'Nhân Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17701, N'Hiến Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17704, N'Mỹ Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17707, N'Trù Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17710, N'Đại Sơn', 427 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17713, N'Thanh Chương', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17716, N'Cát Văn', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17719, N'Thanh Nho', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17722, N'Hạnh Lâm', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17723, N'Thanh Sơn', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17725, N'Thanh Hòa', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17728, N'Phong Thịnh', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17731, N'Thanh Phong', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17734, N'Thanh Mỹ', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17737, N'Thanh Tiên', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17743, N'Thanh Liên', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17749, N'Đại Đồng', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17752, N'Thanh Đồng', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17755, N'Thanh Ngọc', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17758, N'Thanh Hương', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17759, N'Ngọc Lâm', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17761, N'Thanh Lĩnh', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17764, N'Đồng Văn', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17767, N'Ngọc Sơn', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17770, N'Thanh Thịnh', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17773, N'Thanh An', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17776, N'Thanh Chi', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17779, N'Xuân Tường', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17782, N'Thanh Dương', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17785, N'Thanh Lương', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17788, N'Thanh Khê', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17791, N'Võ Liệt', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17794, N'Thanh Long', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17797, N'Thanh Thủy', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17800, N'Thanh Khai', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17803, N'Thanh Yên', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17806, N'Thanh Hà', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17809, N'Thanh Giang', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17812, N'Thanh Tùng', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17815, N'Thanh Lâm', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17818, N'Thanh Mai', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17821, N'Thanh Xuân', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17824, N'Thanh Đức', 428 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17827, N'Quán Hành', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17830, N'Nghi Văn', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17833, N'Nghi Yên', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17836, N'Nghi Tiến', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17839, N'Nghi Hưng', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17842, N'Nghi Đồng', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17845, N'Nghi Thiết', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17848, N'Nghi Lâm', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17851, N'Nghi Quang', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17854, N'Nghi Kiều', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17857, N'Nghi Mỹ', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17860, N'Nghi Phương', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17863, N'Nghi Thuận', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17866, N'Nghi Long', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17869, N'Nghi Xá', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17875, N'Nghi Hoa', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17878, N'Khánh Hợp', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17881, N'Nghi Thịnh', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17884, N'Nghi Công Bắc', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17887, N'Nghi Công Nam', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17890, N'Nghi Thạch', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17893, N'Nghi Trung', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17896, N'Nghi Trường', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17899, N'Nghi Diên', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17902, N'Nghi Phong', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17905, N'Nghi Xuân', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17908, N'Nghi Liên', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17911, N'Nghi Vạn', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17914, N'Nghi Ân', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17917, N'Phúc Thọ', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17920, N'Nghi Kim', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17923, N'Nghi Đức', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17926, N'Nghi Thái', 429 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17929, N'Nam Đàn', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17932, N'Nam Hưng', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17935, N'Nam Nghĩa', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17938, N'Nam Thanh', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17941, N'Nam Anh', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17944, N'Nam Xuân', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17947, N'Nam Thái', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17953, N'Nam Lĩnh', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17956, N'Nam Giang', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17959, N'Xuân Hòa', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17962, N'Hùng Tiến', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17971, N'Kim Liên', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17974, N'Thượng Tân Lộc', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17977, N'Hồng Long', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17980, N'Xuân Lâm', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17983, N'Nam Cát', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17986, N'Khánh Sơn', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17995, N'Trung Phúc Cường', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 17998, N'Nam Kim', 430 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18001, N'Hưng Nguyên', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18004, N'Hưng Trung', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18007, N'Hưng Yên', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18008, N'Hưng Yên Bắc', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18010, N'Hưng Tây', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18013, N'Hưng Chính', 412 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18016, N'Hưng Đạo', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18019, N'Hưng Mỹ', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18022, N'Hưng Thịnh', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18025, N'Hưng Lĩnh', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18028, N'Hưng Thông', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18031, N'Hưng Tân', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18034, N'Hưng Lợi', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18037, N'Hưng Nghĩa', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18040, N'Hưng Phúc', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18043, N'Long Xá', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18058, N'Châu Nhân', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18061, N'Hưng Thành', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18067, N'Xuân Lam', 431 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18070, N'Trần Phú', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18073, N'Nam Hà', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18076, N'Bắc Hà', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18077, N'Nguyễn Du', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18079, N'Tân Giang', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18082, N'Đại Nài', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18085, N'Hà Huy Tập', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18088, N'Thạch Trung', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18091, N'Thạch Quý', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18094, N'Thạch Linh', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18097, N'Văn Yên', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18100, N'Thạch Hạ', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18103, N'Đồng Môn', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18109, N'Thạch Hưng', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18112, N'Thạch Bình', 436 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18115, N'Bắc Hồng', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18118, N'Nam Hồng', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18121, N'Trung Lương', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18124, N'Đức Thuận', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18127, N'Đậu Liêu', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18130, N'Thuận Lộc', 437 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18133, N'Phố Châu', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18136, N'Tây Sơn', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18139, N'Sơn Hồng', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18142, N'Sơn Tiến', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18145, N'Sơn Lâm', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18148, N'Sơn Lễ', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18151, N'An Hòa Thịnh', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18157, N'Sơn Giang', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18160, N'Sơn Lĩnh', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18166, N'Tân Mỹ Hà', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18172, N'Sơn Tây', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18175, N'Sơn Ninh', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18178, N'Sơn Châu', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18187, N'Sơn Trung', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18190, N'Sơn Bằng', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18193, N'Sơn Bình', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18196, N'Sơn Kim 1', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18199, N'Sơn Kim 2', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18202, N'Sơn Trà', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18205, N'Sơn Long', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18208, N'Quang Diệm', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18211, N'Kim Hoa', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18214, N'Sơn Hàm', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18217, N'Sơn Phú', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18223, N'Sơn Trường', 439 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18229, N'Đức Thọ', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18232, N'Quang Vĩnh', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18238, N'Tùng Châu', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18244, N'Trường Sơn', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18247, N'Liên Minh', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18253, N'Yên Hồ', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18259, N'Tùng Ảnh', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18262, N'Bùi La Nhân', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18280, N'Hòa Lạc', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18283, N'Tân Dân', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18286, N'Lâm Trung Thủy', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18289, N'Thanh Bình Thịnh', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18298, N'An Dũng', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18304, N'Đức Đồng', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18307, N'Đức Lạng', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18310, N'Tân Hương', 440 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18313, N'Vũ Quang', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18316, N'Ân Phú', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18319, N'Đức Giang', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18322, N'Đức Lĩnh', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18328, N'Đức Hương', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18331, N'Đức Bồng', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18334, N'Đức Liên', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18337, N'Thọ Điền', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18340, N'Hương Minh', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18346, N'Quang Thọ', 441 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18349, N'Tiên Điền', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18352, N'Xuân An', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18355, N'Xuân Hội', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18358, N'Đan Trường', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18364, N'Xuân Phổ', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18367, N'Xuân Hải', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18370, N'Xuân Giang', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18376, N'Xuân Yên', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18379, N'Xuân Mỹ', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18382, N'Xuân Thành', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18385, N'Xuân Viên', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18388, N'Xuân Hồng', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18391, N'Cỗ Đạm', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18394, N'Xuân Liên', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18397, N'Xuân Lĩnh', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18400, N'Xuân Lam', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18403, N'Cương Gián', 442 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18406, N'Nghèn', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18409, N'Tân Lộc', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18412, N'Hồng Lộc', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18415, N'Thiên Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18418, N'Thuần Thiện', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18421, N'Thịnh Lộc', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18424, N'Kim Song Trường', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18427, N'Vượng Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18430, N'Bình An', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18433, N'Thanh Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18439, N'Thường Nga', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18445, N'Tùng Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18454, N'Phú Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18457, N'Ích Hậu', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18460, N'Khánh Vĩnh Yên', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18463, N'Gia Hanh', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18472, N'Trung Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18475, N'Xuân Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18478, N'Thượng Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18481, N'Quang Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18484, N'Đồng Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18487, N'Mỹ Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18490, N'Sơn Lộc', 443 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18493, N'Phù Lưu', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18496, N'Hương Khê', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18499, N'Điền Mỹ', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18502, N'Hà Linh', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18505, N'Hương Thủy', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18508, N'Hòa Hải', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18514, N'Phúc Đồng', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18517, N'Hương Giang', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18520, N'Lộc Yên', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18523, N'Hương Bình', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18526, N'Hương Long', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18529, N'Phú Gia', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18532, N'Gia Phố', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18535, N'Phú Phong', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18538, N'Hương Đô', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18541, N'Hương Vĩnh', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18544, N'Hương Xuân', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18547, N'Phúc Trạch', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18550, N'Hương Trà', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18553, N'Hương Trạch', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18556, N'Hương Lâm', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18559, N'Hương Liên', 444 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18562, N'Thạch Hà', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18565, N'Ngọc Sơn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18568, N'Lộc Hà', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18571, N'Thạch Hải', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18574, N'Đỉnh Bàn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18577, N'Thạch Mỹ', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18580, N'Thạch Kim', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18583, N'Thạch Châu', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18586, N'Thạch Kênh', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18589, N'Thạch Sơn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18592, N'Thạch Liên', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18598, N'Hộ Độ', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18604, N'Thạch Khê', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18607, N'Thạch Long', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18613, N'Việt Tiến', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18619, N'Thạch Trị', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18622, N'Thạch Lạc', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18625, N'Thạch Ngọc', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18628, N'Tượng Sơn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18631, N'Thạch Văn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18637, N'Thạch Thắng', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18643, N'Thạch Đài', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18646, N'Lưu Vĩnh Sơn', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18649, N'Thạch Hội', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18652, N'Tân Lâm Hương', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18658, N'Thạch Xuân', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18667, N'Nam Điền', 445 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18670, N'Mai Phụ', 448 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18673, N'Cẩm Xuyên', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18676, N'Thiên Cầm', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18679, N'Yên Hòa', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18682, N'Cẩm Dương', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18685, N'Cẩm Bình', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18691, N'Cẩm Vĩnh', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18694, N'Cẩm Thành', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18697, N'Cẩm Quang', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18700, N'Nam Phúc Thăng', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18706, N'Cẩm Thạch', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18709, N'Cẩm Nhượng', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18715, N'Cẩm Duệ', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18721, N'Cẩm Lĩnh', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18724, N'Cẩm Quan', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18727, N'Cẩm Hà', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18730, N'Cẩm Lộc', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18733, N'Cẩm Hưng', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18736, N'Cẩm Thịnh', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18739, N'Cẩm Mỹ', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18742, N'Cẩm Trung', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18745, N'Cẩm Sơn', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18748, N'Cẩm Lạc', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18751, N'Cẩm Minh', 446 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18754, N'Hưng Trí', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18757, N'Kỳ Xuân', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18760, N'Kỳ Bắc', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18763, N'Kỳ Phú', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18766, N'Kỳ Phong', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18769, N'Kỳ Tiến', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18772, N'Kỳ Giang', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18775, N'Kỳ Đồng', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18778, N'Kỳ Khang', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18781, N'Kỳ Ninh', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18784, N'Kỳ Văn', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18787, N'Kỳ Trung', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18790, N'Kỳ Thọ', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18793, N'Kỳ Tây', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18796, N'Kỳ Lợi', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18799, N'Kỳ Thượng', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18802, N'Kỳ Hải', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18805, N'Kỳ Thư', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18808, N'Kỳ Hà', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18811, N'Kỳ Châu', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18814, N'Kỳ Tân', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18820, N'Kỳ Trinh', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18823, N'Kỳ Thịnh', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18829, N'Kỳ Hoa', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18832, N'Kỳ Phương', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18835, N'Kỳ Long', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18838, N'Lâm Hợp', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18841, N'Kỳ Liên', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18844, N'Kỳ Sơn', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18847, N'Kỳ Nam', 449 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18850, N'Kỳ Lạc', 447 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18853, N'Hải Thành', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18856, N'Đồng Phú', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18859, N'Bắc Lý', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18862, N'Đồng Mỹ', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18865, N'Nam Lý', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18868, N'Hải Đình', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18871, N'Đồng Sơn', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18874, N'Phú Hải', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18877, N'Bắc Nghĩa', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18880, N'Đức Ninh Đông', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18883, N'Quang Phú', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18886, N'Lộc Ninh', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18889, N'Bảo Ninh', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18892, N'Nghĩa Ninh', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18895, N'Thuận Đức', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18898, N'Đức Ninh', 450 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18901, N'Quy Đạt', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18904, N'Dân Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18907, N'Trọng Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18910, N'Hóa Phúc', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18913, N'Hồng Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18916, N'Hóa Thanh', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18919, N'Hóa Tiến', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18922, N'Hóa Hợp', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18925, N'Xuân Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18928, N'Yên Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18931, N'Minh Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18934, N'Tân Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18937, N'Hóa Sơn', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18940, N'Quy Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18943, N'Trung Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18946, N'Thượng Hóa', 452 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18949, N'Đồng Lê', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18952, N'Hương Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18955, N'Kim Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18958, N'Thanh Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18961, N'Thanh Thạch', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18964, N'Thuận Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18967, N'Lâm Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18970, N'Lê Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18973, N'Sơn Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18976, N'Đồng Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18979, N'Ngư Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18982, N'Nam Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18985, N'Thạch Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18988, N'Đức Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18991, N'Phong Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18994, N'Mai Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 18997, N'Tiến Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19000, N'Châu Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19003, N'Cao Quảng', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19006, N'Văn Hóa', 453 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19009, N'Ba Đồn', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19012, N'Quảng Hợp', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19015, N'Quảng Kim', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19018, N'Quảng Đông', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19021, N'Quảng Phú', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19024, N'Quảng Châu', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19027, N'Quảng Thạch', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19030, N'Quảng Lưu', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19033, N'Quảng Tùng', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19036, N'Cảnh Dương', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19039, N'Quảng Tiến', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19042, N'Quảng Hưng', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19045, N'Quảng Xuân', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19048, N'Cảnh Hóa', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19051, N'Quảng Liên', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19054, N'Quảng Trường', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19057, N'Quảng Phương', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19060, N'Quảng Long', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19063, N'Phù Hóa', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19066, N'Quảng Thọ', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19069, N'Quảng Tiên', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19072, N'Quảng Thanh', 454 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19075, N'Quảng Trung', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19078, N'Quảng Phong', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19081, N'Quảng Thuận', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19084, N'Quảng Tân', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19087, N'Quảng Hải', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19090, N'Quảng Sơn', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19093, N'Quảng Lộc', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19096, N'Quảng Thủy', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19099, N'Quảng Văn', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19102, N'Quảng Phúc', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19105, N'Quảng Hòa', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19108, N'Quảng Minh', 458 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19111, N'Hoàn Lão', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19114, N'NT Việt Trung', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19117, N'Xuân Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19120, N'Mỹ Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19123, N'Hạ Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19126, N'Bắc Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19129, N'Lâm Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19132, N'Thanh Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19135, N'Liên Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19138, N'Phúc Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19141, N'Cự Nẫm', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19144, N'Hải Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19147, N'Thượng Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19150, N'Sơn Lộc', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19153, N'Phú Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19156, N'Hưng Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19159, N'Đồng Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19162, N'Đức Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19165, N'Sơn Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19168, N'Vạn Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19171, N'Hoàn Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19174, N'Phú Định', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19177, N'Trung Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19180, N'Tây Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19183, N'Hòa Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19186, N'Đại Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19189, N'Nhân Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19192, N'Tân Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19195, N'Nam Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19198, N'Lý Trạch', 455 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19201, N'Quán Hàu', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19204, N'Trường Sơn', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19207, N'Lương Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19210, N'Vĩnh Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19213, N'Võ Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19216, N'Hải Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19219, N'Hàm Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19222, N'Duy Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19225, N'Gia Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19228, N'Trường Xuân', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19231, N'Hiền Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19234, N'Tân Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19237, N'Xuân Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19240, N'An Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19243, N'Vạn Ninh', 456 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19246, N'NT Lệ Ninh', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19249, N'Kiến Giang', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19252, N'Hồng Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19255, N'Ngư Thủy Bắc', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19258, N'Hoa Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19261, N'Thanh Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19264, N'An Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19267, N'Phong Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19270, N'Cam Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19273, N'Ngân Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19276, N'Sơn Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19279, N'Lộc Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19282, N'Ngư Thủy Trung', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19285, N'Liên Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19288, N'Hưng Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19291, N'Dương Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19294, N'Tân Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19297, N'Phú Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19300, N'Xuân Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19303, N'Mỹ Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19306, N'Ngư Thủy Nam', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19309, N'Mai Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19312, N'Sen Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19315, N'Thái Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19318, N'Kim Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19321, N'Trường Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19324, N'Văn Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19327, N'Lâm Thủy', 457 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19330, N'Đông Giang', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19333, N'1', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19336, N'Đông Lễ', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19339, N'Đông Thanh', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19342, N'2', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19345, N'4', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19348, N'5', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19351, N'Đông Lương', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19354, N'3', 461 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19357, N'1', 462 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19358, N'An Đôn', 462 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19360, N'2', 462 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19361, N'3', 462 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19363, N'Hồ Xá', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19366, N'Bến Quan', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19369, N'Vĩnh Thái', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19372, N'Vĩnh Tú', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19375, N'Vĩnh Chấp', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19378, N'Trung Nam', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19381, N'Kim Thạch', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19387, N'Vĩnh Long', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19393, N'Vĩnh Khê', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19396, N'Vĩnh Hòa', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19402, N'Vĩnh Thủy', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19405, N'Vĩnh Lâm', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19408, N'Hiền Thành', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19414, N'Cửa Tùng', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19417, N'Vĩnh Hà', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19420, N'Vĩnh Sơn', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19423, N'Vĩnh Giang', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19426, N'Vĩnh Ô', 464 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19429, N'Khe Sanh', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19432, N'Lao Bảo', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19435, N'Hướng Lập', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19438, N'Hướng Việt', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19441, N'Hướng Phùng', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19444, N'Hướng Sơn', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19447, N'Hướng Linh', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19450, N'Tân Hợp', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19453, N'Hướng Tân', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19456, N'Tân Thành', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19459, N'Tân Long', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19462, N'Tân Lập', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19465, N'Tân Liên', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19468, N'Húc', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19471, N'Thuận', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19474, N'Hướng Lộc', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19477, N'Ba Tầng', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19480, N'Thanh', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19483, N'A Dơi', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19486, N'Lìa', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19492, N'Xy', 465 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19495, N'Gio Linh', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19496, N'Cửa Việt', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19498, N'Trung Giang', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19501, N'Trung Hải', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19504, N'Trung Sơn', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19507, N'Phong Bình', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19510, N'Gio Mỹ', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19519, N'Gio Hải', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19522, N'Gio An', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19525, N'Gio Châu', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19531, N'Gio Việt', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19534, N'Linh Trường', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19537, N'Gio Sơn', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19543, N'Gio Mai', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19546, N'Hải Thái', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19549, N'Linh Hải', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19552, N'Gio Quang', 466 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19555, N'Krông Klang', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19558, N'Mò Ó', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19561, N'Hướng Hiệp', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19564, N'Đa Krông', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19567, N'Triệu Nguyên', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19570, N'Ba Lòng', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19576, N'Ba Nang', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19579, N'Tà Long', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19582, N'Húc Nghì', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19585, N'A Vao', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19588, N'Tà Rụt', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19591, N'A Bung', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19594, N'A Ngo', 467 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19597, N'Cam Lộ', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19600, N'Cam Tuyền', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19603, N'Thanh An', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19606, N'Cam Thủy', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19612, N'Cam Thành', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19615, N'Cam Hiếu', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19618, N'Cam Chính', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19621, N'Cam Nghĩa', 468 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19624, N'Ái Tử', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19627, N'Triệu An', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19630, N'Triệu Vân', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19633, N'Triệu Phước', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19636, N'Triệu Độ', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19639, N'Triệu Trạch', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19642, N'Triệu Thuận', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19645, N'Triệu Đại', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19648, N'Triệu Hòa', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19651, N'Triệu Lăng', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19654, N'Triệu Sơn', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19657, N'Triệu Long', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19660, N'Triệu Tài', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19666, N'Triệu Trung', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19669, N'Triệu Ái', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19672, N'Triệu Thượng', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19675, N'Triệu Giang', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19678, N'Triệu Thành', 469 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19681, N'Diên Sanh', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19684, N'Hải An', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19687, N'Hải Ba', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19693, N'Hải Quy', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19696, N'Hải Quế', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19699, N'Hải Hưng', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19702, N'Hải Phú', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19705, N'Hải Lệ', 462 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19708, N'Hải Thượng', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19711, N'Hải Dương', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19714, N'Hải Định', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19717, N'Hải Lâm', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19723, N'Hải Phong', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19729, N'Hải Trường', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19735, N'Hải Sơn', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19738, N'Hải Chánh', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19741, N'Hải Khê', 470 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19744, N'Phú Thuận', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19747, N'Phú Bình', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19750, N'Tây Lộc', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19753, N'Thuận Lộc', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19756, N'Phú Hiệp', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19759, N'Phú Hậu', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19762, N'Thuận Hòa', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19765, N'Thuận Thành', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19768, N'Phú Hòa', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19771, N'Phú Cát', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19774, N'Kim Long', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19777, N'Vĩ Dạ', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19780, N'Phường Đúc', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19783, N'Vĩnh Ninh', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19786, N'Phú Hội', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19789, N'Phú Nhuận', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19792, N'Xuân Phú', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19795, N'Trường An', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19798, N'Phước Vĩnh', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19801, N'An Cựu', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19803, N'An Hòa', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19804, N'Hương Sơ', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19807, N'Thuỷ Biều', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19810, N'Hương Long', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19813, N'Thuỷ Xuân', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19815, N'An Đông', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19816, N'An Tây', 474 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19819, N'Phong Điền', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19822, N'Điền Hương', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19825, N'Điền Môn', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19828, N'Điền Lộc', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19831, N'Phong Bình', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19834, N'Điền Hòa', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19837, N'Phong Chương', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19840, N'Phong Hải', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19843, N'Điền Hải', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19846, N'Phong Hòa', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19849, N'Phong Thu', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19852, N'Phong Hiền', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19855, N'Phong Mỹ', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19858, N'Phong An', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19861, N'Phong Xuân', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19864, N'Phong Sơn', 476 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19867, N'Sịa', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19870, N'Quảng Thái', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19873, N'Quảng Ngạn', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19876, N'Quảng Lợi', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19879, N'Quảng Công', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19882, N'Quảng Phước', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19885, N'Quảng Vinh', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19888, N'Quảng An', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19891, N'Quảng Thành', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19894, N'Quảng Thọ', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19897, N'Quảng Phú', 477 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19900, N'Thuận An', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19903, N'Phú Thuận', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19906, N'Phú Dương', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19909, N'Phú Mậu', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19912, N'Phú An', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19915, N'Phú Hải', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19918, N'Phú Xuân', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19921, N'Phú Diên', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19924, N'Phú Thanh', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19927, N'Phú Mỹ', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19930, N'Phú Thượng', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19933, N'Phú Hồ', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19936, N'Vinh Xuân', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19939, N'Phú Lương', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19942, N'Phú Đa', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19945, N'Vinh Thanh', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19948, N'Vinh An', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19954, N'Phú Gia', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19957, N'Vinh Hà', 478 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19960, N'Phú Bài', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19963, N'Thủy Vân', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19966, N'Thủy Thanh', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19969, N'Thủy Dương', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19972, N'Thủy Phương', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19975, N'Thủy Châu', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19978, N'Thủy Lương', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19981, N'Thủy Bằng', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19984, N'Thủy Tân', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19987, N'Thủy Phù', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19990, N'Phú Sơn', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19993, N'Dương Hòa', 479 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19996, N'Tứ Hạ', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 19999, N'Hải Dương', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20002, N'Hương Phong', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20005, N'Hương Toàn', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20008, N'Hương Vân', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20011, N'Hương Văn', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20014, N'Hương Vinh', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20017, N'Hương Xuân', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20020, N'Hương Chữ', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20023, N'Hương An', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20026, N'Hương Bình', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20029, N'Hương Hồ', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20032, N'Hương Thọ', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20035, N'Bình Tiến', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20041, N'Bình Thành', 480 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20044, N'A Lưới', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20047, N'Hồng Vân', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20050, N'Hồng Hạ', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20053, N'Hồng Kim', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20056, N'Trung Sơn', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20059, N'Hương Nguyên', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20065, N'Hồng Bắc', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20068, N'A Ngo', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20071, N'Sơn Thủy', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20074, N'Phú Vinh', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20080, N'Hương Phong', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20083, N'Quảng Nhâm', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20086, N'Hồng Thượng', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20089, N'Hồng Thái', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20092, N'Lâm Đớt', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20095, N'A Roằng', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20098, N'Đông Sơn', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20104, N'Hồng Thủy', 481 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20107, N'Phú Lộc', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20110, N'Lăng Cô', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20113, N'Vinh Mỹ', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20116, N'Vinh Hưng', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20122, N'Giang Hải', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20125, N'Vinh Hiền', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20128, N'Lộc Bổn', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20131, N'Lộc Sơn', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20134, N'Lộc Bình', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20137, N'Lộc Vĩnh', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20140, N'Lộc An', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20143, N'Lộc Điền', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20146, N'Lộc Thủy', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20149, N'Lộc Trì', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20152, N'Lộc Tiến', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20155, N'Lộc Hòa', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20158, N'Xuân Lộc', 482 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20161, N'Khe Tre', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20164, N'Hương Phú', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20167, N'Hương Sơn', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20170, N'Hương Lộc', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20173, N'Thượng Quảng', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20176, N'Hương Xuân', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20182, N'Hương Hữu', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20185, N'Thượng Lộ', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20188, N'Thượng Long', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20191, N'Thượng Nhật', 483 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20194, N'Hòa Hiệp Bắc', 490 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20195, N'Hòa Hiệp Nam', 490 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20197, N'Hòa Khánh Bắc', 490 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20198, N'Hòa Khánh Nam', 490 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20200, N'Hòa Minh', 490 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20203, N'Tam Thuận', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20206, N'Thanh Khê Tây', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20207, N'Thanh Khê Đông', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20209, N'Xuân Hà', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20212, N'Tân Chính', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20215, N'Chính Gián', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20218, N'Vĩnh Trung', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20221, N'Thạc Gián', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20224, N'An Khê', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20225, N'Hòa Khê', 491 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20227, N'Thanh Bình', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20230, N'Thuận Phước', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20233, N'Thạch Thang', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20236, N'Hải Châu  I', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20239, N'Hải Châu II', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20242, N'Phước Ninh', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20245, N'Hòa Thuận Tây', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20246, N'Hòa Thuận Đông', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20248, N'Nam Dương', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20251, N'Bình Hiên', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20254, N'Bình Thuận', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20257, N'Hòa Cường Bắc', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20258, N'Hòa Cường Nam', 492 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20260, N'Khuê Trung', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20263, N'Thọ Quang', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20266, N'Nại Hiên Đông', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20269, N'Mân Thái', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20272, N'An Hải Bắc', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20275, N'Phước Mỹ', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20278, N'An Hải Tây', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20281, N'An Hải Đông', 493 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20284, N'Mỹ An', 494 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20285, N'Khuê Mỹ', 494 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20287, N'Hoà Quý', 494 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20290, N'Hoà Hải', 494 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20293, N'Hòa Bắc', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20296, N'Hòa Liên', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20299, N'Hòa Ninh', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20302, N'Hòa Sơn', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20305, N'Hòa Phát', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20306, N'Hòa An', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20308, N'Hòa Nhơn', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20311, N'Hòa Thọ Tây', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20312, N'Hòa Thọ Đông', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20314, N'Hòa Xuân', 495 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20317, N'Hòa Phú', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20320, N'Hòa Phong', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20323, N'Hòa Châu', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20326, N'Hòa Tiến', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20329, N'Hòa Phước', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20332, N'Hòa Khương', 497 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20335, N'Tân Thạnh', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20338, N'Phước Hòa', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20341, N'An Mỹ', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20344, N'Hòa Hương', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20347, N'An Xuân', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20350, N'An Sơn', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20353, N'Trường Xuân', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20356, N'An Phú', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20359, N'Tam Thanh', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20362, N'Tam Thăng', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20364, N'Phú Thịnh', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20365, N'Tam Thành', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20368, N'Tam An', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20371, N'Tam Phú', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20374, N'Tam Đàn', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20375, N'Hoà Thuận', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20377, N'Tam Lộc', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20380, N'Tam Phước', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20383, N'Tam Vinh', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20386, N'Tam Thái', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20387, N'Tam Đại', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20389, N'Tam Ngọc', 502 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20392, N'Tam Dân', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20395, N'Tam Lãnh', 518 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20398, N'Minh An', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20401, N'Tân An', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20404, N'Cẩm Phô', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20407, N'Thanh Hà', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20410, N'Sơn Phong', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20413, N'Cẩm Châu', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20416, N'Cửa Đại', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20419, N'Cẩm An', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20422, N'Cẩm Hà', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20425, N'Cẩm Kim', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20428, N'Cẩm Nam', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20431, N'Cẩm Thanh', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20434, N'Tân Hiệp', 503 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20437, N'Ch''ơm', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20440, N'Ga Ri', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20443, N'A Xan', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20446, N'Tr''Hy', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20449, N'Lăng', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20452, N'A Nông', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20455, N'A Tiêng', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20458, N'Bha Lê', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20461, N'A Vương', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20464, N'Dang', 504 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20467, N'P Rao', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20470, N'Tà Lu', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20473, N'Sông Kôn', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20476, N'Jơ Ngây', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20479, N'A Ting', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20482, N'Tư', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20485, N'Ba', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20488, N'A Rooi', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20491, N'Za Hung', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20494, N'Mà Cooi', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20497, N'Ka Dăng', 505 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20500, N'Ái Nghĩa', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20503, N'Đại Sơn', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20506, N'Đại Lãnh', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20509, N'Đại Hưng', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20512, N'Đại Hồng', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20515, N'Đại Đồng', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20518, N'Đại Quang', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20521, N'Đại Nghĩa', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20524, N'Đại Hiệp', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20527, N'Đại Thạnh', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20530, N'Đại Chánh', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20533, N'Đại Tân', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20536, N'Đại Phong', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20539, N'Đại Minh', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20542, N'Đại Thắng', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20545, N'Đại Cường', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20547, N'Đại An', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20548, N'Đại Hòa', 506 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20551, N'Vĩnh Điện', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20554, N'Điện Tiến', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20557, N'Điện Hòa', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20560, N'Điện Thắng Bắc', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20561, N'Điện Thắng Trung', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20562, N'Điện Thắng Nam', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20563, N'Điện Ngọc', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20566, N'Điện Hồng', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20569, N'Điện Thọ', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20572, N'Điện Phước', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20575, N'Điện An', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20578, N'Điện Nam Bắc', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20579, N'Điện Nam Trung', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20580, N'Điện Nam Đông', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20581, N'Điện Dương', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20584, N'Điện Quang', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20587, N'Điện Trung', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20590, N'Điện Phong', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20593, N'Điện Minh', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20596, N'Điện Phương', 507 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20599, N'Nam Phước', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20602, N'Duy Thu', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20605, N'Duy Phú', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20608, N'Duy Tân', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20611, N'Duy Hòa', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20614, N'Duy Châu', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20617, N'Duy Trinh', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20620, N'Duy Sơn', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20623, N'Duy Trung', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20626, N'Duy Phước', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20629, N'Duy Thành', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20632, N'Duy Vinh', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20635, N'Duy Nghĩa', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20638, N'Duy Hải', 508 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20641, N'Đông Phú', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20644, N'Quế Xuân 1', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20647, N'Quế Xuân 2', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20650, N'Quế Phú', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20651, N'Hương An', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20653, N'Quế Cường', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20656, N'Quế Trung', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20659, N'Quế Hiệp', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20662, N'Quế Thuận', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20665, N'Phú Thọ', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20668, N'Quế Ninh', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20669, N'Phước Ninh', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20671, N'Quế Lộc', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20672, N'Sơn Viên', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20674, N'Quế Phước', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20677, N'Quế Long', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20680, N'Quế Châu', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20683, N'Quế Phong', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20686, N'Quế An', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20689, N'Quế Minh', 509 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20692, N'Quế Lâm', 519 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20695, N'Thạnh Mỹ', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20698, N'Laêê', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20699, N'Chơ Chun', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20701, N'Zuôich', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20702, N'Tà Pơơ', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20704, N'La Dêê', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20705, N'Đắc Tôi', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20707, N'Chà Vàl', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20710, N'Tà Bhinh', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20713, N'Cà Dy', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20716, N'Đắc Pre', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20719, N'Đắc Pring', 510 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20722, N'Khâm Đức', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20725, N'Phước Xuân', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20728, N'Phước Hiệp', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20729, N'Phước Hoà', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20731, N'Phước Đức', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20734, N'Phước Năng', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20737, N'Phước Mỹ', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20740, N'Phước Chánh', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20743, N'Phước Công', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20746, N'Phước Kim', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20749, N'Phước Lộc', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20752, N'Phước Thành', 511 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20755, N'Tân An', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20758, N'Hiệp Hòa', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20761, N'Hiệp Thuận', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20764, N'Quế Thọ', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20767, N'Bình Lâm', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20770, N'Sông Trà', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20773, N'Phước Trà', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20776, N'Phước Gia', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20779, N'Quế Bình', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20782, N'Quế Lưu', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20785, N'Thăng Phước', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20788, N'Bình Sơn', 512 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20791, N'Hà Lam', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20794, N'Bình Dương', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20797, N'Bình Giang', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20800, N'Bình Nguyên', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20803, N'Bình Phục', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20806, N'Bình Triều', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20809, N'Bình Đào', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20812, N'Bình Minh', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20815, N'Bình Lãnh', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20818, N'Bình Trị', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20821, N'Bình Định Bắc', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20822, N'Bình Định Nam', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20824, N'Bình Quý', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20827, N'Bình Phú', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20830, N'Bình Chánh', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20833, N'Bình Tú', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20836, N'Bình Sa', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20839, N'Bình Hải', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20842, N'Bình Quế', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20845, N'Bình An', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20848, N'Bình Trung', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20851, N'Bình Nam', 513 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20854, N'Tiên Kỳ', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20857, N'Tiên Sơn', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20860, N'Tiên Hà', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20863, N'Tiên Cẩm', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20866, N'Tiên Châu', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20869, N'Tiên Lãnh', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20872, N'Tiên Ngọc', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20875, N'Tiên Hiệp', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20878, N'Tiên Cảnh', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20881, N'Tiên Mỹ', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20884, N'Tiên Phong', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20887, N'Tiên Thọ', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20890, N'Tiên An', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20893, N'Tiên Lộc', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20896, N'Tiên Lập', 514 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20899, N'Trà My', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20900, N'Trà Sơn', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20902, N'Trà Kót', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20905, N'Trà Nú', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20908, N'Trà Đông', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20911, N'Trà Dương', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20914, N'Trà Giang', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20917, N'Trà Bui', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20920, N'Trà Đốc', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20923, N'Trà Tân', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20926, N'Trà Giác', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20929, N'Trà Giáp', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20932, N'Trà Ka', 515 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20935, N'Trà Leng', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20938, N'Trà Dơn', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20941, N'Trà Tập', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20944, N'Trà Mai', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20947, N'Trà Cang', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20950, N'Trà Linh', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20953, N'Trà Nam', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20956, N'Trà Don', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20959, N'Trà Vân', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20962, N'Trà Vinh', 516 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20965, N'Núi Thành', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20968, N'Tam Xuân I', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20971, N'Tam Xuân II', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20974, N'Tam Tiến', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20977, N'Tam Sơn', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20980, N'Tam Thạnh', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20983, N'Tam Anh Bắc', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20984, N'Tam Anh Nam', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20986, N'Tam Hòa', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20989, N'Tam Hiệp', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20992, N'Tam Hải', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20995, N'Tam Giang', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 20998, N'Tam Quang', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21001, N'Tam Nghĩa', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21004, N'Tam Mỹ Tây', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21005, N'Tam Mỹ Đông', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21007, N'Tam Trà', 517 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21010, N'Lê Hồng Phong', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21013, N'Trần Phú', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21016, N'Quảng Phú', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21019, N'Nghĩa Chánh', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21022, N'Trần Hưng Đạo', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21025, N'Nguyễn Nghiêm', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21028, N'Nghĩa Lộ', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21031, N'Chánh Lộ', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21034, N'Nghĩa Dũng', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21037, N'Nghĩa Dõng', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21040, N'Châu Ổ', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21043, N'Bình Thuận', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21046, N'Bình Thạnh', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21049, N'Bình Đông', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21052, N'Bình Chánh', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21055, N'Bình Nguyên', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21058, N'Bình Khương', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21061, N'Bình Trị', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21064, N'Bình An', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21067, N'Bình Hải', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21070, N'Bình Dương', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21073, N'Bình Phước', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21076, N'Bình Thới', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21079, N'Bình Hòa', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21082, N'Bình Trung', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21085, N'Bình Minh', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21088, N'Bình Long', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21091, N'Bình Thanh Tây', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21094, N'Bình Phú', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21097, N'Bình Thanh Đông', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21100, N'Bình Chương', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21103, N'Bình Hiệp', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21106, N'Bình Mỹ', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21109, N'Bình Tân', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21112, N'Bình Châu', 524 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21115, N'Trà Xuân', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21118, N'Trà Giang', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21121, N'Trà Thủy', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21124, N'Trà Hiệp', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21127, N'Trà Bình', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21130, N'Trà Phú', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21133, N'Trà Lâm', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21136, N'Trà Tân', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21139, N'Trà Sơn', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21142, N'Trà Bùi', 525 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21145, N'Trà Thanh', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21148, N'Trà Khê', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21151, N'Trà Quân', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21154, N'Trà Phong', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21157, N'Trà Lãnh', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21160, N'Trà Nham', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21163, N'Trà Xinh', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21166, N'Trà Thọ', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21169, N'Trà Trung', 526 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21172, N'Trương Quang Trọng', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21175, N'Tịnh Thọ', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21178, N'Tịnh Trà', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21181, N'Tịnh Phong', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21184, N'Tịnh Hiệp', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21187, N'Tịnh Hòa', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21190, N'Tịnh Kỳ', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21193, N'Tịnh Bình', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21196, N'Tịnh Đông', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21199, N'Tịnh Thiện', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21202, N'Tịnh Ấn Đông', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21205, N'Tịnh Bắc', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21208, N'Tịnh Châu', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21211, N'Tịnh Khê', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21214, N'Tịnh Long', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21217, N'Tịnh Sơn', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21220, N'Tịnh Hà', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21223, N'Tịnh Ấn Tây', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21226, N'Tịnh Giang', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21229, N'Tịnh Minh', 527 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21232, N'Tịnh An', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21235, N'La Hà', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21238, N'Sông Vệ', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21241, N'Nghĩa Lâm', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21244, N'Nghĩa Thắng', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21247, N'Nghĩa Thuận', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21250, N'Nghĩa Kỳ', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21253, N'Nghĩa Phú', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21256, N'Nghĩa Hà', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21259, N'Nghĩa Sơn', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21262, N'Nghĩa An', 522 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21265, N'Nghĩa Thọ', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21268, N'Nghĩa Hòa', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21271, N'Nghĩa Điền', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21274, N'Nghĩa Thương', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21277, N'Nghĩa Trung', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21280, N'Nghĩa Hiệp', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21283, N'Nghĩa Phương', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21286, N'Nghĩa Mỹ', 528 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21289, N'Di Lăng', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21292, N'Sơn Hạ', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21295, N'Sơn Thành', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21298, N'Sơn Nham', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21301, N'Sơn Bao', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21304, N'Sơn Linh', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21307, N'Sơn Giang', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21310, N'Sơn Trung', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21313, N'Sơn Thượng', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21316, N'Sơn Cao', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21319, N'Sơn Hải', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21322, N'Sơn Thủy', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21325, N'Sơn Kỳ', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21328, N'Sơn Ba', 529 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21331, N'Sơn Bua', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21334, N'Sơn Mùa', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21335, N'Sơn Liên', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21337, N'Sơn Tân', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21338, N'Sơn Màu', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21340, N'Sơn Dung', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21341, N'Sơn Long', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21343, N'Sơn Tinh', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21346, N'Sơn Lập', 530 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21349, N'Long Sơn', 531 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21352, N'Long Mai', 531 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21355, N'Thanh An', 531 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21358, N'Long Môn', 531 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21361, N'Long Hiệp', 531 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21364, N'Chợ Chùa', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21367, N'Hành Thuận', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21370, N'Hành Dũng', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21373, N'Hành Trung', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21376, N'Hành Nhân', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21379, N'Hành Đức', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21382, N'Hành Minh', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21385, N'Hành Phước', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21388, N'Hành Thiện', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21391, N'Hành Thịnh', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21394, N'Hành Tín Tây', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21397, N'Hành Tín  Đông', 532 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21400, N'Mộ Đức', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21403, N'Đức Lợi', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21406, N'Đức Thắng', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21409, N'Đức Nhuận', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21412, N'Đức Chánh', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21415, N'Đức Hiệp', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21418, N'Đức Minh', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21421, N'Đức Thạnh', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21424, N'Đức Hòa', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21427, N'Đức Tân', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21430, N'Đức Phú', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21433, N'Đức Phong', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21436, N'Đức Lân', 533 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21439, N'Đức Phổ', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21442, N'Phổ An', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21445, N'Phổ Phong', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21448, N'Phổ Thuận', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21451, N'Phổ Văn', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21454, N'Phổ Quang', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21457, N'Phổ Nhơn', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21460, N'Phổ Ninh', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21463, N'Phổ Minh', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21466, N'Phổ Vinh', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21469, N'Phổ Hòa', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21472, N'Phổ Cường', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21475, N'Phổ Khánh', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21478, N'Phổ Thạnh', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21481, N'Phổ Châu', 534 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21484, N'Ba Tơ', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21487, N'Ba Điền', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21490, N'Ba Vinh', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21493, N'Ba Thành', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21496, N'Ba Động', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21499, N'Ba Dinh', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21500, N'Ba Giang', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21502, N'Ba Liên', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21505, N'Ba Ngạc', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21508, N'Ba Khâm', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21511, N'Ba Cung', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21514, N'Ba Chùa', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21517, N'Ba Tiêu', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21520, N'Ba Trang', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21523, N'Ba Tô', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21526, N'Ba Bích', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21529, N'Ba Vì', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21532, N'Ba Lế', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21535, N'Ba Nam', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21538, N'Ba Xa', 535 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21541, N'An Vĩnh', 536 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21544, N'An Hải', 536 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21547, N'An Bình', 536 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21550, N'Nhơn Bình', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21553, N'Nhơn Phú', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21556, N'Đống Đa', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21559, N'Trần Quang Diệu', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21562, N'Hải Cảng', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21565, N'Quang Trung', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21568, N'Thị Nại', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21571, N'Lê Hồng Phong', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21574, N'Trần Hưng Đạo', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21577, N'Ngô Mây', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21580, N'Lý Thường Kiệt', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21583, N'Lê Lợi', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21586, N'Trần Phú', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21589, N'Bùi Thị Xuân', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21592, N'Nguyễn Văn Cừ', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21595, N'Ghềnh Ráng', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21598, N'Nhơn Lý', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21601, N'Nhơn Hội', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21604, N'Nhơn Hải', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21607, N'Nhơn Châu', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21609, N'An Lão', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21610, N'An Hưng', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21613, N'An Trung', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21616, N'An Dũng', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21619, N'An Vinh', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21622, N'An Toàn', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21625, N'An Tân', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21628, N'An Hòa', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21631, N'An Quang', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21634, N'An Nghĩa', 542 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21637, N'Tam Quan', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21640, N'Bồng Sơn', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21643, N'Hoài Sơn', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21646, N'Hoài Châu Bắc', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21649, N'Hoài Châu', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21652, N'Hoài Phú', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21655, N'Tam Quan Bắc', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21658, N'Tam Quan Nam', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21661, N'Hoài Hảo', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21664, N'Hoài Thanh Tây', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21667, N'Hoài Thanh', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21670, N'Hoài Hương', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21673, N'Hoài Tân', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21676, N'Hoài Hải', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21679, N'Hoài Xuân', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21682, N'Hoài Mỹ', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21685, N'Hoài Đức', 543 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21688, N'Tăng Bạt Hổ', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21690, N'Ân Hảo Tây', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21691, N'Ân Hảo Đông', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21694, N'Ân Sơn', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21697, N'Ân Mỹ', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21700, N'Dak Mang', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21703, N'Ân Tín', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21706, N'Ân Thạnh', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21709, N'Ân Phong', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21712, N'Ân Đức', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21715, N'Ân Hữu', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21718, N'Bok Tới', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21721, N'Ân Tường Tây', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21724, N'Ân Tường Đông', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21727, N'Ân Nghĩa', 544 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21730, N'Phù Mỹ', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21733, N'Bình Dương', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21736, N'Mỹ Đức', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21739, N'Mỹ Châu', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21742, N'Mỹ Thắng', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21745, N'Mỹ Lộc', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21748, N'Mỹ Lợi', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21751, N'Mỹ An', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21754, N'Mỹ Phong', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21757, N'Mỹ Trinh', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21760, N'Mỹ Thọ', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21763, N'Mỹ Hòa', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21766, N'Mỹ Thành', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21769, N'Mỹ Chánh', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21772, N'Mỹ Quang', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21775, N'Mỹ Hiệp', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21778, N'Mỹ Tài', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21781, N'Mỹ Cát', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21784, N'Mỹ Chánh Tây', 545 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21786, N'Vĩnh Thạnh', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21787, N'Vĩnh Sơn', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21790, N'Vĩnh Kim', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21796, N'Vĩnh Hiệp', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21799, N'Vĩnh Hảo', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21801, N'Vĩnh Hòa', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21802, N'Vĩnh Thịnh', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21804, N'Vĩnh Thuận', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21805, N'Vĩnh Quang', 546 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21808, N'Phú Phong', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21811, N'Bình Tân', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21814, N'Tây Thuận', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21817, N'Bình Thuận', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21820, N'Tây Giang', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21823, N'Bình Thành', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21826, N'Tây An', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21829, N'Bình Hòa', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21832, N'Tây Bình', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21835, N'Bình Tường', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21838, N'Tây Vinh', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21841, N'Vĩnh An', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21844, N'Tây Xuân', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21847, N'Bình Nghi', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21850, N'Tây Phú', 547 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21853, N'Ngô Mây', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21856, N'Cát Sơn', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21859, N'Cát Minh', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21862, N'Cát Khánh', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21865, N'Cát Tài', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21868, N'Cát Lâm', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21871, N'Cát Hanh', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21874, N'Cát Thành', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21877, N'Cát Trinh', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21880, N'Cát Hải', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21883, N'Cát Hiệp', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21886, N'Cát Nhơn', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21889, N'Cát Hưng', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21892, N'Cát Tường', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21895, N'Cát Tân', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21898, N'Cát Tiến', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21901, N'Cát Thắng', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21904, N'Cát Chánh', 548 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21907, N'Bình Định', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21910, N'Đập Đá', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21913, N'Nhơn Mỹ', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21916, N'Nhơn Thành', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21919, N'Nhơn Hạnh', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21922, N'Nhơn Hậu', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21925, N'Nhơn Phong', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21928, N'Nhơn An', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21931, N'Nhơn Phúc', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21934, N'Nhơn Hưng', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21937, N'Nhơn Khánh', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21940, N'Nhơn Lộc', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21943, N'Nhơn Hoà', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21946, N'Nhơn Tân', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21949, N'Nhơn Thọ', 549 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21952, N'Tuy Phước', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21955, N'Diêu Trì', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21958, N'Phước Thắng', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21961, N'Phước Hưng', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21964, N'Phước Quang', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21967, N'Phước Hòa', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21970, N'Phước Sơn', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21973, N'Phước Hiệp', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21976, N'Phước Lộc', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21979, N'Phước Nghĩa', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21982, N'Phước Thuận', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21985, N'Phước An', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21988, N'Phước Thành', 550 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21991, N'Phước Mỹ', 540 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21994, N'Vân Canh', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 21997, N'Canh Liên', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22000, N'Canh Hiệp', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22003, N'Canh Vinh', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22006, N'Canh Hiển', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22009, N'Canh Thuận', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22012, N'Canh Hòa', 551 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22015, N'1', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22018, N'8', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22021, N'2', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22024, N'9', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22027, N'3', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22030, N'4', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22033, N'5', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22036, N'7', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22039, N'6', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22040, N'Phú Thạnh', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22041, N'Phú Đông', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22042, N'Hòa Kiến', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22045, N'Bình Kiến', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22048, N'Bình Ngọc', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22051, N'Xuân Phú', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22052, N'Xuân Lâm', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22053, N'Xuân Thành', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22054, N'Xuân Hải', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22057, N'Xuân Lộc', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22060, N'Xuân Bình', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22066, N'Xuân Cảnh', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22069, N'Xuân Thịnh', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22072, N'Xuân Phương', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22073, N'Xuân Yên', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22075, N'Xuân Thọ 1', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22076, N'Xuân Đài', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22078, N'Xuân Thọ 2', 557 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22081, N'La Hai', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22084, N'Đa Lộc', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22087, N'Phú Mỡ', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22090, N'Xuân Lãnh', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22093, N'Xuân Long', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22096, N'Xuân Quang 1', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22099, N'Xuân Sơn Bắc', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22102, N'Xuân Quang 2', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22105, N'Xuân Sơn Nam', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22108, N'Xuân Quang 3', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22111, N'Xuân Phước', 558 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22114, N'Chí Thạnh', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22117, N'An Dân', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22120, N'An Ninh Tây', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22123, N'An Ninh Đông', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22126, N'An Thạch', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22129, N'An Định', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22132, N'An Nghiệp', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22138, N'An Cư', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22141, N'An Xuân', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22144, N'An Lĩnh', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22147, N'An Hòa Hải', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22150, N'An Hiệp', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22153, N'An Mỹ', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22156, N'An Chấn', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22159, N'An Thọ', 559 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22162, N'An Phú', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22165, N'Củng Sơn', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22168, N'Phước Tân', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22171, N'Sơn Hội', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22174, N'Sơn Định', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22177, N'Sơn Long', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22180, N'Cà Lúi', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22183, N'Sơn Phước', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22186, N'Sơn Xuân', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22189, N'Sơn Nguyên', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22192, N'Eachà Rang', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22195, N'Krông Pa', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22198, N'Suối Bạc', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22201, N'Sơn Hà', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22204, N'Suối Trai', 560 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22207, N'Hai Riêng', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22210, N'Ea Lâm', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22213, N'Đức Bình Tây', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22216, N'Ea Bá', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22219, N'Sơn Giang', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22222, N'Đức Bình Đông', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22225, N'EaBar', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22228, N'EaBia', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22231, N'EaTrol', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22234, N'Sông Hinh', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22237, N'Ealy', 561 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22240, N'Phú Lâm', 555 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22243, N'Hòa Thành', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22246, N'Hòa Hiệp Bắc', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22249, N'Sơn Thành Tây', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22250, N'Sơn Thành Đông', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22252, N'Hòa Bình 1', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22255, N'Phú Thứ', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22258, N'Hoà Vinh', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22261, N'Hoà Hiệp Trung', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22264, N'Hòa Phong', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22267, N'Hòa Tân Đông', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22270, N'Hòa Phú', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22273, N'Hòa Tân Tây', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22276, N'Hòa Đồng', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22279, N'Hòa Xuân Tây', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22282, N'Hòa Hiệp Nam', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22285, N'Hòa Mỹ Đông', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22288, N'Hòa Mỹ Tây', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22291, N'Hòa Xuân Đông', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22294, N'Hòa Thịnh', 562 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22297, N'Hòa Tâm', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22300, N'Hòa Xuân Nam', 564 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22303, N'Hòa Quang Bắc', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22306, N'Hòa Quang Nam', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22309, N'Hòa Hội', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22312, N'Hòa Trị', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22315, N'Hòa An', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22318, N'Hòa Định Đông', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22319, N'Phú Hoà', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22321, N'Hòa Định Tây', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22324, N'Hòa Thắng', 563 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22327, N'Vĩnh Hòa', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22330, N'Vĩnh Hải', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22333, N'Vĩnh Phước', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22336, N'Ngọc Hiệp', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22339, N'Vĩnh Thọ', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22342, N'Xương Huân', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22345, N'Vạn Thắng', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22348, N'Vạn Thạnh', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22351, N'Phương Sài', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22354, N'Phương Sơn', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22357, N'Phước Hải', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22360, N'Phước Tân', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22363, N'Lộc Thọ', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22366, N'Phước Tiến', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22369, N'Tân Lập', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22372, N'Phước Hòa', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22375, N'Vĩnh Nguyên', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22378, N'Phước Long', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22381, N'Vĩnh Trường', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22384, N'Vĩnh Lương', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22387, N'Vĩnh Phương', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22390, N'Vĩnh Ngọc', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22393, N'Vĩnh Thạnh', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22396, N'Vĩnh Trung', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22399, N'Vĩnh Hiệp', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22402, N'Vĩnh Thái', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22405, N'Phước Đồng', 568 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22408, N'Cam Nghĩa', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22411, N'Cam Phúc Bắc', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22414, N'Cam Phúc Nam', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22417, N'Cam Lộc', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22420, N'Cam Phú', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22423, N'Ba Ngòi', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22426, N'Cam Thuận', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22429, N'Cam Lợi', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22432, N'Cam Linh', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22435, N'Cam Tân', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22438, N'Cam Hòa', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22441, N'Cam Hải Đông', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22444, N'Cam Hải Tây', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22447, N'Sơn Tân', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22450, N'Cam Hiệp Bắc', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22453, N'Cam Đức', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22456, N'Cam Hiệp Nam', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22459, N'Cam Phước Tây', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22462, N'Cam Thành Bắc', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22465, N'Cam An Bắc', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22468, N'Cam Thành Nam', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22471, N'Cam An Nam', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22474, N'Cam Phước Đông', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22477, N'Cam Thịnh Tây', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22480, N'Cam Thịnh Đông', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22483, N'Cam Lập', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22486, N'Cam Bình', 569 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22489, N'Vạn Giã', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22492, N'Đại Lãnh', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22495, N'Vạn Phước', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22498, N'Vạn Long', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22501, N'Vạn Bình', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22504, N'Vạn Thọ', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22507, N'Vạn Khánh', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22510, N'Vạn Phú', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22513, N'Vạn Lương', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22516, N'Vạn Thắng', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22519, N'Vạn Thạnh', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22522, N'Xuân Sơn', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22525, N'Vạn Hưng', 571 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22528, N'Ninh Hiệp', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22531, N'Ninh Sơn', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22534, N'Ninh Tây', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22537, N'Ninh Thượng', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22540, N'Ninh An', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22543, N'Ninh Hải', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22546, N'Ninh Thọ', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22549, N'Ninh Trung', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22552, N'Ninh Sim', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22555, N'Ninh Xuân', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22558, N'Ninh Thân', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22561, N'Ninh Diêm', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22564, N'Ninh Đông', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22567, N'Ninh Thủy', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22570, N'Ninh Đa', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22573, N'Ninh Phụng', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22576, N'Ninh Bình', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22579, N'Ninh Phước', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22582, N'Ninh Phú', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22585, N'Ninh Tân', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22588, N'Ninh Quang', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22591, N'Ninh Giang', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22594, N'Ninh Hà', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22597, N'Ninh Hưng', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22600, N'Ninh Lộc', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22603, N'Ninh Ích', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22606, N'Ninh Vân', 572 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22609, N'Khánh Vĩnh', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22612, N'Khánh Hiệp', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22615, N'Khánh Bình', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22618, N'Khánh Trung', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22621, N'Khánh Đông', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22624, N'Khánh Thượng', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22627, N'Khánh Nam', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22630, N'Sông Cầu', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22633, N'Giang Ly', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22636, N'Cầu Bà', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22639, N'Liên Sang', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22642, N'Khánh Thành', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22645, N'Khánh Phú', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22648, N'Sơn Thái', 573 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22651, N'Diên Khánh', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22654, N'Diên Lâm', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22657, N'Diên Điền', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22660, N'Diên Xuân', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22663, N'Diên Sơn', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22666, N'Diên Đồng', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22669, N'Diên Phú', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22672, N'Diên Thọ', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22675, N'Diên Phước', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22678, N'Diên Lạc', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22681, N'Diên Tân', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22684, N'Diên Hòa', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22687, N'Diên Thạnh', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22690, N'Diên Toàn', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22693, N'Diên An', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22696, N'Diên Bình', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22699, N'Diên Lộc', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22702, N'Suối Hiệp', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22705, N'Suối Tiên', 574 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22708, N'Suối Cát', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22711, N'Suối Tân', 570 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22714, N'Tô Hạp', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22717, N'Thành Sơn', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22720, N'Sơn Lâm', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22723, N'Sơn Hiệp', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22726, N'Sơn Bình', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22729, N'Sơn Trung', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22732, N'Ba Cụm Bắc', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22735, N'Ba Cụm Nam', 575 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22736, N'Trường Sa', 576 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22737, N'Song Tử Tây', 576 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22738, N'Đô Vinh', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22739, N'Sinh Tồn', 576 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22741, N'Phước Mỹ', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22744, N'Bảo An', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22747, N'Phủ Hà', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22750, N'Thanh Sơn', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22753, N'Mỹ Hương', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22756, N'Tấn Tài', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22759, N'Kinh Dinh', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22762, N'Đạo Long', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22765, N'Đài Sơn', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22768, N'Đông Hải', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22771, N'Mỹ Đông', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22774, N'Thành Hải', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22777, N'Văn Hải', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22779, N'Mỹ Bình', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22780, N'Mỹ Hải', 582 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22783, N'Phước Bình', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22786, N'Phước Hòa', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22789, N'Phước Tân', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22792, N'Phước Tiến', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22795, N'Phước Thắng', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22798, N'Phước Thành', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22801, N'Phước Đại', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22804, N'Phước Chính', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22807, N'Phước Trung', 584 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22810, N'Tân Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22813, N'Lâm Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22816, N'Lương Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22819, N'Quảng Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22822, N'Mỹ Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22825, N'Hòa Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22828, N'Ma Nới', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22831, N'Nhơn Sơn', 585 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22834, N'Khánh Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22837, N'Phước Chiến', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22840, N'Công Hải', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22843, N'Phước Kháng', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22846, N'Vĩnh Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22849, N'Lợi Hải', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22852, N'Phương Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22853, N'Bắc Sơn', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22855, N'Tân Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22856, N'Bắc Phong', 588 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22858, N'Xuân Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22861, N'Hộ Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22864, N'Tri Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22867, N'Nhơn Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22868, N'Thanh Hải', 586 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22870, N'Phước Dân', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22873, N'Phước Sơn', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22876, N'Phước Thái', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22879, N'Phước Hậu', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22882, N'Phước Thuận', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22885, N'Phước Hà', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22888, N'An Hải', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22891, N'Phước Hữu', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22894, N'Phước Hải', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22897, N'Phước Nam', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22898, N'Phước Ninh', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22900, N'Nhị Hà', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22903, N'Phước Dinh', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22906, N'Phước Minh', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22909, N'Phước Diêm', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22910, N'Cà Ná', 589 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22912, N'Phước Vinh', 587 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22915, N'Mũi Né', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22918, N'Hàm Tiến', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22921, N'Phú Hài', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22924, N'Phú Thủy', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22927, N'Phú Tài', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22930, N'Phú Trinh', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22933, N'Xuân An', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22936, N'Thanh Hải', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22939, N'Bình Hưng', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22942, N'Đức Nghĩa', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22945, N'Lạc Đạo', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22948, N'Đức Thắng', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22951, N'Hưng Long', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22954, N'Đức Long', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22957, N'Thiện Nghiệp', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22960, N'Phong Nẫm', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22963, N'Tiến Lợi', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22966, N'Tiến Thành', 593 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22969, N'Liên Hương', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22972, N'Phan Rí Cửa', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22975, N'Phan Dũng', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22978, N'Phong Phú', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22981, N'Vĩnh Hảo', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22984, N'Vĩnh Tân', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22987, N'Phú Lạc', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22990, N'Phước Thể', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22993, N'Hòa Minh', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22996, N'Chí Công', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 22999, N'Bình Thạnh', 595 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23005, N'Chợ Lầu', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23008, N'Phan Sơn', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23011, N'Phan Lâm', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23014, N'Bình An', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23017, N'Phan Điền', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23020, N'Hải Ninh', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23023, N'Sông Lũy', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23026, N'Phan Tiến', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23029, N'Sông Bình', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23032, N'Lương Sơn', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23035, N'Phan Hòa', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23038, N'Phan Thanh', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23041, N'Hồng Thái', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23044, N'Phan Hiệp', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23047, N'Bình Tân', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23050, N'Phan Rí Thành', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23053, N'Hòa Thắng', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23056, N'Hồng Phong', 596 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23059, N'Ma Lâm', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23062, N'Phú Long', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23065, N'La Dạ', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23068, N'Đông Tiến', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23071, N'Thuận Hòa', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23074, N'Đông Giang', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23077, N'Hàm Phú', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23080, N'Hồng Liêm', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23083, N'Thuận Minh', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23086, N'Hồng Sơn', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23089, N'Hàm Trí', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23092, N'Hàm Đức', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23095, N'Hàm Liêm', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23098, N'Hàm Chính', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23101, N'Hàm Hiệp', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23104, N'Hàm Thắng', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23107, N'Đa Mi', 597 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23110, N'Thuận Nam', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23113, N'Mỹ Thạnh', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23116, N'Hàm Cần', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23119, N'Mương Mán', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23122, N'Hàm Thạnh', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23125, N'Hàm Kiệm', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23128, N'Hàm Cường', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23131, N'Hàm Mỹ', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23134, N'Tân Lập', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23137, N'Hàm Minh', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23140, N'Thuận Quí', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23143, N'Tân Thuận', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23146, N'Tân Thành', 598 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23149, N'Lạc Tánh', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23152, N'Bắc Ruộng', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23155, N'Măng Tố', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23158, N'Nghị Đức', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23161, N'La Ngâu', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23164, N'Huy Khiêm', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23170, N'Đức Phú', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23173, N'Đồng Kho', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23176, N'Gia An', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23179, N'Đức Bình', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23182, N'Gia Huynh', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23185, N'Đức Thuận', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23188, N'Suối Kiết', 599 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23191, N'Võ Xu', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23194, N'Đức Tài', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23197, N'Đa Kai', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23200, N'Sùng Nhơn', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23203, N'Mê Pu', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23206, N'Nam Chính', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23212, N'Đức Hạnh', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23215, N'Đức Tín', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23218, N'Vũ Hoà', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23221, N'Tân Hà', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23224, N'Đông Hà', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23227, N'Trà Tân', 600 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23230, N'Tân Minh', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23231, N'Phước Hội', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23232, N'Phước Lộc', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23234, N'Tân Thiện', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23235, N'Tân An', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23236, N'Tân Nghĩa', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23237, N'Bình Tân', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23239, N'Sông Phan', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23242, N'Tân Phúc', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23245, N'Tân Hải', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23246, N'Tân Tiến', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23248, N'Tân Bình', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23251, N'Tân Đức', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23254, N'Tân Thắng', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23255, N'Thắng Hải', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23257, N'Tân Hà', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23260, N'Tân Xuân', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23266, N'Sơn Mỹ', 601 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23268, N'Tân Phước', 594 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23272, N'Ngũ Phụng', 602 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23275, N'Long Hải', 602 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23278, N'Tam Thanh', 602 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23281, N'Quang Trung', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23284, N'Duy Tân', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23287, N'Quyết Thắng', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23290, N'Trường Chinh', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23293, N'Thắng Lợi', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23296, N'Ngô Mây', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23299, N'Thống Nhất', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23302, N'Lê Lợi', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23305, N'Nguyễn Trãi', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23308, N'Trần Hưng Đạo', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23311, N'Đắk Cấm', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23314, N'Kroong', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23317, N'Ngọk Bay', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23320, N'Vinh Quang', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23323, N'Đắk Blà', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23326, N'Ia Chim', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23327, N'Đăk Năng', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23329, N'Đoàn Kết', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23332, N'Chư Hreng', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23335, N'Đắk Rơ Wa', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23338, N'Hòa Bình', 608 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23341, N'Đắk Glei', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23344, N'Đắk Blô', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23347, N'Đắk Man', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23350, N'Đắk Nhoong', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23353, N'Đắk Pék', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23356, N'Đắk Choong', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23359, N'Xốp', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23362, N'Mường Hoong', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23365, N'Ngọc Linh', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23368, N'Đắk Long', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23371, N'Đắk KRoong', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23374, N'Đắk Môn', 610 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23377, N'Plei Kần', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23380, N'Đắk Ang', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23383, N'Đắk Dục', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23386, N'Đắk Nông', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23389, N'Đắk Xú', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23392, N'Đắk Kan', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23395, N'Bờ Y', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23398, N'Sa Loong', 611 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23401, N'Đắk Tô', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23404, N'Ngọc Lây', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23407, N'Đắk Na', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23410, N'Măng Ri', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23413, N'Ngọc Yêu', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23416, N'Đắk Sao', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23417, N'Đắk Rơ Ông', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23419, N'Đắk Tờ Kan', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23422, N'Tu Mơ Rông', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23425, N'Đắk Hà', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23427, N'Đắk Rơ Nga', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23428, N'Ngọk Tụ', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23430, N'Đắk Trăm', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23431, N'Văn Lem', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23434, N'Kon Đào', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23437, N'Tân Cảnh', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23440, N'Diên Bình', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23443, N'Pô Kô', 612 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23446, N'Tê Xăng', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23449, N'Văn Xuôi', 617 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23452, N'Đắk Nên', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23455, N'Đắk Ring', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23458, N'Măng Buk', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23461, N'Đắk Tăng', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23464, N'Ngok Tem', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23467, N'Pờ Ê', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23470, N'Măng Cành', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23473, N'Măng Đen', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23476, N'Hiếu', 613 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23479, N'Đắk Rve', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23482, N'Đắk Kôi', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23485, N'Đắk Tơ Lung', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23488, N'Đắk Ruồng', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23491, N'Đắk Pne', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23494, N'Đắk Tờ Re', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23497, N'Tân Lập', 614 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23500, N'Đắk Hà', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23503, N'Đắk PXi', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23504, N'Đăk Long', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23506, N'Đắk HRing', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23509, N'Đắk Ui', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23510, N'Đăk Ngọk', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23512, N'Đắk Mar', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23515, N'Ngok Wang', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23518, N'Ngok Réo', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23521, N'Hà Mòn', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23524, N'Đắk La', 615 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23527, N'Sa Thầy', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23530, N'Rơ Kơi', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23533, N'Sa Nhơn', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23534, N'Hơ Moong', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23535, N'Ia Đal', 618 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23536, N'Mô Rai', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23537, N'Ia Dom', 618 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23538, N'Ia Tơi', 618 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23539, N'Sa Sơn', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23542, N'Sa Nghĩa', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23545, N'Sa Bình', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23548, N'Ya Xiêr', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23551, N'Ya Tăng', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23554, N'Ya ly', 616 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23557, N'Yên Đỗ', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23560, N'Diên Hồng', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23563, N'Ia Kring', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23566, N'Hội Thương', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23569, N'Hội Phú', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23570, N'Phù Đổng', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23572, N'Hoa Lư', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23575, N'Tây Sơn', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23578, N'Thống Nhất', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23579, N'Đống Đa', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23581, N'Trà Bá', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23582, N'Thắng Lợi', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23584, N'Yên Thế', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23586, N'Chi Lăng', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23587, N'Chư HDrông', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23590, N'Biển Hồ', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23593, N'Tân Sơn', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23596, N'Trà Đa', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23599, N'Chư Á', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23602, N'An Phú', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23605, N'Diên Phú', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23608, N'Ia Kênh', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23611, N'Gào', 622 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23614, N'An Bình', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23617, N'Tây Sơn', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23620, N'An Phú', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23623, N'An Tân', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23626, N'Tú An', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23627, N'Xuân An', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23629, N'Cửu An', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23630, N'An Phước', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23632, N'Song An', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23633, N'Ngô Mây', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23635, N'Thành An', 623 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23638, N'KBang', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23641, N'Kon Pne', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23644, N'Đăk Roong', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23647, N'Sơn Lang', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23650, N'KRong', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23653, N'Sơ Pai', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23656, N'Lơ Ku', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23659, N'Đông', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23660, N'Đak SMar', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23662, N'Nghĩa An', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23665, N'Tơ Tung', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23668, N'Kông Lơng Khơng', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23671, N'Kông Pla', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23674, N'Đăk HLơ', 625 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23677, N'Đăk Đoa', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23680, N'Hà Đông', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23683, N'Đăk Sơmei', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23684, N'Đăk Krong', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23686, N'Hải Yang', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23689, N'Kon Gang', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23692, N'Hà Bầu', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23695, N'Nam Yang', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23698, N'K'' Dang', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23701, N'H'' Neng', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23704, N'Tân Bình', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23707, N'Glar', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23710, N'A Dơk', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23713, N'Trang', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23714, N'HNol', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23716, N'Ia Pết', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23719, N'Ia Băng', 626 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23722, N'Phú Hòa', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23725, N'Hà Tây', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23728, N'Ia Khươl', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23731, N'Ia Phí', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23734, N'Ia Ly', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23737, N'Ia Mơ Nông', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23738, N'Ia Kreng', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23740, N'Đăk Tơ Ver', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23743, N'Hòa Phú', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23746, N'Chư Đăng Ya', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23749, N'Ia Ka', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23752, N'Ia Nhin', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23755, N'Nghĩa Hòa', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23758, N'Chư Jôr', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23761, N'Nghĩa Hưng', 627 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23764, N'Ia Kha', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23767, N'Ia Sao', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23768, N'Ia Yok', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23770, N'Ia Hrung', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23771, N'Ia Bă', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23773, N'Ia Khai', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23776, N'Ia KRai', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23778, N'Ia Grăng', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23779, N'Ia Tô', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23782, N'Ia O', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23785, N'Ia Dêr', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23788, N'Ia Chia', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23791, N'Ia Pếch', 628 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23794, N'Kon Dơng', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23797, N'Ayun', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23798, N'Đak Jơ Ta', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23799, N'Đak Ta Ley', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23800, N'Hra', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23803, N'Đăk Yă', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23806, N'Đăk Djrăng', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23809, N'Lơ Pang', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23812, N'Kon Thụp', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23815, N'Đê Ar', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23818, N'Kon Chiêng', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23821, N'Đăk Trôi', 629 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23824, N'Kông Chro', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23827, N'Chư Krêy', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23830, N'An Trung', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23833, N'Kông Yang', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23836, N'Đăk Tơ Pang', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23839, N'SRó', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23840, N'Đắk Kơ Ning', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23842, N'Đăk Song', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23843, N'Đăk Pling', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23845, N'Yang Trung', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23846, N'Đăk Pơ Pho', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23848, N'Ya Ma', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23851, N'Chơ Long', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23854, N'Yang Nam', 630 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23857, N'Chư Ty', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23860, N'Ia Dơk', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23863, N'Ia Krêl', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23866, N'Ia Din', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23869, N'Ia Kla', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23872, N'Ia Dom', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23875, N'Ia Lang', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23878, N'Ia Kriêng', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23881, N'Ia Pnôn', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23884, N'Ia Nan', 631 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23887, N'Chư Prông', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23888, N'Ia Kly', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23890, N'Bình Giáo', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23893, N'Ia Drăng', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23896, N'Thăng Hưng', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23899, N'Bàu Cạn', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23902, N'Ia Phìn', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23905, N'Ia Băng', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23908, N'Ia Tôr', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23911, N'Ia Boòng', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23914, N'Ia O', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23917, N'Ia Púch', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23920, N'Ia Me', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23923, N'Ia Vê', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23924, N'Ia Bang', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23926, N'Ia Pia', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23929, N'Ia Ga', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23932, N'Ia Lâu', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23935, N'Ia Piơr', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23938, N'Ia Mơ', 632 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23941, N'Chư Sê', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23942, N'Nhơn Hoà', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23944, N'Ia Tiêm', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23945, N'Chư Pơng', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23946, N'Bar Măih', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23947, N'Bờ Ngoong', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23950, N'Ia Glai', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23953, N'AL Bá', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23954, N'Kông HTok', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23956, N'AYun', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23959, N'Ia HLốp', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23962, N'Ia Blang', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23965, N'Dun', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23966, N'Ia Pal', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23968, N'H Bông', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23971, N'Ia Hrú', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23972, N'Ia Rong', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23974, N'Ia Dreng', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23977, N'Ia Ko', 633 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23978, N'Ia Hla', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23980, N'Chư Don', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23983, N'Ia Phang', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23986, N'Ia Le', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23987, N'Ia BLứ', 639 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23989, N'Hà Tam', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23992, N'An Thành', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23995, N'Đak Pơ', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 23998, N'Yang Bắc', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24001, N'Cư An', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24004, N'Tân An', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24007, N'Phú An', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24010, N'Ya Hội', 634 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24013, N'Pờ Tó', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24016, N'Chư Răng', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24019, N'Ia KDăm', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24022, N'Kim Tân', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24025, N'Chư Mố', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24028, N'Ia Tul', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24031, N'Ia Ma Rơn', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24034, N'Ia Broăi', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24037, N'Ia Trok', 635 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24041, N'Cheo Reo', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24042, N'Hòa Bình', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24043, N'Phú Thiện', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24044, N'Đoàn Kết', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24045, N'Sông Bờ', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24046, N'Chư A Thai', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24048, N'Ayun Hạ', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24049, N'Ia Ake', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24052, N'Ia Sol', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24055, N'Ia Piar', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24058, N'Ia Peng', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24060, N'Chrôh Pơnan', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24061, N'Ia Hiao', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24064, N'Ia RBol', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24065, N'Chư Băh', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24067, N'Ia Yeng', 638 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24070, N'Ia RTô', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24073, N'Ia Sao', 624 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24076, N'Phú Túc', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24079, N'Ia RSai', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24082, N'Ia RSươm', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24085, N'Chư Gu', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24088, N'Đất Bằng', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24091, N'Ia Mláh', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24094, N'Chư Drăng', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24097, N'Phú Cần', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24100, N'Ia HDreh', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24103, N'Ia RMok', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24106, N'Chư Ngọc', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24109, N'Uar', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24112, N'Chư Rcăm', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24115, N'Krông Năng', 637 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24118, N'Tân Lập', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24121, N'Tân Hòa', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24124, N'Tân An', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24127, N'Thống Nhất', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24130, N'Thành Nhất', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24133, N'Thắng Lợi', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24136, N'Tân Lợi', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24139, N'Thành Công', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24142, N'Tân Thành', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24145, N'Tân Tiến', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24148, N'Tự An', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24151, N'Ea Tam', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24154, N'Khánh Xuân', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24157, N'Hòa Thuận', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24160, N'Cư ÊBur', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24163, N'Ea Tu', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24166, N'Hòa Thắng', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24169, N'Ea Kao', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24172, N'Hòa Phú', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24175, N'Hòa Khánh', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24178, N'Hòa Xuân', 643 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24181, N'Ea Drăng', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24184, N'Ea H''leo', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24187, N'Ea Sol', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24190, N'Ea Ral', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24193, N'Ea Wy', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24194, N'Cư A Mung', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24196, N'Cư Mốt', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24199, N'Ea Hiao', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24202, N'Ea Khal', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24205, N'Dliê Yang', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24207, N'Ea Tir', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24208, N'Ea Nam', 645 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24211, N'Ea Súp', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24214, N'Ia Lốp', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24215, N'Ia JLơi', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24217, N'Ea Rốk', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24220, N'Ya Tờ Mốt', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24221, N'Ia RVê', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24223, N'Ea Lê', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24226, N'Cư KBang', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24229, N'Ea Bung', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24232, N'Cư M''Lan', 646 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24235, N'Krông Na', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24238, N'Ea Huar', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24241, N'Ea Wer', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24244, N'Tân Hoà', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24247, N'Cuôr KNia', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24250, N'Ea Bar', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24253, N'Ea Nuôl', 647 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24256, N'Ea Pốk', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24259, N'Quảng Phú', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24262, N'Quảng Tiến', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24264, N'Ea Kuêh', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24265, N'Ea Kiết', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24268, N'Ea Tar', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24271, N'Cư Dliê M''nông', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24274, N'Ea H''đinh', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24277, N'Ea Tul', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24280, N'Ea KPam', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24283, N'Ea M''DRóh', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24286, N'Quảng Hiệp', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24289, N'Cư M''gar', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24292, N'Ea D''Rơng', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24295, N'Ea M''nang', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24298, N'Cư Suê', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24301, N'Cuor Đăng', 648 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24305, N'An Lạc', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24307, N'Cư Né', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24308, N'An Bình', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24310, N'Chư KBô', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24311, N'Thiện An', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24313, N'Cư Pơng', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24314, N'Ea Sin', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24316, N'Pơng Drang', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24317, N'Tân Lập', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24318, N'Đạt Hiếu', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24319, N'Ea Ngai', 649 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24322, N'Đoàn Kết', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24325, N'Ea Blang', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24328, N'Ea Drông', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24331, N'Thống Nhất', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24332, N'Bình Tân', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24334, N'Ea Siên', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24337, N'Bình Thuận', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24340, N'Cư Bao', 644 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24343, N'Krông Năng', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24346, N'ĐLiê Ya', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24349, N'Ea Tóh', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24352, N'Ea Tam', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24355, N'Phú Lộc', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24358, N'Tam Giang', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24359, N'Ea Puk', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24360, N'Ea Dăh', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24361, N'Ea Hồ', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24364, N'Phú Xuân', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24367, N'Cư Klông', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24370, N'Ea Tân', 650 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24373, N'Ea Kar', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24376, N'Ea Knốp', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24379, N'Ea Sô', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24380, N'Ea Sar', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24382, N'Xuân Phú', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24385, N'Cư Huê', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24388, N'Ea Tih', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24391, N'Ea Đar', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24394, N'Ea Kmút', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24397, N'Cư Ni', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24400, N'Ea Păl', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24401, N'Cư Prông', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24403, N'Ea Ô', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24404, N'Cư ELang', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24406, N'Cư Bông', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24409, N'Cư Jang', 651 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24412, N'M''Đrắk', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24415, N'Cư Prao', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24418, N'Ea Pil', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24421, N'Ea Lai', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24424, N'Ea H''MLay', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24427, N'Krông Jing', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24430, N'Ea M'' Doal', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24433, N'Ea Riêng', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24436, N'Cư M''ta', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24439, N'Cư K Róa', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24442, N'Krông Á', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24444, N'Cư San', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24445, N'Ea Trang', 652 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24448, N'Krông Kmar', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24451, N'Dang Kang', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24454, N'Cư KTy', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24457, N'Hòa Thành', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24460, N'Hòa Tân', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24463, N'Hòa Phong', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24466, N'Hòa Lễ', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24469, N'Yang Reh', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24472, N'Ea Trul', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24475, N'Khuê Ngọc Điền', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24478, N'Cư Pui', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24481, N'Hòa Sơn', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24484, N'Cư Drăm', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24487, N'Yang Mao', 653 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24490, N'Phước An', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24493, N'KRông Búk', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24496, N'Ea Kly', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24499, N'Ea Kênh', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24502, N'Ea Phê', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24505, N'Ea KNuec', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24508, N'Ea Yông', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24511, N'Hòa An', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24514, N'Ea Kuăng', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24517, N'Hòa Đông', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24520, N'Ea Hiu', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24523, N'Hòa Tiến', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24526, N'Tân Tiến', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24529, N'Vụ Bổn', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24532, N'Ea Uy', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24535, N'Ea Yiêng', 654 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24538, N'Buôn Trấp', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24540, N'Ea Ning', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24541, N'Cư Ê Wi', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24544, N'Ea Ktur', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24547, N'Ea Tiêu', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24550, N'Ea BHốk', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24553, N'Ea Hu', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24556, N'Dray Sáp', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24559, N'Ea Na', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24561, N'Dray Bhăng', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24562, N'Hòa Hiệp', 657 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24565, N'Ea Bông', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24568, N'Băng A Drênh', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24571, N'Dur KMăl', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24574, N'Bình Hòa', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24577, N'Quảng Điền', 655 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24580, N'Liên Sơn', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24583, N'Yang Tao', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24586, N'Bông Krang', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24589, N'Đắk Liêng', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24592, N'Buôn Triết', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24595, N'Buôn Tría', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24598, N'Đắk Phơi', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24601, N'Đắk Nuê', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24604, N'Krông Nô', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24607, N'Nam Ka', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24610, N'Ea R''Bin', 656 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24611, N'Nghĩa Đức', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24612, N'Nghĩa Thành', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24614, N'Nghĩa Phú', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24615, N'Nghĩa Tân', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24616, N'Quảng Sơn', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24617, N'Nghĩa Trung', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24618, N'Đăk R''Moan', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24619, N'Quảng Thành', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24620, N'Quảng Hoà', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24622, N'Đắk Ha', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24625, N'Đắk R''Măng', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24628, N'Đắk Nia', 660 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24631, N'Quảng Khê', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24634, N'Đắk Plao', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24637, N'Đắk Som', 661 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24640, N'Ea T''Ling', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24643, N'Đắk Wil', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24646, N'Ea Pô', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24649, N'Nam Dong', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24652, N'Đắk DRông', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24655, N'Tâm Thắng', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24658, N'Cư Knia', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24661, N'Trúc Sơn', 662 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24664, N'Đắk Mil', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24667, N'Đắk Lao', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24670, N'Đắk R''La', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24673, N'Đắk Gằn', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24676, N'Đức Mạnh', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24677, N'Đắk N''Drót', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24678, N'Long Sơn', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24679, N'Đắk Sắk', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24682, N'Thuận An', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24685, N'Đức Minh', 663 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24688, N'Đắk Mâm', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24691, N'Đắk Sôr', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24692, N'Nam Xuân', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24694, N'Buôn Choah', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24697, N'Nam Đà', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24699, N'Tân Thành', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24700, N'Đắk Drô', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24703, N'Nâm Nung', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24706, N'Đức Xuyên', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24709, N'Đắk Nang', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24712, N'Quảng Phú', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24715, N'Nâm N''Đir', 664 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24717, N'Đức An', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24718, N'Đắk Môl', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24719, N'Đắk Hòa', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24721, N'Nam Bình', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24722, N'Thuận Hà', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24724, N'Thuận Hạnh', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24727, N'Đắk N''Dung', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24728, N'Nâm N''Jang', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24730, N'Trường Xuân', 665 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24733, N'Kiến Đức', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24736, N'Quảng Trực', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24739, N'Đắk Búk So', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24740, N'Quảng Tâm', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24742, N'Đắk R''Tíh', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24745, N'Quảng Tín', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24746, N'Đắk Ngo', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24748, N'Quảng Tân', 667 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24750, N'Đắk Wer', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24751, N'Nhân Cơ', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24754, N'Kiến Thành', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24756, N'Nghĩa Thắng', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24757, N'Đạo Nghĩa', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24760, N'Đắk Sin', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24761, N'Hưng Bình', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24763, N'Đắk Ru', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24766, N'Nhân Đạo', 666 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24769, N'7', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24772, N'8', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24775, N'12', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24778, N'9', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24781, N'2', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24784, N'1', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24787, N'6', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24790, N'5', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24793, N'4', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24796, N'10', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24799, N'11', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24802, N'3', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24805, N'Xuân Thọ', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24808, N'Tà Nung', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24810, N'Trạm Hành', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24811, N'Xuân Trường', 672 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24814, N'Lộc Phát', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24817, N'Lộc Tiến', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24820, N'2', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24823, N'1', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24826, N'B''lao', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24829, N'Lộc Sơn', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24832, N'Đạm Bri', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24835, N'Lộc Thanh', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24838, N'Lộc Nga', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24841, N'Lộc Châu', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24844, N'Đại Lào', 673 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24846, N'Lạc Dương', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24847, N'Đạ Chais', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24848, N'Đạ Nhim', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24850, N'Đưng KNớ', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24853, N'Đạ Tông', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24856, N'Đạ Long', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24859, N'Đạ M'' Rong', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24862, N'Lát', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24865, N'Đạ Sar', 675 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24868, N'Nam Ban', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24871, N'Đinh Văn', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24874, N'Liêng Srônh', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24875, N'Đạ Rsal', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24877, N'Rô Men', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24880, N'Phú Sơn', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24883, N'Phi Tô', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24886, N'Phi Liêng', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24889, N'Đạ K'' Nàng', 674 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24892, N'Mê Linh', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24895, N'Đạ Đờn', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24898, N'Phúc Thọ', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24901, N'Đông Thanh', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24904, N'Gia Lâm', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24907, N'Tân Thanh', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24910, N'Tân Văn', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24913, N'Hoài Đức', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24916, N'Tân Hà', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24919, N'Liên Hà', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24922, N'Đan Phượng', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24925, N'Nam Hà', 676 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24928, N'D''Ran', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24931, N'Thạnh Mỹ', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24934, N'Lạc Xuân', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24937, N'Đạ Ròn', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24940, N'Lạc Lâm', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24943, N'Ka Đô', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24946, N'Quảng Lập', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24949, N'Ka Đơn', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24952, N'Tu Tra', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24955, N'Pró', 677 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24958, N'Liên Nghĩa', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24961, N'Hiệp An', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24964, N'Liên Hiệp', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24967, N'Hiệp Thạnh', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24970, N'Bình Thạnh', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24973, N'N''Thol Hạ', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24976, N'Tân Hội', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24979, N'Tân Thành', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24982, N'Phú Hội', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24985, N'Ninh Gia', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24988, N'Tà Năng', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24989, N'Đa Quyn', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24991, N'Tà Hine', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24994, N'Đà Loan', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 24997, N'Ninh Loan', 678 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25000, N'Di Linh', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25003, N'Đinh Trang Thượng', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25006, N'Tân Thượng', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25007, N'Tân Lâm', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25009, N'Tân Châu', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25012, N'Tân Nghĩa', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25015, N'Gia Hiệp', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25018, N'Đinh Lạc', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25021, N'Tam Bố', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25024, N'Đinh Trang Hòa', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25027, N'Liên Đầm', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25030, N'Gung Ré', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25033, N'Bảo Thuận', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25036, N'Hòa Ninh', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25039, N'Hòa Trung', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25042, N'Hòa Nam', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25045, N'Hòa Bắc', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25048, N'Sơn Điền', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25051, N'Gia Bắc', 679 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25054, N'Lộc Thắng', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25057, N'Lộc Bảo', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25060, N'Lộc Lâm', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25063, N'Lộc Phú', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25066, N'Lộc Bắc', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25069, N'B'' Lá', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25072, N'Lộc Ngãi', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25075, N'Lộc Quảng', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25078, N'Lộc Tân', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25081, N'Lộc Đức', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25084, N'Lộc An', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25087, N'Tân Lạc', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25090, N'Lộc Thành', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25093, N'Lộc Nam', 680 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25096, N'Đạ M''ri', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25099, N'Ma Đa Guôi', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25105, N'Hà Lâm', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25108, N'Đạ Tồn', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25111, N'Đạ Oai', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25114, N'Đạ Ploa', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25117, N'Ma Đa Guôi', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25120, N'Đoàn Kết', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25123, N'Phước Lộc', 681 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25126, N'Đạ Tẻh', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25129, N'An Nhơn', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25132, N'Quốc Oai', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25135, N'Mỹ Đức', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25138, N'Quảng Trị', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25141, N'Đạ Lây', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25147, N'Triệu Hải', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25153, N'Đạ Kho', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25156, N'Đạ Pal', 682 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25159, N'Cát Tiên', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25162, N'Tiên Hoàng', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25165, N'Phước Cát 2', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25168, N'Gia Viễn', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25171, N'Nam Ninh', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25180, N'Phước Cát', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25183, N'Đức Phổ', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25189, N'Quảng Ngãi', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25192, N'Đồng Nai Thượng', 683 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25195, N'Tân Phú', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25198, N'Tân Đồng', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25201, N'Tân Bình', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25204, N'Tân Xuân', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25205, N'Tân Thiện', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25207, N'Tân Thành', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25210, N'Tiến Thành', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25213, N'Tiến Hưng', 689 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25216, N'Thác Mơ', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25217, N'Long Thủy', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25219, N'Phước Bình', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25220, N'Long Phước', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25222, N'Bù Gia Mập', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25225, N'Đak Ơ', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25228, N'Đức Hạnh', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25229, N'Phú Văn', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25231, N'Đa Kia', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25232, N'Phước Minh', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25234, N'Bình Thắng', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25237, N'Sơn Giang', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25240, N'Long Bình', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25243, N'Bình Tân', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25244, N'Bình Sơn', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25245, N'Long Giang', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25246, N'Long Hưng', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25249, N'Phước Tín', 688 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25250, N'Phước Tân', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25252, N'Bù Nho', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25255, N'Long Hà', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25258, N'Long Tân', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25261, N'Phú Trung', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25264, N'Phú Riềng', 698 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25267, N'Phú Nghĩa', 691 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25270, N'Lộc Ninh', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25273, N'Lộc Hòa', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25276, N'Lộc An', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25279, N'Lộc Tấn', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25280, N'Lộc Thạnh', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25282, N'Lộc Hiệp', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25285, N'Lộc Thiện', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25288, N'Lộc Thuận', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25291, N'Lộc Quang', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25292, N'Lộc Phú', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25294, N'Lộc Thành', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25297, N'Lộc Thái', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25300, N'Lộc Điền', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25303, N'Lộc Hưng', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25305, N'Lộc Thịnh', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25306, N'Lộc Khánh', 692 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25308, N'Thanh Bình', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25309, N'Hưng Phước', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25310, N'Phước Thiện', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25312, N'Thiện Hưng', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25315, N'Thanh Hòa', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25318, N'Tân Thành', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25320, N'Hưng Chiến', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25321, N'Tân Tiến', 693 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25324, N'An Lộc', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25325, N'Phú Thịnh', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25326, N'Phú Đức', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25327, N'Thanh An', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25330, N'An Khương', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25333, N'Thanh Lương', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25336, N'Thanh Phú', 690 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25339, N'An Phú', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25342, N'Tân Lợi', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25345, N'Tân Hưng', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25348, N'Minh Đức', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25349, N'Minh Tâm', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25351, N'Phước An', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25354, N'Thanh Bình', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25357, N'Tân Khai', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25360, N'Đồng Nơ', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25361, N'Tân Hiệp', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25363, N'Tân Phú', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25366, N'Thuận Lợi', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25369, N'Đồng Tâm', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25372, N'Tân Phước', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25375, N'Tân Hưng', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25378, N'Tân Lợi', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25381, N'Tân Lập', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25384, N'Tân Hòa', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25387, N'Thuận Phú', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25390, N'Đồng Tiến', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25393, N'Tân Tiến', 695 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25396, N'Đức Phong', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25398, N'Đường 10', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25399, N'Đak Nhau', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25400, N'Phú Sơn', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25402, N'Thọ Sơn', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25404, N'Bình Minh', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25405, N'Bom Bo', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25408, N'Minh Hưng', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25411, N'Đoàn Kết', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25414, N'Đồng Nai', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25417, N'Đức Liễu', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25420, N'Thống Nhất', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25423, N'Nghĩa Trung', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25424, N'Nghĩa Bình', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25426, N'Đăng Hà', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25429, N'Phước Sơn', 696 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25432, N'Chơn Thành', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25433, N'Thành Tâm', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25435, N'Minh Lập', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25438, N'Tân Quan', 694 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25439, N'Quang Minh', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25441, N'Minh Hưng', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25444, N'Minh Long', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25447, N'Minh Thành', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25450, N'Nha Bích', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25453, N'Minh Thắng', 697 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25456, N'1', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25459, N'3', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25462, N'4', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25465, N'Hiệp Ninh', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25468, N'2', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25471, N'Thạnh Tân', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25474, N'Tân Bình', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25477, N'Bình Minh', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25480, N'Ninh Sơn', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25483, N'Ninh Thạnh', 703 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25486, N'Tân Biên', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25489, N'Tân Lập', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25492, N'Thạnh Bắc', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25495, N'Tân Bình', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25498, N'Thạnh Bình', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25501, N'Thạnh Tây', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25504, N'Hòa Hiệp', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25507, N'Tân Phong', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25510, N'Mỏ Công', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25513, N'Trà Vong', 705 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25516, N'Tân Châu', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25519, N'Tân Hà', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25522, N'Tân Đông', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25525, N'Tân Hội', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25528, N'Tân Hòa', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25531, N'Suối Ngô', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25534, N'Suối Dây', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25537, N'Tân Hiệp', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25540, N'Thạnh Đông', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25543, N'Tân Thành', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25546, N'Tân Phú', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25549, N'Tân Hưng', 706 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25552, N'Dương Minh Châu', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25555, N'Suối Đá', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25558, N'Phan', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25561, N'Phước Ninh', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25564, N'Phước Minh', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25567, N'Bàu Năng', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25570, N'Chà Là', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25573, N'Cầu Khởi', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25576, N'Bến Củi', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25579, N'Lộc Ninh', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25582, N'Truông Mít', 707 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25585, N'Châu Thành', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25588, N'Hảo Đước', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25591, N'Phước Vinh', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25594, N'Đồng Khởi', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25597, N'Thái Bình', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25600, N'An Cơ', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25603, N'Biên Giới', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25606, N'Hòa Thạnh', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25609, N'Trí Bình', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25612, N'Hòa Hội', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25615, N'An Bình', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25618, N'Thanh Điền', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25621, N'Thành Long', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25624, N'Ninh Điền', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25627, N'Long Vĩnh', 708 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25630, N'Hòa Thành', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25633, N'Hiệp Tân', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25636, N'Long Thành Bắc', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25639, N'Trường Hòa', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25642, N'Trường Đông', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25645, N'Long Thành Trung', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25648, N'Trường Tây', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25651, N'Long Thành Nam', 709 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25654, N'Gò Dầu', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25657, N'Thạnh Đức', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25660, N'Cẩm Giang', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25663, N'Hiệp Thạnh', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25666, N'Bàu Đồn', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25669, N'Phước Thạnh', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25672, N'Phước Đông', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25675, N'Phước Trạch', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25678, N'Thanh Phước', 710 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25681, N'Bến Cầu', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25684, N'Long Chữ', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25687, N'Long Phước', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25690, N'Long Giang', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25693, N'Tiên Thuận', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25696, N'Long Khánh', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25699, N'Lợi Thuận', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25702, N'Long Thuận', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25705, N'An Thạnh', 711 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25708, N'Trảng Bàng', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25711, N'Đôn Thuận', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25714, N'Hưng Thuận', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25717, N'Lộc Hưng', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25720, N'Gia Lộc', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25723, N'Gia Bình', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25726, N'Phước Lưu', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25729, N'Bình Thạnh', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25732, N'An Tịnh', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25735, N'An Hòa', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25738, N'Phước Chỉ', 712 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25741, N'Hiệp Thành', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25744, N'Phú Lợi', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25747, N'Phú Cường', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25750, N'Phú Hòa', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25753, N'Phú Thọ', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25756, N'Chánh Nghĩa', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25759, N'Định Hoà', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25760, N'Hoà Phú', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25762, N'Phú Mỹ', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25763, N'Phú Tân', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25765, N'Tân An', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25768, N'Hiệp An', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25771, N'Tương Bình Hiệp', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25774, N'Chánh Mỹ', 718 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25777, N'Dầu Tiếng', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25780, N'Minh Hoà', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25783, N'Minh Thạnh', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25786, N'Minh Tân', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25789, N'Định An', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25792, N'Long Hoà', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25795, N'Định Thành', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25798, N'Định Hiệp', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25801, N'An Lập', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25804, N'Long Tân', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25807, N'Thanh An', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25810, N'Thanh Tuyền', 720 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25813, N'Mỹ Phước', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25816, N'Trừ Văn Thố', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25819, N'Cây Trường II', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25822, N'Lai Uyên', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25825, N'Tân Hưng', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25828, N'Long Nguyên', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25831, N'Hưng Hòa', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25834, N'Lai Hưng', 719 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25837, N'Chánh Phú Hòa', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25840, N'An Điền', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25843, N'An Tây', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25846, N'Thới Hòa', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25849, N'Hòa Lợi', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25852, N'Tân Định', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25855, N'Phú An', 721 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25858, N'Phước Vĩnh', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25861, N'An Linh', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25864, N'Phước Sang', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25865, N'An Thái', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25867, N'An Long', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25870, N'An Bình', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25873, N'Tân Hiệp', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25876, N'Tam Lập', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25879, N'Tân Long', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25882, N'Vĩnh Hoà', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25885, N'Phước Hoà', 722 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25888, N'Uyên Hưng', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25891, N'Tân Phước Khánh', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25894, N'Tân Định', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25897, N'Bình Mỹ', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25900, N'Tân Bình', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25903, N'Tân Lập', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25906, N'Tân Thành', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25907, N'Đất Cuốc', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25908, N'Hiếu Liêm', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25909, N'Lạc An', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25912, N'Vĩnh Tân', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25915, N'Hội Nghĩa', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25918, N'Tân Mỹ', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25920, N'Tân Hiệp', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25921, N'Khánh Bình', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25924, N'Phú Chánh', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25927, N'Thường Tân', 726 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25930, N'Bạch Đằng', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25933, N'Tân Vĩnh Hiệp', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25936, N'Thạnh Phước', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25937, N'Thạnh Hội', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25939, N'Thái Hòa', 723 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25942, N'Dĩ An', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25945, N'Tân Bình', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25948, N'Tân Đông Hiệp', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25951, N'Bình An', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25954, N'Bình Thắng', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25957, N'Đông Hòa', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25960, N'An Bình', 724 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25963, N'An Thạnh', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25966, N'Lái Thiêu', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25969, N'Bình Chuẩn', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25972, N'Thuận Giao', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25975, N'An Phú', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25978, N'Hưng Định', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25981, N'An Sơn', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25984, N'Bình Nhâm', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25987, N'Bình Hòa', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25990, N'Vĩnh Phú', 725 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25993, N'Trảng Dài', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25996, N'Tân Phong', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 25999, N'Tân Biên', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26002, N'Hố Nai', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26005, N'Tân Hòa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26008, N'Tân Hiệp', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26011, N'Bửu Long', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26014, N'Tân Tiến', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26017, N'Tam Hiệp', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26020, N'Long Bình', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26023, N'Quang Vinh', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26026, N'Tân Mai', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26029, N'Thống Nhất', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26032, N'Trung Dũng', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26035, N'Tam Hòa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26038, N'Hòa Bình', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26041, N'Quyết Thắng', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26044, N'Thanh Bình', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26047, N'Bình Đa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26050, N'An Bình', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26053, N'Bửu Hòa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26056, N'Long Bình Tân', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26059, N'Tân Vạn', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26062, N'Tân Hạnh', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26065, N'Hiệp Hòa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26068, N'Hóa An', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26071, N'Xuân Trung', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26074, N'Xuân Thanh', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26077, N'Xuân Bình', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26080, N'Xuân An', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26083, N'Xuân Hoà', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26086, N'Phú Bình', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26089, N'Bình Lộc', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26092, N'Bảo Quang', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26095, N'Suối Tre', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26098, N'Bảo Vinh', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26101, N'Xuân Lập', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26104, N'Bàu Sen', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26107, N'Bàu Trâm', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26110, N'Xuân Tân', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26113, N'Hàng Gòn', 732 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26116, N'Tân Phú', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26119, N'Dak Lua', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26122, N'Nam Cát Tiên', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26125, N'Phú An', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26128, N'Núi Tượng', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26131, N'Tà Lài', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26134, N'Phú Lập', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26137, N'Phú Sơn', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26140, N'Phú Thịnh', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26143, N'Thanh Sơn', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26146, N'Phú Trung', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26149, N'Phú Xuân', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26152, N'Phú Lộc', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26155, N'Phú Lâm', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26158, N'Phú Bình', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26161, N'Phú Thanh', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26164, N'Trà Cổ', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26167, N'Phú Điền', 734 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26170, N'Vĩnh An', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26173, N'Phú Lý', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26176, N'Trị An', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26179, N'Tân An', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26182, N'Vĩnh Tân', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26185, N'Bình Lợi', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26188, N'Thạnh Phú', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26191, N'Thiện Tân', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26194, N'Tân Bình', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26197, N'Bình Hòa', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26200, N'Mã Đà', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26203, N'Hiếu Liêm', 735 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26206, N'Định Quán', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26209, N'Thanh Sơn', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26212, N'Phú Tân', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26215, N'Phú Vinh', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26218, N'Phú Lợi', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26221, N'Phú Hòa', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26224, N'Ngọc Định', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26227, N'La Ngà', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26230, N'Gia Canh', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26233, N'Phú Ngọc', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26236, N'Phú Cường', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26239, N'Túc Trưng', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26242, N'Phú Túc', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26245, N'Suối Nho', 736 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26248, N'Trảng Bom', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26251, N'Thanh Bình', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26254, N'Cây Gáo', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26257, N'Bàu Hàm', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26260, N'Sông Thao', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26263, N'Sông Trầu', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26266, N'Đông Hoà', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26269, N'Bắc Sơn', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26272, N'Hố Nai 3', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26275, N'Tây Hoà', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26278, N'Bình Minh', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26281, N'Trung Hoà', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26284, N'Đồi 61', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26287, N'Hưng Thịnh', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26290, N'Quảng Tiến', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26293, N'Giang Điền', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26296, N'An Viễn', 737 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26299, N'Gia Tân 1', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26302, N'Gia Tân 2', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26305, N'Gia Tân 3', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26308, N'Gia Kiệm', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26311, N'Quang Trung', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26314, N'Bàu Hàm 2', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26317, N'Hưng Lộc', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26320, N'Lộ 25', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26323, N'Xuân Thiện', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26326, N'Dầu Giây', 738 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26329, N'Sông Nhạn', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26332, N'Xuân Quế', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26335, N'Nhân Nghĩa', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26338, N'Xuân Đường', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26341, N'Long Giao', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26344, N'Xuân Mỹ', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26347, N'Thừa Đức', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26350, N'Bảo Bình', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26353, N'Xuân Bảo', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26356, N'Xuân Tây', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26359, N'Xuân Đông', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26362, N'Sông Ray', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26365, N'Lâm San', 739 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26368, N'Long Thành', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26371, N'An Hòa', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26374, N'Tam Phước', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26377, N'Phước Tân', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26380, N'Long Hưng', 731 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26383, N'An Phước', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26386, N'Bình An', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26389, N'Long Đức', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26392, N'Lộc An', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26395, N'Bình Sơn', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26398, N'Tam An', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26401, N'Cẩm Đường', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26404, N'Long An', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26410, N'Bàu Cạn', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26413, N'Long Phước', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26416, N'Phước Bình', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26419, N'Tân Hiệp', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26422, N'Phước Thái', 740 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26425, N'Gia Ray', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26428, N'Xuân Bắc', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26431, N'Suối Cao', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26434, N'Xuân Thành', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26437, N'Xuân Thọ', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26440, N'Xuân Trường', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26443, N'Xuân Hòa', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26446, N'Xuân Hưng', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26449, N'Xuân Tâm', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26452, N'Suối Cát', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26455, N'Xuân Hiệp', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26458, N'Xuân Phú', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26461, N'Xuân Định', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26464, N'Bảo Hoà', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26467, N'Lang Minh', 741 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26470, N'Phước Thiền', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26473, N'Long Tân', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26476, N'Đại Phước', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26479, N'Hiệp Phước', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26482, N'Phú Hữu', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26485, N'Phú Hội', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26488, N'Phú Thạnh', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26491, N'Phú Đông', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26494, N'Long Thọ', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26497, N'Vĩnh Thanh', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26500, N'Phước Khánh', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26503, N'Phước An', 742 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26506, N'1', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26508, N'Thắng Tam', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26509, N'2', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26512, N'3', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26515, N'4', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26518, N'5', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26521, N'Thắng Nhì', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26524, N'7', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26526, N'Nguyễn An Ninh', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26527, N'8', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26530, N'9', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26533, N'Thắng Nhất', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26535, N'Rạch Dừa', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26536, N'10', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26539, N'11', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26542, N'12', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26545, N'Long Sơn', 747 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26548, N'Phước Hưng', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26551, N'Phước Hiệp', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26554, N'Phước Nguyên', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26557, N'Long Toàn', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26558, N'Long Tâm', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26560, N'Phước Trung', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26563, N'Long Hương', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26566, N'Kim Dinh', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26567, N'Tân Hưng', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26569, N'Long Phước', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26572, N'Hoà Long', 748 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26574, N'Bàu Chinh', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26575, N'Ngãi Giao', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26578, N'Bình Ba', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26581, N'Suối Nghệ', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26584, N'Xuân Sơn', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26587, N'Sơn Bình', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26590, N'Bình Giã', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26593, N'Bình Trung', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26596, N'Xà Bang', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26599, N'Cù Bị', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26602, N'Láng Lớn', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26605, N'Quảng Thành', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26608, N'Kim Long', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26611, N'Suối Rao', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26614, N'Đá Bạc', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26617, N'Nghĩa Thành', 750 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26620, N'Phước Bửu', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26623, N'Phước Thuận', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26626, N'Phước Tân', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26629, N'Xuyên Mộc', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26632, N'Bông Trang', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26635, N'Tân Lâm', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26638, N'Bàu Lâm', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26641, N'Hòa Bình', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26644, N'Hòa Hưng', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26647, N'Hòa Hiệp', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26650, N'Hòa Hội', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26653, N'Bưng Riềng', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26656, N'Bình Châu', 751 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26659, N'Long Điền', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26662, N'Long Hải', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26665, N'An Ngãi', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26668, N'Tam Phước', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26671, N'An Nhứt', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26674, N'Phước Tỉnh', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26677, N'Phước Hưng', 752 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26680, N'Đất Đỏ', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26683, N'Phước Long Thọ', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26686, N'Phước Hội', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26689, N'Long Mỹ', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26692, N'Phước Hải', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26695, N'Long Tân', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26698, N'Láng Dài', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26701, N'Lộc An', 753 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26704, N'Phú Mỹ', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26707, N'Tân Hoà', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26710, N'Tân Hải', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26713, N'Phước Hoà', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26716, N'Tân Phước', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26719, N'Mỹ Xuân', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26722, N'Sông Xoài', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26725, N'Hắc Dịch', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26728, N'Châu Pha', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26731, N'Tóc Tiên', 754 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26734, N'Tân Định', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26737, N'Đa Kao', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26740, N'Bến Nghé', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26743, N'Bến Thành', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26746, N'Nguyễn Thái Bình', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26749, N'Phạm Ngũ Lão', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26752, N'Cầu Ông Lãnh', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26755, N'Cô Giang', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26758, N'Nguyễn Cư Trinh', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26761, N'Cầu Kho', 760 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26764, N'Thạnh Xuân', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26767, N'Thạnh Lộc', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26770, N'Hiệp Thành', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26773, N'Thới An', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26776, N'Tân Chánh Hiệp', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26779, N'An Phú Đông', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26782, N'Tân Thới Hiệp', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26785, N'Trung Mỹ Tây', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26787, N'Tân Hưng Thuận', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26788, N'Đông Hưng Thuận', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26791, N'Tân Thới Nhất', 761 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26794, N'Linh Xuân', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26797, N'Bình Chiểu', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26800, N'Linh Trung', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26803, N'Tam Bình', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26806, N'Tam Phú', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26809, N'Hiệp Bình Phước', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26812, N'Hiệp Bình Chánh', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26815, N'Linh Chiểu', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26818, N'Linh Tây', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26821, N'Linh Đông', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26824, N'Bình Thọ', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26827, N'Trường Thọ', 762 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26830, N'Long Bình', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26833, N'Long Thạnh Mỹ', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26836, N'Tân Phú', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26839, N'Hiệp Phú', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26842, N'Tăng Nhơn Phú A', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26845, N'Tăng Nhơn Phú B', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26848, N'Phước Long B', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26851, N'Phước Long A', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26854, N'Trường Thạnh', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26857, N'Long Phước', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26860, N'Long Trường', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26863, N'Phước Bình', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26866, N'Phú Hữu', 763 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26869, N'15', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26872, N'13', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26875, N'17', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26876, N'6', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26878, N'16', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26881, N'12', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26882, N'14', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26884, N'10', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26887, N'05', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26890, N'07', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26893, N'04', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26896, N'01', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26897, N'9', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26898, N'8', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26899, N'11', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26902, N'03', 764 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26905, N'13', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26908, N'11', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26911, N'27', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26914, N'26', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26917, N'12', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26920, N'25', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26923, N'05', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26926, N'07', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26929, N'24', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26932, N'06', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26935, N'14', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26938, N'15', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26941, N'02', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26944, N'01', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26947, N'03', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26950, N'17', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26953, N'21', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26956, N'22', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26959, N'19', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26962, N'28', 765 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26965, N'02', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26968, N'04', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26971, N'12', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26974, N'13', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26977, N'01', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26980, N'03', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26983, N'11', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26986, N'07', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26989, N'05', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26992, N'10', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26995, N'06', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 26998, N'08', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27001, N'09', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27004, N'14', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27007, N'15', 766 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27010, N'Tân Sơn Nhì', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27013, N'Tây Thạnh', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27016, N'Sơn Kỳ', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27019, N'Tân Quý', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27022, N'Tân Thành', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27025, N'Phú Thọ Hòa', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27028, N'Phú Thạnh', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27031, N'Phú Trung', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27034, N'Hòa Thạnh', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27037, N'Hiệp Tân', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27040, N'Tân Thới Hòa', 767 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27043, N'04', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27046, N'05', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27049, N'09', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27052, N'07', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27055, N'03', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27058, N'01', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27061, N'02', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27064, N'08', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27067, N'15', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27070, N'10', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27073, N'11', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27076, N'17', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27079, N'14', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27082, N'12', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27085, N'13', 768 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27088, N'Thảo Điền', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27091, N'An Phú', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27094, N'Bình An', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27097, N'Bình Trưng Đông', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27100, N'Bình Trưng Tây', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27103, N'Bình Khánh', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27106, N'An Khánh', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27109, N'Cát Lái', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27112, N'Thạnh Mỹ Lợi', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27115, N'An Lợi Đông', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27118, N'Thủ Thiêm', 769 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27121, N'08', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27124, N'07', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27127, N'14', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27130, N'12', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27133, N'11', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27136, N'13', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27139, N'06', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27142, N'09', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27145, N'10', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27148, N'04', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27151, N'05', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27154, N'03', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27157, N'02', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27160, N'01', 770 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27163, N'15', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27166, N'13', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27169, N'14', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27172, N'12', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27175, N'11', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27178, N'10', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27181, N'09', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27184, N'01', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27187, N'08', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27190, N'02', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27193, N'04', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27196, N'07', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27199, N'05', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27202, N'06', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27205, N'03', 771 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27208, N'15', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27211, N'05', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27214, N'14', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27217, N'11', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27220, N'03', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27223, N'10', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27226, N'13', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27229, N'08', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27232, N'09', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27235, N'12', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27238, N'07', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27241, N'06', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27244, N'04', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27247, N'01', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27250, N'02', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27253, N'16', 772 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27256, N'12', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27259, N'13', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27262, N'09', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27265, N'06', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27268, N'08', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27271, N'10', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27274, N'05', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27277, N'18', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27280, N'14', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27283, N'04', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27286, N'03', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27289, N'16', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27292, N'02', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27295, N'15', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27298, N'01', 773 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27301, N'04', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27304, N'09', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27307, N'03', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27310, N'12', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27313, N'02', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27316, N'08', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27319, N'15', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27322, N'07', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27325, N'01', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27328, N'11', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27331, N'14', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27334, N'05', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27337, N'06', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27340, N'10', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27343, N'13', 774 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27346, N'14', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27349, N'13', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27352, N'09', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27355, N'06', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27358, N'12', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27361, N'05', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27364, N'11', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27367, N'02', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27370, N'01', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27373, N'04', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27376, N'08', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27379, N'03', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27382, N'07', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27385, N'10', 775 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27388, N'08', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27391, N'02', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27394, N'01', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27397, N'03', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27400, N'11', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27403, N'09', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27406, N'10', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27409, N'04', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27412, N'13', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27415, N'12', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27418, N'05', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27421, N'14', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27424, N'06', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27427, N'15', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27430, N'16', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27433, N'07', 776 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27436, N'Bình Hưng Hòa', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27439, N'Bình Hưng Hoà A', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27442, N'Bình Hưng Hoà B', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27445, N'Bình Trị Đông', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27448, N'Bình Trị Đông A', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27451, N'Bình Trị Đông B', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27454, N'Tân Tạo', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27457, N'Tân Tạo A', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27460, N'An Lạc', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27463, N'An Lạc A', 777 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27466, N'Tân Thuận Đông', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27469, N'Tân Thuận Tây', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27472, N'Tân Kiểng', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27475, N'Tân Hưng', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27478, N'Bình Thuận', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27481, N'Tân Quy', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27484, N'Phú Thuận', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27487, N'Tân Phú', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27490, N'Tân Phong', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27493, N'Phú Mỹ', 778 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27496, N'Củ Chi', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27499, N'Phú Mỹ Hưng', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27502, N'An Phú', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27505, N'Trung Lập Thượng', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27508, N'An Nhơn Tây', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27511, N'Nhuận Đức', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27514, N'Phạm Văn Cội', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27517, N'Phú Hòa Đông', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27520, N'Trung Lập Hạ', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27523, N'Trung An', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27526, N'Phước Thạnh', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27529, N'Phước Hiệp', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27532, N'Tân An Hội', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27535, N'Phước Vĩnh An', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27538, N'Thái Mỹ', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27541, N'Tân Thạnh Tây', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27544, N'Hòa Phú', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27547, N'Tân Thạnh Đông', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27550, N'Bình Mỹ', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27553, N'Tân Phú Trung', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27556, N'Tân Thông Hội', 783 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27559, N'Hóc Môn', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27562, N'Tân Hiệp', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27565, N'Nhị Bình', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27568, N'Đông Thạnh', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27571, N'Tân Thới Nhì', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27574, N'Thới Tam Thôn', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27577, N'Xuân Thới Sơn', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27580, N'Tân Xuân', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27583, N'Xuân Thới Đông', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27586, N'Trung Chánh', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27589, N'Xuân Thới Thượng', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27592, N'Bà Điểm', 784 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27595, N'Tân Túc', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27598, N'Phạm Văn Hai', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27601, N'Vĩnh Lộc A', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27604, N'Vĩnh Lộc B', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27607, N'Bình Lợi', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27610, N'Lê Minh Xuân', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27613, N'Tân Nhựt', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27616, N'Tân Kiên', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27619, N'Bình Hưng', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27622, N'Phong Phú', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27625, N'An Phú Tây', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27628, N'Hưng Long', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27631, N'Đa Phước', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27634, N'Tân Quý Tây', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27637, N'Bình Chánh', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27640, N'Quy Đức', 785 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27643, N'Nhà Bè', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27646, N'Phước Kiển', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27649, N'Phước Lộc', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27652, N'Nhơn Đức', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27655, N'Phú Xuân', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27658, N'Long Thới', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27661, N'Hiệp Phước', 786 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27664, N'Cần Thạnh', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27667, N'Bình Khánh', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27670, N'Tam Thôn Hiệp', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27673, N'An Thới Đông', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27676, N'Thạnh An', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27679, N'Long Hòa', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27682, N'Lý Nhơn', 787 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27685, N'5', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27688, N'2', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27691, N'4', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27692, N'Tân Khánh', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27694, N'1', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27697, N'3', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27698, N'7', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27700, N'6', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27703, N'Hướng Thọ Phú', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27706, N'Nhơn Thạnh Trung', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27709, N'Lợi Bình Nhơn', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27712, N'Bình Tâm', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27715, N'Khánh Hậu', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27718, N'An Vĩnh Ngãi', 794 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27721, N'Tân Hưng', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27724, N'Hưng Hà', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27727, N'Hưng Điền B', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27730, N'Hưng Điền', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27733, N'Thạnh Hưng', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27736, N'Hưng Thạnh', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27739, N'Vĩnh Thạnh', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27742, N'Vĩnh Châu B', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27745, N'Vĩnh Lợi', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27748, N'Vĩnh Đại', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27751, N'Vĩnh Châu A', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27754, N'Vĩnh Bửu', 796 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27757, N'Vĩnh Hưng', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27760, N'Hưng Điền A', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27763, N'Khánh Hưng', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27766, N'Thái Trị', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27769, N'Vĩnh Trị', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27772, N'Thái Bình Trung', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27775, N'Vĩnh Bình', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27778, N'Vĩnh Thuận', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27781, N'Tuyên Bình', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27784, N'Tuyên Bình Tây', 797 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27787, N'1', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27788, N'2', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27790, N'Thạnh Trị', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27793, N'Bình Hiệp', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27796, N'Bình Hòa Tây', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27799, N'Bình Tân', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27802, N'Bình Thạnh', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27805, N'Tuyên Thạnh', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27806, N'3', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27808, N'Bình Hòa Trung', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27811, N'Bình Hòa Đông', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27814, N'Bình Phong Thạnh', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27817, N'Thạnh Hưng', 795 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27820, N'Tân Lập', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27823, N'Tân Thành', 798 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27826, N'Tân Thạnh', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27829, N'Bắc Hòa', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27832, N'Hậu Thạnh Tây', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27835, N'Nhơn Hòa Lập', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27838, N'Tân Lập', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27841, N'Hậu Thạnh Đông', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27844, N'Nhơn Hoà', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27847, N'Kiến Bình', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27850, N'Tân Thành', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27853, N'Tân Bình', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27856, N'Tân Ninh', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27859, N'Nhơn Ninh', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27862, N'Tân Hòa', 799 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27865, N'Thạnh Hóa', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27868, N'Tân Hiệp', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27871, N'Thuận Bình', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27874, N'Thạnh Phước', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27877, N'Thạnh Phú', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27880, N'Thuận Nghĩa Hòa', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27883, N'Thủy Đông', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27886, N'Thủy Tây', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27889, N'Tân Tây', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27892, N'Tân Đông', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27895, N'Thạnh An', 800 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27898, N'Đông Thành', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27901, N'Mỹ Quý Đông', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27904, N'Mỹ Thạnh Bắc', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27907, N'Mỹ Quý Tây', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27910, N'Mỹ Thạnh Tây', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27913, N'Mỹ Thạnh Đông', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27916, N'Bình Thành', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27919, N'Bình Hòa Bắc', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27922, N'Bình Hòa Hưng', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27925, N'Bình Hòa Nam', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27928, N'Mỹ Bình', 801 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27931, N'Hậu Nghĩa', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27934, N'Hiệp Hòa', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27937, N'Đức Hòa', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27940, N'Lộc Giang', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27943, N'An Ninh Đông', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27946, N'An Ninh Tây', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27949, N'Tân Mỹ', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27952, N'Hiệp Hòa', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27955, N'Đức Lập Thượng', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27958, N'Đức Lập Hạ', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27961, N'Tân Phú', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27964, N'Mỹ Hạnh Bắc', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27967, N'Đức Hòa Thượng', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27970, N'Hòa Khánh Tây', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27973, N'Hòa Khánh Đông', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27976, N'Mỹ Hạnh Nam', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27979, N'Hòa Khánh Nam', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27982, N'Đức Hòa Đông', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27985, N'Đức Hòa Hạ', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27988, N'Hựu Thạnh', 802 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27991, N'Bến Lức', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27994, N'Thạnh Lợi', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 27997, N'Lương Bình', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28000, N'Thạnh Hòa', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28003, N'Lương Hòa', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28006, N'Tân Hòa', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28009, N'Tân Bửu', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28012, N'An Thạnh', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28015, N'Bình Đức', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28018, N'Mỹ Yên', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28021, N'Thanh Phú', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28024, N'Long Hiệp', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28027, N'Thạnh Đức', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28030, N'Phước Lợi', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28033, N'Nhựt Chánh', 803 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28036, N'Thủ Thừa', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28039, N'Long Thạnh', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28042, N'Tân Thành', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28045, N'Long Thuận', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28048, N'Mỹ Lạc', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28051, N'Mỹ Thạnh', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28054, N'Bình An', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28057, N'Nhị Thành', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28060, N'Mỹ An', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28063, N'Bình Thạnh', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28066, N'Mỹ Phú', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28069, N'Tân Long', 804 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28075, N'Tân Trụ', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28081, N'Tân Bình', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28084, N'Quê Mỹ Thạnh', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28087, N'Lạc Tấn', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28090, N'Bình Trinh Đông', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28093, N'Tân Phước Tây', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28096, N'Bình Lãng', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28099, N'Bình Tịnh', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28102, N'Đức Tân', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28105, N'Nhựt Ninh', 805 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28108, N'Cần Đước', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28111, N'Long Trạch', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28114, N'Long Khê', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28117, N'Long Định', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28120, N'Phước Vân', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28123, N'Long Hòa', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28126, N'Long Cang', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28129, N'Long Sơn', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28132, N'Tân Trạch', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28135, N'Mỹ Lệ', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28138, N'Tân Lân', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28141, N'Phước Tuy', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28144, N'Long Hựu Đông', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28147, N'Tân Ân', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28150, N'Phước Đông', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28153, N'Long Hựu Tây', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28156, N'Tân Chánh', 806 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28159, N'Cần Giuộc', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28162, N'Phước Lý', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28165, N'Long Thượng', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28168, N'Long Hậu', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28174, N'Phước Hậu', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28177, N'Mỹ Lộc', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28180, N'Phước Lại', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28183, N'Phước Lâm', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28189, N'Thuận Thành', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28192, N'Phước Vĩnh Tây', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28195, N'Phước Vĩnh Đông', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28198, N'Long An', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28201, N'Long Phụng', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28204, N'Đông Thạnh', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28207, N'Tân Tập', 807 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28210, N'Tầm Vu', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28213, N'Bình Quới', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28216, N'Hòa Phú', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28219, N'Phú Ngãi Trị', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28222, N'Vĩnh Công', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28225, N'Thuận Mỹ', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28228, N'Hiệp Thạnh', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28231, N'Phước Tân Hưng', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28234, N'Thanh Phú Long', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28237, N'Dương Xuân Hội', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28240, N'An Lục Long', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28243, N'Long Trì', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28246, N'Thanh Vĩnh Đông', 808 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28249, N'5', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28252, N'4', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28255, N'7', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28258, N'3', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28261, N'1', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28264, N'2', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28267, N'8', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28270, N'6', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28273, N'9', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28276, N'10', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28279, N'Tân Long', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28282, N'Đạo Thạnh', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28285, N'Trung An', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28288, N'Mỹ Phong', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28291, N'Tân Mỹ Chánh', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28294, N'3', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28297, N'2', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28300, N'4', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28303, N'1', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28306, N'5', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28309, N'Long Hưng', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28312, N'Long Thuận', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28315, N'Long Chánh', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28318, N'Long Hòa', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28321, N'Mỹ Phước', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28324, N'Tân Hòa Đông', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28327, N'Thạnh Tân', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28330, N'Thạnh Mỹ', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28333, N'Thạnh Hoà', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28336, N'Phú Mỹ', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28339, N'Tân Hòa Thành', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28342, N'Hưng Thạnh', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28345, N'Tân Lập 1', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28348, N'Tân Hòa Tây', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28351, N'Mỹ Phước', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28354, N'Tân Lập 2', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28357, N'Phước Lập', 818 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28360, N'Cái Bè', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28363, N'Hậu Mỹ Bắc B', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28366, N'Hậu Mỹ Bắc A', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28369, N'Mỹ Trung', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28372, N'Hậu Mỹ Trinh', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28375, N'Hậu Mỹ Phú', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28378, N'Mỹ Tân', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28381, N'Mỹ Lợi B', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28384, N'Thiện Trung', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28387, N'Mỹ Hội', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28390, N'An Cư', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28393, N'Hậu Thành', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28396, N'Mỹ Lợi A', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28399, N'Hòa Khánh', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28402, N'Thiện Trí', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28405, N'Mỹ Đức Đông', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28408, N'Mỹ Đức Tây', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28411, N'Đông Hòa Hiệp', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28414, N'An Thái Đông', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28417, N'Tân Hưng', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28420, N'Mỹ Lương', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28423, N'Tân Thanh', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28426, N'An Thái Trung', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28429, N'An Hữu', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28432, N'Hòa Hưng', 819 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28435, N'1', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28436, N'2', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28437, N'3', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28438, N'Thạnh Lộc', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28439, N'4', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28440, N'5', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28441, N'Mỹ Thành Bắc', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28444, N'Phú Cường', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28447, N'Mỹ Phước Tây', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28450, N'Mỹ Hạnh Đông', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28453, N'Mỹ Hạnh Trung', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28456, N'Mỹ Thành Nam', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28459, N'Tân Phú', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28462, N'Tân Bình', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28465, N'Phú Nhuận', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28468, N'Tân Hội', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28471, N'Bình Phú', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28474, N'Nhị Mỹ', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28477, N'Nhị Quý', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28480, N'Thanh Hòa', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28483, N'Phú Quý', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28486, N'Long Khánh', 817 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28489, N'Cẩm Sơn', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28492, N'Phú An', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28495, N'Mỹ Long', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28498, N'Long Tiên', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28501, N'Hiệp Đức', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28504, N'Long Trung', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28507, N'Hội Xuân', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28510, N'Tân Phong', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28513, N'Tam Bình', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28516, N'Ngũ Hiệp', 820 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28519, N'Tân Hiệp', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28522, N'Tân Hội Đông', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28525, N'Tân Hương', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28528, N'Tân Lý Đông', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28531, N'Tân Lý Tây', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28534, N'Thân Cửu Nghĩa', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28537, N'Tam Hiệp', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28540, N'Điềm Hy', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28543, N'Nhị Bình', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28546, N'Dưỡng Điềm', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28549, N'Đông Hòa', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28552, N'Long Định', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28555, N'Hữu Đạo', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28558, N'Long An', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28561, N'Long Hưng', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28564, N'Bình Trưng', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28567, N'Phước Thạnh', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28570, N'Thạnh Phú', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28573, N'Bàn Long', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28576, N'Vĩnh Kim', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28579, N'Bình Đức', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28582, N'Song Thuận', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28585, N'Kim Sơn', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28588, N'Phú Phong', 821 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28591, N'Thới Sơn', 815 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28594, N'Chợ Gạo', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28597, N'Trung Hòa', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28600, N'Hòa Tịnh', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28603, N'Mỹ Tịnh An', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28606, N'Tân Bình Thạnh', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28609, N'Phú Kiết', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28612, N'Lương Hòa Lạc', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28615, N'Thanh Bình', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28618, N'Quơn Long', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28621, N'Bình Phục Nhứt', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28624, N'Đăng Hưng Phước', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28627, N'Tân Thuận Bình', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28630, N'Song Bình', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28633, N'Bình Phan', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28636, N'Long Bình Điền', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28639, N'An Thạnh Thủy', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28642, N'Xuân Đông', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28645, N'Hòa Định', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28648, N'Bình Ninh', 822 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28651, N'Vĩnh Bình', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28654, N'Đồng Sơn', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28657, N'Bình Phú', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28660, N'Đồng Thạnh', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28663, N'Thành Công', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28666, N'Bình Nhì', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28669, N'Yên Luông', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28672, N'Thạnh Trị', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28675, N'Thạnh Nhựt', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28678, N'Long Vĩnh', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28681, N'Bình Tân', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28684, N'Vĩnh Hựu', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28687, N'Long Bình', 823 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28690, N'Tân Thới', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28693, N'Tân Phú', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28696, N'Phú Thạnh', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28699, N'Tân Thạnh', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28702, N'Tân Hòa', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28705, N'Tăng Hoà', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28708, N'Bình Đông', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28711, N'Tân Phước', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28714, N'Gia Thuận', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28717, N'Bình Xuân', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28720, N'Vàm Láng', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28723, N'Tân Tây', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28726, N'Kiểng Phước', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28729, N'Tân Trung', 816 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28732, N'Tân Đông', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28735, N'Bình Ân', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28738, N'Tân Điền', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28741, N'Bình Nghị', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28744, N'Phước Trung', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28747, N'Tân Thành', 824 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28750, N'Phú Đông', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28753, N'Phú Tân', 825 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28756, N'Phú Khương', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28757, N'Phú Tân', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28759, N'8', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28762, N'6', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28765, N'4', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28768, N'5', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28771, N'1', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28774, N'3', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28777, N'2', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28780, N'7', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28783, N'Sơn Đông', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28786, N'Phú Hưng', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28789, N'Bình Phú', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28792, N'Mỹ Thạnh An', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28795, N'Nhơn Thạnh', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28798, N'Phú Nhuận', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28801, N'Châu Thành', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28804, N'Tân Thạch', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28807, N'Qưới Sơn', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28810, N'An Khánh', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28813, N'Giao Long', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28816, N'Giao Hòa', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28819, N'Phú Túc', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28822, N'Phú Đức', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28825, N'Phú An Hòa', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28828, N'An Phước', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28831, N'Tam Phước', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28834, N'Thành Triệu', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28837, N'Tường Đa', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28840, N'Tân Phú', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28843, N'Quới Thành', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28846, N'Phước Thạnh', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28849, N'An Hóa', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28852, N'Tiên Long', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28855, N'An Hiệp', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28858, N'Hữu Định', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28861, N'Tiên Thủy', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28864, N'Sơn Hòa', 831 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28867, N'Mỹ Thành', 829 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28870, N'Chợ Lách', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28873, N'Phú Phụng', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28876, N'Sơn Định', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28879, N'Vĩnh Bình', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28882, N'Hòa Nghĩa', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28885, N'Long Thới', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28888, N'Phú Sơn', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28889, N'Phú Mỹ', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28891, N'Tân Thiềng', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28894, N'Vĩnh Thành', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28897, N'Vĩnh Hòa', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28900, N'Hưng Khánh Trung B', 832 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28901, N'Hưng Khánh Trung A', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28903, N'Mỏ Cày', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28906, N'Thanh Tân', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28909, N'Thạnh Ngãi', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28912, N'Tân Phú Tây', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28915, N'Phước Mỹ Trung', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28918, N'Tân Thành Bình', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28921, N'Thành An', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28924, N'Hòa Lộc', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28927, N'Tân Thanh Tây', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28930, N'Định Thủy', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28933, N'Tân Bình', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28936, N'Nhuận Phú Tân', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28939, N'Đa Phước Hội', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28940, N'Tân Hội', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28942, N'Phước Hiệp', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28945, N'Bình Khánh Đông', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28948, N'Khánh Thạnh Tân', 838 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28951, N'An Thạnh', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28954, N'Bình Khánh Tây', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28957, N'An Định', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28960, N'Thành Thới B', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28963, N'Tân Trung', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28966, N'An Thới', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28969, N'Thành Thới A', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28972, N'Minh Đức', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28975, N'Ngãi Đăng', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28978, N'Cẩm Sơn', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28981, N'Hương Mỹ', 833 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28984, N'Giồng Trôm', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28987, N'Phong Nẫm', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28990, N'Phong Mỹ', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28993, N'Mỹ Thạnh', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28996, N'Châu Hòa', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 28999, N'Lương Hòa', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29002, N'Lương Quới', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29005, N'Lương Phú', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29008, N'Châu Bình', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29011, N'Thuận Điền', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29014, N'Sơn Phú', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29017, N'Bình Hoà', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29020, N'Phước Long', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29023, N'Hưng Phong', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29026, N'Long Mỹ', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29029, N'Tân Hào', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29032, N'Bình Thành', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29035, N'Tân Thanh', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29038, N'Tân Lợi Thạnh', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29041, N'Thạnh Phú Đông', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29044, N'Hưng Nhượng', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29047, N'Hưng Lễ', 834 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29050, N'Bình Đại', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29053, N'Tam Hiệp', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29056, N'Long Định', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29059, N'Long Hòa', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29062, N'Phú Thuận', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29065, N'Vang Quới Tây', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29068, N'Vang Quới Đông', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29071, N'Châu Hưng', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29074, N'Phú Vang', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29077, N'Lộc Thuận', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29080, N'Định Trung', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29083, N'Thới Lai', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29086, N'Bình Thới', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29089, N'Phú Long', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29092, N'Bình Thắng', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29095, N'Thạnh Trị', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29098, N'Đại Hòa Lộc', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29101, N'Thừa Đức', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29104, N'Thạnh Phước', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29107, N'Thới Thuận', 835 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29110, N'Ba Tri', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29113, N'Tân Mỹ', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29116, N'Mỹ Hòa', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29119, N'Tân Xuân', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29122, N'Mỹ Chánh', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29125, N'Bảo Thạnh', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29128, N'An Phú Trung', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29131, N'Mỹ Thạnh', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29134, N'Mỹ Nhơn', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29137, N'Phước Tuy', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29140, N'Phú Ngãi', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29143, N'An Ngãi Trung', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29146, N'Phú Lễ', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29149, N'An Bình Tây', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29152, N'Bảo Thuận', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29155, N'Tân Hưng', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29158, N'An Ngãi Tây', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29161, N'An Hiệp', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29164, N'Vĩnh Hòa', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29167, N'Tân Thủy', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29170, N'Vĩnh An', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29173, N'An Đức', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29176, N'An Hòa Tây', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29179, N'An Thủy', 836 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29182, N'Thạnh Phú', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29185, N'Phú Khánh', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29188, N'Đại Điền', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29191, N'Quới Điền', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29194, N'Tân Phong', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29197, N'Mỹ Hưng', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29200, N'An Thạnh', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29203, N'Thới Thạnh', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29206, N'Hòa Lợi', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29209, N'An Điền', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29212, N'Bình Thạnh', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29215, N'An Thuận', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29218, N'An Quy', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29221, N'Thạnh Hải', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29224, N'An Nhơn', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29227, N'Giao Thạnh', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29230, N'Thạnh Phong', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29233, N'Mỹ An', 837 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29236, N'4', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29239, N'1', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29242, N'3', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29245, N'2', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29248, N'5', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29251, N'6', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29254, N'7', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29257, N'8', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29260, N'9', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29263, N'Long Đức', 842 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29266, N'Càng Long', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29269, N'Mỹ Cẩm', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29272, N'An Trường A', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29275, N'An Trường', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29278, N'Huyền Hội', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29281, N'Tân An', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29284, N'Tân Bình', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29287, N'Bình Phú', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29290, N'Phương Thạnh', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29293, N'Đại Phúc', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29296, N'Đại Phước', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29299, N'Nhị Long Phú', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29302, N'Nhị Long', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29305, N'Đức Mỹ', 844 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29308, N'Cầu Kè', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29311, N'Hòa Ân', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29314, N'Châu Điền', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29317, N'An Phú Tân', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29320, N'Hoà Tân', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29323, N'Ninh Thới', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29326, N'Phong Phú', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29329, N'Phong Thạnh', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29332, N'Tam Ngãi', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29335, N'Thông Hòa', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29338, N'Thạnh Phú', 845 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29341, N'Tiểu Cần', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29344, N'Cầu Quan', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29347, N'Phú Cần', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29350, N'Hiếu Tử', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29353, N'Hiếu Trung', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29356, N'Long Thới', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29359, N'Hùng Hòa', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29362, N'Tân Hùng', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29365, N'Tập Ngãi', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29368, N'Ngãi Hùng', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29371, N'Tân Hòa', 846 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29374, N'Châu Thành', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29377, N'Đa Lộc', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29380, N'Mỹ Chánh', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29383, N'Thanh Mỹ', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29386, N'Lương Hoà A', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29389, N'Lương Hòa', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29392, N'Song Lộc', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29395, N'Nguyệt Hóa', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29398, N'Hòa Thuận', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29401, N'Hòa Lợi', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29404, N'Phước Hảo', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29407, N'Hưng Mỹ', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29410, N'Hòa Minh', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29413, N'Long Hòa', 847 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29416, N'Cầu Ngang', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29419, N'Mỹ Long', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29422, N'Mỹ Long Bắc', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29425, N'Mỹ Long Nam', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29428, N'Mỹ Hòa', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29431, N'Vĩnh Kim', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29434, N'Kim Hòa', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29437, N'Hiệp Hòa', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29440, N'Thuận Hòa', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29443, N'Long Sơn', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29446, N'Nhị Trường', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29449, N'Trường Thọ', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29452, N'Hiệp Mỹ Đông', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29455, N'Hiệp Mỹ Tây', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29458, N'Thạnh Hòa Sơn', 848 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29461, N'Trà Cú', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29462, N'Định An', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29464, N'Phước Hưng', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29467, N'Tập Sơn', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29470, N'Tân Sơn', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29473, N'An Quảng Hữu', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29476, N'Lưu Nghiệp Anh', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29479, N'Ngãi Xuyên', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29482, N'Kim Sơn', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29485, N'Thanh Sơn', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29488, N'Hàm Giang', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29489, N'Hàm Tân', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29491, N'Đại An', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29494, N'Định An', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29497, N'Đôn Xuân', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29500, N'Đôn Châu', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29503, N'Ngọc Biên', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29506, N'Long Hiệp', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29509, N'Tân Hiệp', 849 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29512, N'1', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29513, N'Long Thành', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29515, N'Long Toàn', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29516, N'2', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29518, N'Long Hữu', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29521, N'Long Khánh', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29524, N'Dân Thành', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29527, N'Trường Long Hòa', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29530, N'Ngũ Lạc', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29533, N'Long Vĩnh', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29536, N'Đông Hải', 850 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29539, N'Hiệp Thạnh', 851 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29542, N'9', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29545, N'5', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29548, N'1', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29551, N'2', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29554, N'4', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29557, N'3', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29560, N'8', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29563, N'Tân Ngãi', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29566, N'Tân Hòa', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29569, N'Tân Hội', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29572, N'Trường An', 855 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29575, N'Long Hồ', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29578, N'Đồng Phú', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29581, N'Bình Hòa Phước', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29584, N'Hòa Ninh', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29587, N'An Bình', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29590, N'Thanh Đức', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29593, N'Tân Hạnh', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29596, N'Phước Hậu', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29599, N'Long Phước', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29602, N'Phú Đức', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29605, N'Lộc Hòa', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29608, N'Long An', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29611, N'Phú Quới', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29614, N'Thạnh Quới', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29617, N'Hòa Phú', 857 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29620, N'Cái Nhum', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29623, N'Mỹ An', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29626, N'Mỹ Phước', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29629, N'An Phước', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29632, N'Nhơn Phú', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29635, N'Long Mỹ', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29638, N'Hòa Tịnh', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29641, N'Chánh Hội', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29644, N'Bình Phước', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29647, N'Chánh An', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29650, N'Tân An Hội', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29653, N'Tân Long', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29656, N'Tân Long Hội', 858 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29659, N'Vũng Liêm', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29662, N'Tân Quới Trung', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29665, N'Quới Thiện', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29668, N'Quới An', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29671, N'Trung Chánh', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29674, N'Tân An Luông', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29677, N'Thanh Bình', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29680, N'Trung Thành Tây', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29683, N'Trung Hiệp', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29686, N'Hiếu Phụng', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29689, N'Trung Thành Đông', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29692, N'Trung Thành', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29695, N'Trung Hiếu', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29698, N'Trung Ngãi', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29701, N'Hiếu Thuận', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29704, N'Trung Nghĩa', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29707, N'Trung An', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29710, N'Hiếu Nhơn', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29713, N'Hiếu Thành', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29716, N'Hiếu Nghĩa', 859 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29719, N'Tam Bình', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29722, N'Tân Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29725, N'Phú Thịnh', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29728, N'Hậu Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29731, N'Hòa Thạnh', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29734, N'Hoà Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29737, N'Phú Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29740, N'Song Phú', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29743, N'Hòa Hiệp', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29746, N'Mỹ Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29749, N'Tân Phú', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29752, N'Long Phú', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29755, N'Mỹ Thạnh Trung', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29758, N'Tường Lộc', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29761, N'Loan Mỹ', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29764, N'Ngãi Tứ', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29767, N'Bình Ninh', 860 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29770, N'Cái Vồn', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29771, N'Thành Phước', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29773, N'Tân Hưng', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29776, N'Tân Thành', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29779, N'Thành Trung', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29782, N'Tân An Thạnh', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29785, N'Tân Lược', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29788, N'Nguyễn Văn Thảnh', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29791, N'Thành Đông', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29794, N'Mỹ Thuận', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29797, N'Tân Bình', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29800, N'Thành Lợi', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29803, N'Tân Quới', 863 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29806, N'Thuận An', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29809, N'Đông Thạnh', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29812, N'Đông Bình', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29813, N'Đông Thuận', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29815, N'Mỹ Hòa', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29818, N'Đông Thành', 861 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29821, N'Trà Ôn', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29824, N'Xuân Hiệp', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29827, N'Nhơn Bình', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29830, N'Hòa Bình', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29833, N'Thới Hòa', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29836, N'Trà Côn', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29839, N'Tân Mỹ', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29842, N'Hựu Thành', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29845, N'Vĩnh Xuân', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29848, N'Thuận Thới', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29851, N'Phú Thành', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29854, N'Thiện Mỹ', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29857, N'Lục Sỹ Thành', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29860, N'Tích Thiện', 862 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29863, N'11', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29866, N'1', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29869, N'2', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29872, N'4', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29875, N'3', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29878, N'6', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29881, N'Mỹ Ngãi', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29884, N'Mỹ Tân', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29887, N'Mỹ Trà', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29888, N'Mỹ Phú', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29890, N'Tân Thuận Tây', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29892, N'Hoà Thuận', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29893, N'Hòa An', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29896, N'Tân Thuận Đông', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29899, N'Tịnh Thới', 866 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29902, N'3', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29905, N'1', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29908, N'4', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29911, N'2', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29914, N'Tân Khánh Đông', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29917, N'Tân Quy Đông', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29919, N'An Hoà', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29920, N'Tân Quy Tây', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29923, N'Tân Phú Đông', 867 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29926, N'Sa Rài', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29929, N'Tân Hộ Cơ', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29932, N'Thông Bình', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29935, N'Bình Phú', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29938, N'Tân Thành A', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29941, N'Tân Thành B', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29944, N'Tân Phước', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29947, N'Tân Công Chí', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29950, N'An Phước', 869 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29954, N'An Lộc', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29955, N'An Thạnh', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29956, N'Thường Phước 1', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29959, N'Bình Thạnh', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29962, N'Thường Thới Hậu A', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29965, N'Tân Hội', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29971, N'Thường Thới Tiền', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29974, N'Thường Phước 2', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29977, N'Thường Lạc', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29978, N'An Lạc', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29980, N'Long Khánh A', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29983, N'Long Khánh B', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29986, N'An Bình B', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29989, N'An Bình A', 868 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29992, N'Long Thuận', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29995, N'Phú Thuận B', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 29998, N'Phú Thuận A', 870 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30001, N'Tràm Chim', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30004, N'Hoà Bình', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30007, N'Tân Công Sính', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30010, N'Phú Hiệp', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30013, N'Phú Đức', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30016, N'Phú Thành B', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30019, N'An Hòa', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30022, N'An Long', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30025, N'Phú Cường', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30028, N'Phú Ninh', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30031, N'Phú Thọ', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30034, N'Phú Thành A', 871 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30037, N'Mỹ An', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30040, N'Thạnh Lợi', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30043, N'Hưng Thạnh', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30046, N'Trường Xuân', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30049, N'Tân Kiều', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30052, N'Mỹ Hòa', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30055, N'Mỹ Quý', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30058, N'Mỹ Đông', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30061, N'Đốc Binh Kiều', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30064, N'Mỹ An', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30067, N'Phú Điền', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30070, N'Láng Biển', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30073, N'Thanh Mỹ', 872 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30076, N'Mỹ Thọ', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30079, N'Gáo Giồng', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30082, N'Phương Thịnh', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30085, N'Ba Sao', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30088, N'Phong Mỹ', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30091, N'Tân Nghĩa', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30094, N'Phương Trà', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30097, N'Nhị Mỹ', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30100, N'Mỹ Thọ', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30103, N'Tân Hội Trung', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30106, N'An Bình', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30109, N'Mỹ Hội', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30112, N'Mỹ Hiệp', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30115, N'Mỹ Long', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30118, N'Bình Hàng Trung', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30121, N'Mỹ Xương', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30124, N'Bình Hàng Tây', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30127, N'Bình Thạnh', 873 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30130, N'Thanh Bình', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30133, N'Tân Quới', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30136, N'Tân Hòa', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30139, N'An Phong', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30142, N'Phú Lợi', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30145, N'Tân Mỹ', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30148, N'Bình Tấn', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30151, N'Tân Huề', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30154, N'Tân Bình', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30157, N'Tân Thạnh', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30160, N'Tân Phú', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30163, N'Bình Thành', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30166, N'Tân Long', 874 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30169, N'Lấp Vò', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30172, N'Mỹ An Hưng A', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30175, N'Tân Mỹ', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30178, N'Mỹ An Hưng B', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30181, N'Tân  Khánh Trung', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30184, N'Long Hưng A', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30187, N'Vĩnh Thạnh', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30190, N'Long Hưng B', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30193, N'Bình Thành', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30196, N'Định An', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30199, N'Định Yên', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30202, N'Hội An Đông', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30205, N'Bình Thạnh Trung', 875 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30208, N'Lai Vung', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30211, N'Tân Dương', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30214, N'Hòa Thành', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30217, N'Long Hậu', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30220, N'Tân Phước', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30223, N'Hòa Long', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30226, N'Tân Thành', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30229, N'Long Thắng', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30232, N'Vĩnh Thới', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30235, N'Tân Hòa', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30238, N'Định Hòa', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30241, N'Phong Hòa', 876 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30244, N'Cái Tàu Hạ', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30247, N'An Hiệp', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30250, N'An Nhơn', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30253, N'Tân Nhuận Đông', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30256, N'Tân Bình', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30259, N'Tân Phú Trung', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30262, N'Phú Long', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30265, N'An Phú Thuận', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30268, N'Phú Hựu', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30271, N'An Khánh', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30274, N'Tân Phú', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30277, N'Hòa Tân', 877 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30280, N'Mỹ Bình', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30283, N'Mỹ Long', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30285, N'Đông Xuyên', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30286, N'Mỹ Xuyên', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30289, N'Bình Đức', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30292, N'Bình Khánh', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30295, N'Mỹ Phước', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30298, N'Mỹ Quý', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30301, N'Mỹ Thới', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30304, N'Mỹ Thạnh', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30307, N'Mỹ Hòa', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30310, N'Mỹ Khánh', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30313, N'Mỹ Hoà Hưng', 883 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30316, N'Châu Phú B', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30319, N'Châu Phú A', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30322, N'Vĩnh Mỹ', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30325, N'Núi Sam', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30328, N'Vĩnh Ngươn', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30331, N'Vĩnh Tế', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30334, N'Vĩnh Châu', 884 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30337, N'An Phú', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30340, N'Khánh An', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30341, N'Long Bình', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30343, N'Khánh Bình', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30346, N'Quốc Thái', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30349, N'Nhơn Hội', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30352, N'Phú Hữu', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30355, N'Phú Hội', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30358, N'Phước Hưng', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30361, N'Vĩnh Lộc', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30364, N'Vĩnh Hậu', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30367, N'Vĩnh Trường', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30370, N'Vĩnh Hội Đông', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30373, N'Đa Phước', 886 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30376, N'Long Thạnh', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30377, N'Long Hưng', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30378, N'Long Châu', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30379, N'Phú Lộc', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30382, N'Vĩnh Xương', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30385, N'Vĩnh Hòa', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30387, N'Tân Thạnh', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30388, N'Tân An', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30391, N'Long An', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30394, N'Long Phú', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30397, N'Châu Phong', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30400, N'Phú Vĩnh', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30403, N'Lê Chánh', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30406, N'Phú Mỹ', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30409, N'Chợ Vàm', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30412, N'Long Sơn', 887 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30415, N'Long Hoà', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30418, N'Phú Long', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30421, N'Phú Lâm', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30424, N'Phú Hiệp', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30427, N'Phú Thạnh', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30430, N'Hoà Lạc', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30433, N'Phú Thành', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30436, N'Phú An', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30439, N'Phú Xuân', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30442, N'Hiệp Xương', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30445, N'Phú Bình', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30448, N'Phú Thọ', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30451, N'Phú Hưng', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30454, N'Bình Thạnh Đông', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30457, N'Tân Hòa', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30460, N'Tân Trung', 888 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30463, N'Cái Dầu', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30466, N'Khánh Hòa', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30469, N'Mỹ Đức', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30472, N'Mỹ Phú', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30475, N'Ô Long Vỹ', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30478, N'Vĩnh Thạnh Trung', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30481, N'Thạnh Mỹ Tây', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30484, N'Bình Long', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30487, N'Bình Mỹ', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30490, N'Bình Thủy', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30493, N'Đào Hữu Cảnh', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30496, N'Bình Phú', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30499, N'Bình Chánh', 889 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30502, N'Nhà Bàng', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30505, N'Chi Lăng', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30508, N'Núi Voi', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30511, N'Nhơn Hưng', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30514, N'An Phú', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30517, N'Thới Sơn', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30520, N'Tịnh Biên', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30523, N'Văn Giáo', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30526, N'An Cư', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30529, N'An Nông', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30532, N'Vĩnh Trung', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30535, N'Tân Lợi', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30538, N'An Hảo', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30541, N'Tân Lập', 890 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30544, N'Tri Tôn', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30547, N'Ba Chúc', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30550, N'Lạc Quới', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30553, N'Lê Trì', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30556, N'Vĩnh Gia', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30559, N'Vĩnh Phước', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30562, N'Châu Lăng', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30565, N'Lương Phi', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30568, N'Lương An Trà', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30571, N'Tà Đảnh', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30574, N'Núi Tô', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30577, N'An Tức', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30580, N'Cô Tô', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30583, N'Tân Tuyến', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30586, N'Ô Lâm', 891 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30589, N'An Châu', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30592, N'An Hòa', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30595, N'Cần Đăng', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30598, N'Vĩnh Hanh', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30601, N'Bình Thạnh', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30604, N'Vĩnh Bình', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30607, N'Bình Hòa', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30610, N'Vĩnh An', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30613, N'Hòa Bình Thạnh', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30616, N'Vĩnh Lợi', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30619, N'Vĩnh Nhuận', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30622, N'Tân Phú', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30625, N'Vĩnh Thành', 892 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30628, N'Chợ Mới', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30631, N'Mỹ Luông', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30634, N'Kiến An', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30637, N'Mỹ Hội Đông', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30640, N'Long Điền A', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30643, N'Tấn Mỹ', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30646, N'Long Điền B', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30649, N'Kiến Thành', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30652, N'Mỹ Hiệp', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30655, N'Mỹ An', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30658, N'Nhơn Mỹ', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30661, N'Long Giang', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30664, N'Long Kiến', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30667, N'Bình Phước Xuân', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30670, N'An Thạnh Trung', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30673, N'Hội An', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30676, N'Hòa Bình', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30679, N'Hòa An', 893 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30682, N'Núi Sập', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30685, N'Phú Hoà', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30688, N'Óc Eo', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30691, N'Tây Phú', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30692, N'An Bình', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30694, N'Vĩnh Phú', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30697, N'Vĩnh Trạch', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30700, N'Phú Thuận', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30703, N'Vĩnh Chánh', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30706, N'Định Mỹ', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30709, N'Định Thành', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30712, N'Mỹ Phú Đông', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30715, N'Vọng Đông', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30718, N'Vĩnh Khánh', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30721, N'Thoại Giang', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30724, N'Bình Thành', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30727, N'Vọng Thê', 894 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30730, N'Vĩnh Thanh Vân', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30733, N'Vĩnh Thanh', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30736, N'Vĩnh Quang', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30739, N'Vĩnh Hiệp', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30742, N'Vĩnh Bảo', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30745, N'Vĩnh Lạc', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30748, N'An Hòa', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30751, N'An Bình', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30754, N'Rạch Sỏi', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30757, N'Vĩnh Lợi', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30760, N'Vĩnh Thông', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30763, N'Phi Thông', 899 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30766, N'Tô Châu', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30769, N'Đông Hồ', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30772, N'Bình San', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30775, N'Pháo Đài', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30778, N'Mỹ Đức', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30781, N'Tiên Hải', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30784, N'Thuận Yên', 900 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30787, N'Kiên Lương', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30790, N'Kiên Bình', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30791, N'Vĩnh Phú', 914 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30793, N'Vĩnh Điều', 914 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30796, N'Tân Khánh Hòa', 914 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30797, N'Phú Lợi', 914 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30799, N'Phú Mỹ', 914 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30802, N'Hòa Điền', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30805, N'Dương Hòa', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30808, N'Bình An', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30809, N'Bình Trị', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30811, N'Sơn Hải', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30814, N'Hòn Nghệ', 902 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30817, N'Hòn Đất', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30820, N'Sóc Sơn', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30823, N'Bình Sơn', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30826, N'Bình Giang', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30828, N'Mỹ Thái', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30829, N'Nam Thái Sơn', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30832, N'Mỹ Hiệp Sơn', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30835, N'Sơn Kiên', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30836, N'Sơn Bình', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30838, N'Mỹ Thuận', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30840, N'Lình Huỳnh', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30841, N'Thổ Sơn', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30844, N'Mỹ Lâm', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30847, N'Mỹ Phước', 903 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30850, N'Tân Hiệp', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30853, N'Tân Hội', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30856, N'Tân Thành', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30859, N'Tân Hiệp B', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30860, N'Tân Hoà', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30862, N'Thạnh Đông B', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30865, N'Thạnh Đông', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30868, N'Tân Hiệp A', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30871, N'Tân An', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30874, N'Thạnh Đông A', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30877, N'Thạnh Trị', 904 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30880, N'Minh Lương', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30883, N'Mong Thọ A', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30886, N'Mong Thọ B', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30887, N'Mong Thọ', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30889, N'Giục Tượng', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30892, N'Vĩnh Hòa Hiệp', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30893, N'Vĩnh Hoà Phú', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30895, N'Minh Hòa', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30898, N'Bình An', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30901, N'Thạnh Lộc', 905 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30904, N'Giồng Riềng', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30907, N'Thạnh Hưng', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30910, N'Thạnh Phước', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30913, N'Thạnh Lộc', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30916, N'Thạnh Hòa', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30917, N'Thạnh Bình', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30919, N'Bàn Thạch', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30922, N'Bàn Tân Định', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30925, N'Ngọc Thành', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30928, N'Ngọc Chúc', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30931, N'Ngọc Thuận', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30934, N'Hòa Hưng', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30937, N'Hoà Lợi', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30940, N'Hoà An', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30943, N'Long Thạnh', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30946, N'Vĩnh Thạnh', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30947, N'Vĩnh Phú', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30949, N'Hòa Thuận', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30950, N'Ngọc Hoà', 906 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30952, N'Gò Quao', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30955, N'Vĩnh Hòa Hưng Bắc', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30958, N'Định Hòa', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30961, N'Thới Quản', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30964, N'Định An', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30967, N'Thủy Liễu', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30970, N'Vĩnh Hòa Hưng Nam', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30973, N'Vĩnh Phước A', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30976, N'Vĩnh Phước B', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30979, N'Vĩnh Tuy', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30982, N'Vĩnh Thắng', 907 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30985, N'Thứ Ba', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30988, N'Tây Yên', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30991, N'Tây Yên A', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30994, N'Nam Yên', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 30997, N'Hưng Yên', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31000, N'Nam Thái', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31003, N'Nam Thái A', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31006, N'Đông Thái', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31009, N'Đông Yên', 908 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31012, N'Thạnh Yên', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31015, N'Thạnh Yên A', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31018, N'Thứ Mười Một', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31021, N'Thuận Hoà', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31024, N'Đông Hòa', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31027, N'An Minh Bắc', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31030, N'Đông Thạnh', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31031, N'Tân Thạnh', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31033, N'Đông Hưng', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31036, N'Đông Hưng A', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31039, N'Đông Hưng B', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31042, N'Vân Khánh', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31045, N'Vân Khánh Đông', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31048, N'Vân Khánh Tây', 909 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31051, N'Vĩnh Thuận', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31054, N'Vĩnh Hòa', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31057, N'Hoà Chánh', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31060, N'Vĩnh Bình Bắc', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31063, N'Vĩnh Bình Nam', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31064, N'Bình Minh', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31066, N'Minh Thuận', 913 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31069, N'Vĩnh Thuận', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31072, N'Tân Thuận', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31074, N'Phong Đông', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31075, N'Vĩnh Phong', 910 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31078, N'Dương Đông', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31081, N'An Thới', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31084, N'Cửa Cạn', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31087, N'Gành Dầu', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31090, N'Cửa Dương', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31093, N'Hàm Ninh', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31096, N'Dương Tơ', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31099, N'Hòn Thơm', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31102, N'Bãi Thơm', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31105, N'Thổ Châu', 911 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31108, N'Hòn Tre', 912 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31111, N'Lại Sơn', 912 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31114, N'An Sơn', 912 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31115, N'Nam Du', 912 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31117, N'Cái Khế', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31120, N'An Hòa', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31123, N'Thới Bình', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31126, N'An Nghiệp', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31129, N'An Cư', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31132, N'An Hội', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31135, N'Tân An', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31138, N'An Lạc', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31141, N'An Phú', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31144, N'Xuân Khánh', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31147, N'Hưng Lợi', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31149, N'An Khánh', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31150, N'An Bình', 916 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31153, N'Châu Văn Liêm', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31154, N'Thới Hòa', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31156, N'Thới Long', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31157, N'Long Hưng', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31159, N'Thới An', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31162, N'Phước Thới', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31165, N'Trường Lạc', 917 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31168, N'Bình Thủy', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31169, N'Trà An', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31171, N'Trà Nóc', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31174, N'Thới An Đông', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31177, N'An Thới', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31178, N'Bùi Hữu Nghĩa', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31180, N'Long Hòa', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31183, N'Long Tuyền', 918 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31186, N'Lê Bình', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31189, N'Hưng Phú', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31192, N'Hưng Thạnh', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31195, N'Ba Láng', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31198, N'Thường Thạnh', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31201, N'Phú Thứ', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31204, N'Tân Phú', 919 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31207, N'Thốt Nốt', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31210, N'Thới Thuận', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31211, N'Vĩnh Bình', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31212, N'Thuận An', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31213, N'Tân Lộc', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31216, N'Trung Nhứt', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31217, N'Thạnh Hoà', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31219, N'Trung Kiên', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31222, N'Trung An', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31225, N'Trung Thạnh', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31227, N'Tân Hưng', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31228, N'Thuận Hưng', 923 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31231, N'Thanh An', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31232, N'Vĩnh Thạnh', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31234, N'Thạnh Mỹ', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31237, N'Vĩnh Trinh', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31240, N'Thạnh An', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31241, N'Thạnh Tiến', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31243, N'Thạnh Thắng', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31244, N'Thạnh Lợi', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31246, N'Thạnh Qưới', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31249, N'Thạnh Phú', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31252, N'Thạnh Lộc', 924 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31255, N'Trung Hưng', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31258, N'Thới Lai', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31261, N'Cờ Đỏ', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31264, N'Thới Hưng', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31267, N'Thới Thạnh', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31268, N'Tân Thạnh', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31270, N'Xuân Thắng', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31273, N'Đông Hiệp', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31274, N'Đông Thắng', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31276, N'Thới Đông', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31277, N'Thới Xuân', 925 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31279, N'Đông Bình', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31282, N'Đông Thuận', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31285, N'Thới Tân', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31286, N'Trường Thắng', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31288, N'Định Môn', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31291, N'Trường Thành', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31294, N'Trường Xuân', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31297, N'Trường Xuân A', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31298, N'Trường Xuân B', 927 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31299, N'Phong Điền', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31300, N'Nhơn Ái', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31303, N'Giai Xuân', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31306, N'Tân Thới', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31309, N'Trường Long', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31312, N'Mỹ Khánh', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31315, N'Nhơn Nghĩa', 926 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31318, N'I', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31321, N'III', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31324, N'IV', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31327, N'V', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31330, N'VII', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31333, N'Vị Tân', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31336, N'Hoả Lựu', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31338, N'Tân Tiến', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31339, N'Hoả Tiến', 930 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31340, N'Ngã Bảy', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31341, N'Lái Hiếu', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31342, N'Một Ngàn', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31343, N'Hiệp Thành', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31344, N'Hiệp Lợi', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31345, N'Tân Hoà', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31346, N'Bảy Ngàn', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31348, N'Trường Long Tây', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31351, N'Trường Long A', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31357, N'Nhơn Nghĩa A', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31359, N'Rạch Gòi', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31360, N'Thạnh Xuân', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31362, N'Cái Tắc', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31363, N'Tân Phú Thạnh', 932 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31366, N'Ngã Sáu', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31369, N'Đông Thạnh', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31372, N'Phú An', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31375, N'Đông Phú', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31378, N'Phú Hữu', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31379, N'Phú Tân', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31381, N'Mái Dầm', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31384, N'Đông Phước', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31387, N'Đông Phước A', 933 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31393, N'Kinh Cùng', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31396, N'Cây Dương', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31399, N'Tân Bình', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31402, N'Bình Thành', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31405, N'Thạnh Hòa', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31408, N'Long Thạnh', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31411, N'Đại Thành', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31414, N'Tân Thành', 931 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31417, N'Phụng Hiệp', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31420, N'Hòa Mỹ', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31423, N'Hòa An', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31426, N'Phương Bình', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31429, N'Hiệp Hưng', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31432, N'Tân Phước Hưng', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31433, N'Búng Tàu', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31435, N'Phương Phú', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31438, N'Tân Long', 934 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31441, N'Nàng Mau', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31444, N'Vị Trung', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31447, N'Vị Thuỷ', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31450, N'Vị Thắng', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31453, N'Vĩnh Thuận Tây', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31456, N'Vĩnh Trung', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31459, N'Vĩnh Tường', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31462, N'Vị Đông', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31465, N'Vị Thanh', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31468, N'Vị Bình', 935 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31471, N'Thuận An', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31472, N'Trà Lồng', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31473, N'Bình Thạnh', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31474, N'Long Bình', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31475, N'Vĩnh Tường', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31477, N'Long Trị', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31478, N'Long Trị A', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31480, N'Long Phú', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31481, N'Tân Phú', 937 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31483, N'Thuận Hưng', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31484, N'Thuận Hòa', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31486, N'Vĩnh Thuận Đông', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31489, N'Vĩnh Viễn', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31490, N'Vĩnh Viễn A', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31492, N'Lương Tâm', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31493, N'Lương Nghĩa', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31495, N'Xà Phiên', 936 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31498, N'5', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31501, N'7', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31504, N'8', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31507, N'6', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31510, N'2', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31513, N'1', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31516, N'4', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31519, N'3', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31522, N'9', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31525, N'10', 941 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31528, N'Kế Sách', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31531, N'An Lạc Thôn', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31534, N'Xuân Hòa', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31537, N'Phong Nẫm', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31540, N'An Lạc Tây', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31543, N'Trinh Phú', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31546, N'Ba Trinh', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31549, N'Thới An Hội', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31552, N'Nhơn Mỹ', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31555, N'Kế Thành', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31558, N'Kế An', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31561, N'Đại Hải', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31564, N'An Mỹ', 943 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31567, N'Huỳnh Hữu Nghĩa', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31569, N'Châu Thành', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31570, N'Hồ Đắc Kiện', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31573, N'Phú Tâm', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31576, N'Thuận Hòa', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31579, N'Long Hưng', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31582, N'Phú Tân', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31585, N'Thiện Mỹ', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31588, N'Hưng Phú', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31591, N'Mỹ Hương', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31594, N'An Hiệp', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31597, N'Mỹ Tú', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31600, N'An Ninh', 942 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31603, N'Mỹ Phước', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31606, N'Thuận Hưng', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31609, N'Mỹ Thuận', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31612, N'Phú Mỹ', 944 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31615, N'Cù Lao Dung', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31618, N'An Thạnh 1', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31621, N'An Thạnh Tây', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31624, N'An Thạnh Đông', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31627, N'Đại Ân 1', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31630, N'An Thạnh 2', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31633, N'An Thạnh 3', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31636, N'An Thạnh Nam', 945 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31639, N'Long Phú', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31642, N'Song Phụng', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31645, N'Đại Ngãi', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31648, N'Hậu Thạnh', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31651, N'Long Đức', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31654, N'Trường Khánh', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31657, N'Phú Hữu', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31660, N'Tân Hưng', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31663, N'Châu Khánh', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31666, N'Tân Thạnh', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31669, N'Long Phú', 946 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31672, N'Đại Ân  2', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31673, N'Trần Đề', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31675, N'Liêu Tú', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31678, N'Lịch Hội Thượng', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31679, N'Lịch Hội Thượng', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31681, N'Trung Bình', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31684, N'Mỹ Xuyên', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31687, N'Tài Văn', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31690, N'Đại Tâm', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31693, N'Tham Đôn', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31696, N'Viên An', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31699, N'Thạnh Thới An', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31702, N'Thạnh Thới Thuận', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31705, N'Viên Bình', 951 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31708, N'Thạnh Phú', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31711, N'Ngọc Đông', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31714, N'Thạnh Quới', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31717, N'Hòa Tú 1', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31720, N'Gia Hòa 1', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31723, N'Ngọc Tố', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31726, N'Gia Hòa 2', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31729, N'Hòa Tú II', 947 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31732, N'1', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31735, N'2', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31738, N'Vĩnh Quới', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31741, N'Tân Long', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31744, N'Long Bình', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31747, N'3', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31750, N'Mỹ Bình', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31753, N'Mỹ Quới', 948 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31756, N'Phú Lộc', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31757, N'Hưng Lợi', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31759, N'Lâm Tân', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31762, N'Thạnh Tân', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31765, N'Lâm Kiết', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31768, N'Tuân Tức', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31771, N'Vĩnh Thành', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31774, N'Thạnh Trị', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31777, N'Vĩnh Lợi', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31780, N'Châu Hưng', 949 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31783, N'1', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31786, N'Hòa Đông', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31789, N'Khánh Hòa', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31792, N'Vĩnh Hiệp', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31795, N'Vĩnh Hải', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31798, N'Lạc Hòa', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31801, N'2', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31804, N'Vĩnh Phước', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31807, N'Vĩnh Tân', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31810, N'Lai Hòa', 950 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31813, N'2', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31816, N'3', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31819, N'5', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31822, N'7', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31825, N'1', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31828, N'8', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31831, N'Nhà Mát', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31834, N'Vĩnh Trạch', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31837, N'Vĩnh Trạch Đông', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31840, N'Hiệp Thành', 954 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31843, N'Ngan Dừa', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31846, N'Ninh Quới', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31849, N'Ninh Quới A', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31852, N'Ninh Hòa', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31855, N'Lộc Ninh', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31858, N'Vĩnh Lộc', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31861, N'Vĩnh Lộc A', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31863, N'Ninh Thạnh Lợi A', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31864, N'Ninh Thạnh Lợi', 956 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31867, N'Phước Long', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31870, N'Vĩnh Phú Đông', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31873, N'Vĩnh Phú Tây', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31876, N'Phước Long', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31879, N'Hưng Phú', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31882, N'Vĩnh Thanh', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31885, N'Phong Thạnh Tây A', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31888, N'Phong Thạnh Tây B', 957 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31891, N'Hòa Bình', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31894, N'Vĩnh Hưng', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31897, N'Vĩnh Hưng A', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31900, N'Châu Hưng', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31903, N'Châu Hưng A', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31906, N'Hưng Thành', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31909, N'Hưng Hội', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31912, N'Châu Thới', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31915, N'Minh Diệu', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31918, N'Vĩnh Bình', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31921, N'Long Thạnh', 958 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31924, N'Vĩnh Mỹ B', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31927, N'Vĩnh Hậu', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31930, N'Vĩnh Hậu A', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31933, N'Vĩnh Mỹ A', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31936, N'Vĩnh Thịnh', 961 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31942, N'1', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31945, N'Hộ Phòng', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31948, N'Phong Thạnh Đông', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31951, N'Láng Tròn', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31954, N'Phong Tân', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31957, N'Tân Phong', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31960, N'Phong Thạnh', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31963, N'Phong Thạnh A', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31966, N'Phong Thạnh Tây', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31969, N'Tân Thạnh', 959 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31972, N'Gành Hào', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31975, N'Long Điền Đông', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31978, N'Long Điền Đông A', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31981, N'Long Điền', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31984, N'Long Điền Tây', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31985, N'Điền Hải', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31987, N'An Trạch', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31988, N'An Trạch A', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31990, N'An Phúc', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31993, N'Định Thành', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31996, N'Định Thành A', 960 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 31999, N'9', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32002, N'4', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32005, N'1', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32008, N'5', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32011, N'2', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32014, N'8', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32017, N'6', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32020, N'7', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32022, N'Tân Xuyên', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32023, N'An Xuyên', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32025, N'Tân Thành', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32026, N'Tân Thành', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32029, N'Tắc Vân', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32032, N'Lý Văn Lâm', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32035, N'Định Bình', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32038, N'Hòa Thành', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32041, N'Hòa Tân', 964 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32044, N'U Minh', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32047, N'Khánh Hòa', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32048, N'Khánh Thuận', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32050, N'Khánh Tiến', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32053, N'Nguyễn Phích', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32056, N'Khánh Lâm', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32059, N'Khánh An', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32062, N'Khánh Hội', 966 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32065, N'Thới Bình', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32068, N'Biển Bạch', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32069, N'Tân Bằng', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32071, N'Trí Phải', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32072, N'Trí Lực', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32074, N'Biển Bạch Đông', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32077, N'Thới Bình', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32080, N'Tân Phú', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32083, N'Tân Lộc Bắc', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32086, N'Tân Lộc', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32089, N'Tân Lộc Đông', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32092, N'Hồ Thị Kỷ', 967 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32095, N'Trần Văn Thời', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32098, N'Sông Đốc', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32101, N'Khánh Bình Tây Bắc', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32104, N'Khánh Bình Tây', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32107, N'Trần Hợi', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32108, N'Khánh Lộc', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32110, N'Khánh Bình', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32113, N'Khánh Hưng', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32116, N'Khánh Bình Đông', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32119, N'Khánh Hải', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32122, N'Lợi An', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32124, N'Phong Điền', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32125, N'Phong Lạc', 968 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32128, N'Cái Nước', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32130, N'Thạnh Phú', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32131, N'Lương Thế Trân', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32134, N'Phú Hưng', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32137, N'Tân Hưng', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32140, N'Hưng Mỹ', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32141, N'Hoà Mỹ', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32142, N'Đông Hưng', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32143, N'Đông Thới', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32146, N'Tân Hưng Đông', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32149, N'Trần Thới', 969 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32152, N'Đầm Dơi', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32155, N'Tạ An Khương', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32158, N'Tạ An Khương  Đông', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32161, N'Trần Phán', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32162, N'Tân Trung', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32164, N'Tân Đức', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32167, N'Tân Thuận', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32170, N'Tạ An Khương  Nam', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32173, N'Tân Duyệt', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32174, N'Tân Dân', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32176, N'Tân Tiến', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32179, N'Quách Phẩm Bắc', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32182, N'Quách Phẩm', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32185, N'Thanh Tùng', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32186, N'Ngọc Chánh', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32188, N'Nguyễn Huân', 970 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32191, N'Năm Căn', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32194, N'Hàm Rồng', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32197, N'Hiệp Tùng', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32200, N'Đất Mới', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32201, N'Lâm Hải', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32203, N'Hàng Vịnh', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32206, N'Tam Giang', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32209, N'Tam Giang Đông', 971 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32212, N'Cái Đôi Vàm', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32214, N'Phú Thuận', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32215, N'Phú Mỹ', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32218, N'Phú Tân', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32221, N'Tân Hải', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32224, N'Việt Thắng', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32227, N'Tân Hưng Tây', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32228, N'Rạch Chèo', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32230, N'Nguyễn Việt Khái', 972 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32233, N'Tam Giang Tây', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32236, N'Tân Ân Tây', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32239, N'Viên An Đông', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32242, N'Viên An', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32244, N'Rạch Gốc', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32245, N'Tân Ân', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 32248, N'Đất Mũi', 973 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09163, N'Vũ Ninh', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09166, N'Đáp Cầu', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09169, N'Thị Cầu', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09172, N'Kinh Bắc', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09175, N'Vệ An', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09178, N'Tiền An', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09181, N'Đại Phúc', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09184, N'Ninh Xá', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09187, N'Suối Hoa', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09190, N'Võ Cường', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09214, N'Hòa Long', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09226, N'Vạn An', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09235, N'Khúc Xuyên', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09244, N'Phong Khê', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09256, N'Kim Chân', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09271, N'Vân Dương', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09286, N'Nam Sơn', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09325, N'Khắc Niệm', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09331, N'Hạp Lĩnh', 256 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09193, N'Chờ', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09196, N'Dũng Liệt', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09199, N'Tam Đa', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09202, N'Tam Giang', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09205, N'Yên Trung', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09208, N'Thụy Hòa', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09211, N'Hòa Tiến', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09217, N'Đông Tiến', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09220, N'Yên Phụ', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09223, N'Trung Nghĩa', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09229, N'Đông Phong', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09232, N'Long Châu', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09238, N'Văn Môn', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09241, N'Đông Thọ', 258 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09247, N'Phố Mới', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09250, N'Việt Thống', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09253, N'Đại Xuân', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09259, N'Nhân Hòa', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09262, N'Bằng An', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09265, N'Phương Liễu', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09268, N'Quế Tân', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09274, N'Phù Lương', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09277, N'Phù Lãng', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09280, N'Phượng Mao', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09283, N'Việt Hùng', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09289, N'Ngọc Xá', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09292, N'Châu Phong', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09295, N'Bồng Lai', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09298, N'Cách Bi', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09301, N'Đào Viên', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09304, N'Yên Giả', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09307, N'Mộ Đạo', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09310, N'Đức Long', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09313, N'Chi Lăng', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09316, N'Hán Quảng', 259 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09319, N'Lim', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09322, N'Phú Lâm', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09328, N'Nội Duệ', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09334, N'Liên Bão', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09337, N'Hiên Vân', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09340, N'Hoàn Sơn', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09343, N'Lạc Vệ', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09346, N'Việt Đoàn', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09349, N'Phật Tích', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09352, N'Tân Chi', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09355, N'Đại Đồng', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09358, N'Tri Phương', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09361, N'Minh Đạo', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09364, N'Cảnh Hưng', 260 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09367, N'Đông Ngàn', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09370, N'Tam Sơn', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09373, N'Hương Mạc', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09376, N'Tương Giang', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09379, N'Phù Khê', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09382, N'Đồng Kỵ', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09383, N'Trang Hạ', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09385, N'Đồng Nguyên', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09388, N'Châu Khê', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09391, N'Tân Hồng', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09394, N'Đình Bảng', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09397, N'Phù Chẩn', 261 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09400, N'Hồ', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09403, N'Hoài Thượng', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09406, N'Đại Đồng Thành', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09409, N'Mão Điền', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09412, N'Song Hồ', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09415, N'Đình Tổ', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09418, N'An Bình', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09421, N'Trí Quả', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09424, N'Gia Đông', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09427, N'Thanh Khương', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09430, N'Trạm Lộ', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09433, N'Xuân Lâm', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09436, N'Hà Mãn', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09439, N'Ngũ Thái', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09442, N'Nguyệt Đức', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09445, N'Ninh Xá', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09448, N'Nghĩa Đạo', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09451, N'Song Liễu', 262 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09454, N'Gia Bình', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09457, N'Vạn Ninh', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09460, N'Thái Bảo', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09463, N'Giang Sơn', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09466, N'Cao Đức', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09469, N'Đại Lai', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09472, N'Song Giang', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09475, N'Bình Dương', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09478, N'Lãng Ngâm', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09481, N'Nhân Thắng', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09484, N'Xuân Lai', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09487, N'Đông Cứu', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09490, N'Đại Bái', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09493, N'Quỳnh Phú', 263 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09496, N'Thứa', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09499, N'An Thịnh', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09502, N'Trung Kênh', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09505, N'Phú Hòa', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09508, N'Mỹ Hương', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09511, N'Tân Lãng', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09514, N'Quảng Phú', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09517, N'Trừng Xá', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09520, N'Lai Hạ', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09523, N'Trung Chính', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09526, N'Minh Tân', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09529, N'Bình Định', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09532, N'Phú Lương', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09535, N'Lâm Thao', 264 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01267, N'Sông Hiến', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01270, N'Sông Bằng', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01273, N'Hợp Giang', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01276, N'Tân Giang', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01279, N'Ngọc Xuân', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01282, N'Đề Thám', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01285, N'Hoà Chung', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01288, N'Duyệt Trung', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01693, N'Vĩnh Quang', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01705, N'Hưng Đạo', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01720, N'Chu Trinh', 040 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01290, N'Pác Miầu', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01291, N'Đức Hạnh', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01294, N'Lý Bôn', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01296, N'Nam Cao', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01297, N'Nam Quang', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01300, N'Vĩnh Quang', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01303, N'Quảng Lâm', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01304, N'Thạch Lâm', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01306, N'Tân Việt', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01309, N'Vĩnh Phong', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01312, N'Mông Ân', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01315, N'Thái Học', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01316, N'Thái Sơn', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01318, N'Yên Thổ', 042 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01321, N'Bảo Lạc', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01324, N'Cốc Pàng', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01327, N'Thượng Hà', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01330, N'Cô Ba', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01333, N'Bảo Toàn', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01336, N'Khánh Xuân', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01339, N'Xuân Trường', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01342, N'Hồng Trị', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01343, N'Kim Cúc', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01345, N'Phan Thanh', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01348, N'Hồng An', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01351, N'Hưng Đạo', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01352, N'Hưng Thịnh', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01354, N'Huy Giáp', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01357, N'Đình Phùng', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01359, N'Sơn Lập', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01360, N'Sơn Lộ', 043 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01363, N'Thông Nông', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01366, N'Cần Yên', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01367, N'Cần Nông', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01369, N'Vị Quang', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01372, N'Lương Thông', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01375, N'Đa Thông', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01378, N'Ngọc Động', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01381, N'Yên Sơn', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01384, N'Lương Can', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01387, N'Thanh Long', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01390, N'Bình Lãng', 044 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01392, N'Xuân Hòa', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01393, N'Lũng Nặm', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01396, N'Kéo Yên', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01399, N'Trường Hà', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01402, N'Vân An', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01405, N'Cải Viên', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01408, N'Nà Sác', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01411, N'Nội Thôn', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01414, N'Tổng Cọt', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01417, N'Sóc Hà', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01420, N'Thượng Thôn', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01423, N'Vần Dính', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01426, N'Hồng Sĩ', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01429, N'Sĩ Hai', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01432, N'Quý Quân', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01435, N'Mã Ba', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01438, N'Phù Ngọc', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01441, N'Đào Ngạn', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01444, N'Hạ Thôn', 045 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01447, N'Hùng Quốc', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01450, N'Cô Mười', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01453, N'Tri Phương', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01456, N'Quang Hán', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01459, N'Quang Vinh', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01462, N'Xuân Nội', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01465, N'Quang Trung', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01468, N'Lưu Ngọc', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01471, N'Cao Chương', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01474, N'Quốc Toản', 046 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01477, N'Trùng Khánh', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01480, N'Ngọc Khê', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01481, N'Ngọc Côn', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01483, N'Phong Nậm', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01486, N'Ngọc Chung', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01489, N'Đình Phong', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01492, N'Lăng Yên', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01495, N'Đàm Thuỷ', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01498, N'Khâm Thành', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01501, N'Chí Viễn', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01504, N'Lăng Hiếu', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01507, N'Phong Châu', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01510, N'Đình Minh', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01513, N'Cảnh Tiên', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01516, N'Trung Phúc', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01519, N'Cao Thăng', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01522, N'Đức Hồng', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01525, N'Thông Hoè', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01528, N'Thân Giáp', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01531, N'Đoài Côn', 047 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01534, N'Minh Long', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01537, N'Lý Quốc', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01540, N'Thắng Lợi', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01543, N'Đồng Loan', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01546, N'Đức Quang', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01549, N'Kim Loan', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01552, N'Quang Long', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01555, N'An Lạc', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01558, N'Thanh Nhật', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01561, N'Vinh Quý', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01564, N'Việt Chu', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01567, N'Cô Ngân', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01570, N'Thái Đức', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01573, N'Thị Hoa', 048 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01576, N'Quảng Uyên', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01579, N'Phi Hải', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01582, N'Quảng Hưng', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01585, N'Bình Lăng', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01588, N'Quốc Dân', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01591, N'Quốc Phong', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01594, N'Độc Lập', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01597, N'Cai Bộ', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01600, N'Đoài Khôn', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01603, N'Phúc Sen', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01606, N'Chí Thảo', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01609, N'Tự Do', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01612, N'Hồng Định', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01615, N'Hồng Quang', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01618, N'Ngọc Động', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01621, N'Hoàng Hải', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01624, N'Hạnh Phúc', 049 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01627, N'Tà Lùng', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01630, N'Triệu ẩu', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01633, N'Hồng Đại', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01636, N'Cách Linh', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01639, N'Đại Sơn', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01642, N'Lương Thiện', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01645, N'Tiên Thành', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01648, N'Hoà Thuận', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01651, N'Mỹ Hưng', 050 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01654, N'Nước Hai', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01657, N'Dân Chủ', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01660, N'Nam Tuấn', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01663, N'Đức Xuân', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01666, N'Đại Tiến', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01669, N'Đức Long', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01672, N'Ngũ Lão', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01675, N'Trương Lương', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01678, N'Bình Long', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01681, N'Nguyễn Huệ', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01684, N'Công Trừng', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01687, N'Hồng Việt', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01690, N'Bế Triều', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01696, N'Hoàng Tung', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01699, N'Trương Vương', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01702, N'Quang Trung', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01708, N'Bạch Đằng', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01711, N'Bình Dương', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01714, N'Lê Chung', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01717, N'Hà Trì', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01723, N'Hồng Nam', 051 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01726, N'Nguyên Bình', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01729, N'Tĩnh Túc', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01732, N'Yên Lạc', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01735, N'Triệu Nguyên', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01738, N'Ca Thành', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01741, N'Thái Học', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01744, N'Vũ Nông', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01747, N'Minh Tâm', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01750, N'Thể Dục', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01753, N'Bắc Hợp', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01756, N'Mai Long', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01759, N'Lang Môn', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01762, N'Minh Thanh', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01765, N'Hoa Thám', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01768, N'Phan Thanh', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01771, N'Quang Thành', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01774, N'Tam Kim', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01777, N'Thành Công', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01780, N'Thịnh Vượng', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01783, N'Hưng Đạo', 052 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01786, N'Đông Khê', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01789, N'Canh Tân', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01792, N'Kim Đồng', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01795, N'Minh Khai', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01798, N'Thị Ngân', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01801, N'Đức Thông', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01804, N'Thái Cường', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01807, N'Vân Trình', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01810, N'Thụy Hùng', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01813, N'Quang Trọng', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01816, N'Trọng Con', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01819, N'Lê Lai', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01822, N'Đức Long', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01825, N'Danh Sỹ', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01828, N'Lê Lợi', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01831, N'Đức Xuân', 053 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03124, N'Noong Bua', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03127, N'Him Lam', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03130, N'Thanh Bình', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03133, N'Tân Thanh', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03136, N'Mường Thanh', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03139, N'Nam Thanh', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03142, N'Thanh Trường', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03145, N'Thanh Minh', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03316, N'Nà Tấu', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03317, N'Nà Nhạn', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03325, N'Mường Phăng', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03326, N'Pá Khoang', 094 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03148, N'Sông Đà', 095 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03151, N'Na Lay', 095 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03184, N'Lay Nưa', 095 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03154, N'Sín Thầu', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03155, N'Sen Thượng', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03157, N'Chung Chải', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03158, N'Leng Su Sìn', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03159, N'Pá Mỳ', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03160, N'Mường Nhé', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03161, N'Nậm Vì', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03162, N'Nậm Kè', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03163, N'Mường Toong', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03164, N'Quảng Lâm', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03177, N'Huổi Lếnh', 096 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03172, N'Mường Chà', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03178, N'Xá Tổng', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03181, N'Mường Tùng', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03190, N'Hừa Ngài', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03191, N'Huổi Mí', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03193, N'Pa Ham', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03194, N'Nậm Nèn', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03196, N'Huổi Lèng', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03197, N'Sa Lông', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03200, N'Ma Thì Hồ', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03201, N'Na Sang', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03202, N'Mường Mươn', 097 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03217, N'Tủa Chùa', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03220, N'Huổi Só', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03223, N'Xín Chải', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03226, N'Tả Sìn Thàng', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03229, N'Lao Xả Phình', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03232, N'Tả Phìn', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03235, N'Tủa Thàng', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03238, N'Trung Thu', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03241, N'Sính Phình', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03244, N'Sáng Nhè', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03247, N'Mường Đun', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03250, N'Mường Báng', 098 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03253, N'Tuần Giáo', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03259, N'Phình Sáng', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03260, N'Rạng Đông', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03262, N'Mùn Chung', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03263, N'Nà Tòng', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03265, N'Ta Ma', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03268, N'Mường Mùn', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03269, N'Pú Xi', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03271, N'Pú Nhung', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03274, N'Quài Nưa', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03277, N'Mường Thín', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03280, N'Tỏa Tình', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03283, N'Nà Sáy', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03284, N'Mường Khong', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03289, N'Quài Cang', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03295, N'Quài Tở', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03298, N'Chiềng Sinh', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03299, N'Chiềng Đông', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03304, N'Tênh Phông', 099 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03319, N'Mường Pồn', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03322, N'Thanh Nưa', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03323, N'Hua Thanh', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03328, N'Thanh Luông', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03331, N'Thanh Hưng', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03334, N'Thanh Xương', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03337, N'Thanh Chăn', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03340, N'Pa Thơm', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03343, N'Thanh An', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03346, N'Thanh Yên', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03349, N'Noong Luống', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03352, N'Noọng Hẹt', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03355, N'Sam Mứn', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03356, N'Pom Lót', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03358, N'Núa Ngam', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03359, N'Hẹ Muông', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03361, N'Na Ư', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03364, N'Mường Nhà', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03365, N'Na Tông', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03367, N'Mường Lói', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03368, N'Phu Luông', 100 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03203, N'Điện Biên Đông', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03205, N'Na Son', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03208, N'Phì Nhừ', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03211, N'Chiềng Sơ', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03214, N'Mường Luân', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03370, N'Pú Nhi', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03371, N'Nong U', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03373, N'Xa Dung', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03376, N'Keo Lôm', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03379, N'Luân Giới', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03382, N'Phình Giàng', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03383, N'Pú Hồng', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03384, N'Tìa Dình', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03385, N'Háng Lìa', 101 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03256, N'Mường Ảng', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03286, N'Mường Đăng', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03287, N'Ngối Cáy', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03292, N'Ẳng Tở', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03301, N'Búng Lao', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03302, N'Xuân Lao', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03307, N'Ẳng Nưa', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03310, N'Ẳng Cang', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03312, N'Nặm Lịch', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03313, N'Mường Lạn', 102 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03156, N'Nậm Tin', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03165, N'Pa Tần', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03166, N'Chà Cang', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03167, N'Na Cô Sa', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03168, N'Nà Khoa', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03169, N'Nà Hỳ', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03170, N'Nà Bủng', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03171, N'Nậm Nhừ', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03173, N'Nậm Chua', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03174, N'Nậm Khăn', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03175, N'Chà Tở', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03176, N'Vàng Đán', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03187, N'Chà Nưa', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03198, N'Phìn Hồ', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 03199, N'Si Pa Phìn', 103 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00688, N'Quang Trung', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00691, N'Trần Phú', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00692, N'Ngọc Hà', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00694, N'Nguyễn Trãi', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00697, N'Minh Khai', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00700, N'Ngọc Đường', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00946, N'Phương Độ', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00949, N'Phương Thiện', 024 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00712, N'Phó Bảng', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00715, N'Lũng Cú', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00718, N'Má Lé', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00721, N'Đồng Văn', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00724, N'Lũng Táo', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00727, N'Phố Là', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00730, N'Thài Phìn Tủng', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00733, N'Sủng Là', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00736, N'Xà Phìn', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00739, N'Tả Phìn', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00742, N'Tả Lủng', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00745, N'Phố Cáo', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00748, N'Sính Lủng', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00751, N'Sảng Tủng', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00754, N'Lũng Thầu', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00757, N'Hố Quáng Phìn', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00760, N'Vần Chải', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00763, N'Lũng Phìn', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00766, N'Sủng Trái', 026 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00769, N'Mèo Vạc', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00772, N'Thượng Phùng', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00775, N'Pải Lủng', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00778, N'Xín Cái', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00781, N'Pả Vi', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00784, N'Giàng Chu Phìn', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00787, N'Sủng Trà', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00790, N'Sủng Máng', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00793, N'Sơn Vĩ', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00796, N'Tả Lủng', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00799, N'Cán Chu Phìn', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00802, N'Lũng Pù', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00805, N'Lũng Chinh', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00808, N'Tát Ngà', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00811, N'Nậm Ban', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00814, N'Khâu Vai', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00815, N'Niêm Tòng', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00817, N'Niêm Sơn', 027 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00820, N'Yên Minh', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00823, N'Thắng Mố', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00826, N'Phú Lũng', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00829, N'Sủng Tráng', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00832, N'Bạch Đích', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00835, N'Na Khê', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00838, N'Sủng Thài', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00841, N'Hữu Vinh', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00844, N'Lao Và Chải', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00847, N'Mậu Duệ', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00850, N'Đông Minh', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00853, N'Mậu Long', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00856, N'Ngam La', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00859, N'Ngọc Long', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00862, N'Đường Thượng', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00865, N'Lũng Hồ', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00868, N'Du Tiến', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00871, N'Du Già', 028 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00874, N'Tam Sơn', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00877, N'Bát Đại Sơn', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00880, N'Nghĩa Thuận', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00883, N'Cán Tỷ', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00886, N'Cao Mã Pờ', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00889, N'Thanh Vân', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00892, N'Tùng Vài', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00895, N'Đông Hà', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00898, N'Quản Bạ', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00901, N'Lùng Tám', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00904, N'Quyết Tiến', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00907, N'Tả Ván', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00910, N'Thái An', 029 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00703, N'Kim Thạch', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00706, N'Phú Linh', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00709, N'Kim Linh', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00913, N'Vị Xuyên', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00916, N'Nông Trường Việt Lâm', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00919, N'Minh Tân', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00922, N'Thuận Hoà', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00925, N'Tùng Bá', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00928, N'Thanh Thủy', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00931, N'Thanh Đức', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00934, N'Phong Quang', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00937, N'Xín Chải', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00940, N'Phương Tiến', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00943, N'Lao Chải', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00952, N'Cao Bồ', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00955, N'Đạo Đức', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00958, N'Thượng Sơn', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00961, N'Linh Hồ', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00964, N'Quảng Ngần', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00967, N'Việt Lâm', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00970, N'Ngọc Linh', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00973, N'Ngọc Minh', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00976, N'Bạch Ngọc', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00979, N'Trung Thành', 030 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00982, N'Minh Sơn', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00985, N'Giáp Trung', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00988, N'Yên Định', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00991, N'Yên Phú', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00994, N'Minh Ngọc', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00997, N'Yên Phong', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01000, N'Lạc Nông', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01003, N'Phú Nam', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01006, N'Yên Cường', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01009, N'Thượng Tân', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01012, N'Đường Âm', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01015, N'Đường Hồng', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01018, N'Phiêng Luông', 031 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01021, N'Vinh Quang', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01024, N'Bản Máy', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01027, N'Thàng Tín', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01030, N'Thèn Chu Phìn', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01033, N'Pố Lồ', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01036, N'Bản Phùng', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01039, N'Túng Sán', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01042, N'Chiến Phố', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01045, N'Đản Ván', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01048, N'Tụ Nhân', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01051, N'Tân Tiến', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01054, N'Nàng Đôn', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01057, N'Pờ Ly Ngài', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01060, N'Sán Xả Hồ', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01063, N'Bản Luốc', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01066, N'Ngàm Đăng Vài', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01069, N'Bản Nhùng', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01072, N'Tả Sử Choóng', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01075, N'Nậm Dịch', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01081, N'Hồ Thầu', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01084, N'Nam Sơn', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01087, N'Nậm Tỵ', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01090, N'Thông Nguyên', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01093, N'Nậm Khòa', 032 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01096, N'Cốc Pài', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01099, N'Nàn Xỉn', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01102, N'Bản Díu', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01105, N'Chí Cà', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01108, N'Xín Mần', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01111, N'Trung Thịnh', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01114, N'Thèn Phàng', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01120, N'Pà Vầy Sủ', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01123, N'Cốc Rế', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01126, N'Thu Tà', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01129, N'Nàn Ma', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01132, N'Tả Nhìu', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01135, N'Bản Ngò', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01138, N'Chế Là', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01141, N'Nấm Dẩn', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01144, N'Quảng Nguyên', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01147, N'Nà Chì', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01150, N'Khuôn Lùng', 033 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01153, N'Việt Quang', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01156, N'Vĩnh Tuy', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01159, N'Tân Lập', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01162, N'Tân Thành', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01165, N'Đồng Tiến', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01168, N'Đồng Tâm', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01171, N'Tân Quang', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01174, N'Thượng Bình', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01177, N'Hữu Sản', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01180, N'Kim Ngọc', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01183, N'Việt Vinh', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01186, N'Bằng Hành', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01189, N'Quang Minh', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01192, N'Liên Hiệp', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01195, N'Vô Điếm', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01198, N'Việt Hồng', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01201, N'Hùng An', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01204, N'Đức Xuân', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01207, N'Tiên Kiều', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01210, N'Vĩnh Hảo', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01213, N'Vĩnh Phúc', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01216, N'Đồng Yên', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01219, N'Đông Thành', 034 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01222, N'Xuân Minh', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01225, N'Tiên Nguyên', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01228, N'Tân Nam', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01231, N'Bản Rịa', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01234, N'Yên Thành', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01237, N'Yên Bình', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01240, N'Tân Trịnh', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01243, N'Tân Bắc', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01246, N'Bằng Lang', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01249, N'Yên Hà', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01252, N'Hương Sơn', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01255, N'Xuân Giang', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01258, N'Nà Khương', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01261, N'Tiên Yên', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 01264, N'Vĩ Thượng', 035 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00001, N'Phúc Xá', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00004, N'Trúc Bạch', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00006, N'Vĩnh Phúc', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00007, N'Cống Vị', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00008, N'Liễu Giai', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00010, N'Nguyễn Trung Trực', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00013, N'Quán Thánh', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00016, N'Ngọc Hà', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00019, N'Điện Biên', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00022, N'Đội Cấn', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00025, N'Ngọc Khánh', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00028, N'Kim Mã', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00031, N'Giảng Võ', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00034, N'Thành Công', 001 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00037, N'Phúc Tân', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00040, N'Đồng Xuân', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00043, N'Hàng Mã', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00046, N'Hàng Buồm', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00049, N'Hàng Đào', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00052, N'Hàng Bồ', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00055, N'Cửa Đông', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00058, N'Lý Thái Tổ', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00061, N'Hàng Bạc', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00064, N'Hàng Gai', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00067, N'Chương Dương', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00070, N'Hàng Trống', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00073, N'Cửa Nam', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00076, N'Hàng Bông', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00079, N'Tràng Tiền', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00082, N'Trần Hưng Đạo', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00085, N'Phan Chu Trinh', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00088, N'Hàng Bài', 002 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00091, N'Phú Thượng', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00094, N'Nhật Tân', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00097, N'Tứ Liên', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00100, N'Quảng An', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00103, N'Xuân La', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00106, N'Yên Phụ', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00109, N'Bưởi', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00112, N'Thụy Khuê', 003 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00115, N'Thượng Thanh', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00118, N'Ngọc Thụy', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00121, N'Giang Biên', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00124, N'Đức Giang', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00127, N'Việt Hưng', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00130, N'Gia Thụy', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00133, N'Ngọc Lâm', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00136, N'Phúc Lợi', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00139, N'Bồ Đề', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00142, N'Sài Đồng', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00145, N'Long Biên', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00148, N'Thạch Bàn', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00151, N'Phúc Đồng', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00154, N'Cự Khối', 004 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00157, N'Nghĩa Đô', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00160, N'Nghĩa Tân', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00163, N'Mai Dịch', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00166, N'Dịch Vọng', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00167, N'Dịch Vọng Hậu', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00169, N'Quan Hoa', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00172, N'Yên Hoà', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00175, N'Trung Hoà', 005 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00178, N'Cát Linh', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00181, N'Văn Miếu', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00184, N'Quốc Tử Giám', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00187, N'Láng Thượng', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00190, N'Ô Chợ Dừa', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00193, N'Văn Chương', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00196, N'Hàng Bột', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00199, N'Láng Hạ', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00202, N'Khâm Thiên', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00205, N'Thổ Quan', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00208, N'Nam Đồng', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00211, N'Trung Phụng', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00214, N'Quang Trung', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00217, N'Trung Liệt', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00220, N'Phương Liên', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00223, N'Thịnh Quang', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00226, N'Trung Tự', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00229, N'Kim Liên', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00232, N'Phương Mai', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00235, N'Ngã Tư Sở', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00238, N'Khương Thượng', 006 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00241, N'Nguyễn Du', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00244, N'Bạch Đằng', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00247, N'Phạm Đình Hổ', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00250, N'Bùi Thị Xuân', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00253, N'Ngô Thì Nhậm', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00256, N'Lê Đại Hành', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00259, N'Đồng Nhân', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00262, N'Phố Huế', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00265, N'Đống Mác', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00268, N'Thanh Lương', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00271, N'Thanh Nhàn', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00274, N'Cầu Dền', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00277, N'Bách Khoa', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00280, N'Đồng Tâm', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00283, N'Vĩnh Tuy', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00286, N'Bạch Mai', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00289, N'Quỳnh Mai', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00292, N'Quỳnh Lôi', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00295, N'Minh Khai', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00298, N'Trương Định', 007 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00301, N'Thanh Trì', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00304, N'Vĩnh Hưng', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00307, N'Định Công', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00310, N'Mai Động', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00313, N'Tương Mai', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00316, N'Đại Kim', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00319, N'Tân Mai', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00322, N'Hoàng Văn Thụ', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00325, N'Giáp Bát', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00328, N'Lĩnh Nam', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00331, N'Thịnh Liệt', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00334, N'Trần Phú', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00337, N'Hoàng Liệt', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00340, N'Yên Sở', 008 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00343, N'Nhân Chính', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00346, N'Thượng Đình', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00349, N'Khương Trung', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00352, N'Khương Mai', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00355, N'Thanh Xuân Trung', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00358, N'Phương Liệt', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00361, N'Hạ Đình', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00364, N'Khương Đình', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00367, N'Thanh Xuân Bắc', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00370, N'Thanh Xuân Nam', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00373, N'Kim Giang', 009 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00376, N'Sóc Sơn', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00379, N'Bắc Sơn', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00382, N'Minh Trí', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00385, N'Hồng Kỳ', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00388, N'Nam Sơn', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00391, N'Trung Giã', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00394, N'Tân Hưng', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00397, N'Minh Phú', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00400, N'Phù Linh', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00403, N'Bắc Phú', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00406, N'Tân Minh', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00409, N'Quang Tiến', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00412, N'Hiền Ninh', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00415, N'Tân Dân', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00418, N'Tiên Dược', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00421, N'Việt Long', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00424, N'Xuân Giang', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00427, N'Mai Đình', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00430, N'Đức Hoà', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00433, N'Thanh Xuân', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00436, N'Đông Xuân', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00439, N'Kim Lũ', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00442, N'Phú Cường', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00445, N'Phú Minh', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00448, N'Phù Lỗ', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00451, N'Xuân Thu', 016 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00454, N'Đông Anh', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00457, N'Xuân Nộn', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00460, N'Thuỵ Lâm', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00463, N'Bắc Hồng', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00466, N'Nguyên Khê', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00469, N'Nam Hồng', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00472, N'Tiên Dương', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00475, N'Vân Hà', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00478, N'Uy Nỗ', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00481, N'Vân Nội', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00484, N'Liên Hà', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00487, N'Việt Hùng', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00490, N'Kim Nỗ', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00493, N'Kim Chung', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00496, N'Dục Tú', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00499, N'Đại Mạch', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00502, N'Vĩnh Ngọc', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00505, N'Cổ Loa', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00508, N'Hải Bối', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00511, N'Xuân Canh', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00514, N'Võng La', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00517, N'Tàm Xá', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00520, N'Mai Lâm', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00523, N'Đông Hội', 017 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00526, N'Yên Viên', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00529, N'Yên Thường', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00532, N'Yên Viên', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00535, N'Ninh Hiệp', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00538, N'Đình Xuyên', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00541, N'Dương Hà', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00544, N'Phù Đổng', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00547, N'Trung Mầu', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00550, N'Lệ Chi', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00553, N'Cổ Bi', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00556, N'Đặng Xá', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00559, N'Phú Thị', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00562, N'Kim Sơn', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00565, N'Trâu Quỳ', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00568, N'Dương Quang', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00571, N'Dương Xá', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00574, N'Đông Dư', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00577, N'Đa Tốn', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00580, N'Kiêu Kỵ', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00583, N'Bát Tràng', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00586, N'Kim Lan', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00589, N'Văn Đức', 018 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00592, N'Cầu Diễn', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00622, N'Xuân Phương', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00623, N'Phương Canh', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00625, N'Mỹ Đình 1', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00626, N'Mỹ Đình 2', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00628, N'Tây Mỗ', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00631, N'Mễ Trì', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00632, N'Phú Đô', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00634, N'Đại Mỗ', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00637, N'Trung Văn', 019 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00640, N'Văn Điển', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00643, N'Tân Triều', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00646, N'Thanh Liệt', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00649, N'Tả Thanh Oai', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00652, N'Hữu Hoà', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00655, N'Tam Hiệp', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00658, N'Tứ Hiệp', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00661, N'Yên Mỹ', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00664, N'Vĩnh Quỳnh', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00667, N'Ngũ Hiệp', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00670, N'Duyên Hà', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00673, N'Ngọc Hồi', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00676, N'Vạn Phúc', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00679, N'Đại áng', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00682, N'Liên Ninh', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00685, N'Đông Mỹ', 020 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00595, N'Thượng Cát', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00598, N'Liên Mạc', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00601, N'Đông Ngạc', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00602, N'Đức Thắng', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00604, N'Thụy Phương', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00607, N'Tây Tựu', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00610, N'Xuân Đỉnh', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00611, N'Xuân Tảo', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00613, N'Minh Khai', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00616, N'Cổ Nhuế 1', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00617, N'Cổ Nhuế 2', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00619, N'Phú Diễn', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 00620, N'Phúc Diễn', 021 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08973, N'Chi Đông', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08974, N'Đại Thịnh', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08977, N'Kim Hoa', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08980, N'Thạch Đà', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08983, N'Tiến Thắng', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08986, N'Tự Lập', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08989, N'Quang Minh', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08992, N'Thanh Lâm', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08995, N'Tam Đồng', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 08998, N'Liên Mạc', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09001, N'Vạn Yên', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09004, N'Chu Phan', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09007, N'Tiến Thịnh', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09010, N'Mê Linh', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09013, N'Văn Khê', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09016, N'Hoàng Kim', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09019, N'Tiền Phong', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09022, N'Tráng Việt', 250 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09538, N'Nguyễn Trãi', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09541, N'Mộ Lao', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09542, N'Văn Quán', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09544, N'Vạn Phúc', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09547, N'Yết Kiêu', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09550, N'Quang Trung', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09551, N'La Khê', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09552, N'Phú La', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09553, N'Phúc La', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09556, N'Hà Cầu', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09562, N'Yên Nghĩa', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09565, N'Kiến Hưng', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09568, N'Phú Lãm', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09571, N'Phú Lương', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09886, N'Dương Nội', 268 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09574, N'Lê Lợi', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09577, N'Phú Thịnh', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09580, N'Ngô Quyền', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09583, N'Quang Trung', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09586, N'Sơn Lộc', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09589, N'Xuân Khanh', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09592, N'Đường Lâm', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09595, N'Viên Sơn', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09598, N'Xuân Sơn', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09601, N'Trung Hưng', 269 )
INSERT INTO Ward
  ( id, name, district_ward )
VALUES
  ( 09604, N'Thanh Mỹ', 269 )
GO

SET IDENTITY_INSERT [Ward] OFF
GO
SET IDENTITY_INSERT [Permission] ON
GO

INSERT INTO [Permission]
  ( id, name )
VALUES
  ( 1, 'READ:OWN_PROFILE' ),
  ( 2, 'WRITE:OWN_PROFILE' ),
  ( 3, 'READ:ANY_PROFILE' ),
  ( 4, 'WRITE:ANY_PROFILE' ),
  ( 5, 'READ:OWN_ORDERS' ),
  ( 6, 'WRITE:OWN_ORDERS' ),
  ( 7, 'READ:ANY_ORDERS' ),
  ( 8, 'WRITE:ANY_ORDERS' ),
  ( 9, 'READ:PRODUCT' ),
  ( 10, 'WRITE:PRODUCT' )
GO

SET IDENTITY_INSERT [Permission] OFF
GO
SET IDENTITY_INSERT [Role] ON
GO

INSERT INTO [Role]
  ( id, name )
VALUES
  ( 1, 'USER' ),
  ( 2, 'CUSTOMER' ),
  ( 3, 'MANAGER' )
GO

SET IDENTITY_INSERT [Role] OFF
GO

INSERT INTO [Role_Permission]
  ( role_id, permission_id )
VALUES
  ( 1, 1 ),
  ( 1, 2 ),
  ( 2, 5 ),
  ( 2, 6 ),
  ( 2, 9 ),
  ( 2, 10 ),
  ( 3, 3 ),
  ( 3, 4 ),
  ( 3, 7 ),
  ( 3, 8 )
GO

SET IDENTITY_INSERT [User] ON
GO

INSERT INTO [User]
  ( id, phone, password, full_name )
VALUES
  ( 1, '0901111111', '$2y$12$L4uQGPD9RR4WlrCupg29qOy1lREMNCUS7cr4tG10Y0uZHUbNM/97a', 'Super user' ),
  ( 2, '0902222222', '$2y$12$L4uQGPD9RR4WlrCupg29qOy1lREMNCUS7cr4tG10Y0uZHUbNM/97a', 'The best customer' )
GO

SET IDENTITY_INSERT [User] OFF
GO

INSERT INTO [Assignment]
  ( [user], [role] )
VALUES
  ( 1, 1 ),
  ( 1, 2 ),
  ( 2, 1 ),
  ( 2, 3 )
GO

INSERT INTO [Media]
  ( [name], [uri], [ext], [mime], [size], [hash], [sha256] )
VALUES
  ('iPhone 12', 'https://salt.tikicdn.com/cache/w1200/ts/product/86/dd/0c/11d4a7aa14e6a7a384df5b910cd1ae68.jpg', 'jpg', 'image/jpg', '123', 'hashed', 'hashed'),
  ('MacBook Pro M1', 'https://salt.tikicdn.com/cache/w1200/ts/product/a7/e8/d6/0aae2ebd7d4568cb577629db0a5c744b.jpg', 'jpg', 'image/jpg', '123', 'hashed', 'hashed')
GO

INSERT INTO [Product]
  ( [name] )
VALUES
  ('iPhone 12 Pro' ),
  ('MacBook Pro M1' )
GO

INSERT INTO [Product_Media]
  ( [product_id], [media_id] )
VALUES
  (1, 1 ),
  (2, 2 )
GO

INSERT INTO [Product_Variant]
  ( [product_id], [name], [price], [in_stock], [status] )
VALUES
  (1, 'iPhone 12 Pro', 1, 10, 'IN_STOCK'),
  (2, 'MacBook Pro M1', 2, 10, 'IN_STOCK' )
GO

