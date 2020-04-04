*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_11_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'RECHTS'.
      PERFORM rechts.
    WHEN 'LINKS'.
      PERFORM links.
    WHEN 'UPDATE'.
      PERFORM update.
*  	WHEN OTHERS.
  ENDCASE.

ENDMODULE.
