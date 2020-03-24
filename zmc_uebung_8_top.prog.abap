*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_8_TOP
*&---------------------------------------------------------------------*
TABLES: zmc_kurs_2.
DATA: gc_cont TYPE REF TO cl_gui_custom_container,
      gc_grid TYPE REF TO cl_gui_alv_grid,
      gs_layo TYPE        lvc_s_layo,
      gt_fcat TYPE        lvc_t_fcat.

DATA: gt_table LIKE zmc_kurs_2 OCCURS 0,
      gs_table LIKE LINE OF gt_table.

DATA: ok_code LIKE sy-ucomm.

DATA: kurs_nummer TYPE n LENGTH 5.

DATA: gt_kurs LIKE         zmc_kurs_2 OCCURS 0,
      gs_kurs LIKE LINE OF gt_kurs,
      gs_kur2 LIKE LINE OF gt_kurs.

DATA: lc_cont   TYPE REF TO cl_gui_custom_container,
      lc_grid   TYPE REF TO cl_gui_alv_grid.
