*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_FRM.
*----------------------------------------------------------------------*
" Class Event Handlung, Hotspot, Pushbutton, Färbung Drilldow und Vrnte.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE gt_list.

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

  IF gr_alvgrid IS INITIAL .

    CREATE OBJECT gr_ccontainer
      EXPORTING
        container_name = 'CONTAINER'.

    CREATE OBJECT gr_alvgrid
      EXPORTING
        i_parent = gr_ccontainer.

    gs_variant-report = sy-repid.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        is_variant           = gs_variant
        i_save               = 'A'
*       i_default            = 'X'
        is_layout            = gs_layout
*       is_print             =
*       it_special_groups    =
        it_toolbar_excluding = gt_exclude
*       it_hyperlink         =
*       it_alv_graphics      =
*       it_except_qinfo      =
*       ir_salv_adapter      =
      CHANGING
        it_outtab            = gt_list[]
        it_fieldcatalog      = gt_fieldcat
        it_sort              = gt_sort[]
        it_filter            = gt_filt.

  ELSE.

    CALL METHOD gr_alvgrid->set_sort_criteria
      EXPORTING
        it_sort = gt_sort.

    CALL METHOD gr_alvgrid->set_filter_criteria
      EXPORTING
        it_filter = gt_filt.

    CALL METHOD gr_alvgrid->check_changed_data.
    CALL METHOD gr_alvgrid->refresh_table_display.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VOR_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vor_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VOR_LAYO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vor_layo .

  gs_layout-zebra      = 'X' .
  gs_layout-sel_mode   = 'D' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VERSTECKEN_BUTTONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM verstecken_buttons  CHANGING pt_exclude TYPE ui_functions .

  DATA: ls_exclude LIKE LINE OF pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_maximum .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_minimum .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_print .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_pc_file .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_print_back .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_print_prev .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_reprep .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_subtot .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_sum .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_average .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_mb_sum .
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_mb_subtot .
  APPEND ls_exclude TO pt_exclude.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_SORT  text
*----------------------------------------------------------------------*
FORM sort_table  CHANGING pt_sort TYPE lvc_t_sort.

  DATA ls_sort TYPE lvc_s_sort .

  ls_sort-spos      = '1'.
  ls_sort-fieldname = 'SEATSOCC' .
  ls_sort-up        = space. "von A bis Z
  ls_sort-down      = 'X'.   "von Z bis A
  APPEND ls_sort TO pt_sort.

  ls_sort-spos      = '2' .
  ls_sort-fieldname = 'FLDATE'.
  ls_sort-up        = space .
  ls_sort-down      = 'X' . "von Z bis A
  APPEND ls_sort TO pt_sort .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILTER_LISTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FILT  text
*----------------------------------------------------------------------*
FORM filter_liste  CHANGING pt_filt TYPE lvc_t_filt.

  DATA: ls_filt   TYPE          lvc_s_filt,
        lt_fields TYPE TABLE OF sval,
        ls_fields LIKE LINE OF  lt_fields.

  ls_fields-tabname   = 'ZMC_2_DATUM'.
  ls_fields-fieldname = 'DATUM1'.
  ls_fields-fieldtext = 'VON'.
  APPEND ls_fields TO lt_fields.

  ls_fields-tabname   = 'ZMC_2_DATUM'.
  ls_fields-fieldname = 'DATUM2'.
  ls_fields-fieldtext = 'BIS'.
  APPEND ls_fields TO lt_fields.

  CLEAR: ls_fields.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title = 'Sie können hier das Zeitintervall eingeben.'
    TABLES
      fields      = lt_fields.

  READ TABLE lt_fields INTO ls_fields INDEX 1.
  ls_filt-low = ls_fields-value.
  CLEAR: ls_fields.

  READ TABLE lt_fields INTO ls_fields INDEX 2.
  ls_filt-high = ls_fields-value.
  CLEAR: ls_fields.

  ls_filt-fieldname = 'FLDATE'.
  ls_filt-sign = 'E'.
  ls_filt-option = 'BT'.
  APPEND ls_filt TO pt_filt.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUSGEWAHLT_ZELLEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_ZELLEN  text
*----------------------------------------------------------------------*
FORM ausgewahlt_zellen  CHANGING pt_zellen TYPE lvc_t_cell.

  DATA: ls_zellen TYPE lvc_s_cell,
        ls_zell_2 TYPE lvc_s_cell,
        lt_row    TYPE lvc_s_row OCCURS 0,
        ls_row    TYPE lvc_s_row,
        ls_col    TYPE lvc_s_scol,
        counter   TYPE i,
        lines     TYPE i,
        row_id    TYPE i,
        lines_2   TYPE i.

  CALL METHOD gr_alvgrid->get_selected_cells
    IMPORTING
      et_cell = pt_zellen.

  LOOP AT pt_zellen INTO ls_zellen.
    ls_row-index = ls_zellen-row_id.
    COLLECT ls_row INTO lt_row.

    ls_col-fname = ls_zellen-col_id.
    ls_col-color-col = '7'.
    ls_col-color-int = '1'.

    APPEND ls_col TO gt_sflight-cellcolors.
  ENDLOOP.

  CLEAR: gs_list, ls_row, ls_zellen.

  LOOP AT lt_row INTO ls_row.

    READ TABLE gt_list INTO  gs_list INDEX ls_row-index.
    MOVE-CORRESPONDING gs_list TO gs_sflight.
    APPEND gs_sflight TO gt_sflight.

    CLEAR:gs_list, ls_zellen, gs_sflight.

  ENDLOOP.

  DESCRIBE TABLE gt_sflight LINES lines_2.

  LOOP AT gt_sflight INTO gs_sflight.

    counter = counter + 1.

    LOOP AT pt_zellen INTO ls_zellen.

      DESCRIBE TABLE pt_zellen LINES lines.

      IF lines > 1.

        READ TABLE pt_zellen INDEX 2 INTO ls_zell_2.

        ls_col-fname     = ls_zellen-col_id.
        ls_col-color-col = '7'.
        ls_col-color-int = '1'.

        APPEND ls_col TO gs_sflight-cellcolors.

        row_id = ls_zellen-row_id.

        DELETE TABLE pt_zellen FROM ls_zellen.

        IF ls_zell_2-row_id NE ls_zellen-row_id.
          MODIFY gt_sflight INDEX counter FROM gs_sflight.
          EXIT.
        ENDIF.

      ELSE.

        ls_col-fname     = ls_zellen-col_id.
        ls_col-color-col = '7'.
        ls_col-color-int = '1'.

        APPEND ls_col TO gs_sflight-cellcolors.

        MODIFY gt_sflight INDEX lines_2 FROM gs_sflight.

      ENDIF.

    ENDLOOP.

  ENDLOOP.

  DATA ls_style TYPE lvc_s_styl .

  LOOP AT gt_sflight INTO gs_sflight.

    CLEAR: ls_style.

    IF gs_sflight-paymentsum > 48231.

      ls_style-fieldname = 'PAYMENTSUM'.
      ls_style-style = cl_gui_alv_grid=>mc_style_button.
      APPEND ls_style TO gs_sflight-cellstyles.

    ENDIF.

    IF gs_sflight-fldate > '20190101'.

      CLEAR: ls_style.
      ls_style-fieldname = 'FLDATE'.
      ls_style-style = cl_gui_alv_grid=>mc_style_hotspot.
      INSERT ls_style INTO TABLE gs_sflight-cellstyles.

      " Hier können wir den Befehl 'APPEND' nicht benutzen, weil
      " cellstyles ein sorted table ist.

    ENDIF.

    MODIFY gt_sflight FROM gs_sflight.

    CLEAR: gs_sflight.

  ENDLOOP.

  CALL SCREEN 0200.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_VARIANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_variant .

  gs_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = gs_variant
     I_SAVE     = 'X'
     I_DISPLAY_VIA_GRID        = 'X'
    IMPORTING
      es_variant = gs_variant.

  IF sy-subrc = 0.
    variant = gs_variant-variant.
  ENDIF.

ENDFORM.
