/*
 * C header file for basic Object classes.
 * 
 * Initially: 
 *    Integer class, partial implementatIOn (from IntObj.c)
 *    Object class, has no methods? 
 */


/* ================================
 *    Object
 * ================================
 */


struct class_Object;
struct obj_Object;
struct obj_String;  

struct obj_Object {
  struct class_Object* clazz;
};

/*
 * We'll give all Objects a "to_String" method which can be used
 * in printing.  As in Java, the top-level to_String will just 
 * identify the address of the Object. 
 */

struct class_Object {
  struct class_Object* super;
  /* vtable */
  struct obj_Object* (*constructor) ();     
  struct obj_String* (*to_String) (struct obj_Object* self);
  struct obj_String* (*type_name) (struct obj_Object* self);
  struct obj_Object* (*abort) (struct obj_Object* self);
  struct obj_Object* (*copy) (struct obj_Object* self);
};

/* Method signatures */ 
struct obj_Object* Object_new();
struct obj_String* Object_to_String(struct obj_Object* self);
struct obj_String* Object_type_name(struct obj_Object* self);
struct obj_Object* Object_abort(struct obj_Object* self);
struct obj_Object* Object_copy(struct obj_Object* self);

struct class_Object the_class_Object = {
  &the_class_Object, 
  /* vtable */ 
  Object_new, 
  Object_to_String,
  Object_type_name,
  Object_abort,
  Object_copy
};
    
  
/* ================================
 *    Integer
 * ================================
 */
struct class_Integer;
struct obj_Integer;


/* 
 * Method signatures for Integer methods, including a special constructor that takes
 * a 32-bit unboxed Integer (returning the "boxed" Integer Object).
 */
struct obj_Integer* Integer_new(int value);                       /* constructor */
struct obj_String*  Integer_to_String(struct obj_Integer* self);  /* override to_String */ 
/* additIOn */ 
struct obj_Integer* Integer_add(struct obj_Integer* self, struct obj_Integer* other);  


/* 
 * The Integer class structure
 */
struct class_Integer {
  struct class_Object* super;
  /* This is the vtable: */ 
  struct obj_Integer* (* constructor) (int);
  struct obj_String*  (* to_String) (struct obj_Integer*);
  struct obj_Integer* (* add) (struct obj_Integer* self, struct obj_Integer* other);
}; 

/* 
 * Singleton Integer class Object initialized with the vtable
 */ 
struct class_Integer the_class_Integer = { 
  &the_class_Object,
  /* Here is the vtable */
  Integer_new,  /* Constructor */
  Integer_to_String,  /* Override to_String method of Object class  */ 
  Integer_add   /* implementatIOn of a+b as a.add(b) */
};

/* static struct class_Integer* the_class_Integer = &class_Integer_rep; */

/* 
 * The Integer Object structure. Being a built-in, it can have
 *  a field ('value') that is not a Cool Object.  All user-defined 
 * classes will have only Cool Objects as fields. 
 */
struct obj_Integer {
  struct class_Integer* clazz;
  int value;
};

  
/* ================================
 *    String
 * ================================
 */

/* Following Cool design, we'll use fixed-size buffers
 * of size 1024.  
 */

struct class_String;
struct obj_String;

struct obj_String {
  struct class_String* clazz;
  char text[1024];
};

struct class_String {
  struct class_Object* super;
  /* vtable */
  struct obj_String* (*constructor) ();     
  struct obj_String* (*to_String) (struct obj_String* self);
  struct obj_String* (*copy) (struct obj_String* self);
  struct obj_String* (*concat) (struct obj_String* self, struct obj_String* other);
};

/* Method signatures */ 
struct obj_String* String_new(char *text);
struct obj_String* String_to_String(struct obj_String* self);
struct obj_String* String_copy (struct obj_String* self);
struct obj_String* String_concat (struct obj_String* self, struct obj_String* other);


struct class_String the_class_String = {
  &the_class_Object, 
  /* vtable */ 
  String_new, 
  String_to_String,
  String_copy, 
  String_concat
};
    
/* ================================
 *    IO
 * ================================
 */

struct class_IO;
struct obj_IO;

/* Method signatures */ 
struct obj_IO* IO_new();
struct obj_IO* IO_out(struct obj_IO *self, struct obj_Object *thing);
struct obj_IO* IO_out_string(struct obj_IO *self, struct obj_String *x);
struct obj_IO* IO_out_int(struct obj_IO *self, struct obj_Integer *x);
struct obj_String* IO_in_string(struct obj_IO *self);
struct obj_Integer* IO_in_int(struct obj_IO *self);

struct class_IO {
  struct class_Object* super;
  /* vtable */
  struct obj_IO* (*constructor) ();     
  struct obj_String* (*to_String) (struct obj_Object* self); /* Inherited */
  struct obj_IO* (*IO_out) (struct obj_IO *self, struct obj_Object *thing);
  struct obj_IO* (*IO_out_string) (struct obj_IO *self, struct obj_String *thing);
  struct obj_IO* (*IO_out_int) (struct obj_IO *self, struct obj_Integer *thing);
  struct obj_String* (*IO_in_string) (struct obj_IO *self);
  struct obj_Integer* (*IO_in_int) (struct obj_IO *self);
};

struct class_IO the_class_IO = {
  &the_class_Object, 
  /* vtable */ 
  IO_new,   
  Object_to_String,  /* Inherit the obj_to_String method as String_to_String */
  IO_out,
  IO_out_string,
  IO_out_int,
  IO_in_string,
  IO_in_int
};

struct obj_IO {
  struct class_IO* clazz;
};






