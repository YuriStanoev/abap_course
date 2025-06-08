CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

    METHODS cancelOrder FOR MODIFY
      IMPORTING keys FOR ACTION Order~cancelOrder RESULT result.

    METHODS completeOrder FOR MODIFY
      IMPORTING keys FOR ACTION Order~completeOrder RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~setInitialStatus.

    METHODS setCreationDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setCreationDate.

    METHODS setOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setOrderID.

    METHODS validateItemsExist FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateItemsExist.



    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateMandatoryFields.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
    ENTITY Order
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orders)
    FAILED failed.

    result = VALUE #( FOR ls_order IN lt_orders INDEX INTO i
                     ( %tky = ls_order-%tky
                       %features-%action-cancelOrder = COND #( WHEN ls_order-Status = 'P'
                                                              THEN if_abap_behv=>fc-o-enabled
                                                              ELSE if_abap_behv=>fc-o-disabled )
                       %features-%action-completeOrder = COND #( WHEN ls_order-Status = 'P'
                                                                THEN if_abap_behv=>fc-o-enabled
                                                                ELSE if_abap_behv=>fc-o-disabled )
                      %action-Edit = COND #( WHEN ls_order-Status = 'C'
                                       THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )

                                      %features-%update = COND #( WHEN ls_order-Status = 'C' OR
                                                         ls_order-Status = 'X'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled )

                       %features-%delete = COND #( WHEN ls_order-Status = 'P'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  ELSE if_abap_behv=>fc-o-disabled )

                     ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancelOrder.
    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( Status CancellationDate )
          WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                         Status = 'X'
                                         CancellationDate = cl_abap_context_info=>get_system_date( ) ) )
        REPORTED DATA(ls_reported).

    " Read the updated entities
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    " Set the action result
    result = VALUE #( FOR order IN lt_orders ( %tky = order-%tky
                                              %param = order ) ).
  ENDMETHOD.

  METHOD completeOrder.
    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( Status CompletionDate )
          WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                         Status = 'C'
                                         CompletionDate = cl_abap_context_info=>get_system_date( ) ) )
        REPORTED DATA(ls_reported).

    " Read the updated entities
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    " Set the action result
    result = VALUE #( FOR order IN lt_orders ( %tky = order-%tky
                                              %param = order ) ).
  ENDMETHOD.

  METHOD setInitialStatus.
    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                       Status = 'P' ) )
      REPORTED DATA(ls_reported).
  ENDMETHOD.

  METHOD setCreationDate.
    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( CreationDate )
          WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                         CreationDate = cl_abap_context_info=>get_system_date( ) ) )
        REPORTED DATA(ls_reported).


  ENDMETHOD.

  METHOD setOrderID.
    DATA: max_order_id TYPE i VALUE 0.

    " Read from database table to find max OrderID
    SELECT MAX( order_id ) FROM zorder_master INTO @DATA(lv_max_id).

    IF lv_max_id IS NOT INITIAL.
      TRY.
          max_order_id = CONV i( lv_max_id ).
        CATCH cx_sy_conversion_no_number.
          max_order_id = 0.
      ENDTRY.
    ENDIF.

    " Assign new OrderIDs to each key
    DATA: lt_update  TYPE TABLE FOR UPDATE zi_order_ys,
          lv_counter TYPE i VALUE 1.

    LOOP AT keys INTO DATA(ls_key).
      max_order_id = max_order_id + lv_counter.
      APPEND VALUE #( %tky = ls_key-%tky
                     OrderID = |{ max_order_id }| ) TO lt_update.
      lv_counter = lv_counter + 1.
    ENDLOOP.

    " Update the entities
    MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
      ENTITY Order
      UPDATE FIELDS ( OrderID )
      WITH lt_update
      REPORTED DATA(ls_reported).
  ENDMETHOD.

  METHOD validateItemsExist.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
     ENTITY Order BY \_Items
       FROM VALUE #( FOR key IN keys ( %tky = key-%tky ) )
       RESULT DATA(lt_items).

    " Check if orders have at least one item
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      DATA(lv_has_items) = abap_false.

      " Check if any items exist for this order
      LOOP AT lt_items INTO DATA(ls_item).
        IF ls_item-%is_draft = <key>-%is_draft AND
           ls_item-OrderUUID = <key>-%tky-OrderUUID.
          lv_has_items = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_has_items = abap_false.
        " No items found for this order
        APPEND VALUE #( %tky = <key>-%tky ) TO failed-order.
        APPEND VALUE #( %tky = <key>-%tky
                        %msg = new_message_with_text(
                                          severity = if_abap_behv_message=>severity-error
                                          text = 'Order must have at least one item' )
                        %element-OrderID = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.



  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
    ENTITY Order
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orderdata)
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

    LOOP AT lt_orderdata INTO DATA(ls_orderdata).

      DATA(lv_has_error) = abap_false.

      " Check Name
      IF ls_orderdata-Name IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #(
        %tky = ls_orderdata-%tky
        %state_area = 'VALIDATE_NAME'
        %msg = new_message(
        id = 'SY'
        number = '002'
        v1 = 'Name of the Order is Mandatory'
        severity = if_abap_behv_message=>severity-error )
        %element-Name = if_abap_behv=>mk-on
        ) TO reported-order.
      ENDIF.

      " Check Customer
      IF ls_orderdata-Customer IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #(
        %tky = ls_orderdata-%tky
        %state_area = 'VALIDATE_CUSTOMERID'
        %msg = new_message(
        id = 'SY'
        number = '002'
        v1 = 'Customer ID is Mandatory'
        severity = if_abap_behv_message=>severity-error )
        %element-Customer = if_abap_behv=>mk-on
        ) TO reported-order.
      ENDIF.

      " Check DeliveryCountry
      IF ls_orderdata-DeliveryCountry IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #(
        %tky = ls_orderdata-%tky
        %state_area = 'VALIDATE_DELIVERY_COUNTRY'
        %msg = new_message(
        id = 'SY'
        number = '002'
        v1 = 'Delivery Country for the Order is Mandatory'
        severity = if_abap_behv_message=>severity-error )
        %element-DeliveryCountry = if_abap_behv=>mk-on
        ) TO reported-order.
      ENDIF.

      " If any field is missing, mark the whole record as failed
      IF lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_orderdata-%tky ) TO failed-order.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
