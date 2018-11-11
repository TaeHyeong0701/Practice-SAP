*&---------------------------------------------------------------------*
*& Report  Z_TH0701_INTERNALTABLE_2
*&
*&---------------------------------------------------------------------*
*&
*&           APPEND ���ɹ��� INSERT ���ɹ��� ������.
*&
*&---------------------------------------------------------------------*
REPORT  Z_TH0701_IN_TABLE_2_DECLARTION.

DATA : it_sfl1 TYPE TABLE OF sflcrew WITH HEADER LINE,
      it_sfl2 TYPE TABLE OF sflcrew,
      wo_sfl2 LIKE LINE OF it_Sfl2.

SELECT * FROM sflcrew INTO TABLE it_sfl1
 WHERE carrid = 'AA'
       AND fldate = '20090810'.

SELECT * FROM sflcrew INTO TABLE it_sfl2
 WHERE carrid = 'AA'
       AND fldate = '20090810'.
************************************************************************
it_sfl1-carrid = 'TH'.
it_sfl1-connid = 93.
INSERT it_sfl1 index 3.                                                  "INSERT�� INDEX�� Ȱ���Ͽ�, ������ ��ġ�� ������ ���� ����
************************************************************************ INSERT WITH HEADER LINE.
wo_sfl2-carrid = 'TH'.
wo_sfl2-connid = 93.
APPEND wo_sfl2 to it_sfl2.                                               "UPDATE�� ������ ������ ���� ��ġ�� ������ ���� ����
************************************************************************ APPEND WITH WORKAREA.
WRITE : / 'INSERT ���.'.
LOOP AT it_sfl1.
WRITE : / it_sfl1-carrid,
         it_sfl1-connid.
ENDLOOP.
*********************************************************************** HEADERLINE INSERT PRINT
WRITE : / 'APPEND ���.'.
LOOP AT it_sfl2 into wo_sfl2.
WRITE : / wo_sfl2-carrid,
         wo_sfl2-connid.
ENDLOOP.
********************************************************************** WORKAREA APPEND PRINT