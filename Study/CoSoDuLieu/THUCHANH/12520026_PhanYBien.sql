/* Họ Tên: Phan Y Biển
MSSV: 12520026
Lớp: IT004.E16*/

-- Lưu ý: Thực hiện đổi kiểu nhập ngày tháng 
set dateformat dmy
-- Câu 1
select KH.MaKH, TenKH
from BAO B, KHACHHANG KH, PHIEUDATBAO PDB
where B.MaB=PDB.MaB and KH.MaKH=PDB.MaKH
		and TenB=N'Người lao động' and NgayDat='1/12/2006'

-- Câu 2
select distinct TenKH
from BAO B, KHACHHANG KH, PHIEUDATBAO PDB
where B.MaB=PDB.MaB and KH.MaKH=PDB.MaKH
		and TenB=N'Tuổi trẻ' and NgayDat>='1/1/2006' and NgayDat<='31/3/2006'

-- Câu 3
select MaB, TenB
from BAO
where DonGiaTK in (select MAX(DonGiaTK)
					from BAO)

-- Câu 4
select MaB, SUM(SoTo) TongSoToDatMua
from PHIEUDATBAO
where YEAR(NgayDat)=2005
group by MaB

-- Câu 5
select TenB, TongSoToDatMua
from BAO B, (select MaB, SUM(SoTo) TongSoToDatMua
				from PHIEUDATBAO
				where YEAR(NgayDat)=2005
				group by MaB) S
where B.MaB=S.MaB

-- Câu 6
select COUNT(TenB) TongSoBao
from (select distinct TenKH, TenB
		from BAO B, KHACHHANG KH, PHIEUDATBAO PDB
		where B.MaB=PDB.MaB and KH.MaKH=PDB.MaKH
		and TenKH=N'Nguyễn Lê Ân' and YEAR(NgayDat)=2005) A
		
-- Câu 7
select MaB, SUM(ThanhTien) TongTien
from PHIEUDATBAO
where YEAR(NgayDat)=2006
group by MaB

-- Câu 8
select TT.MaB, TenB, TongTien
from BAO B, (select MaB, SUM(ThanhTien) TongTien
			from PHIEUDATBAO
			where YEAR(NgayDat)=2006
			group by MaB) TT
where B.MaB=TT.MaB

-- Câu 9
select MONTH(NgayDat) Thang, SUM(ThanhTien) TongTien
from PHIEUDATBAO
where MaB='B04' and	YEAR(NgayDat)=2006
group by MONTH(NgayDat)

-- Câu10
select MaKH, TenKH
from KHACHHANG
where MaKH in (select MaKH
				from PHIEUDATBAO
				group by MaKH
				having SUM(ThanhTien)>70000)

-- Câu 11
select A.MaKH, TenKH, A.TongTien
from KHACHHANG KH, (select MaKH, SUM(ThanhTien) TongTien
					from PHIEUDATBAO
					group by MaKH
					having SUM(ThanhTien)>70000) A
where KH.MaKH=A.MaKH
order by A.TongTien DESC, TenKH ASC

-- Câu 12
(select distinct MaKH
from PHIEUDATBAO
where MaB='B04')
intersect
(select distinct MaKH
from PHIEUDATBAO
where MaB='B05')

-- Câu 13
(select distinct MaKH
from BAO B, PHIEUDATBAO PDB
where B.MaB=PDB.MaB and TenB=N'Tuổi trẻ')
intersect
(select distinct MaKH
from BAO B, PHIEUDATBAO PDB
where B.MaB=PDB.MaB and TenB=N'An ninh nhân dân')

-- Câu 14
(select distinct PDB.MaKH, TenKH
from BAO B, PHIEUDATBAO PDB, KHACHHANG KH
where B.MaB=PDB.MaB and PDB.MaKH=KH.MaKH and TenB=N'Tuổi trẻ')	
intersect
(select distinct PDB.MaKH, TenKH
from BAO B, PHIEUDATBAO PDB, KHACHHANG KH
where B.MaB=PDB.MaB and PDB.MaKH=KH.MaKH and TenB=N'An ninh nhân dân')	

-- Câu 15
select *
from BAO
where DONGIATK in (select distinct top 2 DONGIATK
					from BAO
					order by DonGiaTK DESC)