*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_8_PBO.
*----------------------------------------------------------------------*
" Container ALV (Auch ein Beispiel von FM Number_Get_Next )
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'MEIN_STATUS'.
  SET TITLEBAR 'TITEL_BAR' WITH sy-datum sy-uzeit.

  PERFORM get_data.
  PERFORM kreieren_container.
ENDMODULE.
