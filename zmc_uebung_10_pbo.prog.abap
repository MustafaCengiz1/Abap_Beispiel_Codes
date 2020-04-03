*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_PBO.
*----------------------------------------------------------------------*
" Class Event Handlung, Hotspot, Pushbutton, Färbung Drilldow und Vrnte.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'MEIN_STATUS'.
  SET TITLEBAR 'TITLE' WITH sy-datum sy-uzeit.

  PERFORM get_data.
  PERFORM vor_fcat.
  PERFORM vor_layo.
  PERFORM verstecken_buttons CHANGING gt_exclude.
  PERFORM zeig_alv.

ENDMODULE.
