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

-- Câu 11
select distinct HOTEN
from GIANGDAY GD, GIAOVIEN GV
where GD.MAGV=GV.MAGV and (MALOP='K11' or MALOP='K12') and MAMH='CTRR' and HOCKY=1 and NAM=2006

-- Câu 12
select MAHV,HO,TEN
from HOCVIEN 
where MAHV in (select MAHV
				from KETQUATHI
				where MAMH='CSDL' and KQUA='Khong Dat'
				group by MAHV
				having COUNT(MAHV)=1)

-- Câu 13
select MAGV,HOTEN
from GIAOVIEN
where MAGV not in (select MAGV
					from GIANGDAY)

-- Câu 14 *
/*select MAGV, GV.MAKHOA
from MONHOC MH, GIAOVIEN GV
where not exists (select MAMH
					from MONHOC MH, GIAOVIEN GV
					where MH.MAKHOA=GV.MAKHOA)*/
					
(select MAGV, MH.MAMH, MAKHOA
from MONHOC MH, GIANGDAY GD
where MH.MAMH=GD.MAMH)

-- Câu 15
select HO,TEN
from HOCVIEN HV, KETQUATHI KQT
where HV.MAHV=KQT.MAHV and MALOP='K11' and ((LANTHI=3 and KQUA='Khong Dat') or (LANTHI=2 and MAMH='CTRR' and DIEM=5))

-- Câu 16
select HOTEN
from GIAOVIEN GV, (select MAGV, NAM, HOCKY, COUNT(MALOP) SL_Lop_CTRR
					from GIANGDAY
					where MAMH='CTRR' 
					group by NAM, HOCKY, MAGV
					having COUNT(MALOP)>=2) A
where GV.MAGV=A.MAGV

-- Câu 17 
(select KQT.MAHV, HO, TEN, MAMH, LANTHI, DIEM
from KETQUATHI KQT, HOCVIEN HV
where KQT.MAHV=HV.MAHV and MAMH='CSDL' and KQT.MAHV not in (select MAHV
															from KETQUATHI
															where MAMH='CSDL' and (LANTHI=2 or LANTHI=3)))
union
(select KQT.MAHV, HO, TEN, MAMH, LANTHI, DIEM
from KETQUATHI KQT, HOCVIEN HV
where KQT.MAHV=HV.MAHV and MAMH='CSDL' and LANTHI=2 and KQT.MAHV not in (select MAHV
																		from KETQUATHI
																		where MAMH='CSDL' and LANTHI=3))
union
(select KQT.MAHV, HO, TEN, MAMH, LANTHI, DIEM
from KETQUATHI KQT, HOCVIEN HV
where KQT.MAHV=HV.MAHV and KQT.MAMH='CSDL' and LANTHI=3)

-- Câu 18
select HV.MAHV,HO,TEN,NGSINH,GIOITINH,NOISINH,MALOP,DT_Mon_Co_So_Du_Lieu
from HOCVIEN HV , (select MAHV, MAX(DIEM) DT_Mon_Co_So_Du_Lieu
					from KETQUATHI KQT, MONHOC MH
					where KQT.MAMH=MH.MAMH and TENMH='Co So Du Lieu'
					group by MAHV) A
where HV.MAHV=A.MAHV

-- Câu 19
select MAKHOA, TENKHOA
from KHOA
where NGTLAP in(select min(NGTLAP)
				from KHOA)

-- Câu 20
select count(HOCHAM) So_hoc_ham_GS_PGS
from (select HOCHAM
		from GIAOVIEN
		where HOCHAM='GS' or HOCHAM='PGS') A
		
-- Câu 21
select MAKHOA, HOCVI, COUNT(MAGV) SLGV
from GIAOVIEN
group by HOCVI, MAKHOA

-- Câu 22
select SL.MAMH,TENMH, KQUA, So_Luong_HV
from MONHOC MH, (select MAMH, KQUA, COUNT(MAHV) So_Luong_HV
				from KETQUATHI
				group by MAMH, KQUA) SL
where MH.MAMH=SL.MAMH

-- Câu 23
select MAGVCN, HOTEN
from LOP, GIAOVIEN
where MAGVCN=MAGV and MAGVCN in (select distinct MAGV
								from GIANGDAY
								where MAGV in (select MAGVCN
												from LOP))

-- Câu 24
select TRGLOP, HO, TEN
from LOP L, HOCVIEN HV
where L.TRGLOP=HV.MAHV and SISO in (select MAX(SISO)
									from LOP)

-- Câu 25
select MAHV, MAMH, KQUA
from KETQUATHI
where KQUA='Khong Dat' /*and MAHV in (select TRGLOP
									from LOP)*/
-- Câu 26
select top 1 A.MAHV, HO,TEN
from HOCVIEN HV, (select MAHV, count(DIEM) Tong
				from KETQUATHI
				where DIEM=9 or DIEM =10
				group by MAHV) A
where HV.MAHV=A.MAHV
order by Tong DESC

-- Câu 27
-- Câu 28
-- Câu 29
select GV.MAGV, HOTEN
from GIAOVIEN GV,(select NAM, HOCKY, MAGV, COUNT(MAGV) SL
							from GIANGDAY
							group by NAM, HOCKY, MAGV) A
where GV.MAGV=A.MAGV and SL in (select MAX(SL)
								from (select NAM, HOCKY, MAGV, COUNT(MAGV) SL
										from GIANGDAY
										group by NAM, HOCKY, MAGV) A)



select * from KHOA
select * from MONHOC
select * from DIEUKIEN
select * from GIAOVIEN
select * from LOP
select * from HOCVIEN
select * from GIANGDAY
select * from KETQUATHI 
