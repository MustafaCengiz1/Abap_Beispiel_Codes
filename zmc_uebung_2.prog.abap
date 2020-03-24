REPORT zmc_uebung_2.

TABLES: sscrfields.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001 NO INTERVALS.
PARAMETERS: p1 TYPE i, " die Stunden
            p2 TYPE i, " die Minuten
            p3 TYPE i. " die Sekunden
SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-002 NO INTERVALS.
PARAMETERS: das_res TYPE i. " das Resultat
SELECTION-SCREEN END OF BLOCK a2.

SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.

DATA: p4 TYPE i.

INITIALIZATION.
  sscrfields-functxt_01 = 'Kalkulieren'.
  sscrfields-functxt_02 = 'Löschen'.
* sscrfields-search_btn = 'ICON_GENERATE'.
* Weil wir kein PF-STATUS haben, können wir kein ICON einsetzen.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'FC01'.
    PERFORM kalkulieren.
  ELSEIF sscrfields-ucomm = 'FC02'.
    PERFORM loschen.
  ENDIF.

START-OF-SELECTION.

AT SELECTION-SCREEN OUTPUT.

  PERFORM kalkulieren.

  LOOP AT SCREEN.
    IF screen-name = 'DAS_RES'.
      das_res     = p4.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  KALKULIEREN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM kalkulieren .

  IF p1 > 0.
    p4 = p1 * 3600.
  ENDIF.

  IF p2 > 0.
    p4 = p4 + 60 * p2.
  ENDIF.

  IF p3 > 0.
    p4 = p4 + p3.
  ENDIF.

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
  CLEAR: p1, p2, p3, p4, das_res.
  MODIFY SCREEN.
ENDFORM.
