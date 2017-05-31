--Create Role
CREATE ROLE TruongPhong; 
CREATE ROLE GiamDoc; 
CREATE ROLE TruongChiNhanh; 
CREATE ROLE NhanVien; 
CREATE ROLE TruongDuAn; 

--Grant các quyền cho Role
--Trưởng phòng
GRANT SELECT, INSERT, UPDATE ON DUAN TO TruongPhong;
GRANT EXECUTE ON capNhatPhongBan_TruongPhong TO TruongPhong;
--Trưởng chi nhánh
GRANT EXECUTE ON capNhatPhongBan_TruongCN TO TruongChiNhanh;
-- Giám đốc
GRANT SELECT ON DUAN TO GiamDoc;
GRANT SELECT ON PHONGBAN TO GiamDoc;
GRANT SELECT ON CHINHANH TO GiamDoc;
GRANT SELECT ON CHITIEU TO GiamDoc;

-- Grant role cho user
GRANT TruongPhong to "10001", "10002", "10003", "10004", "10005";
GRANT GiamDoc to "10000", "10006", "10007", "10008", "10009";
GRANT TruongChiNhanh to "10021", "10022", "10023", "10024", "10025";
GRANT NhanVien to "10016", "10017", "10018", "10019", "10020";
GRANT TruongDuAn to "10010", "10011", "10012", "10013", "10014";