CLASS zcl_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_university,
        id       TYPE i,
        name     TYPE string,
        location TYPE string,
      END OF ty_university,
      tt_universities TYPE STANDARD TABLE OF ty_university WITH KEY id.

    CLASS-METHODS:
      create_university
        IMPORTING
          iv_university_name      TYPE string
          iv_university_location  TYPE string
        RETURNING
          VALUE(rv_university_id) TYPE i,

      add_student
        IMPORTING
          iv_student_id    TYPE i
          iv_university_id TYPE i,

      delete_student
        IMPORTING
          iv_student_id TYPE i,

      list_students
        RETURNING
          VALUE(rt_students) TYPE zcl_students=>tt_students.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      gt_universities TYPE tt_universities,
      gv_next_id      TYPE i VALUE 1.

ENDCLASS.

CLASS zcl_university IMPLEMENTATION.

  METHOD create_university.
    DATA(ls_university) = VALUE ty_university(
      id       = gv_next_id
      name     = iv_university_name
      location = iv_university_location
    ).

    INSERT ls_university INTO TABLE gt_universities.
    rv_university_id = gv_next_id.
    gv_next_id = gv_next_id + 1.
  ENDMETHOD.

  METHOD add_student.
    DATA(ls_student) = zcl_students=>get_student( iv_student_id ).
    IF ls_student IS INITIAL.
      RETURN.
    ENDIF.


    zcl_students=>update_university_id(
      iv_student_id    = iv_student_id
      iv_university_id = iv_university_id
    ).
  ENDMETHOD.

  METHOD delete_student.
    DATA(ls_student) = zcl_students=>get_student( iv_student_id ).
    IF ls_student IS INITIAL OR ls_student-university_id = 0.
      RETURN.
    ENDIF.


    zcl_students=>update_university_id(
      iv_student_id    = iv_student_id
      iv_university_id = 0
    ).
  ENDMETHOD.

  METHOD list_students.
    DATA(lt_all_students) = zcl_students=>get_all_students( ).
    rt_students = VALUE #( FOR ls_student IN lt_all_students
                           WHERE ( university_id <> 0 ) ( ls_student ) ).
  ENDMETHOD.

ENDCLASS.
