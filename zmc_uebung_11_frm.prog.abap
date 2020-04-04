*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_11_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zmc_perab INTO CORRESPONDING FIELDS OF TABLE gt_table_1
           WHERE nummer IN s_nummer.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RECHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rechts.

  DATA: antwort(1).

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = 'Möchten Sie,dass die ausgewählten Zeilen gelöscht werden?'
      text_button_1 = 'Ja'
      icon_button_1 = 'ICON_OKAY'
      text_button_2 = 'Nein'
      icon_button_2 = 'ICON_LED_YELLOW'
    IMPORTING
      answer        = antwort.

  IF antwort = '1'.

    LOOP AT gt_table_1 INTO gs_table_1 WHERE selektieren = 'X'.

      APPEND gs_table_1 TO gt_table_2.
      DELETE TABLE gt_table_1 FROM gs_table_1.
      CLEAR: gs_table_1.

    ENDLOOP.

    IF sy-subrc NE 0.
      MESSAGE 'Bitte wählen Sie Zeilen.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSEIF antwort = '2'.

    LOOP AT gt_table_1 INTO gs_table_1 WHERE selektieren = 'X'.

      APPEND gs_table_1 TO gt_table_2.
      CLEAR: gs_table_1.

    ENDLOOP.

    IF sy-subrc NE 0.
      MESSAGE 'Bitte wählen Sie Zeilen.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    EXIT.
  ENDIF.

  SORT gt_table_1 ASCENDING BY nummer.
  SORT gt_table_2 ASCENDING BY nummer.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LINKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM links.

  DATA: antwort(1).

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = 'Möchten Sie,dass die ausgewählten Zeilen gelöscht werden?'
      text_button_1 = 'Ja'
      icon_button_1 = 'ICON_OKAY'
      text_button_2 = 'Nein'
      icon_button_2 = 'ICON_LED_YELLOW'
    IMPORTING
      answer        = antwort.

  IF antwort = '1'.

    LOOP AT gt_table_2 INTO gs_table_2 WHERE selektieren = 'X'.

      APPEND gs_table_2 TO gt_table_1.
      DELETE TABLE gt_table_2 FROM gs_table_2.
      CLEAR: gs_table_2.

    ENDLOOP.

    IF sy-subrc NE 0.
      MESSAGE 'Bitte wählen Sie Zeilen.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSEIF antwort = '2'.

    LOOP AT gt_table_2 INTO gs_table_2 WHERE selektieren = 'X'.

      APPEND gs_table_2 TO gt_table_1.
      CLEAR: gs_table_2.

    ENDLOOP.

    IF sy-subrc NE 0.
      MESSAGE 'Bitte wählen Sie Zeilen.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    EXIT.
  ENDIF.

  SORT gt_table_1 ASCENDING BY nummer.
  SORT gt_table_2 ASCENDING BY nummer.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update.

  LOOP AT gt_table_1 INTO gs_table_1.

    UPDATE zmc_perab SET
    name          = gs_table_1-name
    vorname       = gs_table_1-vorname
    geburtsdatum  = gs_table_1-geburtsdatum
    berufstitel   = gs_table_1-berufstitel
    gehalt        = gs_table_1-gehalt
    raumnummer    = gs_table_1-raumnummer
    telefonnummer = gs_table_1-telefonnummer
    emailadresse  = gs_table_1-emailadresse
    wohnort       = gs_table_1-wohnort
    adresse       = gs_table_1-adresse
    familienstand = gs_table_1-familienstand

    WHERE nummer = gs_table_1-nummer.

  ENDLOOP.

ENDFORM.
