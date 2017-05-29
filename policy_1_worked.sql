

---Tạo package chứa hai function mã hoá và giải mã
CREATE OR REPLACE PACKAGE pEncrypt IS
  FUNCTION ENCRYPT_SALARY(inputData IN VARCHAR2,eKey IN NUMBER) RETURN RAW DETERMINISTIC;
  FUNCTION DECRYPT_SALARY(inputEncryptData IN RAW,eKey IN NUMBER) RETURN NUMBER DETERMINISTIC;
END;


--Tạo nội dung cho package trên bằng 2 function đã khai báo
CREATE OR REPLACE PACKAGE BODY pEncrypt IS 
  encrypt_Type PLS_INTEGER :=DBMS_CRYPTO.ENCRYPT_DES
							+DBMS_CRYPTO.CHAIN_CBC
							+DBMS_CRYPTO.PAD_PKCS5;
  FUNCTION ENCRYPT_SALARY(inputData IN VARCHAR2,eKey IN NUMBER) RETURN RAW DETERMINISTIC
  IS
  	raw_encrypted raw(2000);
    
  BEGIN
       raw_encrypted := dbms_crypto.encrypt(
          src => inputData,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(eKey)
      );
      return raw_encrypted;
  END ENCRYPT_SALARY;
  
  FUNCTION DECRYPT_SALARY(inputEncryptData IN RAW,eKey IN NUMBER) RETURN NUMBER DETERMINISTIC
  IS
    raw_decrypted raw(2000);
  BEGIN
       raw_decrypted := dbms_crypto.decrypt(
          src => inputEncryptData,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(eKey)
      );
      return utl_raw.cast_to_VARCHAR2(raw_decrypted);
  END DECRYPT_SALARY;

END pEncrypt;


--Test decrypt
select pEncrypt.DECRYPT_SALARY(pEncrypt.ENCRYPT_SALARY(50000, 50),50) from dual;
--Test Encrypt
select pEncrypt.ENCRYPT_SALARY(50000, 50) from dual;


--Update bảng lương với cột lương encrypt
BEGIN
	FOR v_MaNV IN (select MaNV from NhanVien)
	LOOP
    UPDATE NhanVien SET LUONG = pEncrypt.ENCRYPT_SALARY(LUONG, MaNV) WHERE MaNV = v_MaNV.MaNV;
	END LOOP;
END;


--Test kiểm tra và hoàn thành
SELECT  MaNV,HoTen,LUONG,pEncrypt.DECRYPT_SALARY(NV.LUONG, NV.MANV) LUONGDC FROM NhanVien NV;