*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_9_PAI.
*----------------------------------------------------------------------*
" Ein Beispiel für eine dynamische Tabelle und E-Mail Sendung
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.
  CASE ok_code.
    WHEN 'ZURUCK'.
      LEAVE TO SCREEN 0.
    WHEN 'ALV'.
      IF flag IS INITIAL.
        PERFORM get_data.
        PERFORM collect.
        PERFORM fcat_herstellen.
        PERFORM dtab_herstellen.
        PERFORM dtab_einfullen.
        PERFORM cont_herstellen.
        PERFORM zeig_taste.
      ELSE.
        REFRESH: gt_fcat.
        PERFORM get_data.
        PERFORM collect.
        PERFORM fcat_herstellen.
        PERFORM dtab_herstellen.
        PERFORM dtab_einfullen.
        PERFORM cont_herstellen.
        PERFORM zeig_taste.

      ENDIF.
    WHEN 'HIN'.
      PERFORM hinzufugen.
    WHEN 'LOSCHEN'.
      PERFORM loschen.
    WHEN 'MAIL'.
      PERFORM e_mail.
  ENDCASE.

ENDMODULE.
