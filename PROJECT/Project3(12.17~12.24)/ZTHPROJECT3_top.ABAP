*&---------------------------------------------------------------------*
*& Include ZPPR0003_08_TOP                                   Report ZPPR0003_08
*&
*&---------------------------------------------------------------------*
************************************************************************
REPORT   zppr0003_08.
************************************************************************
*  TABLES & TYPE-POOLS
*  1. SSCRFIELDS  ---> ��ũ���� �����ϴ� �Ӽ��� �ִ� ���̺�.
*  2. WWWDATATAB  ---> DB�� �ƴ� �ٸ� ����(�����̶����)�� ��Ƴ� �� �ִ� ���̺� ������ wwwdatatab
*  3. icon        ---> ICON���̺��� �ִ� �����ܵ��� Ȱ���ϱ� ���ؼ�.
************************************************************************
TABLES sscrfields.
TABLES: wwwdatatab.
TYPE-POOLS : icon.
************************************************************************
*  DATA TYPE(��)
*  1. SMWO���� ���ø��� �ٿ�ε��ϴµ� ����� ���ͳ� ���̺� �� WorkArea
*  2. Report Program Toolbar button���� ����ϰԵ� ��ư ������
*  3. ������ ����
*  4. �������� �����͸� �������� ����, �ε�����(���� ������ Į������ �� �� ����), ��ü ũ����� �����ϴ� ����.
*  5. ��ü ���� ��ȹ�� �ݿ��� ����� sum
*  6. ���� ������ ���� ����ü
************************************************************************
DATA : it_wwwdatatab TYPE TABLE OF wwwdatatab,
       wa_wwwdatatab LIKE LINE OF it_wwwdatatab.

DATA: ls_sel_button TYPE smp_dyntxt,
      ls_sel_button2 TYPE smp_dyntxt.

DATA : endda TYPE sy-datum.


DATA : gv_index     TYPE sy-tabix,
       gv_start_col TYPE i VALUE '1',
       gv_start_row TYPE i VALUE '1',
       gv_end_col   TYPE i VALUE '256',
       gv_end_row   TYPE i VALUE '65526'.

DATA : sum TYPE i.

DATA : BEGIN OF gs_tab.
DATA : matnr(100) TYPE c,
       werks(100) TYPE c,
       day1(100) TYPE c,
       day2(100) TYPE c,
       day3(100) TYPE c,
       day4(100) TYPE c,
       day5(100) TYPE c,
       day6(100) TYPE c,
       day7(100) TYPE c,
       light TYPE icon-id,
       text TYPE string,
END OF gs_tab.

***************************************************************
*  DATA TYPE(��)
*  1. �������� ������ ���ͳ� ���̺�&Workarea
*  2. �������� �����͸� ������ �� ������ �� �ʵ�ɺ� ����.
*  3. ALV�� �ѷ��� ���ͳ� ���̺�&Workarea
***************************************************************
DATA : it_tab LIKE TABLE OF gs_tab,
      wa_tab LIKE LINE OF it_tab.

DATA : gt_data TYPE kcde_cells OCCURS 0 WITH HEADER LINE.  "������ΰ� ���� ���ͳ����̺� ����.
FIELD-SYMBOLS : <gv_fs> TYPE ANY.                          "Structure


***************************************************************
*  DATA TYPE(��)
*  1. ALV �� �ѷ��� ������ ����.
*  2. ��ȣ� �ѷ��� ������� ����.
*  3. ��� ALV�� �ѷ��� ������ ����ü �� ���ͳ����̺� ����.
***************************************************************

DATA : alv_it_tab LIKE TABLE OF gs_tab,
      alv_wa_tab LIKE LINE OF alv_it_tab.

CONSTANTS: c_green TYPE icon-id VALUE '@08@',
c_yellow TYPE icon-id VALUE '@09@',
c_red TYPE icon-id VALUE '@0A@'.


DATA : re_it_tab LIKE TABLE OF gs_tab,         " ��� ALV ���ͳ� ���̺�
      re_wa_tab LIKE LINE OF re_it_tab.        " ��� ALV ��� wa.

SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.

*----------------------------------------------------------------------*
*   data definition
*----------------------------------------------------------------------*
*       Batchinputdata of single transaction
DATA:   bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
*       error session opened (' ' or 'X')
DATA:   e_group_opened.
*       message texts
TABLES: t100.


********************************************************
* ALV ������ ����.
********************************************************
DATA: ls_layo TYPE lvc_s_layo,
     lt_fcat TYPE lvc_t_fcat.
DATA : container TYPE REF TO cl_gui_custom_container,
      grid  TYPE REF TO cl_gui_alv_grid,
      ok_code TYPE sy-ucomm.

********************************************************
* ��� ALV ������ ����.
********************************************************
DATA: ls_layo2 TYPE lvc_s_layo,
     lt_fcat2 TYPE lvc_t_fcat.
DATA : container2 TYPE REF TO cl_gui_custom_container,
      grid2  TYPE REF TO cl_gui_alv_grid.
*      ok_code TYPE sy-ucomm.


DATA err_text TYPE string.
*&--------------------------------------------------------------------&*
*&  STEP 2
*&--------------------------------------------------------------------&*
*& 1. ������ ������ ICON�� ���� �Ӽ����� �������ش�.
*&--------------------------------------------------------------------&*
INITIALIZATION.
************************************************************************
* 1. Application Toolbar ��ư ����.
* 2. �Ķ���� �� ���� ����.
************************************************************************
  ls_sel_button-icon_id = icon_xls.
  ls_sel_button-quickinfo = 'TEMPLATE DOWNLOAD'.
  ls_sel_button-icon_text = 'SMW0���κ��� ������ ��������'.
  sscrfields-functxt_01 = ls_sel_button.

  ls_sel_button2-icon_id = icon_check.
  ls_sel_button2-quickinfo = 'Data Check'.
  ls_sel_button2-icon_text = 'BDC ������ ���� üũ'.
  sscrfields-functxt_02 = ls_sel_button2.

  SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE text-001.
  PARAMETERS filepath TYPE char128.
  SELECTION-SCREEN END OF BLOCK block1.
  SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE text-002.
  PARAMETERS begda TYPE sy-datum.                                                        " ������ �Ķ����.
  PARAMETERS: p_mode TYPE c DEFAULT 'N'.                                                 " ��׶��� �۾�.
  SELECTION-SCREEN END OF BLOCK block2.

----------------------------------------------------------------------------------
Extracted by Direct Download Enterprise version 1.3.1 - E.G.Mellodew. 1998-2005 UK. Sap Release 701