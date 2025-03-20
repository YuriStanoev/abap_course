CLASS zcl_ysv_abap_course_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abap_course_basics .
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ysv_abap_course_basics IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( 'HELLO SAP ABAP Labs Team' ) . "
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
  ENDMETHOD.


  METHOD zif_abap_course_basics~internal_tables.
  ENDMETHOD.


  METHOD zif_abap_course_basics~open_sql.
  ENDMETHOD.


  METHOD zif_abap_course_basics~scrabble_score.
  ENDMETHOD.
ENDCLASS.
