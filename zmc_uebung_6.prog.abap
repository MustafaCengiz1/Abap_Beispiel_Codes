REPORT zmc_uebung_6.

" Datenübernahme aus Excel ins interne Format

TYPE-POOLS truxs.

TYPES : BEGIN OF t_airtab,
          firma    LIKE sflight-carrid,
          ab_stadt LIKE spfli-cityfrom,
          ab_hafen LIKE spfli-airpfrom,
          an_stadt LIKE spfli-cityto,
          r_datum  LIKE sflight-fldate,
          r_zeit   LIKE spfli-fltime,
        END OF t_airtab.

DATA : airtab          TYPE STANDARD TABLE OF t_airtab,
       lv_tab_raw_data TYPE  truxs_t_text_data.


SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001 NO INTERVALS.
PARAMETERS: p_datei LIKE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK a1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_datei.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_DATEI'
    IMPORTING
      file_name  = p_datei.

START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = lv_tab_raw_data
      i_filename           = p_datei
    TABLES
      i_tab_converted_data = airtab
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

END-OF-SELECTION.
***********************************************************************
* Wegen eines Problems von System funktioniert der Report nicht. Aber
* die Reinfolge der Codes ist korrekt.
***********************************************************************
