*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_9_TOP
*&---------------------------------------------------------------------*

" Ein Beispiel für eine dynamische Tabelle und E-Mail Sendung

DATA: BEGIN OF gt_table OCCURS 0,
        vorname LIKE  zmc_sprache-vorname,
        name    LIKE  zmc_sprache-name,
        sprache LIKE  zmc_sprache-sprache,
      END OF gt_table.

DATA: gs_table LIKE LINE OF gt_table.

DATA: gt_fcat	TYPE lvc_t_fcat,
      gs_fcat LIKE LINE OF gt_fcat,
      gs_layo TYPE lvc_s_layo.

DATA: BEGIN OF gt_vnname OCCURS 0,
        vorname LIKE  zmc_sprache-vorname,
        name    LIKE  zmc_sprache-name,
      END OF gt_vnname.

DATA: gs_vnname LIKE LINE OF gt_vnname.

DATA: BEGIN OF gt_sprache OCCURS 0,
        sprache LIKE zmc_sprache-sprache,
      END OF gt_sprache.

DATA: gs_sprache LIKE LINE OF gt_sprache.

DATA: gc_cont TYPE REF TO cl_gui_custom_container,
      gc_grid TYPE REF TO cl_gui_alv_grid.

FIELD-SYMBOLS: <t_tab>  TYPE STANDARD TABLE,
               <st_tab>,
               <fs_val>   TYPE any,
               <fs_val_2> TYPE any.

DATA: dt_1 TYPE REF TO data,
      ds_1 TYPE REF TO data.

DATA: ok_code LIKE sy-ucomm,
      flag(1),
      flag2(1).
