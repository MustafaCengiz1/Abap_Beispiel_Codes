*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_11_TOP
*&---------------------------------------------------------------------*
TABLES: zmc_perab.

DATA: BEGIN OF gt_table_1 OCCURS 0,
        selektieren TYPE c LENGTH 1.
        INCLUDE STRUCTURE zmc_perab.
DATA: END OF gt_table_1.

DATA: BEGIN OF gt_table_2 OCCURS 0,
        selektieren TYPE c LENGTH 1.
        INCLUDE STRUCTURE zmc_perab.
DATA: END OF gt_table_2.

DATA: gs_table_1 LIKE LINE OF gt_table_1,
      gs_table_2 LIKE LINE OF gt_table_2.

DATA: ok_code LIKE sy-ucomm.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_nummer for zmc_perab-nummer.
SELECTION-SCREEN END OF BLOCK a1.
