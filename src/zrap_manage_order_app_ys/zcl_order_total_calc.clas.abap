CLASS zcl_order_total_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_order_summary,
             order_uuid    TYPE sysuuid_x16,
             total_amount  TYPE p LENGTH 15 DECIMALS 2,
             currency_code TYPE waers,
           END OF ty_order_summary,
           tt_order_summaries TYPE STANDARD TABLE OF ty_order_summary WITH EMPTY KEY.

ENDCLASS.

CLASS zcl_order_total_calc IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    " Step 1: Type-safe data conversion
    DATA: lt_original_data TYPE STANDARD TABLE OF zc_order_master.
    lt_original_data = CORRESPONDING #( it_original_data ).

    CHECK lt_original_data IS NOT INITIAL.

    " Step 2: Build efficient range table for order UUIDs
    DATA: lt_order_uuid_range TYPE RANGE OF sysuuid_x16,
          lt_unique_uuids     TYPE SORTED TABLE OF sysuuid_x16 WITH UNIQUE KEY table_line.

    " Collect unique UUIDs
    LOOP AT lt_original_data INTO DATA(ls_order).
      INSERT ls_order-orderuuid INTO TABLE lt_unique_uuids.
    ENDLOOP.

    CHECK lt_unique_uuids IS NOT INITIAL.

    " Build range table
    LOOP AT lt_unique_uuids INTO DATA(lv_uuid).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_uuid ) TO lt_order_uuid_range.
    ENDLOOP.

    " Step 3: Select totals AND currency from items table

    DATA: lt_order_summaries TYPE tt_order_summaries.

    SELECT order_uuid,
           SUM( price * quantity ) AS total_amount,
           MAX( currency_code ) AS currency_code  " Assuming all items have same currency
      FROM zorder_items
      WHERE order_uuid IN @lt_order_uuid_range
      GROUP BY order_uuid
      INTO CORRESPONDING FIELDS OF TABLE @lt_order_summaries.

    " Step 4: Loop original data and fill calculated fields
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<order>).

      " Find the calculated total and currency for this order
      READ TABLE lt_order_summaries INTO DATA(ls_summary)
        WITH KEY order_uuid = <order>-orderuuid.

      IF sy-subrc = 0.
        <order>-totalprice = ls_summary-total_amount.
        <order>-currencycode = ls_summary-currency_code.
      ELSE.
        <order>-totalprice = 0.
        <order>-currencycode = 'EUR'.  " Default fallback
      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
