REPORT zmc_uebung_7.

TABLES: zmc_kurs.

DATA: gt_kurs LIKE zmc_kurs OCCURS 0 WITH HEADER LINE,
      gs_kurs LIKE LINE OF gt_kurs.

DATA: lt_fcat TYPE  lvc_t_fcat,
      ls_layo TYPE  lvc_s_layo.

PERFORM get_data.
PERFORM set_layo.
PERFORM set_fcat.
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

  SELECT * FROM zmc_kurs INTO CORRESPONDING FIELDS OF TABLE gt_kurs.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layo .

  ls_layo-sel_mode = 'A'.
  ls_layo-cwidth_opt = 'X'.

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
      i_structure_name       = 'ZMC_KURS'
    CHANGING
      ct_fieldcat            = lt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

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
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'MEIN_STATUS'
      i_callback_user_command  = 'MEIN_COMMAND'
      is_layout_lvc            = ls_layo
      it_fieldcat_lvc          = lt_fcat
    TABLES
      t_outtab                 = gt_kurs
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

ENDFORM.

FORM mein_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'STATUS'.
ENDFORM.

FORM mein_command USING rucomm   TYPE sy-ucomm
                        selfield TYPE slis_selfield.

  CASE rucomm.
    WHEN 'ZURUCK'.
      LEAVE PROGRAM.
    WHEN 'EINORDNEN'.
      PERFORM einordnen.
    WHEN 'EINORD_2'.
      PERFORM einord_2.
    WHEN 'LOESCHEN'.
      PERFORM zeile_loeschen.
    WHEN 'FINDEN'.
      PERFORM finden.
    WHEN 'AKTUALSRN'.
      PERFORM aktualisieren.
    WHEN 'HINZUFGN'.
      PERFORM hinzufugen.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EINORDNEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einordnen .

  SORT gt_kurs ASCENDING BY name.
  PERFORM display_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EINORD_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einord_2 .

  SORT gt_kurs ASCENDING BY kursnummer.
  PERFORM display_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZEILE_LOESCHEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zeile_loeschen .
  DATA: lt_kur2 LIKE zmc_kurs OCCURS 0,
        ls_kur2 LIKE LINE OF lt_kur2.

  DATA: grid          TYPE REF TO  cl_gui_alv_grid,
        lt_index_rows TYPE lvc_t_row,
        lt_row_no     TYPE lvc_t_roid,
        ls_row_no     TYPE lvc_s_roid.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = grid.

  CALL METHOD grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows
      et_row_no     = lt_row_no.

  LOOP AT lt_row_no INTO ls_row_no.

    READ TABLE gt_kurs INTO gs_kurs INDEX ls_row_no-row_id.

    APPEND gs_kurs TO lt_kur2.

    CLEAR: gs_kurs.
  ENDLOOP.

  LOOP AT lt_kur2 INTO ls_kur2.

    DELETE gt_kurs WHERE kursnummer = ls_kur2-kursnummer.
    CLEAR: ls_kur2.
  ENDLOOP.

  PERFORM display_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINDEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM finden .

  DATA: lt_kur3   LIKE zmc_kurs OCCURS 0,
        ls_kur3   LIKE LINE OF lt_kur3,
        lt_fields TYPE STANDARD TABLE OF sval WITH HEADER LINE,
        lt_fcat2  TYPE slis_t_fieldcat_alv.

  lt_fields-tabname = 'ZMC_KURS'.
  lt_fields-fieldname = 'KURSNUMMER'.
  lt_fields-value = zmc_kurs-kursnummer.
  APPEND lt_fields.


  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
*     NO_VALUE_CHECK  = ' '
      popup_title     = 'Geben Sie Bitte die Kursnummer ein!'
*     START_COLUMN    = '5'
*     START_ROW       = '5'
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  READ TABLE gt_kurs WITH KEY kursnummer = lt_fields-value INTO ls_kur3.

  APPEND ls_kur3 TO lt_kur3.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'ZMC_KURS'
    CHANGING
      ct_fieldcat            = lt_fcat2
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = 'Die Zeile, die von Ihnen ausgewählt wurde.'
      i_selection           = 'X'
      i_screen_start_column = 5
      i_screen_start_line   = 5
      i_screen_end_column   = 80
      i_screen_end_line     = 10
      i_tabname             = 'LT_KUR3'
      it_fieldcat           = lt_fcat2
    TABLES
      t_outtab              = lt_kur3
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  AKTUALISIEREN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM aktualisieren .

  DATA: lt_kur4 LIKE zmc_kurs OCCURS 0,
        ls_kur4 LIKE LINE OF lt_kur4,
        flag(1),
        ans(1).

  DATA: grid          TYPE REF TO  cl_gui_alv_grid,
        lt_index_rows TYPE lvc_t_row,
        lt_row_no     TYPE lvc_t_roid,
        ls_row_no     TYPE lvc_s_roid.

  DATA: lt_fcat3 TYPE  slis_t_fieldcat_alv,
        ls_fcat3 LIKE LINE OF lt_fcat3.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = grid.

  CALL METHOD grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows
      et_row_no     = lt_row_no.

  CALL METHOD grid->check_changed_data.

  LOOP AT lt_row_no INTO ls_row_no.

    IF sy-tabix = 1.
      READ TABLE gt_kurs INTO gs_kurs INDEX ls_row_no-row_id.
      APPEND gs_kurs TO lt_kur4.
      CLEAR: gs_kurs.
    ELSE.
      MESSAGE 'Bitte wählen Sie nur eine Zeile.' TYPE 'S' DISPLAY LIKE 'E'.
      flag = 'X'.
    ENDIF.

  ENDLOOP.

  IF NOT flag IS INITIAL.
    CLEAR: flag.
    EXIT.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'ZMC_KURS'
    CHANGING
      ct_fieldcat            = lt_fcat3
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT lt_fcat3 INTO ls_fcat3.
    CASE ls_fcat3-fieldname.
      WHEN 'NAME'  OR 'VORNAME'  OR
           'LAND'  OR 'BERUF'    OR 'ENGLISCH' OR
           'EMAIL_ADRESSE'       OR 'TELEFONNUMMER'.

        ls_fcat3-edit = 'X'.
        ls_fcat3-input = 'X'.
        MODIFY lt_fcat3 FROM ls_fcat3.
    ENDCASE.
  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = 'Sie Können Die Infos Hier Wechseln.'
      i_screen_start_column = 5
      i_screen_start_line   = 13
      i_screen_end_column   = 120
      i_screen_end_line     = 18
      i_tabname             = 'LT_KUR4'
      it_fieldcat           = lt_fcat3
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = lt_kur4
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.

  LOOP AT lt_kur4 INTO ls_kur4.
  ENDLOOP.

  READ TABLE gt_kurs  WITH KEY kursnummer = ls_kur4-kursnummer INTO gs_kurs.

  IF gs_kurs NE ls_kur4.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = 'Bestätigen Sie Die Wechselung?'
        text_button_1         = 'Ja'
        icon_button_1         = 'ICON_CHECKED'
        text_button_2         = 'Nein'
        icon_button_2         = 'ICON_CANCEL'
        display_cancel_button = ' '
      IMPORTING
        answer                = ans
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF ans = '1'.

      MOVE-CORRESPONDING ls_kur4 TO gs_kurs.

      UPDATE zmc_kurs SET

      name          = gs_kurs-name
      vorname       = gs_kurs-vorname
      land          = gs_kurs-land
      beruf         = gs_kurs-beruf
      englisch      = gs_kurs-englisch
      email_adresse = gs_kurs-email_adresse
      telefonnummer = gs_kurs-telefonnummer

      WHERE kursnummer = gs_kurs-kursnummer.

      REFRESH gt_kurs.
      PERFORM get_data.
      PERFORM display_data.

      MESSAGE 'Die Informationen wurde erfolgreich gewechselt.' TYPE 'I'.
    ELSE.
      MESSAGE 'Keine Wechselung wurde gemacht.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE 'Keine Wechselung wurde gemacht.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HINZUFUGEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM hinzufugen .

  DATA: lt_fcat4 TYPE  slis_t_fieldcat_alv,
        ls_fcat4 LIKE LINE OF lt_fcat4,
        lt_kur5  LIKE zmc_kurs OCCURS 0,
        ls_kur5  LIKE LINE OF lt_kur5,
        ls_kur6  LIKE LINE OF lt_kur5.

  DATA: grid          TYPE REF TO  cl_gui_alv_grid,
        lt_index_rows TYPE lvc_t_row,
        lt_row_no     TYPE lvc_t_roid,
        ls_row_no     TYPE lvc_s_roid.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = grid.

  CALL METHOD grid->check_changed_data.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'ZMC_KURS'
    CHANGING
      ct_fieldcat            = lt_fcat4
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT lt_fcat4 INTO ls_fcat4.
    CASE ls_fcat4-fieldname.
      WHEN 'NAME'  OR 'VORNAME'  OR
           'LAND'  OR 'BERUF'    OR 'ENGLISCH' OR
           'EMAIL_ADRESSE'       OR 'TELEFONNUMMER'.

        ls_fcat4-edit = 'X'.
        ls_fcat4-input = 'X'.
        ls_fcat4-outputlen = '25'.
        ls_fcat4-emphasize = 'X'.
        MODIFY lt_fcat4 FROM ls_fcat4.
    ENDCASE.
  ENDLOOP.

  ls_kur5-name          = ' '.
  ls_kur5-vorname       = ' '.
  ls_kur5-land          = ' '.
  ls_kur5-beruf         = ' '.
  ls_kur5-englisch      = ' '.
  ls_kur5-email_adresse = ' '.
  ls_kur5-telefonnummer = ' '.

  APPEND ls_kur5 TO lt_kur5.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = 'Sie Können Die Infos Hier Wechseln.'
      i_screen_start_column = 5
      i_screen_start_line   = 13
      i_screen_end_column   = 120
      i_screen_end_line     = 18
      i_tabname             = 'LT_KUR4'
      it_fieldcat           = lt_fcat4
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = lt_kur5
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.

  CLEAR:ls_kur5.

  LOOP AT lt_kur5 INTO ls_kur5.
  ENDLOOP.

  REFRESH lt_kur5.

  SELECT * FROM zmc_kurs INTO CORRESPONDING FIELDS OF TABLE lt_kur5.

  SORT lt_kur5 ASCENDING BY kursnummer.

  LOOP AT lt_kur5 INTO ls_kur6.
  ENDLOOP.

  ls_kur5-kursnummer = ls_kur6-kursnummer + 1.

  IF        NOT ls_kur5-kursnummer    IS INITIAL
        AND NOT ls_kur5-name          IS INITIAL
        AND NOT ls_kur5-vorname       IS INITIAL
        AND NOT ls_kur5-land          IS INITIAL
        AND NOT ls_kur5-beruf         IS INITIAL
        AND NOT ls_kur5-englisch      IS INITIAL
        AND NOT ls_kur5-email_adresse IS INITIAL
        AND NOT ls_kur5-telefonnummer IS INITIAL.

    zmc_kurs-kursnummer    = ls_kur5-kursnummer.
    zmc_kurs-name          = ls_kur5-name.
    zmc_kurs-vorname       = ls_kur5-vorname.
    zmc_kurs-land          = ls_kur5-land.
    zmc_kurs-beruf         = ls_kur5-beruf.
    zmc_kurs-englisch      = ls_kur5-englisch.
    zmc_kurs-email_adresse = ls_kur5-email_adresse.
    zmc_kurs-telefonnummer = ls_kur5-telefonnummer.

    INSERT zmc_kurs.
    PERFORM display_data.
  ELSE.
    MESSAGE 'Füllen Sie bitte alle Felder aus.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
