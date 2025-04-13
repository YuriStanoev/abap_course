CLASS zcl_ysv_abap_course_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
    INTERFACES zif_abap_course_basics.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
        gc_invalid_result TYPE i VALUE '-2147483648'.
ENDCLASS.


CLASS zcl_ysv_abap_course_basics IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


*    1.Hello world method
    out->write( '****Hello World Method****' ).
    out->write( cl_abap_char_utilities=>newline ).

    DATA(result) = zif_abap_course_basics~hello_world( 'Yuri' ).
    out->write( result ).
    out->write( cl_abap_char_utilities=>newline ).

*    2.Calculator
    out->write( '**** Calculator Method****' ).
    out->write( cl_abap_char_utilities=>newline ).

    DATA(lv_operator) = '+'.
    DATA(lv_result) = zif_abap_course_basics~calculator(
        iv_first_number = 8
        iv_second_number = 3
        iv_operator = lv_operator ).

    IF lv_result <> gc_invalid_result.
      out->write( |8 { lv_operator } 3 = { lv_result }| ).
    ELSE.
      out->write( 'Error' ).
    ENDIF.


    lv_operator = '/'.
    lv_result = zif_abap_course_basics~calculator(
        iv_first_number  = 8
        iv_second_number = 0
        iv_operator = lv_operator ).

    IF lv_result <> gc_invalid_result.
      out->write( |8 { lv_operator } 0 = { lv_result }| ).
    ELSE.
      out->write( 'Error: Cannot divide by zero!' ).
    ENDIF.


    lv_operator = 'y'.
    lv_result = zif_abap_course_basics~calculator(
        iv_first_number = 8
        iv_second_number = 2
        iv_operator = lv_operator ).

    IF lv_result <> gc_invalid_result.
      out->write( |8 { lv_operator } 2 = { lv_result }| ).
    ELSE.
      out->write( 'Error: Please choose a valid operator!' ).
    ENDIF.
    out->write( cl_abap_char_utilities=>newline ).

*    3.Fizz_Buzz method
    out->write( '**** FizzBuzz Method****' ).
    out->write( cl_abap_char_utilities=>newline ).

    DATA(fizzbuzz_result) = zif_abap_course_basics~fizz_buzz( ).
    out->write( fizzbuzz_result ).

*    4.Date Parsing method
    out->write( '**** Date Parsing Method****' ).
    out->write( cl_abap_char_utilities=>newline ).

   DATA(parsed_date1) = zif_abap_course_basics~date_parsing( '12 April 2017' ).
   DATA(parsed_date2) = zif_abap_course_basics~date_parsing( '12 04 2017' ).
   out->write( parsed_date1 ).
   out->write( parsed_date2 ).

    out->write( cl_abap_char_utilities=>newline ).

*    5. Scrabble Score
    out->write( '**** Scrabble Score ****' ).
    out->write( cl_abap_char_utilities=>newline ).

    DATA(scrabble_score) = zif_abap_course_basics~scrabble_score( 'ABAP' ).
    out->write( |'ABAP' scores: { scrabble_score } points| ).

    out->write( cl_abap_char_utilities=>newline ).

*    6.Get current date time method
    out->write( '**** Current Timestamp ****' ).
    out->write( cl_abap_char_utilities=>newline ).

    out->write( zif_abap_course_basics~get_current_date_time( ) ).

    out->write( cl_abap_char_utilities=>newline ).
  ENDMETHOD.

  METHOD zif_abap_course_basics~calculator.
    rv_result = gc_invalid_result.

    CASE iv_operator.
      WHEN '+'.
        rv_result = iv_first_number + iv_second_number.
      WHEN '-'.
        rv_result = iv_first_number - iv_second_number.
      WHEN '*'.
        rv_result = iv_first_number * iv_second_number.
      WHEN '/'.
        IF iv_second_number = 0.
          RETURN.
        ELSE.
          rv_result = iv_first_number / iv_second_number.
        ENDIF.
      WHEN OTHERS.
        RETURN.
    ENDCASE.
  ENDMETHOD.

  METHOD zif_abap_course_basics~date_parsing.
    DATA: lv_day TYPE string,
          lv_month TYPE string,
          lv_year TYPE string.
    SPLIT iv_date AT space INTO lv_day lv_month lv_year.
    IF lv_month CO '0123456789'.
    rv_result = |{ lv_year }{ lv_month }{ lv_day }|.
    ELSE.
        DATA(lv_month_number) = COND string(
            WHEN lv_month = 'January' THEN '01'
            WHEN lv_month = 'February'  THEN '02'
            WHEN lv_month = 'March'     THEN '03'
            WHEN lv_month = 'April'     THEN '04'
            WHEN lv_month = 'May'       THEN '05'
            WHEN lv_month = 'June'      THEN '06'
            WHEN lv_month = 'July'      THEN '07'
            WHEN lv_month = 'August'    THEN '08'
            WHEN lv_month = 'September' THEN '09'
            WHEN lv_month = 'October'   THEN '10'
            WHEN lv_month = 'November'  THEN '11'
            WHEN lv_month = 'December'  THEN '12'
            ELSE '00' ).
    rv_result = |{ lv_year }{ lv_month_number }{ lv_day }|.
    ENDIF.

  ENDMETHOD.

  METHOD zif_abap_course_basics~fizz_buzz.
    DATA: lv_result TYPE string,
          lv_number TYPE i,
          lv_output TYPE string.


    CLEAR rv_result.
    DO 100 TIMES.
      lv_number = sy-index.
      CLEAR lv_output.

      IF lv_number MOD 3 = 0.
        lv_output = lv_output && 'Fizz'.
      ENDIF.

      IF lv_number MOD 5 = 0.
        lv_output = lv_output && 'Buzz'.
      ENDIF.

      IF lv_output IS INITIAL.
        lv_output = lv_number.
      ENDIF.

      rv_result = rv_result && lv_output && cl_abap_char_utilities=>newline.
    ENDDO.
  ENDMETHOD.


  METHOD zif_abap_course_basics~get_current_date_time.
  GET TIME STAMP FIELD rv_result.
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
  DATA: lv_char  TYPE c LENGTH 1,
        lv_index TYPE i.

  rv_result = 0.


  IF iv_word IS INITIAL OR strlen( iv_word ) = 0.
    RETURN.
  ENDIF.

  DO strlen( iv_word ) TIMES.
    lv_index = sy-index - 1.


    IF lv_index <= strlen( iv_word ) - 1.
      lv_char = iv_word+lv_index(1).
      TRANSLATE lv_char TO UPPER CASE.

      CASE lv_char.
        WHEN 'A'. rv_result = rv_result + 1.
        WHEN 'B'. rv_result = rv_result + 2.
        WHEN 'C'. rv_result = rv_result + 3.
        WHEN 'D'. rv_result = rv_result + 4.
        WHEN 'E'. rv_result = rv_result + 5.
        WHEN 'F'. rv_result = rv_result + 6.
        WHEN 'G'. rv_result = rv_result + 7.
        WHEN 'H'. rv_result = rv_result + 8.
        WHEN 'I'. rv_result = rv_result + 9.
        WHEN 'J'. rv_result = rv_result + 10.
        WHEN 'K'. rv_result = rv_result + 11.
        WHEN 'L'. rv_result = rv_result + 12.
        WHEN 'M'. rv_result = rv_result + 13.
        WHEN 'N'. rv_result = rv_result + 14.
        WHEN 'O'. rv_result = rv_result + 15.
        WHEN 'P'. rv_result = rv_result + 16.
        WHEN 'Q'. rv_result = rv_result + 17.
        WHEN 'R'. rv_result = rv_result + 18.
        WHEN 'S'. rv_result = rv_result + 19.
        WHEN 'T'. rv_result = rv_result + 20.
        WHEN 'U'. rv_result = rv_result + 21.
        WHEN 'V'. rv_result = rv_result + 22.
        WHEN 'W'. rv_result = rv_result + 23.
        WHEN 'X'. rv_result = rv_result + 24.
        WHEN 'Y'. rv_result = rv_result + 25.
        WHEN 'Z'. rv_result = rv_result + 26.
      ENDCASE.
    ENDIF.
  ENDDO.
   ENDMETHOD.
ENDCLASS.

