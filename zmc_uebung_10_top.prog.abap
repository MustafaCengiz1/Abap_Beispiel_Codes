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

DATA: BEGIN OF gt_list OCCURS 0,
        sira TYPE n LENGTH 3.
        INCLUDE STRUCTURE sflight.
DATA: rowcolor(4).
DATA: cellcolors    TYPE lvc_t_scol.
DATA: carrid_handle TYPE int4.
DATA: connid_handle TYPE int4.
*DATA: dd_hndl       TYPE int4.
DATA: cellstyles TYPE lvc_t_styl.
DATA: END OF gt_list.

DATA: gs_list LIKE LINE OF gt_list.

DATA: gt_sort TYPE lvc_t_sort,
      gt_filt TYPE lvc_t_filt.

DATA: gs_cellcolor TYPE lvc_s_scol,
      gt_hype      TYPE lvc_t_hype,
      gt_ddval     TYPE lvc_t_drop.

DATA: gs_variant TYPE disvariant.
DATA: ok_code LIKE sy-ucomm.
DATA: gt_exclude TYPE ui_functions.
DATA: gt_zellen TYPE lvc_t_cell.

  DATA: gt_sflight LIKE sflight OCCURS 0,
        gs_sflight LIKE LINE OF gt_sflight.
