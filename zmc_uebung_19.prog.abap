*&---------------------------------------------------------------------*
*& Report  ZMC_UBUNG_19
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZMC_UEBUNG_19.

" In diesem beispiel Code können wir sehen, was die Funktion von Constructor Method ist.
" Einfach nehmen wir nur carrid und connid vom Benutzer.
" Erstmal prüfen wir, ob die beiden Felder gefüllt sind.
" Danach sehen wir die Tabelle spfli an, ob es Informationen über die gegebenen carrid und connid gibt.
" Endlich wählen wir die Zeile von der Tabella sflight und schreiben alles.

" Dieses Program konnte prozedural (nicht OO) geschrieben werden,
" aber ich wollte einfach Ihnen ein Beispiel von Object Oriented Programmierung geben.

" Ich wünsche Ihnen viel Erfolg und bis bald :)

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001 NO INTERVALS.
  PARAMETERS: p_carr TYPE s_carr_id,
              p_conn TYPE s_conn_id.
SELECTION-SCREEN END OF BLOCK a1.

CLASS lcl_cls DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF t_sflight,
           carrid   TYPE sflight-carrid,
           carrname TYPE scarr-carrname,
           connid   TYPE sflight-connid,
           fldate   TYPE sflight-fldate,
           price    TYPE sflight-price,
           currency TYPE sflight-currency,
           seatsocc TYPE sflight-seatsocc,
           seatsmax TYPE sflight-seatsmax,
           percent  TYPE p LENGTH 4 DECIMALS 2,
         END OF t_sflight.

    DATA: is_sflight TYPE t_sflight,
          it_sflight TYPE STANDARD TABLE OF t_sflight.

    DATA: gv_cfrom TYPE spfli-cityfrom,
          gv_cto   TYPE spfli-cityto.

    DATA: gs_spfli TYPE spfli,
          gv_mess_1 TYPE string,
          gv_mess_2 TYPE string.

    METHODS: constructor IMPORTING carr TYPE s_carr_id
                                   conn TYPE s_conn_id,
             nimm_data,
             percentage,
             write_infos.

ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.

  METHOD constructor.
    IF carr is INITIAL or
       conn is INITIAL.
     MESSAGE 'Füllen Sie alle Mußfelder aus!' TYPE 'E'.

      ELSE.

        SELECT SINGLE * from spfli INTO CORRESPONDING FIELDS OF gs_spfli WHERE carrid = carr and
                                                                           connid = conn.
          IF sy-subrc <> 0.
            CONCATENATE 'Flug_' p_carr '_' p_conn ' ist nicht vorhanden' INTO gv_mess_1.
            MESSAGE gv_mess_1 TYPE 'E'.
          ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD nimm_data.
    SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE it_sflight WHERE carrid = p_carr AND
                                                                              connid = p_conn.
      IF sy-subrc <> 0.
        CONCATENATE 'Keine Anzeige-Berecntigung für Fluggeselschaft ' p_carr INTO gv_mess_2.
        MESSAGE  gv_mess_2 TYPE 'E'.
      ENDIF.
  ENDMETHOD.

  METHOD percentage.
    LOOP AT it_sflight INTO is_sflight.

     is_sflight-percent = is_sflight-seatsocc / is_sflight-seatsmax * 100.

     SELECT SINGLE carrname FROM scarr INTO is_sflight-carrname WHERE carrid = is_sflight-carrid.
     SELECT SINGLE cityfrom cityto FROM spfli INTO ( gv_cfrom, gv_cto ) WHERE carrid = p_carr AND
                                                                              connid = p_conn.
     MODIFY it_sflight FROM is_sflight INDEX sy-tabix.
    ENDLOOP.

    SORT it_sflight DESCENDING BY percent.
  ENDMETHOD.

  METHOD write_infos.
    WRITE: 'Details der Flugverbindung von ', gv_cfrom, 'nach ', gv_cto.
    ULINE.
    WRITE:/ '     ID  NAME                 FLUG DATUM                   PREIS   CUR         BELEGET    MAX     AUSLASTUNG' COLOR = 1  .
    ULINE.

    LOOP AT it_sflight INTO is_sflight.

        IF is_sflight-percent >= 75.
          WRITE:/ icon_green_light AS ICON.

         ELSEIF is_sflight-percent >= 50 AND
                is_sflight-percent <  75.
          WRITE:/ icon_yellow_light AS ICON.

         ELSEIF is_sflight-percent < 50.
          WRITE:/ icon_red_light AS ICON.
        ENDIF.

        WRITE:   is_sflight-carrid,
                 is_sflight-carrname,
                 is_sflight-connid,
                 is_sflight-fldate,
                 is_sflight-price,
                 is_sflight-currency,
                 is_sflight-seatsocc,
                 is_sflight-seatsmax.

        IF is_sflight-percent >= 75.
          WRITE: is_sflight-percent COLOR = 5.

         ELSEIF is_sflight-percent >= 50 AND
                is_sflight-percent <  75.
          WRITE: is_sflight-percent COLOR = 3.

         ELSEIF is_sflight-percent < 50.
          WRITE: is_sflight-percent COLOR = 6.
        ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

DATA: mein_obj TYPE REF TO lcl_cls.

START-OF-SELECTION.

CREATE OBJECT mein_obj EXPORTING carr = p_carr
                                 conn = p_conn.

CALL METHOD mein_obj->nimm_data.
CALL METHOD mein_obj->percentage.
CALL METHOD mein_obj->write_infos.
