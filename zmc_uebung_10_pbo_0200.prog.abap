*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_PBO_0200.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  SET TITLEBAR 'TITEL' WITH sy-datum sy-uzeit.
  PERFORM zeig_alv_2.

ENDMODULE.
