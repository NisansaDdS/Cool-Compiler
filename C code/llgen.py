"""
Generate some sample Cool llvm code from Python.

The bookkeeping to generate the llvm code by hand was getting tedious
and too error-prone. At least generating code programmatically, I
repeat less and so get less chance to make the same mistakes over and
over.

I'm using Python here for convenience.  It will obviously be a little
different in Java.  In particular, some of the information I'm keeping
here in custom data structures should live in the AST.

Generated code is intended to be appended to BasicClasses.ll, the
built-in classes. 
"""

known_classes = { }

def type_struct(name):
    """
    llvm reference for either a Cool class or a primitive (unboxed) type
    """
    if name in known_classes:
        return "%struct.obj_{}*".format(name)
    else:
        return name

class Cool_Method:
    """
    We need enough information to figure out where to put it in the
    vtable, as well as what types it expects and produces.

    arglist should be list of (argname, argtype)
    """
    def __init__(this, method_name, class_name, result_type, arglist, vtable_position):
        this.method_name = method_name
        this.class_name = class_name # The class in which this method was defined
        this.result_type = result_type
        this.arglist = arglist 
        this.vtable_position = vtable_position

    def __str__(this):
        return "{}.{} at slot {}".format(this.class_name, this.method_name, this.vtable_position)

    def __repr__(this):
        return str(this)

    def signature(this):
        """
        Signature of this method in llvm notation
        """
        sig = ""
        sig += " {0} ".format(type_struct(this.result_type))
        sig +=  "{0}(".format(this.method_name)
        arg_sep = ""
        # print("Iterating through arglist {}".format(this.arglist))
        for argname, argtype in this.arglist:
            sig += arg_sep
            sig += " {0}".format(type_struct(argtype))
            arg_sep=", "
        sig += ")"
        return sig

    def ll_define_method(this):
        """emit llvm code for method definition beginning line"""
        lldef = "define {0} @{1}_{2}( ".format(
            type_struct(this.result_type), this.class_name, this.method_name)
        arg_sep = ""
        for argname, argtype in this.arglist:
            lldef += arg_sep
            lldef += "{0} %{1}".format(type_struct(argtype), argname)
            arg_sep = ", "
        lldef += ") #0 {"
        print(lldef);
        # return lldef

    def ll_save_arg(this, arg):
        """llvm code to allocate and store one argument in activation record
           arg is a (name type) pair, where type is a Cool object reference.
           Returns an llvm register name.
           We'll use standard names for arguments in the stack, so they are
           easy to refer to in the code. 
        """
        argname, argtype = arg
        ll_reg_name = "%local_{}".format(arg[0])
        print("    {reg} = alloca {argstruct}, align 8".format(
            reg=ll_reg_name,argstruct=type_struct(argtype)))
        print("    store {argstruct} %{argname}, {argstruct}* {reg}, align 8".format(
            reg=ll_reg_name,argname=argname,argstruct=type_struct(argtype)))
        return ll_reg_name

    def ll_save_args(this):
        for arg in this.arglist:
            this.ll_save_arg(arg)

    def ll_alloc_local(this, vname, vtype):
        """
        Create a local variable with name vname and type vtype
        """
        ll_reg_name = "%local_{}".format(vname)
        print("    {reg} = alloca {struct}, align 8".format(reg=ll_reg_name))



class LLref:
    """
    Basically an llvm register name, but since llvm wants to be reminded of the
    type of each thing it references, it is convenient to package up the register
    name with its structural type (e.g., "struct obj_Integer*" for a reference to an
    Integer object).  In a Cool program
    the only possible types are Cool objects and references to Cool objects, i.e., memory
    cells that contain references to Cool objects, so it's enough to keep the register
    name, the class (from which we can generate the structural description as needed), and
    a flag to indicate whether it's an object reference (not indirect) or the address of a
    memory cell in which the object reference can be found (indirect). 
    """

    def __init__(this, regname, regclass, indirect=False):
        this.regname = regname
        this.regclass = regclass
        this.indirect=indirect

    def __str__(this):
        """
        Printed representation of an LLref is the representation as it should
        appear in llvm code, that is, structural type followed by register name.

        There are really only two kinds of references we can have in generated
        Cool code:  object references, and references to object references. 
        """
        if this.indirect:
            return "{}* {}".format(type_struct(this.regclass), this.regname)
        else: 
            return "{} {}".format(type_struct(this.regclass), this.regname)

class LLrefgen:
    """
    Generate llvm instructions --- mostly methods for creating
    LLref objects.  Create an LLrefgen object for each method, to
    have its own set of registers. 
    """

    def __init__(this):
        # this.class_name = class_name  #Do we need it? 
        # this.the_class = known_classes[class_name]
        this.reg_count = 0
        
    def fresh_reg(this):
        """
        Allocate a fresh LLVM pseudo-register
        """
        this.reg_count += 1
        return "%{}".format(this.reg_count)

    def ll_load_local(this, local_variable_name, local_variable_type):
        """
        Given the name of a local variable (including the standard names we
        will give to arguments stored into the activation record in the stack)
        return a (register, type) pair indicating a virtual register holding
        the value that was stored in that local variable.  This corresponds
        to (load (ref-local v)), but since it results in one line of llvm code,
        for now we'll express it in one method to avoid introducing an intermediate
        virtual register (which I might get wrong).
        """
        target_reg = this.fresh_reg();
        target_struct = type_struct(local_variable_type);
        print("    {target} = load {vstruct}* %local_{vname}, align 8".format(
            target=target_reg, vstruct=target_struct, vname=local_variable_name))
        return LLref(target_reg, local_variable_type)

    def ll_extract_field(this, ref,  field_name):
        """
        We have an LLref to an object.
        We want an LLref to a field in the object. 
        """
        # Example: load self.y from Point object
        #
        # %3 = getelementptr inbounds %struct.obj_Point* %2, i32 0, i32 2
        # %4 = load %struct.obj_Integer** %3, align 8

        # We assume obj_ptr is like %2, already loaded into a register
        field_offset_reg = this.fresh_reg()
        obj_class = ref.regclass
        field_offset, field_type = known_classes[obj_class].field_ref(field_name)
        print("    {toreg} = getelementptr inbounds {objref}, i32 0, i32 {fldnum}".format(
            objref=str(ref), 
            toreg = field_offset_reg, 
            fldnum = field_offset))
        field_ref = LLref(field_offset_reg, field_type, indirect=True)
        target_reg = this.fresh_reg()
        print("    {target} = load {ref}, align 8".format(
            target=target_reg, ref=field_ref))
        target_ref = LLref(target_reg, field_type)
        return target_ref
        
    def ll_store_field(this, obj_ref, field_name, value_ref):
        """
        #(done) %5 = load %struct.obj_Point** %1, align 8
        %6 = getelementptr inbounds %struct.obj_Point* %5, i32 0, i32 1
        store %struct.obj_Integer* %4, %struct.obj_Integer** %6, align 8
        """
        target_reg = this.fresh_reg()
        obj_class = obj_ref.regclass
        field_offset, field_type = known_classes[obj_class].field_ref(field_name)
        print("     {toreg} = getelementptr inbounds {objref}, i32 0, i32 {fldnum}".format(
            objref=str(obj_ref), 
            toreg = target_reg,  
            fldnum = field_offset))
        field_ref = LLref(target_reg, field_type, indirect=True)
        print("     store  {value}, {field}, align 8".format(
           field=field_ref, value=value_ref))
        return None

    def ll_return_obj(this, obj_ref):
        """
        Return an object reference.
        We have an LLref to an object; we want to return it.
        """
        print("    ret {ref}".format(ref=obj_ref))
        



class Cool_Class:
    class_name = "DEFAULT_CLASS_NAME"
    class_super = "DEFAULT_SUPER"
    class_fields = [ ]
    class_methods = [ ]  # Includes constructor! 

    def __init__(this, this_name, this_super):
        this.class_name = this_name
        this.class_super = this_super
        if this_name == "Object":
            the_super = this
        else: 
            assert this_super in known_classes
            the_super = known_classes[this_super]
        # Inherit
        # print("Copying fields and methods from superclass {}".format(the_super))
        this.class_fields = the_super.class_fields.copy()
        this.class_methods = the_super.class_methods.copy()
        # Lookup for code generation 
        known_classes[this_name] = this

    def override(this, method_name, result_type, arglist):
        for slot in range(len(this.class_methods)):
            if method_name == this.class_methods[slot].method_name:
                the_slot = slot
                break
        else:
            print("Attempting to find method {} in class {}".format(method_name, this.class_name))
            assert False, "No matching method to override"
        vtable_position = the_slot
        this.class_methods[the_slot] = Cool_Method(method_name, this.class_name, 
                   result_type, arglist, vtable_position);

    def new_method(this, method_name, result_type, arglist):
        for slot in range(len(this.class_methods)):
            if method_name == this.class_methods[slot].method_name:
                assert False, "No overloading allowed"
        vtable_position = len(this.class_methods)
        method = Cool_Method(method_name, this.class_name, 
                                  result_type, arglist,
                                  vtable_position)
        this.class_methods.append(method)
        return method

    def new_field(this, field_name, field_type):
        this.class_fields.append( (field_name, field_type) )
    
    def __str__(this):
        return "<class {}::{}>".format(this.class_name, this.class_super)


    #
    # Code generation:  Object structure
    #
    def gen_obj_skel(this):
        # print("this.class_fields is {}".format(this.class_fields))
        # Object structure begins with class pointer
        print("%struct.obj_{0} = {{ %struct.class_{0}*".format(this.class_name), end="")
        # Then it has fields for each value
        for name, kind in this.class_fields:
            print(", {0}".format(type_struct(kind)), end="")
        print(" }")

    def gen_class_skel(this):
        print("%struct.class_{0} = {{ %struct.class_{1}*".format(
              this.class_name, this.class_super), end="")
        method_sep = ""
        for method in this.class_methods:
            print(", ", end="")
            print(method.signature(), end="")
            print("*", end="")
        print(" }")

    def gen_class_object(this):
        print("@the_class_{0} = global %struct.class_{0} {{".format(this.class_name), end="")
        # Superclass pointer
        print("%struct.class_{0}* @the_class_{0}".format(this.class_super), end="")
        # All other methods
        for method in this.class_methods:
            print(", {0} @{1}_{2}".format(method.signature(),
                                          method.class_name, method.method_name), end="")
            method_sep = ", "
        print(" }, align 8")
        

    def field_ref(this, field_name): 
        """At what offset (in number of fields) does field with field_name reside?
           We want the offset and the type of the field found there (as a tuple)
        """
        for index in range(len(this.class_fields)):
            name, kind = this.class_fields[index]
            if name==field_name:
                # Add one for class pointer
                return (index+1, kind)
        assert False, "No such field {} in {}".format(field_name, this.class_name)

def build_builtins():
    # Class Object 
    obj_clazz = Cool_Class("Object", "Object")
    obj_clazz.new_method("new", "Object", [ ])
    obj_clazz.new_method("to_string", "String", [ ("self", "Object") ])
    #
    # Class Integer
    int_clazz = Cool_Class("Integer", "Object")
    int_clazz.override("new", "Integer", [ ("val", "i32") ])
    int_clazz.new_field("value", "i32")
    int_clazz.override("to_string", "String", [ ("self", "Integer") ])
    int_clazz.new_method("add", "Integer", [("self", "Integer"), ("other", "Integer")])

def main():
    build_builtins()

    print(";; Building class Point")

    point_clazz = Cool_Class("Point", "Object")
    point_clazz.new_field("x", "Integer")
    point_clazz.new_field("y", "Integer")
    m = point_clazz.new_method("init", "Point",
                               [("self", "Point"), ("ix", "Integer"), ("iy", "Integer")])
    

    # Instructions for init
    

    # point_clazz.gen_obj_skel()
    # print()
    # point_clazz.gen_class_skel()
    # print()
    # Generating code for method "Init"
    m.ll_define_method()
    m.ll_save_args()
    gen = LLrefgen()  # Instructions in this method, with its own registers
    # self->x = ix
    thisref = gen.ll_load_local("self", "Point")
    ixref = gen.ll_load_local("ix", "Integer")
    gen.ll_store_field(thisref, "x", ixref)
    # self->y = iy
    iyref = gen.ll_load_local("iy", "Integer")
    gen.ll_store_field(thisref, "y", iyref)
    # return self
    gen.ll_return_obj(thisref)
    print("}")
    print()
    # point_clazz.gen_class_object()

                               
        
    

main()
