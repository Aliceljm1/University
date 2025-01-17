/*Họ Tên: Phan Y Biển
MSSV: 12520026
Lớp: IT004.E16*/

-- Phần III
-- Câu 1
select MAHV,HO,TEN,NGSINH,MALOP
from HOCVIEN
where MAHV in (select TRGLOP
				from LOP)
				
-- Câu 2
select KQT.MAHV,HO,TEN,LANTHI,DIEM
from HOCVIEN HV, KETQUATHI KQT
where HV.MAHV=KQT.MAHV and MAMH='CTRR' and MALOP='K12'
order by TEN ASC, HO ASC

-- Câu 3
select KQT.MAHV,HO,TEN,TENMH
from HOCVIEN HV, KETQUATHI KQT, MONHOC MH
where HV.MAHV=KQT.MAHV and KQT.MAMH=MH.MAMH
		and LANTHI=1 and KQUA='Dat'
		
-- Câu 4
select KQT.MAHV,HO,TEN
from HOCVIEN HV, KETQUATHI KQT
where HV.MAHV=KQT.MAHV and MALOP='K11' and MAMH='CTRR' and LANTHI=1 and KQUA='Khong Dat'

-- Câu 5
select distinct KQT.MAHV, HO, TEN
from KETQUATHI KQT, HOCVIEN HV
where KQT.MAHV=HV.MAHV and KQT.MAHV not in (select MAHV
											from KETQUATHI
											where MAMH='CTRR' and KQUA='Dat')

-- Câu 6
select distinct TENMH
from MONHOC MH, GIANGDAY GD, GIAOVIEN GV
where MH.MAMH=GD.MAMH and GD.MAGV=GV.MAGV
		and HOTEN='Tran Tam Thanh' and HOCKY=1 and NAM=2006

-- Câu 7
select MH.MAMH, TENMH
from MONHOC MH, GIANGDAY GD
where MH.MAMH=GD.MAMH and HOCKY=1 and NAM=2006 
		and MAGV in (select MAGVCN
						from LOP
						where MALOP='K11')

-- Câu 8
select HO,TEN
from HOCVIEN
where MAHV in (select TRGLOP
				from LOP
				where MALOP in (select MALOP
								from MONHOC MH, GIANGDAY GD, GIAOVIEN GV
								where MH.MAMH=GD.MAMH and GD.MAGV=GV.MAGV
										and HOTEN='Nguyen To Lan' and TENMH='Co So Du Lieu'))
										
-- Câu 9
select MAMH, TENMH
from MONHOC
where MAMH in (select MAMH_TRUOC
				from MONHOC MH, DIEUKIEN DK
				where MH.MAMH=DK.MAMH and TENMH='Co So Du Lieu')

-- Câu 10
select MAMH, TENMH
from MONHOC
where MAMH in (select DK.MAMH
				from MONHOC MH, DIEUKIEN DK
				where MH.MAMH=DK.MAMH_TRUOC and TENMH='Cau Truc Roi Rac')