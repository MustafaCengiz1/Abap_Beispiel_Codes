*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_FRM_0200.
*----------------------------------------------------------------------*
" Class Event Handlung, Hotspot, Pushbutton, Färbung Drilldow und Vrnte.
*&---------------------------------------------------------------------*
*&      Form  ZEIG_ALV_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ZEIG_ALV_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zeig_alv_2 .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = gt_fieldcat_2.

  LOOP AT gt_fieldcat_2 INTO gs_fieldcat_2.

    CASE gs_fieldcat_2-fieldname.
      WHEN 'PLANETYPE'.
        gs_fieldcat_2-web_field = 'PLNTYPE_HANDLE'.
      WHEN 'SEATSOCC'.
        gs_fieldcat_2-drdn_hndl = '1'.
    ENDCASE.

    MODIFY gt_fieldcat_2 FROM gs_fieldcat_2.

  ENDLOOP.

  gs_layout_2-ctab_fname = 'CELLCOLORS'.
  gs_layout_2-stylefname = 'CELLSTYLES'.
  gs_layout_2-sel_mode   = 'A'.
  gs_layout_2-no_toolbar = 'X'.

  IF gr_alvgrid_2 IS INITIAL.

    CREATE OBJECT gr_ccontainer_2
      EXPORTING
        container_name = 'CONTAINER_2'.

    CREATE OBJECT gr_alvgrid_2
      EXPORTING
        i_parent = gr_ccontainer_2.

    CREATE OBJECT gr_event_handler.

    SET HANDLER gr_event_handler->handle_button_click  FOR gr_alvgrid_2.
    SET HANDLER gr_event_handler->handle_double_click  FOR gr_alvgrid_2.
    SET HANDLER gr_event_handler->handle_hotspot_click FOR gr_alvgrid_2.

    CALL METHOD gr_alvgrid_2->set_table_for_first_display
      EXPORTING
*       i_save          =
*       i_default       = 'X'
        is_layout       = gs_layout_2
*       is_print        =
*       it_special_groups    =
*       it_toolbar_excluding = gt_exclude
        it_hyperlink    = gt_hype
*       it_alv_graphics =
*       it_except_qinfo =
*       ir_salv_adapter =
      CHANGING
        it_outtab       = gt_sflight[]
        it_fieldcatalog = gt_fieldcat_2.

    CALL METHOD gr_alvgrid_2->set_drop_down_table
      EXPORTING
        it_drop_down = gt_dropdown.

  ELSE.

    CALL METHOD gr_alvgrid_2->check_changed_data.
    CALL METHOD gr_alvgrid_2->refresh_table_display.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_BUTTON_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ES_COL_ID  text
*      -->P_ES_ROW_NO  text
*----------------------------------------------------------------------*
FORM handle_button_click  USING    p_es_col_id TYPE lvc_s_col
                                   p_es_row_no TYPE lvc_s_roid.

  READ TABLE gt_sflight INTO gs_sflight INDEX p_es_row_no-row_id.

  MESSAGE i000(vaca) WITH 'Booking Total: ' gs_sflight-paymentsum.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW  text
*      -->P_E_COLUMN  text
*      -->P_ES_ROW_NO  text
*----------------------------------------------------------------------*
FORM handle_double_click  USING    p_e_row     TYPE lvc_s_row
                                   p_e_column  TYPE lvc_s_col
                                   p_es_row_no TYPE lvc_s_roid.

  DATA: mess_wort TYPE string.

  SHIFT p_e_row-index LEFT DELETING LEADING '0'.

  CONCATENATE 'Sie haben die ' p_e_row '. Zeile geklickt.' INTO mess_wort.

  CONDENSE mess_wort.

  MESSAGE i000(vaca) WITH mess_wort.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW_ID  text
*      -->P_E_COLUMN_ID  text
*      -->P_ES_ROW_NO  text
*----------------------------------------------------------------------*
FORM handle_hotspot_click  USING    p_e_row_id    TYPE lvc_s_row
                                    p_e_column_id TYPE lvc_s_col
                                    p_es_row_no   TYPE lvc_s_roid .

  MESSAGE 'Das Flugdatum, Sie geklickt haben, ist im Jahr 2019.' TYPE 'I'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HYPERLINKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM hyperlinks.

  DATA: ls_hype TYPE lvc_s_hype.

  ls_hype-handle = '1'.
  ls_hype-href   = 'http://www.boeing.com'.
  APPEND ls_hype TO gt_hype.

  ls_hype-handle = '2'.
  ls_hype-href   = 'http://www.airbus.com'.
  APPEND ls_hype TO gt_hype.

  LOOP AT gt_sflight INTO gs_sflight.

    IF gs_sflight-planetype      = '747-400'.
      gs_sflight-plntype_handle = '1'.
    ELSEIF
       gs_sflight-planetype      = 'A310-300'.
      gs_sflight-plntype_handle = '2'.
    ENDIF.

    MODIFY gt_sflight FROM gs_sflight.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DROPDOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dropdown.

  DATA: seatsocc TYPE n LENGTH 3.

  LOOP AT gt_sflight INTO gs_sflight.

    seatsocc = gs_sflight-seatsocc.

    gs_dropdown-handle = '1'.
    gs_dropdown-value  = seatsocc.
    APPEND gs_dropdown TO gt_dropdown.

  ENDLOOP.

ENDFORM.
