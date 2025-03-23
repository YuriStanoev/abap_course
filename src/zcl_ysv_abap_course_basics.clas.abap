
CLASS zcl_ysv_abap_course_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
    INTERFACES zif_abap_course_basics.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ysv_abap_course_basics IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA(result) = zif_abap_course_basics~hello_world( 'Yuri' ).
    out->write( result ).
  ENDMETHOD.

  METHOD zif_abap_course_basics~calculator.
  ENDMETHOD.


  METHOD zif_abap_course_basics~date_parsing.
  ENDMETHOD.

  METHOD zif_abap_course_basics~fizz_buzz.
  ENDMETHOD.


  METHOD zif_abap_course_basics~get_current_date_time.
  ENDMETHOD.

  METHOD zif_abap_course_basics~hello_world.
    DATA(user_id) = sy-uname.
    rv_result = |Hello { iv_name }, your system user id is { user_id }.|.
  ENDMETHOD.


  METHOD zif_abap_course_basics~internal_tables.
  ENDMETHOD.


  METHOD zif_abap_course_basics~open_sql.
  ENDMETHOD.


  METHOD zif_abap_course_basics~scrabble_score.
  ENDMETHOD.
ENDCLASS.

