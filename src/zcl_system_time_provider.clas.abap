CLASS zcl_system_time_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES zif_time_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_system_time_provider IMPLEMENTATION.
  METHOD zif_time_provider~get_current_timestamp.
    GET TIME STAMP FIELD rv_timestamp.
  ENDMETHOD.

ENDCLASS.
