REPORT zmc_uebung_17.


" In diesem beispiel Code werden wir die Unterschiede zwischen
      " TYPE STANDARD TABLE,
      " TYPE SORTED TABLE,
      " TYPE SORTED TABLE sehen.

" Erstmal die Definierung der Tabellen ist unterschiedlich.

" Eine Standard Tabelle ist wie eine Tüte.
" Was hinzugefügt wird, bleibt in dieser Tüte.

" Eine Sorted Tabelle nimmt eine Zeile nicht auf,
" wenn es schon eine Zeile mit den gleichen key Feldern gibt.
" Zusätzlich sortiert (in Bezug auf die key Felder)
" eine Sorted Tabelle immer die Zeile drinnen.

" Eine Hashed Tabelle (wie Sorted Tabelle) nimmt eine Zeile nicht auf,
" wenn es schon eine Zeile mit den gleichen key Feldern gibt. Aber diese
" Tabelle sortiert die Zeile drinnen nicht. Welche Zeile kommt endlich,
" dann bleibt sie endlich.


SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-002.

PARAMETERS: p_carr_1 TYPE s_carr_id,
            p_conn_1 TYPE s_conn_id,
            p_flda_1 TYPE s_date,
            p_carr_2 TYPE s_carr_id,
            p_conn_2 TYPE s_conn_id,
            p_flda_2 TYPE s_date,
            p_carr_3 TYPE s_carr_id,
            p_conn_3 TYPE s_conn_id,
            p_flda_3 TYPE s_date,
            p_carr_4 TYPE s_carr_id,
            p_conn_4 TYPE s_conn_id,
            p_flda_4 TYPE s_date.

SELECTION-SCREEN END OF BLOCK a1.

CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.

    DATA: gs_structure TYPE sflight.

" Definierung der Tabellen!!!
    CLASS-DATA: gt_table_01 TYPE STANDARD TABLE OF sflight,
                gt_table_02 TYPE SORTED TABLE OF   sflight WITH UNIQUE KEY carrid connid fldate,
                gt_table_03 TYPE HASHED TABLE OF   sflight WITH UNIQUE KEY carrid connid fldate.

    METHODS: method_01 IMPORTING ls_sflight TYPE sflight,
             method_02 IMPORTING ls_sflight TYPE sflight,
             method_03 IMPORTING ls_sflight TYPE sflight,
             loop_standard,
             loop_sorted,
             loop_hashed.
ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.

  METHOD method_01.
    APPEND ls_sflight TO gt_table_01.
  ENDMETHOD.

  METHOD method_02.
    INSERT ls_sflight INTO TABLE gt_table_02.
  ENDMETHOD.

  METHOD method_03.
    INSERT ls_sflight INTO  TABLE gt_table_03.
  ENDMETHOD.

  METHOD loop_standard.

    CLEAR gs_structure.
    WRITE:/ 'Hallo, ich bin eine Standart Tabelle'.

   LOOP AT gt_table_01 INTO gs_structure.
      WRITE:/ gs_structure-carrid,
              gs_structure-connid,
              gs_structure-currency,
              gs_structure-fldate,
              gs_structure-paymentsum,
              gs_structure-planetype,
              gs_structure-price,
              gs_structure-seatsmax,
              gs_structure-seatsocc.
    ENDLOOP.

  ENDMETHOD.

  METHOD loop_sorted.

    CLEAR gs_structure.
    WRITE:/ 'Hallo, ich bin eine Sorted Tabelle'.

    LOOP AT gt_table_02 INTO gs_structure.
      WRITE:/  gs_structure-carrid,
               gs_structure-connid,
               gs_structure-currency,
               gs_structure-fldate,
               gs_structure-paymentsum,
               gs_structure-planetype,
               gs_structure-price,
               gs_structure-seatsmax,
               gs_structure-seatsocc.
    ENDLOOP.

  ENDMETHOD.

  METHOD loop_hashed.

    CLEAR gs_structure.
    WRITE:/ 'Hallo, ich bin eine Hashed Tabelle'.

    LOOP AT gt_table_03 INTO gs_structure.
      WRITE:/ gs_structure-carrid,
              gs_structure-connid,
              gs_structure-currency,
              gs_structure-fldate,
              gs_structure-paymentsum,
              gs_structure-planetype,
              gs_structure-price,
              gs_structure-seatsmax,
              gs_structure-seatsocc.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

DATA: mein_obj   TYPE REF TO lcl_cls.
DATA: gs_sflight TYPE sflight.
DATA: counter    TYPE i.

INITIALIZATION.

  CREATE OBJECT mein_obj.

START-OF-SELECTION.

CALL METHOD mein_obj->loop_standard.
SKIP 1.
ULINE.

CALL METHOD mein_obj->loop_sorted.
SKIP 1.
ULINE.

CALL METHOD mein_obj->loop_hashed.

AT SELECTION-SCREEN OUTPUT.

  IF counter = 1.
    LOOP AT SCREEN.
      IF screen-name = 'P_CARR_1'.
        SELECT SINGLE * FROM sflight INTO CORRESPONDING FIELDS OF gs_sflight
          WHERE carrid = p_carr_1 AND
                connid = p_conn_1 AND
                fldate = p_flda_1.

        CALL METHOD mein_obj->method_01 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_02 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_03 EXPORTING ls_sflight = gs_sflight.

      ELSEIF screen-name = 'P_CARR_2'.

        SELECT SINGLE * FROM sflight INTO CORRESPONDING FIELDS OF gs_sflight
          WHERE carrid = p_carr_2 AND
                connid = p_conn_2 AND
                fldate = p_flda_2.

        CALL METHOD mein_obj->method_01 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_02 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_03 EXPORTING ls_sflight = gs_sflight.

      ELSEIF screen-name = 'P_CARR_3'.

        SELECT SINGLE * FROM sflight INTO CORRESPONDING FIELDS OF gs_sflight
          WHERE carrid = p_carr_3 AND
                connid = p_conn_3 AND
                fldate = p_flda_3.

        CALL METHOD mein_obj->method_01 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_02 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_03 EXPORTING ls_sflight = gs_sflight.

      ELSEIF screen-name = 'P_CARR_4'.

        SELECT SINGLE * FROM sflight INTO CORRESPONDING FIELDS OF gs_sflight
          WHERE carrid = p_carr_4 AND
                connid = p_conn_4 AND
                fldate = p_flda_4.

        CALL METHOD mein_obj->method_01 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_02 EXPORTING ls_sflight = gs_sflight.
        CALL METHOD mein_obj->method_03 EXPORTING ls_sflight = gs_sflight.

      ENDIF.
    ENDLOOP.
  ENDIF.

  counter = counter + 1.

" 18.04.2020, 20.46
