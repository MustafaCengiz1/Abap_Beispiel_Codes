*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_10_TOP
*&---------------------------------------------------------------------*
DATA: gr_alvgrid    TYPE REF TO cl_gui_alv_grid,
      gr_ccontainer TYPE REF TO cl_gui_custom_container,
      gt_fieldcat   TYPE lvc_t_fcat,
      gs_fieldcat   TYPE lvc_s_fcat,
      gs_layout     TYPE lvc_s_layo.

DATA: gr_alvgrid_2    TYPE REF TO cl_gui_alv_grid,
      gr_ccontainer_2 TYPE REF TO cl_gui_custom_container,
      gt_fieldcat_2   TYPE lvc_t_fcat,
      gs_fieldcat_2   TYPE lvc_s_fcat,
      gs_layout_2     TYPE lvc_s_layo.

DATA: BEGIN OF gt_list OCCURS 0.
        INCLUDE STRUCTURE sflight.
DATA: END OF gt_list.

DATA: gs_list LIKE LINE OF gt_list.

DATA: gt_sort TYPE lvc_t_sort,
      gt_filt TYPE lvc_t_filt.

DATA: gs_cellcolor TYPE lvc_s_scol,
      gt_hype      TYPE lvc_t_hype,
      gt_ddval     TYPE lvc_t_drop.

DATA: gs_variant TYPE disvariant.
DATA: ok_code    LIKE sy-ucomm.
DATA: gt_exclude TYPE ui_functions.
DATA: gt_zellen  TYPE lvc_t_cell.

DATA: BEGIN OF gt_sflight OCCURS 0.
        INCLUDE STRUCTURE sflight.
DATA: cellcolors     TYPE lvc_t_scol.
DATA: cellstyles     TYPE lvc_t_styl.
DATA: plntype_handle TYPE int4.
DATA: seatsoc_handle TYPE int4.
DATA: END OF gt_sflight.

DATA: gs_sflight LIKE LINE OF gt_sflight.

DATA: gt_dropdown TYPE lvc_t_drop,
      gs_dropdown TYPE lvc_s_drop.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
PARAMETERS: variant TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK a1.
