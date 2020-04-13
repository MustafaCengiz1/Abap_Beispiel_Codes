REPORT ZMC_UEBUNG_15.

" In diesem Beispiel Code kann man sehen,
" 1- ein Class zu generieren,
" 2- was der Unterschied zwischen instance and static Attribute ist,
" 3- was der Unterschied zwischen instance and static Method ist,
" 4- die Bedeutung der Constructor Methods.
" 5- wie man Methods in Protectet und Private Sections erreichen.
" 6- was das Inheriting Method erben kann.


CLASS lcl_class_01 DEFINITION.

  PUBLIC SECTION.

    DATA: iv_nummer_01 TYPE i,       " Diese sind meine instance Attributes
          iv_nummer_02 TYPE i.

    CLASS-DATA: sv_nummer_03 TYPE i, " Diese sind meine static Attributes
                sv_nummer_04 TYPE i.

    METHODS: constructor, " Wenn ich ein Object referieren und dann erstelle,
      " wird dieses Methid sofort aufgeruft. Dieses Method
      " ist auch ein Instance Method. Deswegen kann es alle
      " Attributes erreichen und benutzen.
      method_01.   " Mein instance Method.

    CLASS-METHODS: class_constructor, " Constructor aber static Method. Also kann
      " es die instance Attributes nicht erreichen.
      " Wenn ich das Program aufrufe, wird dieses
      " class_constructor Method sofort aufgeruft wird.
      " Infolgedessen wird es die Nummer nicht übernehmen können.
      method_02.         " Mein static Method.

  PROTECTED SECTION.

    DATA: iv_nummer_04 TYPE i.
    METHODS method_pro.

  PRIVATE SECTION.

    DATA: iv_nummer_03 TYPE i.
    METHODS method_prv.

ENDCLASS.

CLASS lcl_class_02 DEFINITION INHERITING FROM lcl_class_01.
  PUBLIC SECTION.
    METHODS method_03.
ENDCLASS.

CLASS lcl_class_01 IMPLEMENTATION.

  METHOD constructor.
    DATA: cv_division_01 TYPE p LENGTH 4 DECIMALS 4,
          cv_division_02 TYPE p LENGTH 4 DECIMALS 4.

    cv_division_01 = iv_nummer_01 / iv_nummer_02.
    cv_division_02 = sv_nummer_03 / sv_nummer_04.

    WRITE: / 'Ich bin Constructor method: ', cv_division_01, cv_division_02.
  ENDMETHOD.

  METHOD method_01.

    DATA: iv_summe_01 TYPE i.

    iv_summe_01 = iv_nummer_01 + iv_nummer_02.

    WRITE: / 'Ich bin Instance Method method_01: ', iv_summe_01.

    DATA: neu_obj TYPE REF TO lcl_class_01.

    CREATE OBJECT neu_obj.

    CALL METHOD neu_obj->method_pro. " Man kann die Method on Protected und Private Section
                                     " nicht direct erreichen. Man muss dieses Methoden in
                                     " den anderen Methoden erreichen.
    CALL METHOD neu_obj->method_prv.
  ENDMETHOD.

  METHOD class_constructor.

    DATA: sv_summe_02 TYPE i.
*    sv_summe_02 = iv_nummer_01 + iv_nummer_02. " Ich kann nicht die instance attributes iv_nummer_01 und iv_nummer_02 erreichen.

    sv_summe_02 = sv_nummer_03 + sv_nummer_04.

    WRITE: / 'Ich bin Class_Constructor Method: ', sv_summe_02.

  ENDMETHOD.

  METHOD method_02.


    DATA: sv_product TYPE i.

*    sv_product = iv_nummer_01 * iv_nummer_02. " Ich kann nicht die instance attributes iv_nummer_01 und iv_nummer_02 erreichen.

    sv_product = sv_nummer_03 * sv_nummer_04.
    WRITE: / 'Ich bin static Method method_02: ', sv_product.

  ENDMETHOD.

  METHOD method_prv.
    WRITE:/ 'Ich bin das private Method.'.
  ENDMETHOD.

  METHOD method_pro.
    WRITE:/ 'Ich bin das protected Method.'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_class_02 IMPLEMENTATION.
  METHOD method_03.
    WRITE:/ iv_nummer_01, iv_nummer_02.
    WRITE:/ sv_nummer_03, sv_nummer_04.
  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001 NO INTERVALS.
PARAMETERS: nummer_1 TYPE i,
            nummer_2 TYPE i,
            nummer_3 TYPE i,
            nummer_4 TYPE i.
SELECTION-SCREEN END OF BLOCK a1.

DATA: mein_obj_01 TYPE REF TO lcl_class_01,
      mein_obj_02 TYPE REF TO lcl_class_02.

START-OF-SELECTION.

  lcl_class_01=>sv_nummer_03 = nummer_3. " Ohne erstellung kann ich die static Attribute wechseln.
  lcl_class_01=>sv_nummer_04 = nummer_4. " Ohne erstellung kann ich die static Attribute wechseln.

  CALL METHOD lcl_class_01=>method_02. " Ohne erstellung kann ich das static Method aufrufen.

  CREATE OBJECT mein_obj_01.


  mein_obj_01->iv_nummer_01 = nummer_1. " Nach der Erstellung kann ich die instance Attributes erreichen.
  mein_obj_01->iv_nummer_02 = nummer_2. " Nach der Erstellung kann ich die instance Attributes erreichen.

*call METHOD mein_obj_01->constructor. " Das geht automatisch, also kann ich nicht wieder aufrufen.
  CALL METHOD mein_obj_01->method_01. " Nach der Erstellung kann ich das Method method_01 erreichen.

  SKIP 2.
  ULINE.

  CREATE OBJECT mein_obj_02. " Alle Methoden (egal instance oder static) habe ich geerbt.

  CALL METHOD mein_obj_02->method_01.
  CALL METHOD mein_obj_02->method_02.
  CALL METHOD mein_obj_02->method_03.


" Durch debugging können Sie die Reihenfolge sehen und besser verstehen wıe es liuft.
