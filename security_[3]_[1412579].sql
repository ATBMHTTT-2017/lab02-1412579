CREATE OR REPLACE PACKAGE pEncrypt_3 IS
  FUNCTION ENCRYPT_TARGET(inputData IN VARCHAR2,publicKeyE IN NUMBER,publicKeyN IN NUMBER) RETURN VARCHAR2 DETERMINISTIC;
  FUNCTION DECRYPT_TARGET(inputEncryptData IN VARCHAR2, publicKeyN IN NUMBER, privateKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC;
END;


--Tạo nội dung cho package trên bằng 2 function đã khai báo
--Test decrypt trong phần video
CREATE OR REPLACE PACKAGE BODY pEncrypt_3 IS 
  encrypt_Type PLS_INTEGER :=DBMS_CRYPTO.ENCRYPT_DES
							+DBMS_CRYPTO.CHAIN_CBC
							+DBMS_CRYPTO.PAD_PKCS5;
  FUNCTION ENCRYPT_TARGET(inputData IN VARCHAR2,publicKeyE IN NUMBER,publicKeyN IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
  	raw_encrypted raw(2048);
    raw_decrypted raw(2048);
    raw_key raw(2048);
    keyEn number(38);
    keyEncrypted number(38);
  BEGIN
       keyEn:=ceil(dbms_random.value(1,10));
       raw_encrypted := dbms_crypto.encrypt(
          src => inputData,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(keyEn)
      );
      keyEncrypted := POWER(keyEn,publicKeyE);
      keyEncrypted := MOD(keyEncrypted,publicKeyN);

      raw_decrypted := dbms_crypto.decrypt(
          src => raw_encrypted,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(keyEn)
      );
    
      return 'Key encrypted: ' || keyEncrypted || ', Thong tin ma hoa: ' ||raw_encrypted || ', Sau khi giai ma: ' || raw_decrypted;
  END ENCRYPT_TARGET;
  
  FUNCTION DECRYPT_TARGET(inputEncryptData IN VARCHAR2, publicKeyN IN NUMBER, privateKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
    raw_decrypted raw(2048);
    rawInput raw(2048);
    strTemp varchar2(20);
    keyEncryped number(20);
    keyEn number(38);
  BEGIN
       keyEncryped := utl_raw.cast_to_number(substr(inputEncryptData,1,instr(inputEncryptData,'end')-1));
       strTemp := substr(inputEncryptData,instr(inputEncryptData,'end')+3,length(inputEncryptData));       
       keyEn := MOD(POWER(keyEncryped,privateKey), publicKeyN);
    
     raw_decrypted := dbms_crypto.decrypt(
          src => utl_raw.cast_to_raw(strTemp),
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(keyEn)
      );
       
      return keyEn || ' cacc ' || utl_raw.cast_to_raw(strTemp);
      --return utl_raw.cast_to_VARCHAR2(raw_decrypted);
  END DECRYPT_TARGET;

END pEncrypt_3;




--Test và demo phần nén
CREATE OR REPLACE PACKAGE BODY pEncrypt_3 IS 
  encrypt_Type PLS_INTEGER :=DBMS_CRYPTO.ENCRYPT_DES
							+DBMS_CRYPTO.CHAIN_CBC
							+DBMS_CRYPTO.PAD_PKCS5;
  FUNCTION ENCRYPT_TARGET(inputData IN VARCHAR2,publicKeyE IN NUMBER,publicKeyN IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
  	raw_encrypted raw(2048);
    raw_key raw(2048);
    keyEn number(38);
    keyEncrypted number(38);
  BEGIN
       keyEn:=ceil(dbms_random.value(1,10));
       raw_encrypted := dbms_crypto.encrypt(
          src => inputData,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(keyEn)
      );
      keyEncrypted := POWER(keyEn,publicKeyE);
      keyEncrypted := MOD(keyEncrypted,publicKeyN);
    
      return keyEncrypted || 'end' || utl_raw.cast_to_varchar2(raw_encrypted);
  END ENCRYPT_TARGET;
  
  FUNCTION DECRYPT_TARGET(inputEncryptData IN VARCHAR2, publicKeyN IN NUMBER, privateKey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
    raw_decrypted raw(2048);
    rawInput raw(2048);
    strTemp varchar2(20);
    keyEncryped number(20);
    keyEn number(38);
  BEGIN
       keyEncryped := utl_raw.cast_to_number(substr(inputEncryptData,1,instr(inputEncryptData,'end')-1));
       strTemp := substr(inputEncryptData,instr(inputEncryptData,'end')+3,length(inputEncryptData));       
       keyEn := MOD(POWER(keyEncryped,privateKey), publicKeyN);

       
      return keyEn || ' cacc ' || utl_raw.cast_to_raw(strTemp);
      --return utl_raw.cast_to_VARCHAR2(raw_decrypted);
  END DECRYPT_TARGET;

END pEncrypt_3;







--Các câu lệnh test khi làm
select pEncrypt_3.ENCRYPT_TARGET(50050000, 13, 63) from dual;

select MOD(POWER(9,13),63) from dual;

select POWER(50,37) from dual;

select pEncrypt_3.DECRYPT_TARGET(pEncrypt_3.ENCRYPT_TARGET(50000, 13, 63),63,37) as giainen from dual;


select MOD(POWER(9,13),63) from dual;

select MOD(POWER(9,37),63) from dual;

select utl_raw.cast_to_varchar2('636F6E636163') from dual

select * from chitieu;
update chitieu set sotien = null
update chitieu set sotien = 350000000 where machitieu = 1;
update chitieu set sotien = 150000000 where machitieu = 2;
update chitieu set sotien = 600000000 where machitieu = 3;
update chitieu set sotien = 950000000 where machitieu = 4;
update chitieu set sotien = 550000000 where machitieu = 5;
alter table chitieu modify sotien varchar2(20)

BEGIN
	FOR v_MaCT IN (select MACHITIEU from CHITIEU)
	LOOP
    UPDATE CHITIEU SET SOTIEN = pEncrypt_3.ENCRYPT_TARGET(SOTIEN, 13, 63) WHERE MACHITIEU = v_MaCT.MACHITIEU;
	END LOOP;
END;

select substr('5000endconcac',1,instr('5000endconcac','end')-1) from dual;

select substr('5000endconcac',instr('5000endconcac','end')+3,length('5000endconcac')) from dual;

select power(27,63) from dual;

select * from chitieu;

SELECT  Machitieu,pEncrypt_3.DECRYPT_TARGET(CT.SOTIEN, 37,63) SOTIENDC FROM CHITIEU CT;

