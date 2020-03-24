REPORT zmc_uebung_5.

TABLES: zmc_perab.

DATA: lt_info LIKE zmc_perab OCCURS 0.

DATA: gv_nummer        LIKE zmc_perab-nummer,
      gv_name          LIKE zmc_perab-name,
      gv_vorname       LIKE zmc_perab-vorname,
      gv_geburtsdatum  LIKE zmc_perab-geburtsdatum,
      gv_berufstitel   LIKE zmc_perab-berufstitel,
      gv_gehalt        LIKE zmc_perab-gehalt,
      gv_raumnummer    LIKE zmc_perab-raumnummer,
      gv_telefonnummer LIKE zmc_perab-telefonnummer,
      gv_emailadresse  LIKE zmc_perab-emailadresse,
      gv_wohnort       LIKE zmc_perab-wohnort,
      gv_adresse       LIKE zmc_perab-adresse,
      gv_familienstand LIKE zmc_perab-familienstand.

DATA: ls_info LIKE LINE OF lt_info.
DATA: ok_code LIKE sy-ucomm.


CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'NEU_STATUS'.
  SET TITLEBAR 'NEU_TITLE' WITH sy-datum sy-uzeit.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'SPEICHERN'.
      PERFORM speichern.
    WHEN 'FINDEN'.
      PERFORM finden.
    WHEN 'KLAREN'.
      PERFORM klaren.
    WHEN 'LOSCHEN'.
      PERFORM loschen.
    WHEN 'AKTUAL'.
      PERFORM aktualisieren.
    WHEN 'ZEIG'.
      PERFORM zeig_alv.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  SPEICHERN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM speichern .

  IF NOT gv_nummer IS INITIAL.

    zmc_perab-nummer          = gv_nummer.
    zmc_perab-name            = gv_name.
    zmc_perab-vorname         = gv_vorname.
    zmc_perab-geburtsdatum    = gv_geburtsdatum.
    zmc_perab-berufstitel     = gv_berufstitel.
    zmc_perab-gehalt          = gv_gehalt.
    zmc_perab-raumnummer      = gv_raumnummer.
    zmc_perab-telefonnummer   = gv_telefonnummer.
    zmc_perab-emailadresse    = gv_emailadresse.
    zmc_perab-wohnort         = gv_wohnort.
    zmc_perab-adresse         = gv_adresse.
    zmc_perab-familienstand   = gv_familienstand.

    INSERT zmc_perab.

    IF sy-subrc = 0.
      MESSAGE 'Die Informationen wurden erfolgreich gespeichert!' TYPE 'S'.
    ELSE.
      MESSAGE 'Leider wurde nicht erfolgreich gespeichert! ' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Sie müssen eine neue Personalnummer eingeben!' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

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

  CLEAR: gv_name, gv_vorname, gv_geburtsdatum,
         gv_berufstitel, gv_gehalt, gv_raumnummer, gv_telefonnummer,
         gv_emailadresse, gv_wohnort, gv_adresse, gv_familienstand.

  IF NOT gv_nummer IS INITIAL .

    SELECT SINGLE * FROM zmc_perab INTO ls_info WHERE nummer = gv_nummer.
    IF sy-subrc = 0.

      gv_nummer        = ls_info-nummer.
      gv_name          = ls_info-name.
      gv_vorname       = ls_info-vorname.
      gv_geburtsdatum  = ls_info-geburtsdatum.
      gv_berufstitel   = ls_info-berufstitel.
      gv_gehalt        = ls_info-gehalt.
      gv_raumnummer    = ls_info-raumnummer.
      gv_telefonnummer = ls_info-telefonnummer.
      gv_emailadresse  = ls_info-emailadresse.
      gv_wohnort       = ls_info-wohnort.
      gv_adresse       = ls_info-adresse.
      gv_familienstand = ls_info-familienstand.

      MESSAGE 'Die Informationen wurde gefunden!' TYPE 'S'.
    ELSE.
      MESSAGE 'Leider wurde die Informationen nicht gefunden!' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Geben Sie bitte eine gültige Personalnummer ein!' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  KLAREN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM klaren .

  CLEAR: gv_nummer, gv_name, gv_vorname, gv_geburtsdatum,
         gv_berufstitel, gv_gehalt, gv_raumnummer, gv_telefonnummer,
         gv_emailadresse, gv_wohnort, gv_adresse, gv_familienstand.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LOSCHEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM loschen .

  IF NOT gv_nummer IS INITIAL.
    DELETE  FROM zmc_perab WHERE nummer = gv_nummer.
    IF sy-subrc = 0.
      MESSAGE 'Die Informationen wurden erfolgreich gelöscht!' TYPE 'S'.
    ELSE.
      MESSAGE 'Geben Sie bitte eine gültige Personalnummer ein!' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Geben Sie bitte eine gültige Personalnummer ein!' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

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

  IF NOT gv_nummer IS INITIAL.

    UPDATE zmc_perab SET

    name          = gv_name
    vorname       = gv_vorname
    geburtsdatum  = gv_geburtsdatum
    berufstitel   = gv_berufstitel
    gehalt        = gv_gehalt
    raumnummer    = gv_raumnummer
    telefonnummer = gv_telefonnummer
    emailadresse  = gv_emailadresse
    wohnort       = gv_wohnort
    adresse       = gv_adresse
    familienstand = gv_familienstand

    WHERE nummer = gv_nummer.
    IF sy-subrc = 0.
      MESSAGE 'Die Informationen wurden erfolgreich aktualisiert!' TYPE 'S'.
    ELSE.
      MESSAGE 'Leider ist die Aktualisierung nicht erfolgreich!' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Geben Sie bitte eine gültige Personalnummer ein!' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZEIG_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zeig_alv .

  DATA: lt_fieldcat TYPE  lvc_t_fcat,
        ls_layout   TYPE  lvc_s_layo.

  ls_layout-sel_mode = 'A'.

  REFRESH lt_info.

  SELECT * FROM zmc_perab INTO CORRESPONDING FIELDS OF TABLE lt_info.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZMC_PERAB'
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      is_layout_lvc      = ls_layout
      it_fieldcat_lvc    = lt_fieldcat
    TABLES
      t_outtab           = lt_info
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
