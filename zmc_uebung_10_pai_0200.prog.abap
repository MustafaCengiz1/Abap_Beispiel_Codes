*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_PAI_0200.
*----------------------------------------------------------------------*
" Class Event Handlung, Hotspot, Pushbutton, Färbung Drilldow und Vrnte.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE ok_code.

    WHEN 'ZURUCK'.

      CLEAR: gs_sflight.

      REFRESH gt_sflight.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
