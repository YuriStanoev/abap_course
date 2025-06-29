INTERFACE zif_time_provider
  PUBLIC .

  METHODS: get_current_timestamp
  RETURNING VALUE(rv_timestamp) TYPE timestampl.

ENDINTERFACE.
