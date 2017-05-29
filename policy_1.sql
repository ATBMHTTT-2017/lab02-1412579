CREATE OR REPLACE PACKAGE pEncrypt IS
  FUNCTION ENCRYPT_SALARY(inputData IN VARCHAR2,eKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC;
  FUNCTION DECRYPT_SALARY(inputEncryptData IN VARCHAR2,eKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC;
END;



CREATE OR REPLACE PACKAGE BODY pEncrypt IS 
  encrypt_Type PLS_INTEGER :=DBMS_CRYPTO.ENCRYPT_DES
							+DBMS_CRYPTO.CHAIN_CBC
							+DBMS_CRYPTO.PAD_PKCS5;
  FUNCTION ENCRYPT_SALARY(inputData IN VARCHAR2,eKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
  	raw_encrypted raw(2000);
    
  BEGIN
       raw_encrypted := dbms_crypto.encrypt(
          src => utl_raw.cast_to_raw(inputData),
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(eKey)
      );
      return utl_raw.cast_to_VARCHAR2(raw_encrypted);
  END ENCRYPT_SALARY;
  
  FUNCTION DECRYPT_SALARY(inputEncryptData IN VARCHAR2,eKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
    raw_decrypted raw(2000);
    rawInput raw(2000);
  BEGIN
       rawInput:= utl_raw.cast_to_RAW(inputEncryptData);
       raw_decrypted := dbms_crypto.decrypt(
          src => rawInput,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(eKey)
      );
      return utl_raw.cast_to_VARCHAR2(raw_decrypted);
  END DECRYPT_SALARY;

END pEncrypt;

select * from nhanvien
update nhanvien set luong = 5000000;

update nhanvien set luong = null;


BEGIN
FOR v_MaNV IN (select MaNV from NhanVien)
LOOP
UPDATE NhanVien SET LUONG = LUONG + MaNV * 10 WHERE MaNV = v_MaNV.MaNV;
END LOOP;
end;

ALTER TABLE Nhanvien
MODIFY luong varchar2(20);


select pEncrypt.DECRYPT_SALARY(pEncrypt.ENCRYPT_SALARY(5041523100, 500),500) from dual;

select pEncrypt.ENCRYPT_SALARY(50000, 50) from dual;

select * from nhanvien;

BEGIN
	FOR v_MaNV IN (select MaNV from NhanVien)
	LOOP
    UPDATE NhanVien SET LUONG = pEncrypt.ENCRYPT_SALARY(LUONG, MaNV) WHERE MaNV = v_MaNV.MaNV;
	END LOOP;
END;

select utl_raw.cast_to_RAW(utl_raw.cast_to_VARCHAR2('BA02BC5F7392CEC8')) from dual;

select * from NhanVien where manv = 10026;


SELECT pEncrypt.DECRYPT_SALARY(NV.LUONG,NV.MANV) FROM NHANVIEN NV WHERE MANV = 10037;

SELECT UTL_RAW.CAST_TO_RAW(NV.LUONG) FROM NHANVIEN NV WHERE MANV = 10037;