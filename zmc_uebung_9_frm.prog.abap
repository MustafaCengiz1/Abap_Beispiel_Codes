*&---------------------------------------------------------------------*
*&  Include           ZMC_UEBUNG_9_FRM
*&---------------------------------------------------------------------*
" Ein Beispiel für eine dynamische Tabelle und E-Mail Sendung
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zmc_sprache INTO CORRESPONDING FIELDS OF TABLE gt_table.
  flag = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLLECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM collect .

  CLEAR: gs_table, gs_sprache, gs_vnname.
  REFRESH: gt_vnname, gt_sprache.

  LOOP AT gt_table INTO gs_table.

    CLEAR:gs_vnname, gs_sprache.

    gs_vnname-vorname = gs_table-vorname.
    gs_vnname-name    = gs_table-name.
    COLLECT gs_vnname INTO gt_vnname.

    gs_sprache-sprache = gs_table-sprache.
    COLLECT gs_sprache INTO gt_sprache.

    CLEAR:gs_vnname, gs_sprache, gs_table.
  ENDLOOP.

  SORT gt_vnname  ASCENDING BY vorname.
  SORT gt_sprache ASCENDING BY sprache.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT_HERSTELLEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcat_herstellen .

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'VORNAME'.
  gs_fcat-scrtext_s = 'VORNAME'.
  gs_fcat-coltext   = 'VORNAME'.
  gs_fcat-outputlen = 40.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'NAME'.
  gs_fcat-scrtext_s = 'NAME'.
  gs_fcat-coltext   = 'NAME'.
  gs_fcat-outputlen = 40.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_sprache.
  LOOP AT gt_sprache INTO gs_sprache.

    IF gs_sprache-sprache = 'KÜRDISCH'.
      gs_sprache-sprache = 'KURDISCH'.
    ELSEIF gs_sprache-sprache = 'TÜRKISCH'.
      gs_sprache-sprache = 'TURKISCH'.
    ENDIF.
    gs_fcat-fieldname = gs_sprache-sprache.
    gs_fcat-scrtext_s = gs_sprache-sprache.
    gs_fcat-coltext   = gs_sprache-sprache.
    gs_fcat-outputlen = 40.
    APPEND gs_fcat TO gt_fcat.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DTAB_HERSTELLEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dtab_herstellen .

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_fcat
    IMPORTING
      ep_table        = dt_1.

  ASSIGN dt_1->* TO <t_tab>.
  CREATE DATA ds_1 LIKE LINE OF <t_tab>.
  ASSIGN ds_1->* TO <st_tab>.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DTAB_EINFULLEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dtab_einfullen .

  CLEAR: gs_vnname, gs_table.

  LOOP AT gt_vnname INTO gs_vnname.

    CLEAR: <st_tab>.

    ASSIGN COMPONENT 'VORNAME' OF STRUCTURE <st_tab> TO <fs_val>.
    <fs_val> = gs_vnname-vorname.

    ASSIGN COMPONENT 'NAME' OF STRUCTURE <st_tab> TO <fs_val>.
    <fs_val> = gs_vnname-name.

    LOOP AT gt_table INTO gs_table WHERE vorname = gs_vnname-vorname
                                     AND name    = gs_vnname-name.

      ASSIGN COMPONENT gs_table-sprache OF STRUCTURE <st_tab> TO <fs_val>.
      <fs_val> = 'JA'.

    ENDLOOP.

    APPEND <st_tab> TO <t_tab>.
  ENDLOOP.

  CLEAR: gs_vnname, gs_table.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONT_HERSTELLEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cont_herstellen .

  IF gc_cont IS INITIAL.

    CREATE OBJECT gc_cont
      EXPORTING
        container_name = 'MEIN_CONTAINER'.

    CREATE OBJECT gc_grid
      EXPORTING
        i_parent = gc_cont.

    gs_layo-zebra      = 'X'.
    gs_layo-cwidth_opt = 'X'.
    gs_layo-sel_mode   = 'A'.
    gs_layo-no_toolbar = 'X'.

    CALL METHOD gc_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
        i_save                        = 'A'
        is_layout                     = gs_layo
      CHANGING
        it_outtab                     = <t_tab>
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

  ELSE.
    gs_layo-zebra      = 'X'.
    gs_layo-cwidth_opt = 'X'.
    gs_layo-sel_mode   = 'A'.
    gs_layo-no_toolbar = 'X'.

    CALL METHOD gc_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
        i_save                        = 'A'
        is_layout                     = gs_layo
      CHANGING
        it_outtab                     = <t_tab>
        it_fieldcatalog               = gt_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
*    CALL METHOD gc_grid->check_changed_data.
*    CALL METHOD gc_grid->refresh_table_display.

  ENDIF.

  CLEAR gs_table.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HINZUFUGEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM hinzufugen .

  IF NOT gs_table-vorname IS INITIAL AND
     NOT gs_table-name    IS INITIAL AND
     NOT gs_table-sprache IS INITIAL.

    zmc_sprache-vorname = gs_table-vorname.
    zmc_sprache-name    = gs_table-name.
    zmc_sprache-sprache = gs_table-sprache.

    INSERT zmc_sprache.
  ELSE.
    MESSAGE 'Bitte füllen Sie alle Felder aus.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CLEAR gs_table.

  IF flag IS INITIAL.
    PERFORM get_data.
    PERFORM collect.
    PERFORM fcat_herstellen.
    PERFORM dtab_herstellen.
    PERFORM dtab_einfullen.
    PERFORM cont_herstellen.
  ELSE.
    REFRESH: gt_fcat.
    PERFORM get_data.
    PERFORM collect.
    PERFORM fcat_herstellen.
    PERFORM dtab_herstellen.
    PERFORM dtab_einfullen.
    PERFORM cont_herstellen.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  LOSCHEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM loschen .

  IF NOT gs_table-vorname IS INITIAL AND
     NOT gs_table-name    IS INITIAL AND
     NOT gs_table-sprache IS INITIAL.

    DELETE FROM zmc_sprache WHERE vorname = gs_table-vorname AND
                                  name    = gs_table-name    AND
                                  sprache = gs_table-sprache.
  ELSE.
    MESSAGE 'Bitte füllen Sie alle Felder aus.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CLEAR gs_table.

  IF flag IS INITIAL.
    PERFORM get_data.
    PERFORM collect.
    PERFORM fcat_herstellen.
    PERFORM dtab_herstellen.
    PERFORM dtab_einfullen.
    PERFORM cont_herstellen.
  ELSE.
    REFRESH: gt_fcat.
    PERFORM get_data.
    PERFORM collect.
    PERFORM fcat_herstellen.
    PERFORM dtab_herstellen.
    PERFORM dtab_einfullen.
    PERFORM cont_herstellen.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZEIG_TASTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zeig_taste .

  flag2 = 'X'.
  LOOP AT SCREEN .
    IF screen-group1 = 'GR1' .
      screen-active = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  E_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM e_mail .

  DATA : g_sent_to_all TYPE sonv-flag,
         g_tab_lines   TYPE i.

  DATA : i_document_data TYPE STANDARD TABLE OF sodocchgi1,
         i_packing_list  TYPE STANDARD TABLE OF sopcklsti1,
         i_attachment    TYPE STANDARD TABLE OF solisti1,
         i_body_msg      TYPE STANDARD TABLE OF solisti1,
         i_receivers     TYPE STANDARD TABLE OF somlreci1.

  DATA : w_document_data LIKE LINE OF i_document_data,
         w_packing_list  LIKE LINE OF i_packing_list,
         w_attachment    LIKE LINE OF i_attachment,
         w_body_msg      LIKE LINE OF i_body_msg,
         w_receivers     LIKE LINE OF i_receivers.

  CLASS cl_abap_char_utilities DEFINITION LOAD.

  CONSTANTS:

    con_tab  TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
    con_cret TYPE c VALUE cl_abap_char_utilities=>cr_lf.

  LOOP AT gt_fcat INTO gs_fcat.

    CONCATENATE w_attachment gs_fcat-fieldname INTO         w_attachment
                                               SEPARATED BY con_tab.

  ENDLOOP.

  CONCATENATE con_cret  w_attachment  INTO w_attachment.

  APPEND w_attachment TO i_attachment.

  CLEAR: w_attachment, gs_fcat, <st_tab>.


  LOOP AT <t_tab> INTO <st_tab>.

    LOOP AT gt_fcat INTO gs_fcat.

      ASSIGN COMPONENT gs_fcat-fieldname OF STRUCTURE <st_tab> TO <fs_val_2>.

      IF NOT <fs_val_2> IS INITIAL .
        CONCATENATE w_attachment <fs_val_2> INTO w_attachment SEPARATED BY con_tab.
      ELSE.
        CONCATENATE w_attachment ' ' INTO w_attachment SEPARATED BY con_tab.
      ENDIF.

    ENDLOOP.

    CONCATENATE con_cret w_attachment INTO w_attachment.

    APPEND w_attachment TO i_attachment.
    CLEAR: w_attachment, <fs_val_2>.

  ENDLOOP.

  w_document_data-obj_name = 'MAIL_TO_HEAD'.
  w_document_data-obj_descr = 'Regarding Mail Program by SAP ABAP'.

  w_body_msg = space.
  APPEND w_body_msg TO i_body_msg.

  w_body_msg = 'Hallo. Ist alles okey?'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  w_body_msg = 'Sie können das Dokument im Anhang finden.'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  w_body_msg = 'Falls Sie Fragen haben, bin ich jederzeit unter meiner E-Mail Adresse erreichbar.'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  w_body_msg = 'Mit freundlichen Grüßen'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  w_body_msg = 'Mustafa Cengiz'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  w_body_msg = 'Junior SAP-Abap Anwendungsentwickler'.
  APPEND w_body_msg TO i_body_msg.
  CLEAR w_body_msg.

  DESCRIBE TABLE i_body_msg LINES g_tab_lines.
  w_packing_list-head_start = 1.
  w_packing_list-head_num = 0.
  w_packing_list-body_start = 1.
  w_packing_list-body_num = g_tab_lines.
  w_packing_list-doc_type = 'RAW'.

  APPEND w_packing_list TO i_packing_list.
  CLEAR w_packing_list.

  "Write Packing List for Attachment

  w_packing_list-transf_bin = 'X'.
  w_packing_list-head_start = 1.
  w_packing_list-head_num = 1.
  w_packing_list-body_start = 1.

  DESCRIBE TABLE i_attachment LINES w_packing_list-body_num.

  w_packing_list-doc_type = 'XLS'.
  w_packing_list-obj_descr = 'Excell Attachment'.
  w_packing_list-obj_name = 'XLS_ATTACHMENT'.
  w_packing_list-doc_size = w_packing_list-body_num * 255.

  APPEND w_packing_list TO i_packing_list.

  CLEAR w_packing_list.
*
*  "Fill the document data and get size of attachment
*
  w_document_data-obj_langu = sy-langu.

  READ TABLE i_attachment INTO w_attachment INDEX g_tab_lines.

  w_document_data-doc_size = ( g_tab_lines - 1 ) * 255 + strlen(

  w_attachment ).

  "Receivers List.

  w_receivers-rec_type = 'U'. "Internet address
  w_receivers-receiver = 'MUSTAFACENGIZDE@GMAIL.COM'.
  w_receivers-com_type = 'INT'.
  w_receivers-notif_del = 'X'.
  w_receivers-notif_ndel = 'X'.

  APPEND w_receivers TO i_receivers .

  CLEAR: w_receivers.

  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    EXPORTING
      document_data              = w_document_data
      put_in_outbox              = 'X'
      commit_work                = 'X'
    IMPORTING
      sent_to_all                = g_sent_to_all
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_body_msg
      receivers                  = i_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.

  IF sy-subrc = 0 .

*    MESSAGE i303(me) WITH 'Mail has been Successfully Sent.'.
MESSAGE 'Die E-Mail wurde gesendet!' TYPE 'I'.
  ELSE.

    WAIT UP TO 2 SECONDS.

    "This program starts the SAPconnect send process.

    SUBMIT rsconn01 WITH mode = 'INT'

    WITH output = 'X'

    AND RETURN.

  ENDIF.

ENDFORM.
