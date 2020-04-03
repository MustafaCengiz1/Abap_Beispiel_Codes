*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_10_CLS
*&---------------------------------------------------------------------*

" Class Event Handlung, Hotspot, Pushbutton, Färbung Drilldow und Vrnte.

CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.

    METHODS:

      handle_button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no,

      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,

      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_button_click.
    PERFORM handle_button_click USING es_col_id es_row_no.
  ENDMETHOD.

  METHOD  handle_hotspot_click.
    PERFORM handle_hotspot_click USING e_row_id e_column_id es_row_no.
  ENDMETHOD.

  METHOD handle_double_click.
    PERFORM handle_double_click USING e_row e_column es_row_no.
  ENDMETHOD.

ENDCLASS.

DATA: gr_event_handler TYPE REF TO lcl_event_handler .
