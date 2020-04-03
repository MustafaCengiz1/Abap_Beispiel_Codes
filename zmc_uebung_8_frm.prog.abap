*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_8_FRM.
*----------------------------------------------------------------------*
" Container ALV (Auch ein Beispiel von FM Number_Get_Next )
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zmc_kurs_2 INTO CORRESPONDING FIELDS OF TABLE gt_table.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  KREIEREN_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM kreieren_container .

  IF gc_cont IS INITIAL.

    CREATE OBJECT gc_cont
      EXPORTING
        container_name = 'MEIN_CONT'.

    CREATE OBJECT gc_grid
      EXPORTING
        i_parent = gc_cont.

*    CREATE OBJECT gr_event_handler.
*    SET HANDLER gr_event_handler->cift_tiklama FOR gc_grid.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZMC_KURS_2'
        i_bypassing_buffer     = 'X'
      CHANGING
        ct_fieldcat            = gt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    gs_layo-zebra      = 'X'.
    gs_layo-cwidth_opt = 'X'.
    gs_layo-sel_mode   = 'A'.

    CALL METHOD gc_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
        i_save                        = 'A'
        is_layout                     = gs_layo
      CHANGING
        it_outtab                     = gt_table
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

  ELSE.
    CALL METHOD gc_grid->check_changed_data.
    CALL METHOD gc_grid->refresh_table_display.
  ENDIF.

  PERFORM hinzufugen.

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

  DATA: lt_fcat TYPE         slis_t_fieldcat_alv,
        ls_fcat LIKE LINE OF lt_fcat.


  DATA: "lc_cont   TYPE REF TO cl_gui_custom_container,
    "lc_grid   TYPE REF TO cl_gui_alv_grid,
    ls_layo   TYPE        lvc_s_layo,
    lt_fcat_2 TYPE        lvc_t_fcat,
    ls_fcat_2 TYPE        lvc_s_fcat.

  IF lc_cont IS INITIAL.

    gs_kurs-kursnummer    = ''.
    gs_kurs-name          = ''.
    gs_kurs-vorname       = ''.
    gs_kurs-land          = ''.
    gs_kurs-beruf         = ''.
    gs_kurs-englisch      = ''.
    gs_kurs-email_adresse = ''.
    gs_kurs-telefonnummer = ''.

    APPEND gs_kurs TO gt_kurs.

    CREATE OBJECT lc_cont
      EXPORTING
        container_name = 'KLEIN_CONT'.

    CREATE OBJECT lc_grid
      EXPORTING
        i_parent = lc_cont.

*    CREATE OBJECT gr_event_handler.
*    SET HANDLER gr_event_handler->cift_tiklama FOR gc_grid.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZMC_KURS_2'
        i_bypassing_buffer     = 'X'
      CHANGING
        ct_fieldcat            = lt_fcat_2
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT lt_fcat_2 INTO ls_fcat_2.
      CASE ls_fcat_2-fieldname.
        WHEN 'NAME'  OR 'VORNAME'  OR
             'LAND'  OR 'BERUF'    OR 'ENGLISCH' OR
             'EMAIL_ADRESSE'       OR 'TELEFONNUMMER'.

          ls_fcat_2-edit      = 'X'.
          ls_fcat_2-outputlen = '25'.
          MODIFY lt_fcat_2 FROM ls_fcat_2.
      ENDCASE.
    ENDLOOP.

    ls_layo-zebra      = 'X'.
    ls_layo-sel_mode   = 'A'.
    ls_layo-no_toolbar = 'X'.

    CALL METHOD lc_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
        i_save                        = 'A'
        is_layout                     = ls_layo
      CHANGING
        it_outtab                     = gt_kurs
        it_fieldcatalog               = lt_fcat_2
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

  ELSE.

    CALL METHOD lc_grid->check_changed_data.
    CALL METHOD lc_grid->refresh_table_display.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HNZFGN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM hnzfgn .

  PERFORM hinzufugen.

  DATA: lt_kur2 LIKE zmc_kurs_2 occurs 0,
        gs_kur2 LIKE LINE OF lt_kur2.

  CLEAR:gs_kurs.



  LOOP AT gt_kurs INTO gs_kur2.
  ENDLOOP.

  REFRESH lt_kur2.

  SELECT * FROM zmc_kurs_2 INTO CORRESPONDING FIELDS OF TABLE lt_kur2.

  SORT gt_kurs ASCENDING BY kursnummer.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'Z_NEU_OBJ'
    IMPORTING
      number                  = kurs_nummer
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  gs_kur2-kursnummer = kurs_nummer.

  IF        NOT gs_kur2-kursnummer    IS INITIAL
        AND NOT gs_kur2-name          IS INITIAL
        AND NOT gs_kur2-vorname       IS INITIAL
        AND NOT gs_kur2-land          IS INITIAL
        AND NOT gs_kur2-beruf         IS INITIAL
        AND NOT gs_kur2-email_adresse IS INITIAL
        AND NOT gs_kur2-telefonnummer IS INITIAL.

    zmc_kurs_2-kursnummer    = gs_kur2-kursnummer.
    zmc_kurs_2-name          = gs_kur2-name.
    zmc_kurs_2-vorname       = gs_kur2-vorname.
    zmc_kurs_2-land          = gs_kur2-land.
    zmc_kurs_2-beruf         = gs_kur2-beruf.
    zmc_kurs_2-englisch      = gs_kur2-englisch.
    zmc_kurs_2-email_adresse = gs_kur2-email_adresse.
    zmc_kurs_2-telefonnummer = gs_kur2-telefonnummer.

    INSERT zmc_kurs_2.
    PERFORM get_data.
    PERFORM kreieren_container.
  ELSE.
    MESSAGE 'Füllen Sie bitte alle Felder aus.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
