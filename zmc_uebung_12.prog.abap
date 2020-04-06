REPORT zmc_uebung_12.

" Wie kann ich ein lokales Class definieren.

CLASS mein_class DEFINITION.

  PUBLIC SECTION.
    DATA: mein_text(10).
    METHODS: zeigen_mit_datum,
             zeigen_mit_uzeit,
             zeigen_mit_beidem.

ENDCLASS.

CLASS mein_class IMPLEMENTATION.

  METHOD zeigen_mit_datum.
    WRITE: mein_text,
           sy-datum,
           'Das ist mein erstes Mal, dass ich ein Class implementiere.'.
  ENDMETHOD.

  METHOD zeigen_mit_uzeit.
    WRITE: mein_text,
           sy-uzeit,
           'Das ist mein erstes Mal, dass ich ein Class implementiere.'.
  ENDMETHOD.

  METHOD zeigen_mit_beidem.
    WRITE: mein_text,
           sy-datum,
           sy-uzeit,
           'Das ist mein erstes Mal, dass ich ein Class implementiere.'.
  ENDMETHOD.

ENDCLASS.

DATA: beispiel TYPE REF TO mein_class.

START-OF-SELECTION.       " Was passiert wenn ich f8 clicken.

  CREATE OBJECT beispiel. " Jetzt kann ich alle Methoden von meinem Class benutzen.

  beispiel->mein_text = 'Heute ist '.

  CALL METHOD beispiel->zeigen_mit_datum.
  ULINE.
  SKIP 1.

  CALL METHOD beispiel->zeigen_mit_uzeit.
  ULINE.
  SKIP 1.

  CALL METHOD beispiel->zeigen_mit_beidem.
  ULINE.
