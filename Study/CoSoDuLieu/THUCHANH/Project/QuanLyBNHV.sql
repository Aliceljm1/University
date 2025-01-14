-- Câu 1
create table VONGTHI(
	MaVT char(10),
	NgayThi smalldatetime
	constraint pk_vongthi primary key (MaVT))
	
create table HLVIEN(
	MaHLV char(10),
	TenHLV nvarchar(30),
	GioiTinh char(4),
	constraint pk_hlvien primary key (MaHLV))

create table THISINH(
	MaTS char(10),
	TenTS nvarchar(30),
	GioiTinh char(4),
	NgheNghiep nvarchar(20),
	MaHLV char(10)
	constraint pk_thisinh primary key (MaTS))

create table KETQUAVONG(
	MaTS char(10),
	MaVT char(10),
	DiemTBBGK float,
	SoKGBC int,
	TiepTuc bit,
	GhiChu nvarchar(30),
	constraint pk_ketquavong primary key (MaTS,MaVT))

alter table THISINH add constraint fk_thisinh_hlvien foreign key (MaHLV) references HLVIEN(MaHLV)
alter table KETQUAVONG add constraint fk_ketquavong_thisinh foreign key (MaTS) references THISINH(MaTS)
alter table KETQUAVONG add constraint fk_ketquavong_vongthi foreign key (MaVT) references VONGTHI(MaVT)

-- Câu 2
alter table THISINH add GhiChu varchar(20)

-- Câu 3
alter table THISINH alter column GhiChu varchar(100)

-- Câu 4
-- 4.1
alter table THISINH add constraint ck_gioitinh check (GioiTinh='Nam' or GioiTinh='Nu')

-- 4.2
create trigger thisinh_insert
on THISINH
for insert
as
declare 
	@mahlv char(10)
	select @mahlv from inserted
if @mahlv in (select MaHLV from THISINH)
begin
	rollback transaction
end 

-- Câu 5
-- 5.1
select MaTS, TenTS
from THISINH TS, HLVIEN HLV
where TS.MaHLV=HLV.MaHLV and NgheNghiep=N'Ca Sĩ' and TenHLV='John'

-- 5.2
select TS.MaTS, TenTS
from KETQUAVONG KQV, THISINH TS, (select MaVT, MAX(SoKGBC)SL
								from KETQUAVONG
								group by MaVT) A
where KQV.MaVT=A.MaVT and KQV.MaTS=TS.MaTS

-- 5.3
select MaTS, TenTS
from THISINH
where MaTS in (select MaTS
				from KETQUAVONG
				group by MaTS
				having COUNT(MaVT)>=3)