*&---------------------------------------------------------------------*
*& Report  Z_TH0701_FUNCTION_9_JUSTIFIED
*&
*&---------------------------------------------------------------------*
*& Written By TaeHyeong Kim
*& Reporting Date: `18.12.2
*& Subject: Justified�� �̿��Ͽ� ���� 5���ڿ� ���� 5���ڸ� ����϶�!
*&---------------------------------------------------------------------*

REPORT  Z_TH0701_FUNCTION_9_JUSTIFIED.

DATA : bef_data(10) TYPE n,
      left_data(5) type n,                        " ���� 5���ڸ� ����ϰԵ� ����.
      right_data(5) TYPE n.                      " ���� 5���ڸ� ����ϰԵ� ����.

bef_data = 1234567890.
WRITE bef_data to left_data LEFT-JUSTIFIED.
WRITE bef_data to right_data RIGHT-JUSTIFIED.
write : / bef_data.
WRITE : / left_data.                              " 12345 ���
WRITE : / right_data.                            " 67890 ���