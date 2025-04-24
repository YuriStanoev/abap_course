CLASS zcl_students DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_student,
        student_id    TYPE i,
        university_id TYPE i,
        name          TYPE string,
        age           TYPE i,
        major         TYPE string,
        email         TYPE string,
      END OF ty_student,
      tt_students TYPE STANDARD TABLE OF ty_student WITH KEY student_id.

    CLASS-METHODS:
      create_student
        IMPORTING
          iv_name              TYPE string
          iv_age               TYPE i
          iv_major             TYPE string
          iv_email             TYPE string
        RETURNING
          VALUE(rv_student_id) TYPE i,

      get_student
        IMPORTING
          iv_student_id     TYPE i
        RETURNING
          VALUE(rs_student) TYPE ty_student,

      update_student
        IMPORTING
          iv_student_id TYPE i
          iv_name       TYPE string
          iv_age        TYPE i
          iv_major      TYPE string
          iv_email      TYPE string,

      update_university_id
        IMPORTING
          iv_student_id    TYPE i
          iv_university_id TYPE i,

      get_all_students
        RETURNING
          VALUE(rt_students) TYPE tt_students.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      gt_students TYPE tt_students,
      gv_next_id  TYPE i VALUE 1.

ENDCLASS.

CLASS zcl_students IMPLEMENTATION.

  METHOD create_student.
    DATA(ls_student) = VALUE ty_student(
      student_id    = gv_next_id
      university_id = 0
      name          = iv_name
      age           = iv_age
      major         = iv_major
      email         = iv_email
    ).

    INSERT ls_student INTO TABLE gt_students.
    rv_student_id = gv_next_id.
    gv_next_id = gv_next_id + 1.
  ENDMETHOD.

  METHOD get_student.
    READ TABLE gt_students INTO rs_student WITH KEY student_id = iv_student_id.
  ENDMETHOD.

  METHOD update_student.
    DATA lv_index TYPE sy-tabix.
    READ TABLE gt_students WITH KEY student_id = iv_student_id TRANSPORTING NO FIELDS.
    lv_index = sy-tabix.

    IF lv_index > 0.
      DATA(lv_university_id) = gt_students[ lv_index ]-university_id.

      MODIFY gt_students FROM VALUE #(
        student_id    = iv_student_id
        university_id = lv_university_id
        name          = iv_name
        age           = iv_age
        major         = iv_major
        email         = iv_email
      ) INDEX lv_index.
    ENDIF.
  ENDMETHOD.

  METHOD update_university_id.
    DATA lv_index TYPE sy-tabix.
    READ TABLE gt_students WITH KEY student_id = iv_student_id TRANSPORTING NO FIELDS.
    lv_index = sy-tabix.

    IF lv_index > 0.
      gt_students[ lv_index ]-university_id = iv_university_id.
    ENDIF.
  ENDMETHOD.

  METHOD get_all_students.
    rt_students = gt_students.
  ENDMETHOD.

ENDCLASS.
