REPORT zmc_uebung_3.

" Ein einfaches Beispiel von ALV mit der Tabelle MARA

TABLES: mara.

DATA: BEGIN OF it_mara occurs 0,
        sell  TYPE c LENGTH 1,
        matnr LIKE mara-matnr,
        ersda LIKE mara-ersda,
        ernam LIKE mara-ernam,
        laeda LIKE mara-laeda,
        aenam LIKE mara-aenam,
        vpsta LIKE mara-vpsta,
        pstat LIKE mara-pstat,
        lvorm LIKE mara-lvorm,
      END OF it_mara.

DATA: it_fieldcat TYPE  slis_t_fieldcat_alv.
DATA: is_layout TYPE  slis_layout_alv.

PERFORM get_data.
PERFORM set_layout.
PERFORM display_data.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT matnr
         ersda
         ernam
         laeda
         aenam
         vpsta
         pstat
         lvorm FROM mara INTO CORRESPONDING FIELDS OF TABLE it_mara.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layout .
  is_layout-zebra = 'X'.
  is_layout-box_fieldname = 'SELL'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'IT_MARA'
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = is_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_mara
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
