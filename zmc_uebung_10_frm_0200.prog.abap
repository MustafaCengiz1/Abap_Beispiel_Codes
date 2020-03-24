*----------------------------------------------------------------------*
***INCLUDE ZMC_UEBUNG_10_FRM_0200.
*----------------------------------------------------------------------*
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

  IF gr_alvgrid_2 IS INITIAL .

    CREATE OBJECT gr_ccontainer_2
      EXPORTING
        container_name = 'CONTAINER_2'.

    CREATE OBJECT gr_alvgrid_2
      EXPORTING
        i_parent = gr_ccontainer_2.

    CALL METHOD gr_alvgrid_2->set_table_for_first_display
      EXPORTING
*       is_variant           =
*       i_save               =
*       i_default            = 'X'
        is_layout            = gs_layout_2
*       is_print             =
*       it_special_groups    =
*        it_toolbar_excluding = gt_exclude
*       it_hyperlink         =
*       it_alv_graphics      =
*       it_except_qinfo      =
*       ir_salv_adapter      =
      CHANGING
        it_outtab            = gt_sflight[]
        it_fieldcatalog      = gt_fieldcat_2.


  ELSE.

    CALL METHOD gr_alvgrid_2->check_changed_data.
    CALL METHOD gr_alvgrid_2->refresh_table_display.

  ENDIF.

ENDFORM.
