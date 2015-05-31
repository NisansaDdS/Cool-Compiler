/*
 * C implementatIOns for basic Cool Object classes.
 * 
 * Initially: 
 *    Integer class, partial implementatIOn (from IntObj.c)
 */

#include <stdIO.h>   
#include <stdlib.h>  /* Malloc lives here */
#include <String.h>  /* For strcpy */ 
#include <stdarg.h>


#include "BasicClasses.h"

int asprintf( char **, char *, ... );
int vasprintf( char **, char *, va_list );

/*
 *  Convenience functIOns for constructing constant literals of 
 *  Cool types Integer and String.  These are just a little easier
 *  to call from llvm code, since we don't have to chase pointers. 
 * 
 */
struct obj_Integer* int_const(int c) {
  return the_class_Integer.constructor(c);
}

struct obj_String* str_const(char *s) {
  return the_class_String.constructor(s);
}



/* ================================
 *    Object
 * ================================
 */

struct obj_Object* Object_new() {
  struct obj_Object* new_obj = (struct obj_Object *) 
    malloc(sizeof(struct obj_Object)); 
  new_obj->clazz = &the_class_Object;
  return new_obj;
}

struct obj_String* Object_to_String(struct obj_Object* self) {
  int the_address = (int) self;
  char *rep;
  asprintf(&rep, "<Object at %d>", the_address);
  return str_const(rep);
}

/* =================================
 *    Integer
 * =================================
 */ 


/*  
 * Special constructor --- builds an Integer from an Integer
 */
struct obj_Integer* Integer_new(int value) {
  struct obj_Integer* new_obj = (struct obj_Integer *) malloc(sizeof(struct obj_Integer));
  new_obj->clazz = &the_class_Integer;
  new_obj->value = value;
  return new_obj;
}


/* To String
 *  produced Cool String Object
 */

struct obj_String* Integer_to_String(struct obj_Integer* self) {
  struct obj_String* s = String_new("");
  sprintf(s->text, "%d", self->value);
  return s;
}
 
/* AdditIOn
 * a+b is implemented as a method call a.add(b), which 
 *   is implemented by Integer_add.
 */
struct obj_Integer* Integer_add(struct obj_Integer* self, struct obj_Integer* other) {
  int result_value = self->value + other->value;
  return self->clazz->constructor(result_value);
  /* Could have just been Integer_new(result_value), but I wanted to test
   * the dynamic dispatch pattern. If it were legal to inherit from Integer, 
   * using the dynamic dispatch could have resulted in a different constructor. 
   */
}


/* =================================
 *    String
 * =================================
 */ 

struct obj_String* String_new(char *text) {
  struct obj_String* new_obj = 
    (struct obj_String *) malloc(sizeof(struct obj_String));
  new_obj->clazz = &the_class_String;
  strncpy(new_obj->text, text, 1024);
  return new_obj;
}

struct obj_String*  String_to_String(struct obj_String* self) {
  return self;
}

/*
 * Create a copy of a string (so that it is safe to modify the copy)
 */
struct obj_String* String_copy (struct obj_String* self) {
  return self->clazz->constructor(self->text);
}

/*
 * Append a string to this string (up to 1024 characters)
 */
struct obj_String* String_concat (struct obj_String* self, struct obj_String* other) {
  int start_pos = strlen(self->text);
  int max_copy = 1023 - start_pos;
  strncat(self->text, other->text, max_copy);
  return self;
}

/* =====================================
 *    IO
 * =====================================
 */

/* An IO Object has no state of its own.  It's just a way
 * to inherit the IO operatIOns.  Extend it with another class
 * to get the IO operatIOns.  We'll give it a way to print
 * any Object by using the to_String method. 
 * 
 * IO needs to know about the internal representatIOn of String
 * so that it can use the C IO functIOns on it. 
 */ 

struct obj_IO* IO_new() {
  struct obj_IO* new_obj = 
    (struct obj_IO *) malloc(sizeof(struct obj_IO));
  new_obj->clazz = &the_class_IO;
  return new_obj;
}

struct obj_IO* IO_out(struct obj_IO *self, struct obj_Object *thing) {
   struct obj_String *rep = thing->clazz->to_String(thing);
   printf("%s", rep->text);
   return self;
}


/* 
 * An example of what a user-defined class "point" 
 * might look like. This will be a model for generating
 * similar LLVM code
 */
struct class_Point;
struct obj_Point;

struct obj_Point* Point_new();
struct obj_Point* Point_init(struct obj_Point* self, 
			     struct obj_Integer* xcoord,
			     struct obj_Integer* ycoord);
struct obj_Point* Point_translate(struct obj_Point* self, 
				  struct obj_Point* delta);
struct obj_String* Point_to_String(struct obj_Point* self);

struct obj_Point {
  struct class_Point* clazz;
  struct obj_Integer* x;
  struct obj_Integer* y;
};

struct class_Point {
  struct class_Object* super;
  struct obj_Point* (*constructor) ();
  struct obj_String* (*to_String) (struct obj_Point* self);
  struct obj_Point*  (*init) (struct obj_Point* self, 
			     struct obj_Integer* xcoord,
			     struct obj_Integer* ycoord);
  struct obj_Point* (*translate) (struct obj_Point* self, struct obj_Point*delta);
};

struct obj_Point*  Point_new(); 
struct obj_String* Point_to_String(struct obj_Point* self);
struct obj_Point*  Point_init(struct obj_Point *self, 
			      struct obj_Integer* x, 
			      struct obj_Integer* y);
struct obj_Point* Point_translate(struct obj_Point* self, struct obj_Point* delta);

struct class_Point the_class_Point = {
  &the_class_Object,  /* super */
  Point_new,         /* constructor */
  Point_to_String,   /* to_string */
  Point_init,        /* new method to initialize x and y coords */
  Point_translate    /* new method to move a point by x,y of another point */
};

struct obj_Point* Point_new() {
  struct obj_Point* new_obj = 
    (struct obj_Point *) malloc(sizeof(struct obj_Point));
  new_obj->clazz = &the_class_Point;
  new_obj->x = int_const(0);
  new_obj->y = int_const(0);
  return new_obj;
}
  
struct obj_String* Point_to_String(struct obj_Point* self) {
  struct obj_String* rep = str_const("(");
  rep->clazz->concat(rep, self->x->clazz->to_String(self->x));
  rep->clazz->concat(rep, str_const(","));
  rep->clazz->concat(rep, self->y->clazz->to_String(self->y));
  rep->clazz->concat(rep, str_const(")"));
  return rep;
}

struct obj_Point* Point_fake(struct obj_Point* self, 
			     struct obj_Integer* xcoord,
			     struct obj_Integer* ycoord) {
  self->x = xcoord;
  return self;
}

struct obj_Point* Point_init(struct obj_Point* self, 
			     struct obj_Integer* xcoord,
			     struct obj_Integer* ycoord) {
  self->x = xcoord;
  self->y = ycoord;
  return self;
  /* Let's see what that should be in AST-like representation
   * and what the resulting LLVM code should be. 
   * 
   * After allocating xcoord and ycoord in stack, we might have 
   * (seq
   *    (store  (load (ref-local xcoord)) (ref-field x (load (ref-local self))))
   *    (store  (load (ref-local ycoord)) (ref-field y (load (ref-local self))))
   * )
   * 
   * And the LLVM code for this is: 
   * 
    * ; Function Attrs: nounwind ssp uwtable 
    * define %struct.obj_Point* @Point_init(
         %struct.obj_Point* %self,
         %struct.obj_Integer* %xcoord, %struct.obj_Integer* %ycoord) #0 { 
    ------- Save arguments in stack ----------
    *   %1 = alloca %struct.obj_Point*, align 8      
    *   %2 = alloca %struct.obj_Integer*, align 8    
    *   %3 = alloca %struct.obj_Integer*, align 8 
    *   store %struct.obj_Point* %self, %struct.obj_Point** %1, align 8 
    *         now %1 is *self
    *   store %struct.obj_Integer* %xcoord, %struct.obj_Integer** %2, align 8 
    *         now %2 is *xcoord
    *   store %struct.obj_Integer* %ycoord, %struct.obj_Integer** %3, align 8 
    *         now %3 is *ycoord
    ---------
    *   (load (ref-local xcoord))
    *   %4 = load %struct.obj_Integer** %2, align 8 
    *   (load (ref-local self))
    *   %5 = load %struct.obj_Point** %1, align 8 
    *   (ref-field x (...))
    *   %6 = getelementptr inbounds %struct.obj_Point* %5, i32 0, i32 1 
    *   (store (load ...) (ref-field ...))
    *   store %struct.obj_Integer* %4, %struct.obj_Integer** %6, align 8 
    ----------
    *   %7 = load %struct.obj_Integer** %3, align 8 
    *   %8 = load %struct.obj_Point** %1, align 8 
    *   %9 = getelementptr inbounds %struct.obj_Point* %8, i32 0, i32 2 
    *   store %struct.obj_Integer* %7, %struct.obj_Integer** %9, align 8 
    *   %10 = load %struct.obj_Point** %1, align 8 
    *   ret %struct.obj_Point* %10 
    * } 
  */


}

struct obj_Point* Point_translate(struct obj_Point* self, 
				  struct obj_Point* delta) {
  struct obj_Integer* xd = self->x->clazz->add(self->x,delta->x);
  self->x = xd;
  struct obj_Integer* yd = self->y->clazz->add(self->y,delta->y);
  self->y = yd;
  return self;
}

/*
 * This function is not part of the Point class; I just wanted the 
 * simplest possible example of extracting a field from an object
 */
struct obj_Integer* extract_y(struct obj_Point* pt) {
  struct obj_Integer* field = pt->y;
  return field;
}


/*  
 * From class Thursday. 
 */

struct obj_Integer* silly() {
  struct obj_Integer* (*create)(int)  = the_class_Integer.constructor;
  struct obj_Integer* left =  (*create)(42);
  struct obj_Integer* right = (*create)(18);
  struct obj_Integer* sum = left->clazz->add(left,right);
  return sum;
}

/* 
 * With IO
 */
int main(int argc, char **argv) {
   struct obj_IO* io = the_class_IO.constructor();
   struct obj_String* cr = the_class_String.constructor("\n");
   struct obj_Integer* num = silly();
   io->clazz->out(io, (struct obj_Object *) num);
   io->clazz->out(io, (struct obj_Object *) cr);
   /* Let's check out the default inherited to_String on class Object */
   io->clazz->out(io, (struct obj_Object *) io);
   io->clazz->out(io, (struct obj_Object *) cr); 
   
   io->clazz->out(io, (struct obj_Object*) str_const("Now let's try a point object (15,25)\n"));
   struct obj_Point* pt = the_class_Point.constructor();
   pt->clazz->init(pt, int_const(15), int_const(25));
   io->clazz->out(io, (struct obj_Object *) pt);
   io->clazz->out(io, (struct obj_Object *) cr);

   return 0;
}



//As.c


int vasprintf( char **sptr, char *fmt, va_list argv )
{
int wanted = vsnprintf( *sptr = NULL, 0, fmt, argv );
if( (wanted < 0) || ((*sptr = malloc( 1 + wanted )) == NULL) )
return -1;

return vsprintf( *sptr, fmt, argv );
}

int asprintf( char **sptr, char *fmt, ... )
{
int retval;
va_list argv;
va_start( argv, fmt );
retval = vasprintf( sptr, fmt, argv );
va_end( argv );
return retval;
}