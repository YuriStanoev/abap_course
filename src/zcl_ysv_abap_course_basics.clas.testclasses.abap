CLASS ltcl_ysv_abap_course_basics DEFINITION FINAL for TESTING
RISK LEVEL HARMLESS
DURATION SHORT.

PRIVATE SECTION.
    DATA: cut TYPE REF TO zcl_ysv_abap_course_basics.

    METHODS:
      setup,
      test_hello_world FOR TESTING,
      test_calculator_addition FOR TESTING,
      test_calculator_subtraction FOR TESTING,
      test_calculator_multiplication FOR TESTING,
      test_calculator_division FOR TESTING,
      test_calculator_div_by_zero FOR TESTING,
      test_calculator_inval_operator FOR TESTING,
      test_fizz_buzz FOR TESTING,
      test_date_parsing_numeric FOR TESTING,
      test_date_parsing_textual FOR TESTING,
      test_scrabble_score_abap FOR TESTING,
      test_scrabble_score_empty FOR TESTING,
      test_scrabble_score_mixed_case FOR TESTING,
      test_get_current_date_time FOR TESTING,
      test_internal_tables FOR TESTING,
      test_open_sql FOR TESTING.

ENDCLASS.

CLASS ltcl_ysv_abap_course_basics IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_ysv_abap_course_basics( ).
  ENDMETHOD.

  METHOD test_calculator_addition.

  ENDMETHOD.

  METHOD test_calculator_division.

  ENDMETHOD.

  METHOD test_calculator_div_by_zero.

  ENDMETHOD.

  METHOD test_calculator_inval_operator.

  ENDMETHOD.

  METHOD test_calculator_multiplication.

  ENDMETHOD.

  METHOD test_calculator_subtraction.

  ENDMETHOD.

  METHOD test_date_parsing_numeric.

  ENDMETHOD.

  METHOD test_date_parsing_textual.

  ENDMETHOD.

  METHOD test_fizz_buzz.

  ENDMETHOD.

  METHOD test_get_current_date_time.

  ENDMETHOD.

  METHOD test_hello_world.


  ENDMETHOD.

  METHOD test_internal_tables.

  ENDMETHOD.

  METHOD test_open_sql.

  ENDMETHOD.

  METHOD test_scrabble_score_abap.

  ENDMETHOD.

  METHOD test_scrabble_score_empty.

  ENDMETHOD.

  METHOD test_scrabble_score_mixed_case.

  ENDMETHOD.

ENDCLASS.
