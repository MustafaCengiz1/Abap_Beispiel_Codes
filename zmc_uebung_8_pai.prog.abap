*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_8_PAI.
*----------------------------------------------------------------------*
" Container ALV (Auch ein Beispiel von FM Number_Get_Next )
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ADD'.
      PERFORM hnzfgn.
  ENDCASE.

ENDMODULE.
