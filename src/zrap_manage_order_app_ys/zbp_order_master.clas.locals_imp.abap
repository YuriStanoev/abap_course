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

    METHODS calculateComplexity FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~calculateComplexity.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~setInitialStatus.

    METHODS setCreationDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setCreationDate.

    METHODS setOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setOrderID.

    METHODS validateItemsExist FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateItemsExist.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~calculateTotalPrice.

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
                      " %update = COND #( WHEN ls_order-Status = 'In Process'
                     "                  THEN if_abap_behv=>fc-o-enabled
                      "                ELSE if_abap_behv=>fc-o-disabled )
                      "%delete = COND #( WHEN ls_order-Status = 'In Process'
                       "                 THEN if_abap_behv=>fc-o-enabled
                        "                ELSE if_abap_behv=>fc-o-disabled )
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

  METHOD calculateComplexity.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
    ENTITY Order
      FIELDS ( OrderUUID )
      WITH CORRESPONDING #( keys )
    RESULT DATA(orders).

    IF orders IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).

      READ ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          BY \_Items
          FIELDS ( ItemUUID )
          WITH VALUE #( ( %tky = <order>-%tky ) )
        RESULT DATA(items).

      DATA(item_count) = lines( items ).
      DATA(complexity) = COND string(
          WHEN item_count < 3 THEN 'Easy'
          WHEN item_count <= 4 THEN 'Medium'
          ELSE 'Complex' ).

      MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( Complexity )
          WITH VALUE #( ( %tky = <order>-%tky
                          Complexity = complexity ) )
          REPORTED DATA(ls_reported).

    ENDLOOP.

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
  METHOD calculateTotalPrice.
    TYPES: BEGIN OF ty_item,
             item_uuid     TYPE zorder_items-item_uuid,
             price         TYPE zorder_items-price,
             quantity      TYPE zorder_items-quantity,
             currency_code TYPE zorder_items-currency_code,
           END OF ty_item.

    DATA: lt_order_updates TYPE TABLE FOR UPDATE zi_order_ys.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      DATA: total_price              TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
            currency                 TYPE /dmo/currency_code,
            lt_items_mem             TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,
            lt_items_db              TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,
            lt_items_combined        TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,
            lt_item_uuids_to_exclude TYPE HASHED TABLE OF zorder_items-item_uuid
                                      WITH UNIQUE KEY table_line.

      " Get in-memory OrderItem entities
      READ ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order BY \_Items
        FIELDS ( itemuuid price quantity currencycode )
        WITH VALUE #( ( %tky = <key>-%tky ) )
        RESULT DATA(lt_items_all).

      LOOP AT lt_items_all INTO DATA(ls_mem).
        APPEND VALUE ty_item(
          item_uuid     = ls_mem-itemuuid
          price         = ls_mem-price
          quantity      = ls_mem-quantity
          currency_code = ls_mem-currencycode
        ) TO lt_items_mem.

        IF ls_mem-itemuuid IS NOT INITIAL.
          INSERT ls_mem-itemuuid INTO TABLE lt_item_uuids_to_exclude.
        ENDIF.
      ENDLOOP.

      " Read remaining items from DB
      IF lt_item_uuids_to_exclude IS INITIAL.
        SELECT item_uuid, price, quantity, currency_code
          FROM zorder_items
          WHERE order_uuid = @<key>-%tky-OrderUUID
          INTO TABLE @lt_items_db.
      ELSE.
        DATA lt_uuids_exclude TYPE STANDARD TABLE OF zorder_items-item_uuid WITH EMPTY KEY.

        LOOP AT lt_item_uuids_to_exclude INTO DATA(uuid).
          APPEND uuid TO lt_uuids_exclude.
        ENDLOOP.
        SELECT item_uuid, price, quantity, currency_code
          FROM zorder_items
          FOR ALL ENTRIES IN @lt_uuids_exclude
          WHERE order_uuid = @<key>-%tky-OrderUUID
            AND item_uuid <> @lt_uuids_exclude-table_line
          INTO TABLE @lt_items_db.
      ENDIF.

      " Combine in-memory + DB items
      APPEND LINES OF lt_items_mem TO lt_items_combined.
      APPEND LINES OF lt_items_db  TO lt_items_combined.

      IF lt_items_combined IS INITIAL.
        CONTINUE.
      ENDIF.

      LOOP AT lt_items_combined INTO DATA(ls_item).
        total_price = total_price + ( ls_item-price * ls_item-quantity ).
        IF currency IS INITIAL AND ls_item-currency_code IS NOT INITIAL.
          currency = ls_item-currency_code.
        ENDIF.
      ENDLOOP.

      APPEND VALUE #(
        %tky         = <key>-%tky
        TotalPrice   = total_price
        CurrencyCode = currency
      ) TO lt_order_updates.

    ENDLOOP.

    IF lt_order_updates IS NOT INITIAL.
      MODIFY ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
        UPDATE FIELDS ( TotalPrice CurrencyCode )
        WITH lt_order_updates
        REPORTED DATA(ls_reported).
    ENDIF.
  ENDMETHOD.

  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_order_ys IN LOCAL MODE
        ENTITY Order
          FIELDS ( Name Customer DeliveryCountry )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_order).

      " Validate Name
      IF ls_order-Name IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #( %tky = ls_order-%tky
                       %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text = 'Name is mandatory' )
                       %element-Name = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.

      " Validate Customer
      IF ls_order-Customer IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #( %tky = ls_order-%tky
                       %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text = 'Customer is mandatory' )
                       %element-Customer = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.

      " Validate DeliveryCountry
      IF ls_order-DeliveryCountry IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #( %tky = ls_order-%tky
                       %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text = 'Delivery Country is mandatory' )
                       %element-DeliveryCountry = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
