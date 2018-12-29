FUNCTION Z_THWORKING_COUNT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(STARTDATE) TYPE  SY-DATUM
*"     REFERENCE(WORKDAY) TYPE  NUM1 DEFAULT 0
*"  EXPORTING
*"     REFERENCE(ENDDATE) TYPE  SY-DATUM
*"----------------------------------------------------------------------
************************************************************************
* Written By TaeHyeong
* Reporting Date: `18.12.24
* Subject: �۷ι� �Լ���, �����ϰ� ��ŷ���̳�¥�� �Է¹޾Ƽ� �ָ��� �������� ������ ���� �������� ���ϴ� �Լ�.
************************************************************************
DATA : plandate type d.
data : max TYPE i.
data : count TYPE i.
data : TH_DAYNR TYPE HRVSCHED-DAYNR,
       h_check TYPE c.
plandate = startdate.
max = workday.
WHILE count < max.

  CALL FUNCTION 'RH_GET_DATE_DAYNAME'        "�ָ��� ���ϴ� �Լ�.
       EXPORTING
               LANGU = SY-LANGU
               DATE  = PLANDATE              "�Էµ� ������
       IMPORTING
               DAYNR  = TH_DAYNR.


  IF TH_DAYNR = '6' OR TH_DAYNR = '7'.        "�ָ��̶��
        plandate = plandate + 1.
  ELSE.                                       " �����̶��
   CALL FUNCTION 'HOLIDAY_CHECK_AND_GET_INFO'  "���ѹα� �������� üũ�Ѵ�.
  EXPORTING
  DATE = plandate
  HOLIDAY_CALENDAR_ID = 'KR'
  IMPORTING
  HOLIDAY_FOUND = h_check.


  IF h_check = 'X'.                          " �����ε� �������̶��.
    plandate = plandate + 1.
  ELSE.                                      " �����ε� �������� �ƴ϶��.  ---> �� WORKING DAY���.
    count = count + 1.
    plandate = plandate + 1.
  ENDIF.

  ENDIF.




ENDWHILE.

  enddate = plandate - 1 .

ENDFUNCTION.