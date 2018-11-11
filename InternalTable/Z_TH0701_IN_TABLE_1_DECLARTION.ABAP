*&---------------------------------------------------------------------*
*& Report  Z_TH0701_IN_TABLE_1_DECLARTION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
* ������ ���� �����ϴ� ���ͳ� ���̺� ��� ---> Method1.
* �ڵ带 ���� �� �ִ� ���(�������) ---> Method2.

REPORT  Z_TH0701_IN_TABLE_1_DECLARTION.

TYPES : BEGIN OF header_str,
  CAR TYPE SFLCREW-CARRID,
  CON TYPE SFLCREW-CONNID,
  FLD TYPE SFLCREW-FLDATE,
  END OF header_str.
* ����ü ���� ---> Method2���� �̿��غ�����.

* TYPE TABLE OF = TYPE STANDARD TABLE OF
* [Method1]���� : �ڵ尡 �и��ؼ� ���� �������� ����.
DATA : it1_sflcrew TYPE TABLE OF sflcrew, "Internal Table �����, ABAP
      wo1_sflcrew LIKE LINE OF it1_sflcrew. "WorkArea

*---------------------------------------------------------------------------------------------------------------------
* [Method2]���� : ���� �ڵ����� ���� �� �ִ� ���������, �������� ������. SAP������ ��������� ������� ���� ���� �ǰ�.
DATA : it2_sflcrew TYPE TABLE OF header_str WITH HEADER LINE. "���ͳ� ���̺� ����� �Բ� ������ �̸����� ������� ������.

*---------------------------------------------------------------------------------------------------------------------
* �װ��簡 AA�̸鼭 �������� 2009�� 7�� 9�ϱ��� ��ȸ.
* [Method1] insert
SELECT client carrid connid fldate "���̺��� Ÿ���� ���߱�����, ABAP Dictionary ���̺��� ��Ī�� ��������.
  FROM SFLCREW
  INTO TABLE it1_sflcrew
  WHERE CARRID = 'AA' and
  fldate = '20090709'.
*---------------------------------------------------------------------------------------------------------------------
* [Method2] insert
SELECT carrid connid fldate
  FROM SFLCREW
  INTO TABLE it2_sflcrew
  WHERE CARRID = 'AA' and
  fldate = '20090709'.

*---------------------------------------------------------------------------------------------------------------------
* [Method1] print
WRITE :  'ù ��° ����Դϴ�.', /.
LOOP AT it1_sflcrew INTO wo1_sflcrew.
WRITE : wo1_sflcrew-Carrid, wo1_sflcrew-connid, wo1_sflcrew-FLDate, /.
ENDLOOP.

*---------------------------------------------------------------------------------------------------------------------

* [Method2] print
WRITE :  '�� ��° ����Դϴ�.', /.
LOOP AT it2_sflcrew.
WRITE : it2_sflcrew-Car, it2_sflcrew-con, it2_sflcrew-FLD, /.
ENDLOOP.
*---------------------------------------------------------------------------------------------------------------------