*&---------------------------------------------------------------------*
*& Report  ZMC_UBUNG_16
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZMC_UEBUNG_16.

" In diesem Beispiel werden wir sehen den Unterschied
" zwischen Instance und Static Atrributes sehr einfach.

CLASS mein_lcl DEFINITION.

  PUBLIC SECTION.

    DATA: num_01 TYPE i,
          num_02 TYPE i.

    CLASS-DATA: num_03 TYPE i,
                num_04 TYPE i.

    METHODS: method_01 EXPORTING result TYPE i,
             method_02.

ENDCLASS.

CLASS mein_lcl IMPLEMENTATION.

  METHOD method_01.
    result = num_01 + num_02.
    WRITE:/ result.
  ENDMETHOD.

  METHOD method_02.
    num_03 = num_03 + 3.
    num_04 = num_04 + 4.
    WRITE:/ num_03, num_04.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA: mein_obj_01 TYPE REF TO mein_lcl,
        mein_obj_02 TYPE REF TO mein_lcl.

  DATA: gv_result_01 TYPE i,
        gv_result_02 TYPE i.

  CREATE OBJECT: mein_obj_01, mein_obj_02.

  mein_obj_01->num_01 = 10.
  mein_obj_01->num_02 = 20.

  CALL METHOD mein_obj_01->method_01 IMPORTING result = gv_result_01.
  CALL METHOD mein_obj_01->method_02.

  SKIP 1.
  ULINE.

  " Nach der Erstellung des Objekts mein_obj_02 ist num_01 und num_02 ist null,
  " aber num_03 = 3 und num_04 = 4 sind. Sie haben ihre Werte geleitet.
  " In einem anderen Objekt (hier ist das mein_obj_02) sind sie nicht null geworden.

  mein_obj_02->num_01 = mein_obj_02->num_01 + 5.
  mein_obj_02->num_02 = mein_obj_02->num_02 + 5.

  CALL METHOD mein_obj_02->method_01 IMPORTING result = gv_result_02.
  CALL METHOD mein_obj_02->method_02.
