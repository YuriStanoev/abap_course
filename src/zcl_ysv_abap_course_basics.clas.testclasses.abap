CLASS ltcl_ysv_abap_course_basics DEFINITION FINAL FOR TESTING
RISK LEVEL HARMLESS
DURATION SHORT.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zcl_ysv_abap_course_basics.

    METHODS:
      setup,
      teardown,
      " hello_world tests
      hello_world_valid_input        FOR TESTING,
      hello_world_empty_input        FOR TESTING,

      " calculator tests
      calculator_add                 FOR TESTING,
      calculator_subtract            FOR TESTING,
      calculator_multiply            FOR TESTING,
      calculator_divide              FOR TESTING,
      calculator_divide_zero         FOR TESTING,
      calculator_invalid_operator    FOR TESTING,

      " fizz_buzz test
      fizz_buzz_output               FOR TESTING,

      " date_parsing tests
      date_parsing_assert_convert
      IMPORTING i_date TYPE string
                i_date_expected type dats,
      date_parsing_written_month     FOR TESTING,
      date_parsing_numeric_month     FOR TESTING,
      date_parsing_all_months        FOR TESTING,
      date_parsing_invalid           FOR TESTING,

      " scrabble_score tests
      scrabble_score_normal          FOR TESTING,
      scrabble_score_empty           FOR TESTING,
      scrabble_score_case_insensitiv FOR TESTING,

      " get_current_date_time test
      get_current_date_time_valid    FOR TESTING,

      " internal_tables and open_sql
      internal_tables_basic          FOR TESTING,
      open_sql_basic                 FOR TESTING.
ENDCLASS.

CLASS ltcl_ysv_abap_course_basics IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_ysv_abap_course_basics(  ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR cut.
  ENDMETHOD.


  METHOD calculator_add.
    DATA(result_add) = cut->zif_abap_course_basics~calculator( iv_first_number = 8
                                                               iv_second_number = 3
                                                               iv_operator = '+'
                                                               ).
    DATA(expected_result) = '11'.
    cl_abap_unit_assert=>assert_equals(  exp = expected_result
                                         act = result_add ).

  ENDMETHOD.

  METHOD calculator_divide.
    DATA(result_divide) = cut->zif_abap_course_basics~calculator( iv_first_number = 8
                                                           iv_second_number = 2
                                                           iv_operator = '/' ).
    DATA(expected_result) = '4'.
    cl_abap_unit_assert=>assert_equals(  exp = expected_result
                                         act = result_divide ).
  ENDMETHOD.

  METHOD calculator_divide_zero.
    DATA(result_div_zero) = cut->zif_abap_course_basics~calculator( iv_first_number = 5
                                                                    iv_second_number = 0
                                                                    iv_operator = '/' ).
    DATA(expected_result) = '-2147483648'.
    cl_abap_unit_assert=>assert_equals( exp = expected_result
                                        act = result_div_zero ).
  ENDMETHOD.

  METHOD calculator_invalid_operator.
    DATA(result_inv_operator) = cut->zif_abap_course_basics~calculator( iv_first_number = 8
                                                                        iv_second_number = 2
                                                                        iv_operator = 'y' ).
    DATA(expected_result) = '-2147483648'.
    cl_abap_unit_assert=>assert_equals( exp = expected_result
                                        act =  result_inv_operator ).
  ENDMETHOD.

  METHOD calculator_multiply.
    DATA(result_multiply) = cut->zif_abap_course_basics~calculator( iv_first_number = 8
                                                                    iv_second_number = 2
                                                                    iv_operator = '*' ).
    DATA(expected_result) = '16'.
    cl_abap_unit_assert=>assert_equals( exp = expected_result
                                        act = result_multiply ).
  ENDMETHOD.

  METHOD calculator_subtract.
    DATA(result_subtract) = cut->zif_abap_course_basics~calculator( iv_first_number = 48
                                                                    iv_second_number = 12
                                                                    iv_operator = '-' ).
    DATA(expected_result) = '36'.
    cl_abap_unit_assert=>assert_equals( exp = expected_result
                                        act = result_subtract ).
  ENDMETHOD.

  METHOD date_parsing_invalid.
  date_parsing_assert_convert( i_date = '04 Invalid 1994' i_date_expected = '19940004' ).
  ENDMETHOD.

  METHOD date_parsing_numeric_month.
  date_parsing_assert_convert( i_date = '04 05 1994' i_date_expected = '19940504' ).

  ENDMETHOD.

  METHOD date_parsing_written_month.
  date_parsing_assert_convert( i_date = '04 May 1994' i_date_expected = '19940504' ).

  ENDMETHOD.

  METHOD date_parsing_all_months.

    date_parsing_assert_convert( i_date = '01 January 2025' i_date_expected = '20250101' ).
    date_parsing_assert_convert( i_date = '02 February 2024' i_date_expected = '20240202' ).
    date_parsing_assert_convert( i_date = '03 March 2023' i_date_expected = '20230303' ).
    date_parsing_assert_convert( i_date = '04 April 2022' i_date_expected = '20220404' ).
    date_parsing_assert_convert( i_date = '05 May 2021' i_date_expected = '20210505' ).
    date_parsing_assert_convert( i_date = '06 June 2020' i_date_expected = '20200606' ).
    date_parsing_assert_convert( i_date = '07 July 2019' i_date_expected = '20190707' ).
    date_parsing_assert_convert( i_date = '08 August 2018' i_date_expected = '20180808' ).
    date_parsing_assert_convert( i_date = '09 September 2017' i_date_expected = '20170909' ).
    date_parsing_assert_convert( i_date = '10 October 2016' i_date_expected = '20161010' ).
    date_parsing_assert_convert( i_date = '11 November 2015' i_date_expected = '20151111' ).
    date_parsing_assert_convert( i_date = '12 December 2014' i_date_expected = '20141212' ).

  ENDMETHOD.

  METHOD fizz_buzz_output.
    DATA(result) = cut->zif_abap_course_basics~fizz_buzz(  ).
    cl_abap_unit_assert=>assert_text_matches(
      text    = result
      pattern = '^1\s+2\s+Fizz\s+4\s+Buzz'
                                            ).

    cl_abap_unit_assert=>assert_text_matches(
      text    = result
      pattern = '14\s+FizzBuzz\s+16'
                                            ).

    cl_abap_unit_assert=>assert_text_matches(
                                             text    = result
                                             pattern = '98\s+Fizz\s+Buzz$'
                                            ).

    cl_abap_unit_assert=>assert_text_matches(
    text    = result
    pattern = 'FizzBuzz'
  ).

    cl_abap_unit_assert=>assert_text_matches(
     text    = result
     pattern = 'Fizz'
       ).

    cl_abap_unit_assert=>assert_text_matches(
    text    = result
    pattern = 'Buzz'
      ).

  ENDMETHOD.

  METHOD get_current_date_time_valid.

  ENDMETHOD.


  METHOD hello_world_empty_input.
    DATA(result) = cut->zif_abap_course_basics~hello_world( iv_name = '' ).
    DATA(expected_result) = |Hello , your system user id is { sy-uname }.|.
    cl_abap_unit_assert=>assert_equals( act = result
                                        exp = expected_result ).
  ENDMETHOD.

  METHOD hello_world_valid_input.
    DATA(result) = cut->zif_abap_course_basics~hello_world( iv_name = 'Yuri' ).
    DATA(expected_result) = |Hello Yuri, your system user id is { sy-uname }.|.
    cl_abap_unit_assert=>assert_equals( act = result
                                        exp = expected_result ).
  ENDMETHOD.

  METHOD internal_tables_basic.

  ENDMETHOD.

  METHOD open_sql_basic.

  ENDMETHOD.

  METHOD scrabble_score_case_insensitiv.

  ENDMETHOD.

  METHOD scrabble_score_empty.

  ENDMETHOD.

  METHOD scrabble_score_normal.

  ENDMETHOD.

  METHOD date_parsing_assert_convert.
    cl_abap_unit_assert=>assert_equals( exp = i_date_expected
                                        act = cut->zif_abap_course_basics~date_parsing( iv_date = i_date ) ).

  ENDMETHOD.

ENDCLASS.
