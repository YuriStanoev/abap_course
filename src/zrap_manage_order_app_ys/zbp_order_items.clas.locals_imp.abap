CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateItemTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~calculateItemTotal.

    METHODS validateMandatoryItemFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateMandatoryItemFields.

ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.


  METHOD calculateItemTotal.

    READ ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Item
        FIELDS ( OrderUUID ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_items).


    DATA: lt_order_uuids TYPE TABLE OF sysuuid_x16.

    LOOP AT lt_items INTO DATA(ls_item).
      APPEND ls_item-OrderUUID TO lt_order_uuids.
    ENDLOOP.


    SORT lt_order_uuids.
    DELETE ADJACENT DUPLICATES FROM lt_order_uuids.


    DATA: lt_order_update TYPE TABLE FOR UPDATE zi_order_ys.

    LOOP AT lt_order_uuids INTO DATA(lv_order_uuid).
      APPEND VALUE #( %tky-OrderUUID = lv_order_uuid
                     %control-OrderUUID = if_abap_behv=>mk-on ) TO lt_order_update.
    ENDLOOP.


    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Order
      UPDATE FIELDS ( OrderUUID ) WITH lt_order_update
      REPORTED DATA(ls_reported)
      FAILED DATA(ls_failed).
  ENDMETHOD.

  METHOD validateMandatoryItemFields.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Item
      FIELDS ( Name Price Quantity )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).
      " Validate Name
      IF ls_item-Name IS INITIAL.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Item Name is mandatory' )
          %element-Name = if_abap_behv=>mk-on
        ) TO reported-item.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
      ENDIF.
      " Validate Currency
      IF ls_item-CurrencyCode IS INITIAL.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Currency is mandatory' )
          %element-CurrencyCode = if_abap_behv=>mk-on
        ) TO reported-item.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
      ENDIF.

      " Validate Price
      IF ls_item-Price IS INITIAL OR ls_item-Price <= 0.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Item Price must be greater than 0' )
          %element-Price = if_abap_behv=>mk-on
        ) TO reported-item.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
      ENDIF.

      " Validate Quantity
      IF ls_item-Quantity IS INITIAL OR ls_item-Quantity <= 0.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Item Quantity must be greater than 0' )
          %element-Quantity = if_abap_behv=>mk-on
        ) TO reported-item.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
