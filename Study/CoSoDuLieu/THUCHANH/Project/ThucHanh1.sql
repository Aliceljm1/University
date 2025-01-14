-- Bài tập 1
-- II

-- Câu 2
-- Cop nội dung sang bảng mới
select * into SANPHAM1
from SANPHAM

select * into KHACHHANG1
from KHACHHANG

select * into SANPHAM2
from SANPHAM
where NUOCSX='Singapore'

-- Câu3
-- Tăng 5% GIA
update SANPHAM1 set GIA=GIA*1.05
where NUOCSX='Thai Lan'

-- Câu4
-- Giảm 5% GIA
update SANPHAM1 set GIA=GIA-GIA*0.05
where NUOCSX='Trung Quoc'

-- Câu 5
update SANPHAM1 set DVT='cay'
where (NUOCSX='Thai Lan') AND (GIA>700)

-- Câu 6
alter table KHACHHANG1 add LOAIKH varchar(10)

update KHACHHANG1 set LOAIKH='Vip'
where ((NGDK<'1/1/2007') AND (DOANHSO>=10000000)) OR ((NGDK>='1/1/2007') AND (DOANHSO>=2000000))

-- Xóa những sản phẩm có NUOCSX là Singapore ra khỏi quan hệ SANPHAM1
delete from SANPHAM1
where NUOCSX='Singapore'

-- Xóa những khách hàng sinh vào năm 1980
delete from KHACHHANG1
where YEAR(NGSINH)=1980

-- III
-- Câu 1
select * from SANPHAM1
where NUOCSX='Trung Quoc'

select MASP,TENSP
from SANPHAM1
where NUOCSX='Trung Quoc'

-- Câu 2
select MASP,TENSP,DVT
from SANPHAM1
where (DVT='cay') OR (DVT='quyen')
order by MASP ASC

-- Câu 3
select MASP,TENSP
from SANPHAM1
where MASP Like 'B%01'

-- Câu 4
select MASP,TENSP,NUOCSX,GIA
from SANPHAM1
where (NUOCSX='Trung Quoc') AND (GIA BETWEEN 30000 AND 40000)

-- Câu 6
select SOHD,TRIGIA,NGHD
from HOADON
where (NGHD='1/1/2007') OR (NGHD='2/1/2007')

-- Câu 7
select SOHD,TRIGIA,NGHD
from HOADON
where (MONTH(NGHD)=1) AND (YEAR(NGHD)=2007)
order by NGHD ASC, TRIGIA DESC

-- Câu 8
select KHACHHANG1.MAKH, HOTEN
from KHACHHANG1 inner join HOADON
	on KHACHHANG1.MAKH = HOADON.MAKH
where NGHD ='1/1/2007'

select MAKH, HOTEN
from KHACHHANG1
where MAKH in (select MAKH
				from HOADON
				where NGHD ='1/1/2007')

select MAKH, HOTEN
from KHACHHANG1
where exists (select MAKH
				from HOADON
				where NGHD ='1/1/2007'
				AND HOADON.MAKH=KHACHHANG1.MAKH)
				
select KHACHHANG1.MAKH,HOTEN
from KHACHHANG1, HOADON
where KHACHHANG1.MAKH = HOADON.MAKH
	AND NGHD='1/1/2007'

-- Câu 9
select SOHD,TRIGIA
from NHANVIEN NV inner join HOADON HD on NV.MANV = HD.MANV
where HoTen='Nguyen Van B' AND NGHD = '28/10/2006'

-- Câu 10
select SP.MASP, SP.TENSP
from SANPHAM1 SP, CTHD CT, HOADON HD, KHACHHANG1 KH
where SP.MASP = CT.MASP AND CT.SOHD = HD.SOHD AND HD.MAKH = KH.MAKH
	AND KH.HOTEN='Nguyen Van A'
	AND Month(NGHD)=10 
	AND Year(NGHD)=2006
	
-- Câu 11
select SOHD
from CTHD
where MASP='BB01' OR MASP='BB02'

-- Câu 12
select MASP,SOHD,SL
from CTHD
where (MASP='BB01' OR MASP='BB02') AND (SL BETWEEN 10 and 20)

-- Câu 13
(select SOHD
from CTHD
where MASP='BB01' AND (SL BETWEEN 10 and 20))
intersect -- Phép giao
(select SOHD
from CTHD
where MASP='BB02' AND (SL BETWEEN 10 and 20))

select SOHD
from CTHD CT
where CT.MASP='BB01'
	AND exists (select SOHD
					from CTHD CT1
					where MASP='BB02'
					AND CT.SOHD = CT1.SOHD)
	AND (SL BETWEEN 10 AND 20)

-- Câu 14
select SP.MASP,SP.TENSP,SP.NUOCSX,HD.NGHD
from CTHD CT,HOADON HD, SANPHAM1 SP
where (CT.SOHD = HD.SOHD AND CT.MASP = SP.MASP)
	AND (SP.NUOCSX='Trung Quoc'
	OR HD.NGHD='1/1/2007')

union -- Phép hội

-- Câu 15
select MASP, TENSP
from SANPHAM1
where MASP not in (select MASP
				from CTHD)

-- Câu 16
select distinct SANPHAM.MASP,SANPHAM.TENSP,YEAR(HOADON.NGHD),SANPHAM.NUOCSX
from SANPHAM,HOADON,CTHD
where CTHD.SOHD=HOADON.SOHD
	AND SANPHAM.MASP not in (select CTHD.MASP
								from CTHD)
	AND YEAR(HOADON.NGHD)=2006
				
-- Câu 17
select distinct SANPHAM.MASP,SANPHAM.TENSP,YEAR(HOADON.NGHD)
from SANPHAM,HOADON,CTHD
where CTHD.SOHD=HOADON.SOHD
	AND SANPHAM.MASP not in (select CTHD.MASP
								from CTHD)
	AND YEAR(HOADON.NGHD)=2006
	AND SANPHAM.NUOCSX='Trung Quoc'

-- Câu 18-19 -- Sử dụng phép chia
select SOHD
from HOADON
where year(HOADON.NGHD)=2006 and not exists (select *
							from SANPHAM
							where NUOCSX='Singapore' and not exists (select *
																		from CTHD
																		where HOADON.SOHD=CTHD.SOHD and CTHD.MASP=SANPHAM.MASP))

-- Câu 20
select count(SOHD) SLKH
from HOADON
where MAKH is NULL

-- Câu 21
select COUNT(distinct MASP)
from HOADON,CTHD
where HOADON.SOHD=CTHD.SOHD
	AND YEAR(NGHD)=2006

-- Câu 22
select MAX(TRIGIA) TRIGIACAONHAT ,MIN(TRIGIA) TRIGIATHAPNHAT
from HOADON

-- Câu 23
select AVG(TRIGIA)TRIGIATRUNGBINH
from HOADON
where YEAR(NGHD)=2006

-- Câu 24
select SUM(TRIGIA)DoanhThu
from HOADON
where YEAR(NGHD)=2006

-- Câu 25
select SOHD,TRIGIA
from HOADON
where TRIGIA = (select max(TRIGIA)
				from HOADON
				where YEAR(NGHD)=2006)

-- Câu 26
select KHACHHANG.HOTEN
from KHACHHANG,(select SOHD,TRIGIA,MAKH
				from HOADON
				where TRIGIA = (select max(TRIGIA)
								from HOADON
								where YEAR(NGHD)=2006)
				AND YEAR(NGHD)=2006) MAXTRIGIA
where MAXTRIGIA.MAKH=KHACHHANG.MAKH

-- Câu 27
select top 3 * --MAKH,HOTEN,DOANHSO -- in ra 3 dòng đầu tiên
from KHACHHANG
order by DOANHSO DESC

-- Câu 28
select MASP,TENSP,GIA
from SANPHAM
where GIA = some (select distinct top 3 GIA -- Giá trùng
				from SANPHAM
				order by GIA DESC)

-- Câu 32
select COUNT(MASP)
from SANPHAM
where NUOCSX='Trung Quoc'

-- Câu 36
select TENSP ,SUM(SL) TongSL
from CTHD,HOADON,SANPHAM
where CTHD.SOHD=HOADON.SOHD and SANPHAM.MASP=CTHD.MASP and MONTH(NGHD)=10 and YEAR(NGHD)=2006
group by TENSP

-- Câu 38
select CTHD.SOHD, NGHD, MAKH , COUNT(distinct MASP)
from CTHD, HOADON
where CTHD.SOHD=HOADON.SOHD
group by CTHD.SOHD, NGHD, MAKH
having COUNT(distinct MASP) >=4

-- I

-- Câu 8
create trigger SANPHAM_GIA_Update
on SANPHAM1
for update
as
declare @gia money
		select @gia=GIA from inserted
if(@gia<500)
begin
	raiserror ('Dang goi trigger',16,10)
	rollback transaction
end

update SANPHAM1
set GIA=7000.00
where MASP='BB02'

-- Câu 11
-- Insert HOADON
create trigger hoadon_insert
on HOADON
for insert
as
declare @nghd smalldatetime, @ngdk smalldatetime, @makh char(4)
select @nghd=NGHD from inserted
select @makh=MAKH from inserted
select @ngdk=NGDK from KHACHHANG where MAKH=@makh
if(@nghd<@ngdk)
begin
	--raiserror ('Dang goi trigger',16,10)
	rollback transaction
	print 'NgayHD < NgayDK'
end
else print 'insert thanh cong'

insert into HOADON values (1026,'19-7-2006','KH01','NV01',100000)

drop trigger hoadon_insert

-- Update HOADON
create trigger hoadon_update
on HOADON
for update
as
declare @nghd smalldatetime, @ngdk smalldatetime, @makh char(4)
select @nghd=NGHD from inserted
select @makh=MAKH from inserted
select @ngdk=NGDK from KHACHHANG where MAKH=@makh
if(@nghd<@ngdk)
begin
	--raiserror ('Dang goi trigger',16,10)
	rollback transaction
	print 'NgayHD < NgayDK'
end
else print 'update thanh cong'

update HOADON
set NGHD='25-7-2006'
where SOHD=1001

-- Update KHACHHANG
create trigger khachhang_update
on KHACHHANG
for update
as
declare
	@ngdk smalldatetime,
	@makh char(4)
	select @ngdk = NGDK from inserted
	select @makh = MAKH from inserted
if (exists (select * from HOADON where MAKH=@makh AND NGHD<@ngdk))
begin
	rollback transaction
	print 'NgayHD < NgayDK'
end
else print 'update thanh cong'

update KHACHHANG
set NGDK='20/8/2006'
where MAKH='KH01'

-- Câu 13
create trigger cthd_delete
on CTHD
for delete
as
declare @sohd int
select @sohd=SOHD from deleted
if not exists (select * from CTHD
				where SOHD=@sohd)
begin
	rollback transaction
	print 'Khong duoc xoa'
end
else print 'Xoa thanh cong'

delete from CTHD where SOHD=1001 and MASP='BC02'

-- Câu 14
create trigger cthd_update
on CTHD
for update
as
declare 
@sohd int, @masp char(4), @sl1 int, @sl2 int, @gia money
select @sohd=SOHD, @masp=MASP, @sl1=SL from inserted
select @sl2=SL from deleted
select @gia=GIA from SANPHAM where MASP=@masp
update HOADON set TRIGIA=TRIGIA+@sl1*@gia-@sl2*@gia where SOHD=@sohd

update CTHD
set SL=9
where SOHD=1001 and MASP='TV02'
	
SELECT * FROM KHACHHANG
SELECT * FROM NHANVIEN
SELECT * FROM SANPHAM
SELECT * FROM HOADON
SELECT * FROM CTHD
Set dateformat dmy
	
