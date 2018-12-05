*&---------------------------------------------------------------------*
*&                                  TOP
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   data definition                                                             ---> �ʼ� 1. BDC DATA Definition �� // BDC include BDCRECX1���� ������.
*----------------------------------------------------------------------*
*       Batchinputdata of single transaction
DATA:   BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
*       error session opened (' ' or 'X')
DATA:   E_GROUP_OPENED.
*       message texts
TABLES: T100.

*&---------------------------------------------------------------------*
*&                                  F01
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*        Start new screen                                              *        ---> �ʼ� 2. ��ũ���� ����ȭ�ϴ� ����.
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.
*----------------------------------------------------------------------*
*        Insert field                                                  *        ---> �ʼ� 3. �ʵ� �����͸� �Է��ϴ� ����.
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
    CLEAR BDCDATA.
    BDCDATA-FNAM = FNAM.
    BDCDATA-FVAL = FVAL.
    APPEND BDCDATA.
*  ENDIF.
ENDFORM.

form BDC_CO11N .

DATA l_qty(10) TYPE c.
loop at it_tab into wa_Tab.
      REFRESH messtab.
    REFRESH bdcdata.


********************************************************************
*  �׼� ����.                                                      *
*  1. ���͸� ���߿� �ƴٰ� �ؼ� ���������� ����Ǵ� ���� �ƴϴ�.   *
*  2. Ʈ����ǵ� ����������.                                       *
********************************************************************
********************************************************************
*  First Screen.                                                   *
********************************************************************
perform bdc_dynpro      using 'SAPLCORU_S' '0100'.                     " CO11N�� �ش��ϴ� ���α׷� ȣ��.

  
perform bdc_field       using 'BDC_OKCODE'                             " ���͸� �Է�.
                              '/00'.

perform bdc_field       using 'AFRUD-AUFNR'                            " ������� �Է� ����
                              WA_tab-AUFNR.                            " ���ͳ� ���̺��� ��������� ������ �Ѵ�.

perform bdc_field       using 'AFRUD-VORNR'                            " ������ȣ �Է��ϴ°� ����
                              WA_tab-VORNR.
********************************************************************
*  Second Screen.                                                  *
********************************************************************
perform bdc_dynpro      using 'SAPLCORU_S' '0100'.                     "  ---> ���͸� ġ�� ���α׷��� �ٽ� ȣ��ȴ�. ��ũ���� �ٽ� ȣ��Ǳ� ������

perform bdc_field       using 'BDC_OKCODE'                             " �����ư
                              '=BU'.

WRITE wa_tab-gamng TO l_qty LEFT-JUSTIFIED.
perform bdc_field       using 'AFRUD-LMNGA'                            " Yield ����  ---> Ÿ�� ������ ����.
                              l_qty.


* <=========================�ð� ���õ� ����=========================>

*perform bdc_field       using 'AFRUD-ISM01'                           " Setup �ð� / ��
*                              record-ISM01_012.
*perform bdc_field       using 'AFRUD-ILE01'
*                              'MIN'.

*perform bdc_field       using 'AFRUD-ISM02'                           " Labor �ð� / ��
*                              record-ISM02_14.
*perform bdc_field       using 'AFRUD-ILE02'
*                              'MIN'.


*    REFRESH MESSTAB.
    CALL TRANSACTION 'CO11N' USING BDCDATA
                     MODE   'N'                                        " ��� N(BDC�� �����ϴٰ� ������ ������ �Ѿ��)�̳� A(�ϳ��ϳ� �� �����ִ� ��)�� E��
                     UPDATE 'S'                                        " ������Ʈ �ɼ�: S(���ÿ�)��, A(���ڵ� ������ �����ͺ��̽��� ������Ʈ�� ���߿� �ض�)��, L�̳�
                     MESSAGES INTO MESSTAB.
*perform bdc_transaction using 'CO11N'.
ENDLOOP.
endform.                    " BDC_CO11N


*&---------------------------------------------------------------------*
*&                         ANY WHERE
*&
*&---------------------------------------------------------------------*
 
*...

PERFORM BDC_CO11N.                                                      " BDC ����(������� ���� ó���ϴ� BDC CO11) ����

*...