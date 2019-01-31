*&---------------------------------------------------------------------*
*&  Include           ZPPR0011_08_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data .
*  clear it_tab.
*  clear wa_tab.
************************************************************************
* BOM ���� CBO ���̺����� MATNR�� WERKS�� �����´�.
************************************************************************
*  DATA : it_tab1 LIKE TABLE OF gs_tab.
  SELECT matnr werks
    FROM zppt0010_08 INTO CORRESPONDING FIELDS OF TABLE it_tab
    WHERE matnr IN s_matnr
    AND werks = s_werks.
************************************************************************
* �� ������ MATNR�� WERKS�� �̿��Ͽ�  MAPL���� PLNY = 'N' ���� ��ȸ ���������Ͽ� �����͸� ����Ʈ�Ѵ�.
************************************************************************
  DATA : it_mapl TYPE TABLE OF mapl,
         wa_mapl LIKE LINE OF it_mapl.
* ���ͳ� ���̺��� ������ ���. plnty = 'N' �������� ���.
  SELECT matnr werks plnty plnnr plnal INTO CORRESPONDING FIELDS OF TABLE it_mapl
    FROM mapl
    FOR ALL ENTRIES IN it_tab
    WHERE matnr = it_tab-matnr
    AND werks = it_tab-werks
    AND plnty = 'N'.

* ������ ���ǿ� ���� Read Table �� ������ ���.
  LOOP AT it_tab INTO wa_tab.
* MATNR ����.
    READ TABLE it_mapl INTO wa_mapl WITH KEY  matnr = wa_tab-matnr.
* WERKS ����.
    IF sy-subrc = 0.
************************************************************************
* PLNTY, PLNNR, PLNAL ���.
************************************************************************
      wa_tab-plnty = wa_mapl-plnty.
      wa_tab-plnnr = wa_mapl-plnnr.
      wa_tab-plnal = wa_mapl-plnal.
*        ��ȣ�� �ʷϻ����� �ʱ�ȭ�����ش�.
    ENDIF.
    MODIFY it_tab FROM wa_tab.
    CLEAR wa_tab.
  ENDLOOP.

  LOOP AT it_tab INTO wa_tab.
    IF wa_tab-plnty IS INITIAL.
      wa_tab-c_light = c_red.
    ELSE.
      wa_tab-c_light = c_green.
    ENDIF.
    MODIFY it_tab FROM wa_tab.
  ENDLOOP.
ENDFORM.                    " SELECT_DATA

*----------------------------------------------------------------------*
*  MODULE init_screen OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE init_screen OUTPUT.
*  DATA : alv_event_handler TYPE REF TO alv_event_handler.
  IF container IS INITIAL.
************************************************************************
*  1. Container ��ü ����
************************************************************************
    CREATE OBJECT container
      EXPORTING
        container_name = 'THCONT1'.
************************************************************************
*  2. Grid ��ü ����
************************************************************************
    CREATE OBJECT grid
      EXPORTING
        i_appl_events = 'X' "
        i_parent      = container.
************************************************************************
*  3. ���̾ƿ� ���� �� �ʵ� īŻ�α� ����.
************************************************************************
    PERFORM set_grid_layo_100 CHANGING ls_layo.
    PERFORM set_grid_fcat_100 CHANGING lt_fcat.
************************************************************************
*  4. ALV�� ls_layo(Ŀ���� ����), it_tab(Ŀ���� ���̺� ������), lt_fcat(�ʵ�īŻ�α� ���)�� �̿��Ͽ� ȣ���Ѵ�.
************************************************************************
    CALL METHOD grid->set_table_for_first_display
      EXPORTING
        is_layout       = ls_layo
      CHANGING
        it_outtab       = it_tab
        it_fieldcatalog = lt_fcat.
  ENDIF.
ENDMODULE.                 " INIT_SCREEN  OUTPUT

*&---------------------------------------------------------------------*
*&      Form  set_grid_layo_100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->CS_LAYO    text
*----------------------------------------------------------------------*
FORM set_grid_layo_100  CHANGING cs_layo TYPE lvc_s_layo.
*... ALV-Control: Allgemeine Anzeigeoptionen
  cs_layo-stylefname  = 'X'.
  cs_layo-cwidth_opt  = 'X'.                                                " ���̼� ����ȭ�� ���߱�.
  cs_layo-zebra       = 'X'.                                                "�ٺ� ����ǥ��. ���ӵ� ������ �򰥸� ����.
  cs_layo-smalltitle  = space.
  cs_layo-graphics    = space.
  cs_layo-frontend    = space.
  cs_layo-template    = space.

*... ALV-Control: Gridcustomizing
  cs_layo-no_colexpd  = space.
  cs_layo-no_hgridln  = space.
  cs_layo-no_vgridln  = space.
  cs_layo-no_rowmark  = space.
  cs_layo-no_headers  = space.
  cs_layo-no_merging  = space.
  cs_layo-grid_title  = space.

  cs_layo-no_toolbar  = space.                                "2. Grid Application Toolbar Control. --> Ȯ�����ش�.
************************************************************************
*  A�� �����Ͽ�, ��Ƽ�ü����� ���̾ƿ��� �����Ѵ�.
*  A : multiple row & column selection
*  C : multiple selection listbox
************************************************************************
  cs_layo-sel_mode    = 'A'.

  cs_layo-box_fname   = space.

  cs_layo-sgl_clk_hd  = space.

*... ALV-Control: Summenoptionen
  cs_layo-totals_bef  = space.
  cs_layo-no_totline  = space.
  cs_layo-numc_total  = space.
  cs_layo-no_utsplit  = space.

*... ALV-Control: Exceptions
*  cs_layo-excp_group  = 'LIGHT'.
  cs_layo-excp_fname  = 'C_LIGHT'.
  cs_layo-excp_fname = space.
*  cs_layo-excp_rolln  = space.
*  cs_layo-excp_conds  = gs_test-excp_condense.
*  cs_layo-excp_led    = gs_test-excp_led.

*... ALV-Control: Steuerung Interaktion
  cs_layo-detailinit  = space.
  cs_layo-detailtitl  = space.
  cs_layo-keyhot      = space.
  cs_layo-no_keyfix   = space.
  cs_layo-no_author   = space.
  CLEAR cs_layo-s_dragdrop.

*... ALV-Control: Farben
  cs_layo-info_fname  = space.
  cs_layo-ctab_fname  = space.

*... ALV-Control: Eingabef#higkeit
  cs_layo-edit        = space.
  cs_layo-edit_mode   = space.

  cs_layo-no_rowins   = space.
  cs_layo-no_rowmove  = space.

*... ALV-Control: Web-Optionen
  cs_layo-weblook     = space.
  cs_layo-webstyle    = space.
  cs_layo-webrows     = space.
  cs_layo-webxwidth   = space.
  cs_layo-webxheight  = space.
ENDFORM.                    " SET_GRID_LAYO_100
*&---------------------------------------------------------------------*
*&      Form  set_grid_fcat_100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->CT_FCAT    text
*----------------------------------------------------------------------*
FORM set_grid_fcat_100  CHANGING ct_fcat TYPE lvc_t_fcat.
*    CLEAR l_fcat.
  DATA: ls_fcat TYPE lvc_s_fcat. "�ʵ� īŻ�α� Ÿ��

  ls_fcat-fieldname = 'C_LIGHT'.
  ls_fcat-outputlen = 6.
  ls_fcat-col_pos   = 1.
  ls_fcat-just = 'C'.
  ls_fcat-scrtext_s = 'Routing ����'.
*  ls_fcat-emphasize = 'C119'.
  APPEND ls_fcat TO ct_fcat.

  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = 1.
  ls_fcat-just = 'C'.
  ls_fcat-scrtext_s = 'Material'.
  ls_fcat-emphasize = 'C119'.
  APPEND ls_fcat TO ct_fcat.


  CLEAR ls_fcat.
  ls_fcat-fieldname = 'WERKS'.
  ls_fcat-outputlen = 6.
  ls_fcat-col_pos   = '1'.
  ls_fcat-scrtext_s = '�÷�Ʈ'.
  ls_fcat-just = 'C'.
  ls_fcat-emphasize = 'C119'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PLNTY'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = 1.
  ls_fcat-just = 'C'.
  ls_fcat-scrtext_s = 'Task Type'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PLNNR'.
  ls_fcat-outputlen = 15.
  ls_fcat-col_pos   = 1.
  ls_fcat-scrtext_L = 'Key for Task List Group'.   "Char 20
  ls_fcat-just = 'R'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PLNAL'.
  ls_fcat-outputlen = 16.
  ls_fcat-col_pos   = 1.
  ls_fcat-scrtext_m = 'Group Counter'.
  ls_fcat-just = 'R'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

ENDFORM.                           "SET_GRID_FCAT_100
*&---------------------------------------------------------------------*
*&      Form  SELECT_NOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_not .
  LOOP AT it_tab INTO wa_tab.
    IF wa_tab-plnty IS NOT INITIAL.
      DELETE it_tab INDEX sy-tabix.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SELECT_NOT
*&---------------------------------------------------------------------*
*&      Form  SELECT_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_check .
  LOOP AT it_tab INTO wa_tab.
    IF wa_tab-plnty IS INITIAL.
      DELETE it_tab INDEX sy-tabix.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SELECT_CHECK
*&---------------------------------------------------------------------*
*&      Form  get_selected_rows
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_selected_rows.
************************************************************************
* index_rows�� �ش��ϴ� �ο찪�� ���.
************************************************************************
*  CLEAR index_rows.
  CLEAR index.
  REFRESH index_rows.
*  clear index_id.
  CALL METHOD grid->get_selected_rows
    IMPORTING
      et_index_rows = index_rows
      et_row_no     = index_id.

ENDFORM.                    "GET_SELECTED_ROWS
*&---------------------------------------------------------------------*
*&      Form  CREATE_ROUTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_routing .
  PERFORM get_selected_rows.
  PERFORM select_bapi.
  CALL FUNCTION 'BAPI_ROUTING_CREATE'
*   EXPORTING
*     TESTRUN                      = �� ��
*     PROFILE                      =
*     BOMUSAGE                     =
*     APPLICATION                  =
     IMPORTING
       group                        = gv_group                 "PLNNR: Key for task list group
       groupcounter                 = gv_gr_counter            "PLNAL: Group counter
     TABLES
       task                         = it_task                  "Task list header data in CREATE-BAPI for routings
       materialtaskallocation       = it_mat_task_allo         "Material task list assignment in CREATE-BAPI for routings
*     SEQUENCE                     =
       operation                    = it_op                    "Operations in CREATE-BAPI for routings
*     SUBOPERATION                 =
*     REFERENCEOPERATION           =
*     WORKCENTERREFERENCE          =
*     COMPONENTALLOCATION          =
*     PRODUCTIONRESOURCE           =
*       inspcharacteristic           = it_inspchar              " Inspection Characteristics in CREATE-BAPI for Routings
*     TEXTALLOCATION               =
*     TEXT                         =
       return                       = it_ret .



***********************************************************************
* IF�� ���� ���� �޽��� ���.
***********************************************************************
  IF CH_NUM = 0.              " �༱�� ���ߴ�.
  MESSAGE '���� �����Ͻ��� �ʾҽ��ϴ�.' TYPE 'E'.
  ELSEIF CH_NUM = 1.          " ��� ����� �ִ�.
  MESSAGE '�����Ͻ� �� �߿� �̹� Routing�� �ִ� ���� �ֽ��ϴ�.' TYPE 'W'.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ELSEIF CH_NUM = 2.          " ����� ���� ����ִ�.
  MESSAGE '������� ���� ���翡���� ����� �����Ϸ�' TYPE 'S'.

***********************************************************************
* Transaction Commit�� ���� BAPI���� ������ ������ ����.
***********************************************************************
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  PERFORM select_plnal.
*  ENDIF.
  ENDIF.
  PERFORM refresh_alv.
ENDFORM.                    " CREATE_ROUTING
*&---------------------------------------------------------------------*
*&      Form  SELECT_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_bapi .
  DATA : s_meins TYPE meins.
* Operation Number ����.
  DATA : lv_act(4) TYPE n.
* SELECT DATA.
*  DATA : it_ref LIKE TABLE OF it_tab.
  IF INDEX_ROWS IS INITIAL.
    CH_NUM = 0.
  ELSE.
  ch_num = 1. " ������ �� ��� ������� �ִ� ���.
  ENDIF.
  LOOP AT index_rows INTO index.
    READ TABLE it_tab INTO wa_tab INDEX index-index.
    IF sy-subrc = 0.
*   [it_mat_task_allo] :  ���� ��ũ�� MATNR, WERKS, ��ȿ ��¥ ����
      IF wa_tab-plnty is INITIAL.
        ch_num = 2.
      wa_mat_task_allo-material = wa_tab-matnr.
      wa_mat_task_allo-plant = 1200.
      wa_mat_task_allo-valid_from = sy-datum.
      APPEND wa_mat_task_allo TO it_mat_task_allo.
*      CLEAR wa_mat_task_allo.

*    [it_task] : �� ��° ��ũ�� Lotsize �ִ�ũ�� ����, ��������, ��ȿ ��¥, Plant, List-Usage(1), List_statsus(4)
      wa_task-lot_size_to = 99999999.
      wa_task-task_measure_unit = 'ST'.
      wa_task-valid_from = sy-datum.
      wa_task-plant = '1200'.
      wa_task-task_list_usage = '1  '.
      wa_task-task_list_status = '4  '.
      APPEND wa_task TO it_task.


*     [it_op] : �� ��° ��ũ�� �� 4��° ��ũ�� ���� ���� ��ȿ��¥, Work center(PC-1), Control key(PP01), Description
      wa_op-valid_from = sy-datum.
      wa_op-activity = '0010'.    " Operation ��ȣ
      wa_op-work_cntr = 'PC-1'.   "Work cent ��ȣ
      wa_op-control_key = 'PP01'. "Control Key ��ȣ
*      wa_op-description = 'Test Material'. "���� ���� �ʿ�.
*****************************************************************
* MAKT���� Descrption ����.
*****************************************************************
      SELECT maktx INTO wa_op-description
        FROM makt
        WHERE matnr =  wa_mat_task_allo-material AND
        spras = 'E'. "����� ����
      ENDSELECT.
      wa_op-base_quantity = '1.000'. "Base Qunatity �Է�
      wa_op-denominator  = '1'.
*      wa_OP-NOMINATOR  = '1'.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input    = wa_op-operation_measure_unit
          language = sy-langu
        IMPORTING
          output   = wa_op-operation_measure_unit.

      wa_op-free_grid ='X'.
      wa_op-std_value_01 = '60'.   " ù ��° �ð�
      wa_OP-OPERATION_MEASURE_UNIT = 'MIN'.
      wa_op-std_value_03 = '60'.   " �� ��° �ð�.

      APPEND wa_op TO it_op.
      endif.

    ENDIF.

    if ch_num = 2.
      PERFORM save_bapi. " cbo���̺��� ���� ����.
    endif.
  ENDLOOP.


ENDFORM.                    " SELECT_BAPI
*&---------------------------------------------------------------------*
*&      Form  REFRESH_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM refresh_alv .
  PERFORM select_data.
  DATA ls_stable TYPE lvc_s_stbl.
************************************************************************
* REFRESH �Լ� ȣ��
************************************************************************
  CALL METHOD grid->refresh_table_display
    EXPORTING
      is_stable = ls_stable
    EXCEPTIONS
      finished  = 1
      OTHERS    = 1.
ENDFORM.                    " REFRESH_ALV
*&---------------------------------------------------------------------*
*&      Form  SAVE_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_bapi .

  wa_result-matnr = wa_mat_task_allo-material.
  wa_result-werks = wa_mat_task_allo-plant.
  wa_result-plnty = 'N'.

*  SELECT plnal INTO wa_result-plnal
*    FROM mapl
*    WHERE matnr = wa_result-matnr
*    AND werks = wa_result-werks
*    AND plnty = 'N'.
*  ENDSELECT.

  APPEND wa_result TO it_result.
*  MODIFY zppt0011_08 FROM wa_result.
************************************************************************
* ���̺��� ���� �ִٸ� ����ó�� �߰��ؾ� �ȴ�.
************************************************************************
clear wa_result.

ENDFORM.                    " SAVE_BAPI
*&---------------------------------------------------------------------*
*&      Form  SELECT_PLNAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form SELECT_PLNAL .
  LOOP AT it_result INTO wa_result.
  SELECT plnal INTO wa_result-plnal
    FROM mapl
    WHERE matnr = wa_result-matnr
    AND werks = wa_result-werks
    AND plnty = 'N'.
  ENDSELECT.
  modify ZPPT0011_08 FROM WA_RESULT.
  ENDLOOP.

endform.                    " SELECT_PLNAL

----------------------------------------------------------------------------------
Extracted by Direct Download Enterprise version 1.3.1 - E.G.Mellodew. 1998-2005 UK. Sap Release 701