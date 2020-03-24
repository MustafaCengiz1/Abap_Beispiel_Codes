REPORT zmc_uebung_4.

TABLES: marc.

DATA: BEGIN OF it_marc OCCURS 0,
        matnr LIKE marc-matnr,
        werks LIKE marc-werks,
        pstat LIKE marc-pstat,
        lvorm LIKE marc-lvorm,
        bwtty LIKE marc-bwtty,
        xchar LIKE marc-xchar,
        mmsta LIKE marc-mmsta,
        mmstd LIKE marc-mmstd,
      END OF it_marc.

DATA: ls_marc LIKE LINE OF it_marc.

DATA: it_fieldcat TYPE  lvc_t_fcat,
      ls_fieldcat LIKE LINE OF it_fieldcat.

DATA: is_layout TYPE  LVC_S_LAYO.

PERFORM get_data.
PERFORM set_fcat.
PERFORM set_layout.
PERFORM modif_fcat.
PERFORM display_data.
*BREAK-POINT.
*&---------------------------------------------------------------------*
*&      FORm  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT matnr
         werks
         pstat
         lvorm
         bwtty
         xchar
         mmsta
         mmstd FROM marc INTO CORRESPONDING FIELDS OF TABLE it_marc UP TO 100 ROWS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'MARC'
    CHANGING
      ct_fieldcat            = it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
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

  is_layout-sel_mode = 'A'.
  is_layout-zebra = 'X'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MODIF_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modif_fcat .

  LOOP AT it_fieldcat INTO ls_fieldcat.

    IF ls_fieldcat-fieldname NE 'MATNR' AND
       ls_fieldcat-fieldname NE 'WERKS' AND
       ls_fieldcat-fieldname NE 'PSTAT' AND
       ls_fieldcat-fieldname NE 'LVORM' AND
       ls_fieldcat-fieldname NE 'BWTTY' AND
       ls_fieldcat-fieldname NE 'XCHAR' AND
       ls_fieldcat-fieldname NE 'MMSTA' AND
       ls_fieldcat-fieldname NE 'MMSTD' .

      DELETE TABLE it_fieldcat FROM ls_fieldcat.
      CLEAR: ls_fieldcat.
    ENDIF.

  ENDLOOP.

  LOOP AT it_fieldcat INTO ls_fieldcat.
    ls_fieldcat-col_pos = sy-tabix.
    MODIFY it_fieldcat FROM ls_fieldcat.
  ENDLOOP.
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

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
   EXPORTING

*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
     IS_LAYOUT_LVC                     = is_layout
     IT_FIELDCAT_LVC                   = it_fieldcat

    TABLES
      t_outtab                          = it_marc
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2.



ENDFORM.
