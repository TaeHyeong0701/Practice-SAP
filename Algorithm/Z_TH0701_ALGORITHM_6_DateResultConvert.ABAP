*&---------------------------------------------------------------------*
*& Report  Z_TH0701_Algorithm_6_DateResultConvert
*&
*&---------------------------------------------------------------------*
*& Written By TaeHyeong
*& Reporting Date: '18.12.19
*& Subject: 2018-12-19 텍스트를 2018.12.19로 변경한다
*&---------------------------------------------------------------------*

REPORT  Z_TH0701_BUTTON.
*&--------------------------------------------------------------------&*
*&  STEP 1
*&--------------------------------------------------------------------&*
*& 1. 데이터 변수 선언 및 출력하여 확인.
*&--------------------------------------------------------------------&*
DATA text(20) TYPE c.
DATA convert(20) TYPE c.
text = '2018-11-01'.
WRITE : / text.

*&--------------------------------------------------------------------&*
*&  STEP 2
*&--------------------------------------------------------------------&*
*& 1. CONCATENATE함수와  +() 를 이용하여 char형 변수를 채워넣는다.
*&--------------------------------------------------------------------&*
convert+0(4) = text+0(4).
CONCATENATE convert '.' INTO convert.
CONCATENATE convert text+5(2) INTO convert.
CONCATENATE convert '.' INTO convert.
CONCATENATE convert text+8(2) INTO convert.
write : / convert.