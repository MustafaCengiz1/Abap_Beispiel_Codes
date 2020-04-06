REPORT zmc_uebung_13.

" Wie kann ich ein Parent Class definieren und benutzen.

CLASS eltern DEFINITION.

  PUBLIC SECTION.
    DATA: text_eltern(30) VALUE 'Ich bin der Text von Eltern.'.
    METHODS: eltern_method.

ENDCLASS.

CLASS kind DEFINITION INHERITING FROM eltern.

  PUBLIC SECTION.
    METHODS: kind_method.

ENDCLASS.

CLASS eltern IMPLEMENTATION.

  METHOD eltern_method.
    WRITE: text_eltern.
  ENDMETHOD.

ENDCLASS.

CLASS kind IMPLEMENTATION.

  METHOD kind_method.
    WRITE: text_eltern, 'Aber Sie haben mich von Method eltern geerbt.'.
  ENDMETHOD.

ENDCLASS.

DATA: beispiel_eltern TYPE REF TO eltern,
      beispiel_kind   TYPE REF TO kind.

START-OF-SELECTION.

CREATE OBJECT: beispiel_eltern, beispiel_kind.

CALL METHOD beispiel_eltern->eltern_method.
SKIP 1.
ULINE.

CALL METHOD beispiel_kind->kind_method.
ULINE.
