*&---------------------------------------------------------------------*
*& Report  Z_TH0701_11_08_ALV_1
*&
*&---------------------------------------------------------------------*
*& �ۼ���: TaeHyeong Kim
*& �ۼ��Ͻ�: `2018.11.12
*&---------------------------------------------------------------------*
* SALV. SIMPLE TEST
*
*----------------------------------------------------------------------
REPORT  Z_TH0701_ALV_1_SALV.

DATA: alv TYPE REF TO cl_salv_table,                                     "cl_salv_table Ŭ������ �����Ѵ�.
      it_tab type TABLE OF zthsoccer.

SELECT * FROM zthsoccer into TABLE it_tab.                               "���ͳ� ���̺��� ���� �־��ش�.


 cl_salv_table=>factory(
  importing r_salv_table = alv                                           " ������ ������ alv�� r_salv_table�� �־��ش�.
    changing t_table = it_tab                                            " ���ͳ� ���̺��� �������ش�.
  ).
 alv->display( ).                                                        " ȭ���� �ѷ��ش�.