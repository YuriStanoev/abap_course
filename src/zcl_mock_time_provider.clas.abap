CLASS zcl_mock_time_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_time_provider.
    METHODS: constructor
    IMPORTING iv_fixed_timestamp TYPE timestampl.

  PROTECTED SECTION.
  PRIVATE SECTION.
  DATA: mv_fixed_timestamp TYPE timestampl.
ENDCLASS.



CLASS zcl_mock_time_provider IMPLEMENTATION.


  METHOD zif_time_provider~get_current_timestamp.
  rv_timestamp = mv_fixed_timestamp.
  ENDMETHOD.
  METHOD constructor.
mv_fixed_timestamp = iv_fixed_timestamp.
  ENDMETHOD.


ENDCLASS.
