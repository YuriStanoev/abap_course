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



CLASS ZCL_YSV_ABAP_COURSE_BASICS IMPLEMENTATION.


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

    out->write( |{ zif_abap_course_basics~get_current_date_time( ) TIMESTAMP = ISO }| ).

    out->write( cl_abap_char_utilities=>newline ).

*   7.Internal Tables
    DATA: lt_task7_1 TYPE zif_abap_course_basics=>ltty_travel_id,
          lt_task7_2 TYPE zif_abap_course_basics=>ltty_travel_id,
          lt_task7_3 TYPE zif_abap_course_basics=>ltty_travel_id.

    out->write( '**** Internal Tables Exercise ****' ).
    out->write( cl_abap_char_utilities=>newline ).

    zif_abap_course_basics~internal_tables(
      IMPORTING
        et_travel_ids_task7_1 = lt_task7_1
        et_travel_ids_task7_2 = lt_task7_2
        et_travel_ids_task7_3 = lt_task7_3
    ).

    out->write( 'Results from internal_tables method:' ).
    out->write( cl_abap_char_utilities=>newline ).

    out->write( '1. Agency 070001 with 20 JPY booking fee:' ).
    LOOP AT lt_task7_1 INTO DATA(ls_travel).
      out->write( |Travel ID: { ls_travel-travel_id }| ).
    ENDLOOP.

    out->write( cl_abap_char_utilities=>newline ).
    out->write( '2. Travels > 2000 USD:' ).
    LOOP AT lt_task7_2 INTO DATA(ls_travel2).
      out->write( |Travel ID: { ls_travel2-travel_id }| ).
    ENDLOOP.

    out->write( cl_abap_char_utilities=>newline ).
    out->write( '3. First 10 EUR travels (sorted):' ).
    LOOP AT lt_task7_3 INTO DATA(ls_travel3).
      out->write( |Travel ID: { ls_travel3-travel_id }| ).
    ENDLOOP.

*    8.Open SQL
    DATA: lt_task8_1 TYPE zif_abap_course_basics=>ltty_travel_id,
          lt_task8_2 TYPE zif_abap_course_basics=>ltty_travel_id,
          lt_task8_3 TYPE zif_abap_course_basics=>ltty_travel_id.

    out->write( '**** Open SQL Exercise ****' ).
    out->write( cl_abap_char_utilities=>newline ).

    zif_abap_course_basics~open_sql(
      IMPORTING
        et_travel_ids_task8_1 = lt_task8_1
        et_travel_ids_task8_2 = lt_task8_2
        et_travel_ids_task8_3 = lt_task8_3
    ).

    out->write( 'Results from Open SQL method:' ).
    out->write( cl_abap_char_utilities=>newline ).

    out->write( '1. Agency 070001 with 20 JPY booking fee:' ).
    LOOP AT lt_task8_1 INTO DATA(ls_travelb).
      out->write( |Travel ID: { ls_travelb-travel_id }| ).
    ENDLOOP.

    out->write( cl_abap_char_utilities=>newline ).
    out->write( '2. Travels > 2000 USD:' ).
    LOOP AT lt_task8_2 INTO DATA(ls_travel2b).
      out->write( |Travel ID: { ls_travel2b-travel_id }| ).
    ENDLOOP.

    out->write( cl_abap_char_utilities=>newline ).
    out->write( '3. First 10 EUR travels (sorted):' ).
    LOOP AT lt_task8_3 INTO DATA(ls_travel3b).
      out->write( |Travel ID: { ls_travel3b-travel_id }| ).
    ENDLOOP.

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
    DATA: lv_day   TYPE string,
          lv_month TYPE string,
          lv_year  TYPE string.
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
    SELECT SINGLE @abap_true FROM ztravel_ys INTO @DATA(lv_not_empty).
    IF lv_not_empty <> abap_true.
      SELECT * FROM ztravel_ys INTO TABLE @DATA(lt_ztravel).
      DELETE ztravel_ys FROM TABLE @lt_ztravel.
      COMMIT WORK AND WAIT.

      INSERT ztravel_ys FROM (
        SELECT FROM /dmo/travel
        FIELDS uuid( ) AS travel_uuid,
               travel_id AS travel_id,
               agency_id AS agency_id,
               customer_id AS customer_id,
               begin_date AS begin_date,
               end_date AS end_date,
               booking_fee AS booking_fee,
               total_price AS total_price,
               currency_code AS currency_code,
               description AS description,
               CASE status
                 WHEN 'B' THEN 'A'
                 WHEN 'X' THEN 'X'
                 ELSE 'O'
               END AS overall_status,
               createdby AS createdby,
               createdat AS createdat,
               lastchangedby AS last_changed_by,
               lastchangedat AS last_changed_at
        ORDER BY travel_id
      ).
      COMMIT WORK AND WAIT.
    ELSE.

    ENDIF.

    SELECT * FROM ztravel_ys INTO TABLE @DATA(lt_all_travels).

    " Task 7.1
    et_travel_ids_task7_1 = VALUE #(
      FOR travel IN lt_all_travels
      WHERE ( agency_id = '070001' AND
              booking_fee = '20' AND
              currency_code = 'JPY' )
      ( travel_id = travel-travel_id )
    ).

    " Task 7.2
    CONSTANTS: lc_usd_to_eur TYPE decfloat16 VALUE '1.1',
               lc_jpy_to_usd TYPE decfloat16 VALUE '140',
               lc_threshold  TYPE decfloat16 VALUE '2000'.

    CLEAR et_travel_ids_task7_2.

    LOOP AT lt_all_travels INTO DATA(ls_travel).
      DATA(lv_converted_price) = ls_travel-total_price.

      IF ls_travel-currency_code = 'EUR'.
        lv_converted_price = ls_travel-total_price * lc_usd_to_eur.
      ELSEIF ls_travel-currency_code = 'JPY'.
        lv_converted_price = ls_travel-total_price / lc_jpy_to_usd.
      ENDIF.

      IF lv_converted_price > lc_threshold.
        APPEND VALUE #( travel_id = ls_travel-travel_id ) TO et_travel_ids_task7_2.
      ENDIF.
    ENDLOOP.

    " Task 7.3
    DELETE lt_all_travels WHERE currency_code <> 'EUR'.
    SORT lt_all_travels BY total_price begin_date.

    et_travel_ids_task7_3 = VALUE #(
      FOR i = 1 WHILE i <= 10 AND i <= lines( lt_all_travels )
      ( travel_id = lt_all_travels[ i ]-travel_id )
    ).

  ENDMETHOD.


  METHOD zif_abap_course_basics~open_sql.
    CONSTANTS:
      lc_usd_to_eur TYPE p LENGTH 8 DECIMALS 4 VALUE '1.1000',
      lc_jpy_to_usd TYPE p LENGTH 8 DECIMALS 4 VALUE '140.0000',
      lc_threshold  TYPE p LENGTH 8 DECIMALS 2 VALUE '2000.00'.

*     Task 8.1
    SELECT travel_id
      FROM ztravel_ys
      WHERE agency_id = '070001'
        AND booking_fee = '20'
        AND currency_code = 'JPY'
      INTO TABLE @et_travel_ids_task8_1.

*     Task 8.2
    SELECT travel_id FROM ztravel_ys
      WHERE currency_code = 'USD'
        AND total_price > @lc_threshold
      INTO TABLE @et_travel_ids_task8_2.

    SELECT travel_id FROM ztravel_ys
    WHERE currency_code = 'EUR'
      AND ( CAST( total_price AS DEC( 15,4 ) ) * @lc_usd_to_eur ) > @lc_threshold
    APPENDING TABLE @et_travel_ids_task8_2.

    SELECT travel_id FROM ztravel_ys
      WHERE currency_code = 'JPY'
        AND total_price > ( @lc_threshold * @lc_jpy_to_usd )
      APPENDING TABLE @et_travel_ids_task8_2.

*     Task 8.3
    SELECT travel_id
      FROM ztravel_ys
      WHERE currency_code = 'EUR'
      ORDER BY total_price, begin_date
      INTO TABLE @et_travel_ids_task8_3
      UP TO 10 ROWS.

  ENDMETHOD.


  METHOD zif_abap_course_basics~scrabble_score.
    DATA: lv_char   TYPE c LENGTH 1,
          lv_ascii  TYPE i,
          lv_offset TYPE i,
          lv_index  TYPE i.

    rv_result = 0.

    IF iv_word IS INITIAL OR strlen( iv_word ) = 0.
      RETURN.
    ENDIF.

    DO strlen( iv_word ) TIMES.
      lv_index = sy-index - 1.
      IF lv_index <= strlen( iv_word ) - 1.
        lv_char = iv_word+lv_index(1).

        TRANSLATE lv_char TO UPPER CASE.


        FIND lv_char IN sy-abcde MATCH OFFSET lv_offset.
        IF sy-subrc = 0 AND lv_offset BETWEEN 0 AND 25.

          rv_result = rv_result + lv_offset + 1.
        ENDIF.
      ENDIF.

    ENDDO.

  ENDMETHOD.
ENDCLASS.
