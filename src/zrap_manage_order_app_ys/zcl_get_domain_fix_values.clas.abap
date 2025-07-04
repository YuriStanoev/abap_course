CLASS zcl_get_domain_fix_values DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_get_domain_fix_values IMPLEMENTATION.

  METHOD if_rap_query_provider~select.
    DATA business_data TYPE TABLE OF zi_domain_fixed_val .
    DATA business_data_line TYPE zi_domain_fixed_val .
    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).

    DATA domain_name  TYPE sxco_ad_object_name  .
    DATA pos TYPE i.

    TRY.

        DATA(filter_condition_string) = io_request->get_filter( )->get_as_sql_string( ).
        DATA(filter_condition_ranges) = io_request->get_filter( )->get_as_ranges( ).

        " Get DOMAIN_NAME (mandatory)
        READ TABLE filter_condition_ranges WITH KEY name = 'DOMAIN_NAME'
             INTO DATA(filter_condition_domain_name).

        IF filter_condition_domain_name IS NOT INITIAL.
          domain_name = filter_condition_domain_name-range[ 1 ]-low.
        ELSE.
          io_response->set_total_number_of_records( 0 ).
          io_response->set_data( business_data ).
          RETURN.
        ENDIF.

        " Retrieve DDIC fixed values
        business_data_line-domain_name = domain_name.

        CAST cl_abap_elemdescr(
            cl_abap_typedescr=>describe_by_name( domain_name )
        )->get_ddic_fixed_values(
            EXPORTING
              p_langu        = sy-langu
            RECEIVING
              p_fixed_values = DATA(fixed_values)
        ).

        LOOP AT fixed_values INTO DATA(fixed_value).
          pos += 1.
          business_data_line-pos         = pos.
          business_data_line-low         = fixed_value-low.
          business_data_line-high        = fixed_value-high.
          business_data_line-description = fixed_value-ddtext.
          APPEND business_data_line TO business_data.
        ENDLOOP.

        " Apply paging
        DATA max_index TYPE i.
        IF top IS NOT INITIAL.
          max_index = top + skip.
        ELSE.
          max_index = lines( business_data ).
        ENDIF.

        " Filter business_data by DESCRIPTION or any field from CDS
        SELECT * FROM @business_data AS data_source_fields
               WHERE (filter_condition_string)
               INTO TABLE @business_data
               UP TO @max_index ROWS.

        IF skip IS NOT INITIAL.
          DELETE business_data TO skip.
        ENDIF.

        io_response->set_total_number_of_records( lines( business_data ) ).
        io_response->set_data( business_data ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.


    ENDTRY.
  ENDMETHOD.
ENDCLASS.
