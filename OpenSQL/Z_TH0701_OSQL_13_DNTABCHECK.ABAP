*&---------------------------------------------------------------------*
*& Report  Z_TH0701_DNTABCHECK
*&
*&---------------------------------------------------------------------*
*& Written By TaeHyeongKim
*& Reporting Date: '18.11.28 
*& Subject: Table exist check.
*&---------------------------------------------------------------------*

REPORT  z_th0701_dntabcheck.

WRITE : 2(6)'���̺�'.
SELECT-OPTIONS: result FOR string .

DATA : tdd02l LIKE dd02l.                            " SAP TABLE ������ ����.

SELECT * FROM  dd02l                                " SAP TABLE���� ��ȸ.
       INTO tdd02l
       WHERE  tabname  = result.                    " ��ȸ�� ���.
*             AND    as4local = 'A'                     " ���ÿ� ��Ƽ��Ǿ��°�? (A : Active, L: Locking. ��)
*         AND   ( tabclass      <> 'INTTAB'         " ���̺� Ÿ��. (INTTAB : ����ü, CLUSTER: Ŭ������ ���̺� ��)
ENDSELECT.
IF sy-subrc = 0.
  WRITE : / 'ABAP Dictionary�� ���̺��� �ֽ��ϴ�.'.
ELSE.
  WRITE : / 'ABAP Dictionary�� ���̺��� �����ϴ�.'.
ENDIF.