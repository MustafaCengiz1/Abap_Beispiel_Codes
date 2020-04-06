REPORT zmc_uebung_14.

" In diesem Beispiel haben wir ein globales Class generiert.
" Mit dem Transactionscode se24 haben wir unser Class und
" Methoden (und natürlich Parameters von Methoden) erzeugt.
" Hardcoden können Sie unter finden.

DATA: mein_beispiel TYPE REF TO zmc_sprache_alv,
      gt_table TYPE zmc_sprache_tt,
      gt_fcat TYPE lvc_t_fcat.

CREATE OBJECT mein_beispiel.

CALL METHOD mein_beispiel->zeile_hin
  EXPORTING
    vorname = 'BILL'
    name    = 'GATES'
    sprache = 'ENGLISCH'.

**********************************************************
*Der Quellcode von dem Method zeile_hin

*PARAMETERS:
*
*value( VORNAME )	TYPE ZMC_KURSVOR
*value( NAME )      TYPE ZMC_KURSNAM
*value( SPRACHE )	TYPE ZMC_KURSSPR


*  method ZEILE_HIN.
*    DATA: ls_table TYPE zmc_sprache.
*    ls_table-vorname = vorname.
*    ls_table-name = name.
*    ls_table-sprache = sprache.
*    INSERT INTO zmc_sprache VALUES ls_table.
*  endmethod.
**********************************************************

CALL METHOD mein_beispiel->nimm_data
  IMPORTING
    t_outtab = gt_table[].

**********************************************************
*Der Quellcode von dem Method nimm_data

*PARAMETERS:
*
*value( T_OUTTAB )  TYPE ZMC_SPRACHE_TT


*  method NIMM_DATA.
*    SELECT * FROM zmc_sprache INTO CORRESPONDING FIELDS OF TABLE t_outtab.
*  endmethod.
**********************************************************

CALL METHOD mein_beispiel->alv_zeigen
  EXPORTING
    structure_name      = 'ZMC_SPRACHE'
    internal_table_name = gt_table
  CHANGING
    fieldcatalog        = gt_fcat.
**********************************************************
*Der Quellcode von dem Method alv_zeigen

*PARAMETERS:
*
*value( STRUCTURE_NAME )      TYPE DD02L-TABNAME
*value( INTERNAL_TABLE_NAME )	TYPE STANDARD TABLE
*value( FIELDCATALOG )        TYPE LVC_T_FCAT


*  METHOD alv_zeigen.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = structure_name
*      CHANGING
*        ct_fieldcat      = fieldcatalog.
*    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
*      EXPORTING
*        i_callback_program = sy-repid
*        it_fieldcat_lvc    = fieldcatalog
*      TABLES
*        t_outtab           = internal_table_name.
*  ENDMETHOD.
**********************************************************
