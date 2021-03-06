*&---------------------------------------------------------------------*
*&  Include           ZPPR0010_08_F01
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
  SELECT a~matnr b~werks INTO CORRESPONDING FIELDS OF TABLE it_tab
    FROM mara AS a INNER JOIN marc AS b
    ON a~matnr = b~matnr
*    up to 60 ROWS
    WHERE a~matnr IN matnr
    AND a~mtart = 'HALB'
    AND b~werks = s_werks.

  SELECT matnr werks stlan stlnr
  FROM mast INTO CORRESPONDING FIELDS OF TABLE it_mast
  FOR ALL ENTRIES IN it_tab
  WHERE matnr = it_tab-matnr
  AND werks = it_tab-werks.
  LOOP AT it_tab INTO wa_tab.
    READ TABLE it_mast INTO wa_mast WITH KEY matnr = wa_tab-matnr. " wa_tab의 name필드값과 동일한 soccer_name 이 있는 레코드를 추출하여                                                                        " 구조체에 넣어준다.
    IF sy-subrc = 0 .  " 값이 있다면.
      wa_tab-stlan = wa_mast-stlan.
      wa_tab-stlnr = wa_mast-stlnr.
    ENDIF.
    MODIFY it_tab FROM wa_tab.                      "it_tab 인터널 테이블을 변경시켜준다.
    CLEAR wa_tab.
  ENDLOOP.
*  loop AT it_tab into wa_tab.
*    IF wa_tab-stlan is INITIAL.
*    ENDLOOP.
ENDFORM.                    " SELECT_DATA
*&---------------------------------------------------------------------*
*&      Form  FECT_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fecth_bom.
  LOOP AT it_tab INTO wa_tab.
    IF wa_tab-stlnr IS NOT INITIAL.
      APPEND wa_tab TO it_bom.
    ENDIF.
  ENDLOOP.

  CLEAR it_tab.

  LOOP AT it_bom INTO wa_bom.
    APPEND wa_bom TO it_tab.
  ENDLOOP.
ENDFORM.                    " FECT_BOM
*&---------------------------------------------------------------------*
*&      Form  FECTH_NOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fecth_not.
  LOOP AT it_tab INTO wa_tab.
    IF wa_tab-stlnr IS INITIAL.
      APPEND wa_tab TO it_bom.
    ENDIF.
  ENDLOOP.

  CLEAR it_tab.

  LOOP AT it_bom INTO wa_bom.
    APPEND wa_bom TO it_tab.
  ENDLOOP.
ENDFORM.                    " FECTH_NOT
*&---------------------------------------------------------------------*
*&      Module  INIT_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_screen OUTPUT.
*  DATA : alv_event_handler TYPE REF TO alv_event_handler.
  IF container IS INITIAL.
************************************************************************
*  1. Container 객체 생성
************************************************************************
    CREATE OBJECT container
      EXPORTING
        container_name = 'THCONT1'.
************************************************************************
*  2. Grid 객체 생성
************************************************************************
    CREATE OBJECT grid
      EXPORTING
        i_appl_events     = 'X' "
        i_parent = container.
************************************************************************
*  3. 레이아웃 설정 및 필드 카탈로그 설정.
************************************************************************
    PERFORM set_grid_layo_100 CHANGING ls_layo.
    PERFORM set_grid_fcat_100 CHANGING lt_fcat.
************************************************************************
*  4. ALV를 ls_layo(커스텀 세팅), it_tab(커스텀 테이블 데이터), lt_fcat(필드카탈로그 목록)을 이용하여 호출한다.
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

  cs_layo-cwidth_opt  = space.
  cs_layo-zebra       = 'X'.                                                "줄별 음영표시. 연속된 데이터 헷갈림 방지.
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

  cs_layo-no_toolbar  = space.                                "2. Grid Application Toolbar Control. --> 확인해준다.
************************************************************************
*  A로 세팅하여, 멀티플셀렉터 레이아웃을 설정한다.
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

*... ALV-Control: Eingabefahigkeit
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
  DATA: ls_fcat TYPE lvc_s_fcat. "필드 카탈로그 타입

  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = 1.
  ls_fcat-scrtext_s = 'Material'.
  ls_fcat-emphasize = 'C119'.
  APPEND ls_fcat TO ct_fcat.


  CLEAR ls_fcat.
  ls_fcat-fieldname = 'WERKS'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = '1'.
  ls_fcat-scrtext_s = '플랜트'.
  ls_fcat-emphasize = 'C119'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'STLAN'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = 1.
  ls_fcat-scrtext_s = 'BOM usg'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'STLNR'.
  ls_fcat-outputlen = 8.
  ls_fcat-col_pos   = 1.
  ls_fcat-scrtext_s = 'BOM'.
  APPEND ls_fcat TO ct_fcat.
  CLEAR ls_fcat.

ENDFORM.                           "SET_GRID_FCAT_100
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTED_ROWS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_selected_rows.
************************************************************************
* index_rows에 해당하는 로우값이 담긴.
************************************************************************
*  CLEAR index_rows.
  CLEAR index.
  REFRESH index_rows.
*  clear index_id.
  CALL METHOD grid->get_selected_rows
    IMPORTING
      et_index_rows = index_rows
ET_ROW_NO = index_id.

ENDFORM.                    "GET_SELECTED_ROWS
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
************************************************************************
*  스크린 자릿수 문제 clear
************************************************************************
  SHIFT bdcdata-fval LEFT DELETING LEADING space.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.                    "BDC_FIELD
*&---------------------------------------------------------------------*
*&      Form  BDC_CS01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc_cs01 .
*  IT_REF 테이블을 이용한다.
  DATA : idx(2) TYPE n.
  DATA : zfnam TYPE string.
  DATA : v_nl(2) type c value cl_abap_char_utilities=>cr_lf.
***********************************************************************
*  Get_Selected_rows 폼을 활용하여, 선택한 로우들을 가져온다.
***********************************************************************
*  CLEAR index_rows.
*  CLEAR WA_index.
*  REFRESH index_rows.
*  clear index.
*  PERFORM get_selected_rows.
  DATA : it_ref1 TYPE TABLE OF zbomrefth.
  DATA : it_tab1 LIKE TABLE OF it_tab.
***********************************************************************
*  Index_rows 인터널 테이블의 INDEX데이터를 활용하여, 선택한 ROW들의 인덱스값을 인터널 테이블에 대입을해준다.
***********************************************************************
  LOOP AT index_rows INTO index.
***********************************************************************
*  BDC 스타트!
***********************************************************************
    REFRESH messtab.  "최초 값으로 되돌림.
    REFRESH bdcdata.
    clear wa_tab.
    READ TABLE it_tab INTO wa_tab INDEX index-index.
    IF sy-subrc = 0.
***********************************************************************
* 데이터가 담긴 인터널 테이블 ---> 결과 ALV에 뿌려줄 인터널테이블 데이터 이동.
***********************************************************************
              MOVE-CORRESPONDING wa_tab TO wa_reu_tab.
***********************************************************************
*  인덱스 값과 호환되는 값이 존재한다면, it_ref1으로 데이터를 옮긴다.
***********************************************************************
      SELECT matnr werks idnrk potx1 postp menge meins
        FROM zbomrefth INTO CORRESPONDING FIELDS OF TABLE it_ref1
        WHERE matnr = wa_tab-matnr.
***********************************************************************
*  CBO ref 테이블에 값이 없으면,
***********************************************************************
      IF wa_reu_tab-stlan is not INITIAL.
          wa_reu_tab-c_text = '이미 BOM 정보가 들어있습니다. BOM 생성을 실행하지 않았습니다'.
          wa_reu_tab-c_light = c_yellow.
      ELSE.
***********************************************************************
*  이미 BOM 정보가 담겨져 있다면. 노랑색, BOM이 있습니다.
***********************************************************************
        IF it_ref1 IS INITIAL.
          wa_reu_tab-c_light = c_red.
          wa_reu_tab-c_text = 'CBO 테이블에 값이 없습니다.'.
*         CONCATENATE err_text v_nl wa_reu_tab-matnr  INTO err_text.

          CLEAR wa_tab-stlan.
          CLEAR wa_tab-stlnr.
        else.
        PERFORM bdc_dynpro      USING 'SAPLCSDI' '0100'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                     'RC29N-MATNR'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                        '/00'.
        PERFORM bdc_field       USING 'RC29N-MATNR'
                                      wa_tab-matnr.
        PERFORM bdc_field       USING 'RC29N-WERKS'
                                      wa_tab-werks.
        PERFORM bdc_field       USING 'RC29N-STLAN'
                                      '1'.

        PERFORM bdc_field       USING 'RC29N-DATUV'
                                      sy-datum.
        PERFORM bdc_dynpro      USING 'SAPLCSDI' '0110'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.
*    PERFORM bdc_field       USING 'RC29K-BMENG'
*                                  record-bmeng_005.
*    PERFORM bdc_field       USING 'RC29K-STLST'
*                                  record-stlst_006.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'RC29K-EXSTL'.
        PERFORM bdc_dynpro      USING 'SAPLCSDI' '0111'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'RC29K-MATNR'.
        PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'RC29P-MENGE(01)'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.
        LOOP AT it_ref1 INTO wa_ref.
***********************************************************************
* meins의 언어 문제를 해결. 예. PC ---> ST(X) // PC ---> ST(O)
***********************************************************************
          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
            EXPORTING
              input    = wa_ref-meins
              language = sy-langu
            IMPORTING
              output   = wa_ref-meins.
          APPEND wa_ref TO it_ref.
        ENDLOOP.
        CLEAR it_ref1.
        CLEAR wa_ref.
        endif.
      ENDIF.
    ENDIF.
***********************************************************************
*  자재 하나당 BOM들을 INSERT 결과 인터널테이블에 넣어 준다.
***********************************************************************

    MOVE 1 TO idx.

    LOOP AT it_ref INTO wa_ref.
***********************************************************************
*  2번 쨰 화면.
***********************************************************************

      CONCATENATE 'RC29P-IDNRK('idx')' INTO zfnam.
      PERFORM bdc_field USING zfnam
                            wa_ref-idnrk.
*            perform bdc_field       USING 'RC29P-IDNRK(01)'
*                                          wa_ref-idnrk.
      CONCATENATE 'RC29P-MENGE('idx')' INTO zfnam.
      PERFORM bdc_field USING zfnam
*                            wa_ref-idnrk.
*      PERFORM bdc_field       USING 'RC29P-MENGE(01)'
                                    wa_ref-menge.
      CONCATENATE 'RC29P-MEINS('idx')' INTO zfnam.
      PERFORM bdc_field USING zfnam
*      PERFORM bdc_field       USING 'RC29P-MEINS(01)'
                                    wa_ref-meins.
      CONCATENATE 'RC29P-POSTP('idx')' INTO zfnam.
      PERFORM bdc_field USING zfnam
*      PERFORM bdc_field       USING 'RC29P-POSTP(01)'
                                    wa_ref-postp.
      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0130'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RC29P-AUSCH'.
*    PERFORM bdc_field       USING 'RC29P-POSNR'
*                                  record-posnr_011.
*    PERFORM bdc_field       USING 'RC29P-IDNRK'
*                                  record-idnrk_012.
*    PERFORM bdc_field       USING 'RC29P-MENGE'
*                                  record-menge_013.
*    PERFORM bdc_field       USING 'RC29P-MEINS'
*                                  record-meins_014.
      PERFORM bdc_field       USING 'RC29P-AUSCH'
                                    '10'.
      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0131'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RC29P-POTX1'.
*      PERFORM bdc_field       USING 'RC29P-SANKA'
*                                     ' '.
      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'RC29P-IDNRK(02)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
*    PERFORM bdc_field       USING 'RC29P-IDNRK(02)'
*                                  record-idnrk_02_017.
*    PERFORM bdc_field       USING 'RC29P-MENGE(02)'
*                                  record-menge_02_018.
*    PERFORM bdc_field       USING 'RC29P-MEINS(02)'
*                                  record-meins_02_019.
*    PERFORM bdc_field       USING 'RC29P-POSTP(02)'
*                                  record-postp_02_020.
*    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0130'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RC29P-AUSCH'.
*    PERFORM bdc_field       USING 'RC29P-POSNR'
*                                  record-posnr_021.
*    PERFORM bdc_field       USING 'RC29P-IDNRK'
*                                  record-idnrk_022.
*    PERFORM bdc_field       USING 'RC29P-MENGE'
*                                  record-menge_023.
*    PERFORM bdc_field       USING 'RC29P-MEINS'
*                                  record-meins_024.
*    PERFORM bdc_field       USING 'RC29P-AUSCH'
*                                  record-ausch_025.
*    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0131'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RC29P-POTX1'.
*    PERFORM bdc_field       USING 'RC29P-SANKA'
*                                  record-sanka_026.

      CLEAR wa_ref.
      idx = idx + 1.
    ENDLOOP.
    CLEAR it_ref.
*    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RC29P-POSNR(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=FCBU'.
*  PERFORM bdc_transaction USING 'CS01'.

    CALL TRANSACTION 'CS01' USING bdcdata
                   MODE   p_mode                                   " 모든 N(BDC를 수행하다가 오류가 나더라도 넘어가라)이나 A(하나하나 다 보여주는 것)냐 E냐
                   UPDATE 'L'                                        " 업데이트 옵션: S(동시에)냐, A(레코딩 끝나고 데이터베이스에 업데이트를 나중에 해라)냐, L이냐
                   MESSAGES INTO messtab.

**********************************************************************
* 신호등 로직 시작.
**********************************************************************
    IF wa_reu_tab-c_light IS INITIAL.
      wa_reu_tab-c_light = c_green.
**********************************************************************
* MAST로부터 저장된 STLAN, STLNR값을 가져온다.
**********************************************************************
*       clear it_mast.
      SELECT stlan stlnr
        FROM mast INTO CORRESPONDING FIELDS OF wa_reu_tab
        WHERE matnr = wa_tab-matnr.
      ENDSELECT.
      LOOP AT messtab[] INTO messtab.
***********************************************************************
* messtab의 타입이 E라면.
***********************************************************************
        IF messtab-msgtyp = 'E'.
          wa_reu_tab-c_light = c_red.
***********************************************************************
* MESSAGE_TEXT_BUILD 함수를 통해서, 에러 메시지를 받는다.
***********************************************************************
          CALL FUNCTION 'MESSAGE_TEXT_BUILD'
            EXPORTING
              msgid               = messtab-msgid
              msgnr               = messtab-msgnr
            IMPORTING
              message_text_output = wa_reu_tab-c_text.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
***********************************************************************
* 결과 ALV로 데이터 값 전송.
***********************************************************************

    APPEND wa_reu_tab TO it_reu_tab.
***********************************************************************
* CBO 테이블로 BDC돌린 성공 결과 데이터 전송.
***********************************************************************
    IF wa_reu_tab-c_light = c_green.
      MOVE-CORRESPONDING wa_reu_tab TO wa_end.

    SELECT stlal
      FROM mast INTO CORRESPONDING FIELDS OF wa_end
      WHERE matnr = wa_end-matnr.
    ENDSELECT.
    MODIFY zppt0010_08 FROM wa_end.
        ENDIF.
*    APPEND wa_end to ZPPT0010_08.
    CLEAR wa_reu_tab.
  ENDLOOP.
**********************************************************************
* ERR_MESSAGE 출력.
**********************************************************************
*    IF err_text IS NOT INITIAL.
*      MESSAGE err_text TYPE 'I'.
*    ENDIF.
CLEAR INDEX_ROWS.
clear err_text.
ENDFORM.                                                    " BDC_CS01
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_REUSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_reuse .
  clear wa_layout.
    clear i_fcat.
  PERFORM create_layout .
  PERFORM create_fcat .
************************************************************************
* Reuse ALV 호출 하기 위한 현재 레포트 프로그램 명을 받아놓는다.
************************************************************************
  DATA: l_program TYPE sy-repid.
  l_program = sy-repid.

*  DELETE it_tab INDEX 2.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
************************************************************************
* 1. 현재 레포트 프로그램에서 // wa_layout 레이아웃 // I_FCAT필드카탈로그를 이용해서,
************************************************************************
       i_callback_program = l_program
       is_layout          = wa_layout
      it_fieldcat        = i_fcat
*      it_events          = i_events
************************************************************************
* 2. it_reu_tab 테이블의 데이터를 Reuse ALV로 뿌려준다.
************************************************************************
     TABLES
       t_outtab           = it_reu_tab
     EXCEPTIONS
       program_error      = 1
       OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_REUSE
*&---------------------------------------------------------------------*
*&      Form  F1000_LAYOUT_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_LAYOUT  text
*----------------------------------------------------------------------*
************************************************************************
* Reuse ALV 레이아웃 생성 폼문.
************************************************************************
FORM create_layout .
  wa_layout-zebra = 'X' .
*  wa_layout-colwidth_optimize = 'X' .
  wa_layout-edit = 'X' .
*  wa_layout-no_vline = 'X' .
*  wa_layout-no_hline = 'X' .
ENDFORM.                    "CREATE_LAYOUT
************************************************************************
* Reuse ALV 필드 카탈로그 생성 폼문.
************************************************************************
FORM create_fcat .

  DATA : v_pos TYPE i.
  v_pos = 1 .
************************************************************************
* Col_Pos 위치 값을 하나씩 올려주며, 필드카탈로그들을 생성한다.
************************************************************************
  wa_fcat-col_pos = v_pos.
  wa_fcat-fieldname = 'C_LIGHT' .
  wa_fcat-seltext_m = 'BDC입력결과' .

  wa_fcat-outputlen = 15.
*  WA_FCAT-col_pos   = 1.

  wa_fcat-hotspot = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = v_pos.
  wa_fcat-fieldname = 'MATNR' .
  wa_fcat-seltext_m = 'Material' .

  wa_fcat-outputlen = 8.
*  WA_FCAT-col_pos   = 1.

  wa_fcat-hotspot = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  v_pos = v_pos + 1.
  wa_fcat-col_pos = v_pos .
  wa_fcat-fieldname = 'WERKS' .
  wa_fcat-seltext_m = '플랜트' .

  wa_fcat-outputlen = 8.
*  WA_FCAT-col_pos   = 1.

  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  v_pos = v_pos + 1.
  wa_fcat-col_pos = v_pos .
  wa_fcat-fieldname = 'STLAN' .
  wa_fcat-seltext_m = 'BOM usg' .

  wa_fcat-outputlen = 8.
*  WA_FCAT-col_pos   = 1.

  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  v_pos = v_pos + 1.
  wa_fcat-col_pos = v_pos .
  wa_fcat-fieldname = 'STLNR' .
  wa_fcat-seltext_m = 'BOM' .

  wa_fcat-outputlen = 8.
*  WA_FCAT-col_pos   = 1.

  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  v_pos = v_pos + 1.
  wa_fcat-col_pos = v_pos .
  wa_fcat-fieldname = 'C_TEXT' .
  wa_fcat-seltext_m = 'BDC에러메시지' .

  wa_fcat-outputlen = 25.
*  WA_FCAT-col_pos   = 1.

  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

ENDFORM.                    " CREATE_FCAT