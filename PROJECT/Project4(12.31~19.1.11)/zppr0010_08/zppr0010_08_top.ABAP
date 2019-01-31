*&---------------------------------------------------------------------*
*& Include ZPPR0010_08_TOP                                   Report ZPPR0010_08
*&
*&---------------------------------------------------------------------*
************************************************************************
* Title: BOM ���� ���α׷�
************************************************************************
* DATE          AUTHOR                  DESCRIPTION
************************************************************************
* 2018.12.28    TaeHyeong               Create Radio Button in Report
* 2018.12.31    TaeHyeong               ���� ALV ����.
* 2019.01.02    TaeHyeong               Scroll BDC �۾�.
* 2019.01.03    TaeHyeong               Reuse ALV ����.
************************************************************************
REPORT   ZPPR0010_08.
************************************************************************
* �����ȣ�� �÷�Ʈ�� MARA�� MARC�� ���� �����ޱ� ���ؼ� ������.
************************************************************************
TABLES mara.
TABLES marc.
TABLES mast.

************************************************************************
* ���ͳ� ���̺� ����ü ����
************************************************************************
DATA : BEGIN OF gs_tab.
DATA : matnr type marc-matnr,
       werks TYPE marc-werks,
       stlan type marc-stlan,
       stlnr TYPE mast-stlnr,
END OF gs_tab.

************************************************************************
* 1. WorkArea �� Internal Table ����.
************************************************************************
DATA : it_tab LIKE TABLE OF gs_tab,
      wa_tab LIKE LINE OF it_tab.

DATA : it_re_tab LIKE TABLE OF gs_tab,
       wa_re_tab LIKE LINE OF it_re_tab.
****************************************************************
* MAST ���̺� MATNR, WERKS, STLAN, STLNR�� ��ȸ�ϱ� ���� ����.
************************************************
DATA : it_mast TYPE TABLE OF mast,
      wa_mast LIKE LINE OF it_mast.
************************************************************************
* BOM ---> WorkArea �� Internal Table ����.
************************************************************************
DATA : it_bom Like TABLE of gs_tab,
      wa_bom LIKE LINE OF it_bom.
************************************************************************
* NOT ---> WorkArea �� Internal Table ����.
************************************************************************
DATA : it_not like TABLE OF gs_tab,
      wa_not LIKE LINE OF it_not.

************************************************************************
* CBO Ref ���̺�
************************************************************************
DATA : it_ref TYPE TABLE OF ZBOMREFTH,
      WA_ref LIKE LINE OF it_ref.
************************************************************************
* ALV �⺻ ���ø�.
************************************************************************
DATA : container TYPE REF TO cl_gui_custom_container,            "�����̳� ����. ---> cl_gui_custom_container Ŭ���� ����.
       grid TYPE REF TO cl_gui_alv_grid,                         "�׸��� ����.  ---> cl_gui_alv_grid Ŭ���� ����.
       ok_code TYPE sy-ucomm.                                     "Ŭ�� ���� ����.
DATA: ls_layo TYPE lvc_s_layo,
     lt_fcat TYPE lvc_t_fcat.
************************************************************************
*  ��Ƽ�� ����Ʈ �ο� ��.
************************************************************************
DATA: INDEX_ROWS TYPE LVC_T_ROW,
      index_id TYPE  LVC_T_ROID ,
INDEX LIKE LINE OF INDEX_ROWS.
************************************************************************
*  BDC ��� �Է¸�� ����
************************************************************************
DATA : P_MODE TYPE C.
************************************************************************
*  Reuse ALV �� ���Ǵ� ��ϵ�
*  1. LAYOUT ����.
*  2. Field Catalog ����.(����ü)
*  3. Field Catalog ����.(���ͳ� ���̺�)
************************************************************************
  DATA : wa_layout TYPE slis_layout_alv .
  DATA : wa_fcat TYPE slis_fieldcat_alv .
  DATA : I_FCAT TYPE SLIS_T_FIELDCAT_ALV .
************************************************************************
*  Reuse ALV �� ���Ǵ� ����ü / ���ͳ� ���̺� / WA
************************************************************************
  DATA : BEGIN OF rs_tab.
   INCLUDE STRUCTURE gs_tab.
   DATA : c_light TYPE icon-id,
         c_text TYPE string.
  DATA END OF rs_tab.

  DATA : it_reu_tab LIKE TABLE OF rs_tab,
        wa_reu_tab LIKE LINE OF it_reu_tab.

************************************************************************
*  Reuse ALV �� ���Ǵ� ��ȣ�� / �� // ��  // ��.
************************************************************************
CONSTANTS: c_green TYPE icon-id VALUE '@08@',
c_yellow TYPE icon-id VALUE '@09@',
c_red TYPE icon-id VALUE '@0A@'.
************************************************************************
*  ���� ��� ������ CBO���̺� ���ͳ� // WA ����. // TABLE����.
************************************************************************
DATA : it_end TYPE TABLE OF ZPPT0010_08,
      wa_end LIKE LINE OF it_end.
TABLES ZPPT0010_08.

************************************************************************
*  ���� �޽��� ����� ���� �߰� ����.  (����, ���� �ؽ�Ʈ, cnt)
************************************************************************
DATA : err_mat TYPE mara-matnr,
      err_text TYPE string,
      err_cnt TYPE i.
CLASS alv_event_handler DEFINITION.
*  PUBLIC SECTION.
*   METHODS:
*      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
*        IMPORTING e_object e_interactive.
ENDCLASS.             "lcl_event_receiver DEFINITION
CLASS alv_event_handler IMPLEMENTATION.

*  METHOD handle_toolbar.                                                              "Application Toolbar Button add.
*
*    DATA : ls_toolbar TYPE stb_button.
*
*    CLEAR ls_toolbar.
*    MOVE 0 TO ls_toolbar-butn_type.                                     "Toolbar button type
*    MOVE 'EXCELTH' TO ls_toolbar-function.                              "Function code
*    MOVE icon_xxl TO ls_toolbar-icon.                                   "icon*
*    MOVE 'Download Excel Format to LOCAL Disk' TO ls_toolbar-quickinfo. "Quickinfo for an icon*
*    MOVE ' ' TO ls_toolbar-disabled.                                     "Disabled
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*ENDMETHOD.
ENDCLASS.


*----------------------------------------------------------------------*
*   data definition
*----------------------------------------------------------------------*
*       Batchinputdata of single transaction
DATA:   BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
*       error session opened (' ' or 'X')
DATA:   E_GROUP_OPENED.
*       message texts
TABLES: T100.
************************************************************************
* �����ȣ, �÷�Ʈ ���� ��ũ�� �ۼ�.
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK block1.
 SELECT-OPTIONS : matnr FOR mara-matnr.
 PARAMETERS : s_werks TYPE mast-werks DEFAULT 1200.
SELECTION-SCREEN END OF BLOCK block1.

*************************************************************************
* ALL, BOM CHECK, NOT CHECK  ���� ��ư ���.
*************************************************************************
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS : radio1 RADIOBUTTON GROUP TH.
SELECTION-SCREEN COMMENT 3(10) text-001 FOR FIELD radio1.
PARAMETERS : radio2 RADIOBUTTON GROUP TH.
SELECTION-SCREEN COMMENT 16(10) text-002 FOR FIELD radio2.
PARAMETERS : radio3 RADIOBUTTON GROUP TH.
SELECTION-SCREEN COMMENT 29(10) text-003 FOR FIELD radio3.
SELECTION-SCREEN END OF LINE.

----------------------------------------------------------------------------------
Extracted by Direct Download Enterprise version 1.3.1 - E.G.Mellodew. 1998-2005 UK. Sap Release 701