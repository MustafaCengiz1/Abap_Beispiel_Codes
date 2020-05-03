*&---------------------------------------------------------------------*
*& Report  ZMC_UEBUNG_18
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZMC_UEBUNG_18.

" In diesem biespiel Code werden wir sehen die eigenschaften of SELECTION-SCREEN.
" Diese Eigenschaften sind sehr wichtig, um ein funktionsfähiges SCREEN zu gestalten.

" Es wäre sehr sehr einfacher, wenn ich dieses Program
" durch Dialog Programmierung geschrieben hätte. Aber
" wie ich gesagt habe, mein erstes Ziel ist die Eigenschaften
" von Selection-Screen zu zeigen. Auch habe ich Selection Texts
" nicht genutzt. Ich wollte Ihnen die Befehlen, die man im Selection
" Screen benutzen kann, zeigen.

" Ich hoffe, dass diese Hinweise können Sie verwenden, während
" Sie im Abap Workbench Entwicklungen schreiben.

" Ich habe auch nicht in INCLUDES geschriben. Dadurch kann man
" alle Befehlen in einer Seite lesen.
" Die Anzeige können Sie hier  ------>  https://hizliresim.com/eySBmZ <------ sehen.

" Viel Erfolg wünsche ich Ihnen und bis bald :)

TABLES: sscrfields, zmc_perab.

*************************************************************************
" Gestaltung von Selection Screen
*************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001 NO INTERVALS.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 17(40) ptext.
SELECTION-SCREEN:  END OF LINE.
SELECTION-SCREEN ULINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(15) pnum,
             COMMENT 25(1) p1.
PARAMETERS: p_numm TYPE zmc_pernum.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(13) pnam,
             COMMENT 25(1) p2.
PARAMETERS: p_name TYPE zmc_pernam.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(16) pvor,
             COMMENT 25(1) p3.
PARAMETERS: p_vorn TYPE zmc_pervor.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(21) pgeb,
             COMMENT 25(1) p4.
PARAMETERS: p_gebd TYPE zmc_pergeb.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(20) pber,
             COMMENT 25(1) p5.
PARAMETERS: p_berf TYPE zmc_perber.
SELECTION-SCREEN: END OF LINE.


SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(15) pgeh,
             COMMENT 25(1) p6.
PARAMETERS: p_ghlt TYPE zmc_pergeh.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(19) prau,
             COMMENT 25(1) p7.
PARAMETERS: p_raum TYPE zmc_perrau.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(22) ptel,
             COMMENT 25(1) p8.
PARAMETERS: p_tlfn TYPE zmc_pertel.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(23) pmai,
             COMMENT 25(1) p9.
PARAMETERS: p_mail TYPE zmc_permai.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(16) pwoh,
             COMMENT 25(1) p10.
PARAMETERS: p_whno TYPE zmc_perwoh.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(16) padr,
             COMMENT 25(1) p11.
PARAMETERS: p_adrs TYPE zmc_peradr.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE,
             COMMENT 2(22) pfam,
             COMMENT 25(1) p12.
PARAMETERS: p_fmst TYPE zmc_perfam.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-002 NO INTERVALS.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: rb_1 RADIOBUTTON GROUP opr USER-COMMAND uc1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT (9)  txt1 FOR FIELD rb_1.
SELECTION-SCREEN COMMENT (11) gap1.

PARAMETERS: rb_2 RADIOBUTTON GROUP opr.
SELECTION-SCREEN COMMENT (6)  txt2 FOR FIELD rb_2.
SELECTION-SCREEN COMMENT (13) gap2.

PARAMETERS: rb_3 RADIOBUTTON GROUP opr.
SELECTION-SCREEN COMMENT (6)  txt3 FOR FIELD rb_3.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: rb_4 RADIOBUTTON GROUP opr.
SELECTION-SCREEN COMMENT (7)  txt4 FOR FIELD rb_4.
SELECTION-SCREEN COMMENT (13) gap3.

PARAMETERS: rb_5 RADIOBUTTON GROUP opr.
SELECTION-SCREEN COMMENT (13) txt5 FOR FIELD rb_5.
SELECTION-SCREEN COMMENT (6) gap4.

PARAMETERS: rb_6 RADIOBUTTON GROUP opr.
SELECTION-SCREEN COMMENT (8)  txt6 FOR FIELD rb_6.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN END OF BLOCK a2.

SELECTION-SCREEN BEGIN OF BLOCK a3 WITH FRAME TITLE text-003 NO INTERVALS.
SELECTION-SCREEN: BEGIN OF LINE,
                  PUSHBUTTON 20(13) btname USER-COMMAND pshb.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN END OF BLOCK a3.
**********************Das Ende von der Gestaltung************************

*************************************************************************
" Definierung von unserer localen Klasse
*************************************************************************
CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.

    DATA: it_table TYPE STANDARD TABLE OF zmc_perab,
          is_table TYPE zmc_perab,
          iv_count TYPE i.

    METHODS: speichern IMPORTING nummer        TYPE zmc_pernum
                                 name          TYPE zmc_pernam
                                 vorname       TYPE zmc_pervor
                                 geburtsdatum  TYPE zmc_pergeb
                                 berufstitel   TYPE zmc_perber
                                 gehalt        TYPE zmc_pergeh
                                 raumnummer    TYPE zmc_perrau
                                 telefonnummer TYPE zmc_pertel
                                 emailadresse  TYPE zmc_permai
                                 wohnort       TYPE zmc_perwoh
                                 adresse       TYPE zmc_peradr
                                 familienstand TYPE zmc_perfam,
             finden    IMPORTING nummer        TYPE zmc_pernum,
             klaeren,
             loeschen  IMPORTING nummer        TYPE zmc_pernum,
             aktual    IMPORTING name          TYPE zmc_pernam
                                 vorname       TYPE zmc_pervor
                                 geburtsdatum  TYPE zmc_pergeb
                                 berufstitel   TYPE zmc_perber
                                 gehalt        TYPE zmc_pergeh
                                 raumnummer    TYPE zmc_perrau
                                 telefonnummer TYPE zmc_pertel
                                 emailadresse  TYPE zmc_permai
                                 wohnort       TYPE zmc_perwoh
                                 adresse       TYPE zmc_peradr
                                 familienstand TYPE zmc_perfam,
             zeig_alv.
ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.

  METHOD speichern.

    SELECT * FROM zmc_perab INTO CORRESPONDING FIELDS OF TABLE it_table.
    DESCRIBE TABLE it_table LINES iv_count.
    READ TABLE it_table INTO is_table INDEX iv_count.

     is_table-nummer        = is_table-nummer + 1.
     is_table-name          = name.
     is_table-vorname       = vorname.
     is_table-geburtsdatum  = geburtsdatum.
     is_table-berufstitel   = berufstitel.
     is_table-gehalt        = gehalt.
     is_table-raumnummer    = raumnummer.
     is_table-telefonnummer = telefonnummer.
     is_table-emailadresse  = emailadresse.
     is_table-wohnort       = wohnort.
     is_table-adresse       = adresse.
     is_table-familienstand = adresse.

     INSERT INTO zmc_perab VALUES is_table.

     IF sy-subrc = 0.
       MESSAGE 'Erfolgreich wurde die neue Zeile hinzugefügt.' TYPE 'S'.
       ELSE.
       MESSAGE 'Die Informationen wurden nicht gespeichert!' TYPE 'E'.
     ENDIF.

  ENDMETHOD.

  METHOD finden.

    CLEAR: is_table.

    SELECT  SINGLE * FROM zmc_perab INTO CORRESPONDING FIELDS OF is_table
      WHERE nummer = p_numm.

    IF sy-subrc = 0.

      P_NAME = is_table-name.
      P_GEBD = is_table-geburtsdatum.
      P_GHLT = is_table-gehalt.
      P_TLFN = is_table-telefonnummer.
      P_WHNO = is_table-wohnort.
      P_FMST = is_table-familienstand.
      P_VORN = is_table-vorname.
      P_BERF = is_table-berufstitel.
      P_RAUM = is_table-raumnummer.
      P_MAIL = is_table-emailadresse.
      P_ADRS = is_table-adresse.

      MODIFY SCREEN.

      ELSE.
        MESSAGE 'Die Nummer, die Sie eingegeben haben, ist nicht korrekt!' TYPE 'I'.

    ENDIF.

  ENDMETHOD.

  METHOD klaeren.

    CLEAR: p_numm, p_name, p_gebd, p_ghlt, p_tlfn, p_whno,
           p_fmst, p_vorn, p_berf, p_raum, p_mail, p_adrs.

    MODIFY SCREEN.

  ENDMETHOD.

  METHOD loeschen.

      DELETE FROM zmc_perab WHERE nummer = p_numm.

    IF sy-subrc = 0.
      MESSAGE 'Erfolgreich gelöscht von der Tabelle ZMC_PERAB' TYPE 'S'.
     ELSE.
       MESSAGE 'Die Nummer, die Sie eingegeben haben, ist nicht korrekt!' TYPE 'I'.
    ENDIF.

  ENDMETHOD.

  METHOD aktual.

    CLEAR: is_table.

    SELECT SINGLE * FROM zmc_perab INTO CORRESPONDING FIELDS OF is_table
      WHERE nummer = p_numm.

      UPDATE zmc_perab SET

    name          = p_name
    geburtsdatum  = p_gebd
    gehalt        = p_ghlt
    telefonnummer = p_tlfn
    wohnort       = p_whno
    familienstand = p_fmst
    vorname       = p_vorn
    berufstitel   = p_berf
    raumnummer    = p_raum
    emailadresse  = p_mail
    adresse       = p_adrs

    WHERE nummer = is_table-nummer.

  ENDMETHOD.

  METHOD zeig_alv.

    DATA: layout TYPE	LVC_S_LAYO.

    REFRESH: it_table.

    SELECT * FROM zmc_perab INTO CORRESPONDING FIELDS OF TABLE it_table.

    layout-sel_mode = 'A'.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
     EXPORTING
       I_CALLBACK_PROGRAM                = sy-repid
       I_STRUCTURE_NAME                  = 'ZMC_PERAB'
       IS_LAYOUT_LVC                     = layout
      TABLES
        t_outtab                          = it_table.

  ENDMETHOD.

ENDCLASS.

DATA: mein_obj TYPE REF TO lcl_cls.
*************Das Ende der Definierung von unserer localen Klasse*********

*************************************************************************
" Das Ereignis INITIALIZATION (Arbeitet erstmal!)
*************************************************************************
INITIALIZATION.

  ptext  = 'Hier können Sie die Liste verwalten.'.
  pnum   = 'Personal Nummer'.
  pnam   = 'Personal Name'.
  pvor   = 'Personal Vorname'.
  pgeb   = 'Personal Geburtsdatum'.
  pber   = 'Personal Berufstitel'.
  pgeh   = 'Personal Gehalt'.
  prau   = 'Personal Raumnummer'.
  ptel   = 'Personal Telefonnummer'.
  pmai   = 'Personal E-Mail Adresse'.
  pwoh   = 'Personal Wohnort'.
  padr   = 'Personal Adresse'.
  pfam   = 'Personal Familienstand'.
  p1 = p2 = p3 = p4 = p5 = p6 = p7 = p8 = p9 = p10 = p11 = p12 = ':'.
  txt1   = 'SPEICHERN'.
  txt2   = 'FINDEN'.
  txt3   = 'KLÄREN'.
  txt4   = 'LÖSCHEN'.
  txt5   = 'AKTUALISIEREN'.
  txt6   = 'ZEIG ALV'.
  gap1   = '           '.
  gap2   = '             '.
  gap3   = '             '.
  gap4   = '          '.
  btname = 'Speichern'.

  CREATE OBJECT mein_obj.
****************Das Ende des Ereignises INITIALIZATION*******************


*************************************************************************
" Das Ereignis AT SELECTION-SCREEN OUTPUT
*************************************************************************
AT SELECTION-SCREEN OUTPUT.

  IF rb_1 = 'X'.
    LOOP AT SCREEN.
      btname = 'Speichern'.

      IF screen-name = 'P_NUMM'.
        screen-input = '0'.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_2 = 'X'.
    LOOP AT SCREEN.
      btname = 'Finden'.

      IF screen-name = 'P_NAME' OR screen-name = 'P_VORN' OR
         screen-name = 'P_GEBD' OR screen-name = 'P_BERF' OR
         screen-name = 'P_GHLT' OR screen-name = 'P_RAUM' OR
         screen-name = 'P_TLFN' OR screen-name = 'P_MAIL' OR
         screen-name = 'P_WHNO' OR screen-name = 'P_ADRS' OR
         screen-name = 'P_FMST' OR screen-name = 'P_BERF' OR
         screen-name = 'P_GEBD' OR screen-name = 'P_BERF'.

         screen-input = '0'.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_3 = 'X'.
    LOOP AT SCREEN.
      btname = 'Klären'.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_4 = 'X'.
    LOOP AT SCREEN.
      btname = 'Löschen'.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_5 = 'X'.
    LOOP AT SCREEN.
      btname = 'Aktualisieren'.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_6 = 'X'.
    LOOP AT SCREEN.
      btname = 'Zeig ALV'.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
****************Das Ende des Ereignises AT SELECTION-SCREEN OUTPUT*******


*************************************************************************
" Das Ereignis AT SELECTION-SCREEN:
*************************************************************************
AT SELECTION-SCREEN.

CASE sscrfields.

  WHEN 'PSHB'.

    IF btname = 'Speichern'.

      CALL METHOD mein_obj->speichern EXPORTING nummer        = p_numm
                                                name          = p_name
                                                vorname       = p_vorn
                                                geburtsdatum  = p_gebd
                                                berufstitel   = p_berf
                                                gehalt        = p_ghlt
                                                raumnummer    = p_raum
                                                telefonnummer = p_tlfn
                                                emailadresse  = p_mail
                                                wohnort       = p_whno
                                                adresse       = p_adrs
                                                familienstand = p_fmst.
    ENDIF.

    IF btname = 'Finden'.

      CALL METHOD mein_obj->finden EXPORTING nummer = p_numm.

    ENDIF.

    IF btname = 'Klären'.

      CALL METHOD mein_obj->klaeren.

    ENDIF.

    IF btname = 'Löschen'.

      CALL METHOD mein_obj->loeschen EXPORTING nummer = p_numm.

    ENDIF.

    IF btname = 'Aktualisieren'.

      CALL METHOD mein_obj->aktual EXPORTING name          = p_name
                                             vorname       = p_vorn
                                             geburtsdatum  = p_gebd
                                             berufstitel   = p_berf
                                             gehalt        = p_ghlt
                                             raumnummer    = p_raum
                                             telefonnummer = p_tlfn
                                             emailadresse  = p_mail
                                             wohnort       = p_whno
                                             adresse       = p_adrs
                                             familienstand = p_fmst.
    ENDIF.

    IF btname = 'Zeig ALV'.

      CALL METHOD mein_obj->zeig_alv.

    ENDIF.

ENDCASE.
******************Das Ende des Ereignises AT SELECTION-SCREEN************

" Weil wir niemals F8 benutzen, haben wir kein Ereignis als START-OF-SELECTION.
