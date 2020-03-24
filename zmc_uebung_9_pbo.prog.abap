*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_9_PBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE' WITH sy-datum sy-uzeit.

IF flag2 is INITIAL.

    LOOP AT SCREEN .
    IF screen-group1 = 'GR1' .
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDIF.

ENDMODULE.
