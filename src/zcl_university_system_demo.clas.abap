CLASS zcl_university_system_demo DEFINITION
  PUBLIC
  FINAL
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  CREATE PUBLIC.

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: main REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_university_system_demo IMPLEMENTATION.
  METHOD main.
*   Step 1: Create universities
    out->write( |**** Creating Universities ****| ).
    DATA(lv_sofiauni_id) = zcl_university=>create_university(
      iv_university_name      = 'Софийски университет "Св. Климент Охридски"'
      iv_university_location  = 'София, България'
    ).

    DATA(lv_tehuni_id) = zcl_university=>create_university(
      iv_university_name      = 'Технически университет - София'
      iv_university_location  = 'София, България'
    ).

    out->write( |Created Sofia University with ID: { lv_sofiauni_id }| ).
    out->write( |Created Technical University of Sofia with ID: { lv_tehuni_id }| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 2: Create students
    out->write( |**** Creating Students ****| ).
    DATA(lv_student1_id) = zcl_students=>create_student(
      iv_name  = 'Иван Петров'
      iv_age   = 21
      iv_major = 'Информатика'
      iv_email = 'ivan.petrov@students.uni-sofia.bg'
    ).

    DATA(lv_student2_id) = zcl_students=>create_student(
      iv_name  = 'Мария Георгиева'
      iv_age   = 22
      iv_major = 'Математика'
      iv_email = 'maria.georgieva@students.tu-sofia.bg'
    ).

    DATA(lv_student3_id) = zcl_students=>create_student(
      iv_name  = 'Георги Димитров'
      iv_age   = 20
      iv_major = 'Физика'
      iv_email = 'georgi.dimitrov@students.uni-sofia.bg'
    ).

    out->write( |Created student Иван Петров with ID: { lv_student1_id }| ).
    out->write( |Created student Мария Георгиева with ID: { lv_student2_id }| ).
    out->write( |Created student Георги Димитров with ID: { lv_student3_id }| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 3: Read student information
    out->write( |**** Reading Student Information ****| ).
    DATA(ls_student1) = zcl_students=>get_student( lv_student1_id ).
    out->write( |Student details: { ls_student1-name }, Age: { ls_student1-age }, Major: { ls_student1-major }| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 4: Update student information
    out->write( |**** Updating Student Information ****| ).
    zcl_students=>update_student(
      iv_student_id = lv_student1_id
      iv_name       = 'Иван Петров Петров'
      iv_age        = 22
      iv_major      = 'Изкуствен интелект'
      iv_email      = 'ivan.petrov@students.uni-sofia.bg'
    ).

    ls_student1 = zcl_students=>get_student( lv_student1_id ).
    out->write( |Updated student: { ls_student1-name }, Age: { ls_student1-age }, Major: { ls_student1-major }| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 5: Add students to universities
    out->write( |**** Adding Students to Universities ****| ).
    zcl_university=>add_student(
      iv_student_id    = lv_student1_id
      iv_university_id = lv_sofiauni_id
    ).

    zcl_university=>add_student(
      iv_student_id    = lv_student2_id
      iv_university_id = lv_tehuni_id
    ).

    zcl_university=>add_student(
      iv_student_id    = lv_student3_id
      iv_university_id = lv_sofiauni_id
    ).

    out->write( |Students have been enrolled in universities| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 6: List all students in universities
    out->write( |**** Listing All University Students ****| ).
    DATA(lt_university_students) = zcl_university=>list_students( ).

    LOOP AT lt_university_students INTO DATA(ls_uni_student).
      out->write( |Student ID: { ls_uni_student-student_id }, Name: { ls_uni_student-name }, | &&
                  |University ID: { ls_uni_student-university_id }, Major: { ls_uni_student-major }| ).
    ENDLOOP.
    out->write( cl_abap_char_utilities=>newline ).

*   Step 7: Delete a student from university
    out->write( |**** Removing Student from University ****| ).
    zcl_university=>delete_student( lv_student2_id ).
    out->write( |Student Мария Георгиева has been removed from the university| ).
    out->write( cl_abap_char_utilities=>newline ).

*   Step 8: List students after deletion
    out->write( |**** Listing Students After Removal ****| ).
    lt_university_students = zcl_university=>list_students( ).

    LOOP AT lt_university_students INTO ls_uni_student.
      out->write( |Student ID: { ls_uni_student-student_id }, Name: { ls_uni_student-name }, | &&
                  |University ID: { ls_uni_student-university_id }, Major: { ls_uni_student-major }| ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
