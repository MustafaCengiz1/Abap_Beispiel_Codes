REPORT zmc_uebung_1.

" Umwandlung die Stunden in die Sekunden

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001 NO INTERVALS.
PARAMETERS: p1 TYPE i, " die Stunden
            p2 TYPE i, " die Minuten
            p3 TYPE i. " die Sekunden
SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-002 NO INTERVALS.
PARAMETERS: das_res TYPE i. " das Resultat
SELECTION-SCREEN END OF BLOCK a2.

DATA: p4 TYPE i.

START-OF-SELECTION.

AT SELECTION-SCREEN OUTPUT.

  IF p1 > 0.
    p4 = p1 * 3600.
  ENDIF.

  IF p2 > 0.
    p4 = p4 + 60 * p2.
  ENDIF.

  IF p3 > 0.
    p4 = p4 + p3.
  ENDIF.

  LOOP AT SCREEN.
    IF screen-name = 'DAS_RES'.
      das_res = p4.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
