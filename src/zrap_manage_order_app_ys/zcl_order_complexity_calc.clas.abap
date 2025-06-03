CLASS zcl_order_complexity_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_original_data,
             OrderUUID TYPE sysuuid_x16,
           END OF ty_original_data,
           tt_original_data TYPE STANDARD TABLE OF ty_original_data.

    TYPES: BEGIN OF ty_calculated_data,
             OrderUUID TYPE sysuuid_x16,
             Complexity TYPE string,
           END OF ty_calculated_data,
           tt_calculated_data TYPE STANDARD TABLE OF ty_calculated_data.

ENDCLASS.

CLASS zcl_order_complexity_calc IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    " Specify which original fields are needed for calculation
    LOOP AT it_requested_calc_elements INTO DATA(ls_calc_element).
      CASE ls_calc_element.
        WHEN 'COMPLEXITY'.
          APPEND 'ORDERUUID' TO et_requested_orig_elements.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE tt_original_data,
          lt_calculated_data TYPE tt_calculated_data.

    " Convert input data
    lt_original_data = CORRESPONDING #( it_original_data ).

    " Calculate complexity for each order
    LOOP AT lt_original_data INTO DATA(ls_original_data).

      " Count order items using your existing table
      SELECT COUNT(*)
        FROM zorder_items
        WHERE order_uuid = @ls_original_data-OrderUUID
        INTO @DATA(item_count).


      DATA(complexity) = COND string(
        WHEN item_count < 3 THEN 'Easy'
        WHEN item_count <= 4 THEN 'Medium'
        ELSE 'Complex' ).

      " Add to calculated data
      APPEND VALUE #( OrderUUID = ls_original_data-OrderUUID
                     Complexity = complexity ) TO lt_calculated_data.
    ENDLOOP.

    " Return calculated data
    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).

  ENDMETHOD.

ENDCLASS.
