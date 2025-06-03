
CLASS zcl_order_total_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_item_total,
             order_uuid TYPE sysuuid_x16,
             total_amount TYPE p LENGTH 15 DECIMALS 2,
           END OF ty_item_total,
           tt_item_totals TYPE STANDARD TABLE OF ty_item_total WITH EMPTY KEY.

ENDCLASS.

CLASS zcl_order_total_calc IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    LOOP AT it_requested_calc_elements INTO DATA(ls_calc_element).
      CASE ls_calc_element.
        WHEN 'TOTALPRICE'.

          APPEND 'ORDERUUID' TO et_requested_orig_elements.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    " Step 1: Type-safe data conversion
    DATA: lt_original_data TYPE STANDARD TABLE OF zc_order_master.
    lt_original_data = CORRESPONDING #( it_original_data ).

    CHECK lt_original_data IS NOT INITIAL.

    " Step 2: Build efficient range table for order UUIDs
    DATA: lt_order_uuid_range TYPE RANGE OF sysuuid_x16.

    LOOP AT lt_original_data INTO DATA(ls_order).
      " Avoid duplicates in range table
      READ TABLE lt_order_uuid_range TRANSPORTING NO FIELDS
        WITH KEY low = ls_order-orderuuid.
      IF sy-subrc NE 0.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_order-orderuuid )
               TO lt_order_uuid_range.
      ENDIF.
    ENDLOOP.

    CHECK lt_order_uuid_range IS NOT INITIAL.


    DATA: lt_totals TYPE tt_item_totals.

    SELECT order_uuid,
           SUM( price * quantity ) AS total_amount
      FROM zorder_items
      WHERE order_uuid IN @lt_order_uuid_range
      GROUP BY order_uuid
      INTO CORRESPONDING FIELDS OF TABLE @lt_totals.


    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<order>).

      " Find the calculated total for this order
      READ TABLE lt_totals INTO DATA(ls_total)
        WITH KEY order_uuid = <order>-orderuuid.

      IF sy-subrc = 0.

        <order>-totalprice = ls_total-total_amount.
      ELSE.

        <order>-totalprice = 0.
      ENDIF.



    ENDLOOP.


    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

ENDCLASS.
