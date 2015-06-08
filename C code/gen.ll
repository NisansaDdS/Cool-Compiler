%struct.obj_Main = type { %struct.class_Main*}
%struct.class_Main = type { %struct.class_IO*, %struct.obj_Main* (...)*,  %struct.obj_String* (%struct.obj_Object* )*,  %struct.obj_String* (%struct.obj_Object* )*,  %struct.obj_Object* (%struct.obj_Object* )*,  %struct.obj_Object* (%struct.obj_Object* )*,  %struct.obj_Integer* (%struct.obj_IO* )*,  %struct.obj_IO* (%struct.obj_IO*,  %struct.obj_Integer* )*,  %struct.obj_String* (%struct.obj_IO* )*,  %struct.obj_IO* (%struct.obj_IO*,  %struct.obj_String* )*,  %struct.obj_Object* (%struct.obj_Main* )*}
@the_class_Main = global %struct.class_Main {%struct.class_IO* @the_class_IO, %struct.obj_Main* (...)* bitcast (%struct.obj_Main* ()* @Main_new to %struct.obj_Main* (...)*),  %struct.obj_String* (%struct.obj_Object* )* @Object_to_String,  %struct.obj_String* (%struct.obj_Object* )* @Object_type_name,  %struct.obj_Object* (%struct.obj_Object* )* @Object_copy,  %struct.obj_Object* (%struct.obj_Object* )* @Object_abort,  %struct.obj_Integer* (%struct.obj_IO* )* @IO_in_int,  %struct.obj_IO* (%struct.obj_IO*,  %struct.obj_Integer* )* @IO_out_int,  %struct.obj_String* (%struct.obj_IO* )* @IO_in_string,  %struct.obj_IO* (%struct.obj_IO*,  %struct.obj_String* )* @IO_out_string,  %struct.obj_Object* (%struct.obj_Main* )* @Main_main }, align 8
@.strs0 = private unnamed_addr constant [14 x i8] c"Hello, world.\00", align 1
define %struct.obj_Object*  @Main_main(%struct.obj_Main* %Self ) #0 {
entry:
    %local_Self = alloca %struct.obj_Main*, align 8
    store %struct.obj_Main* %Self, %struct.obj_Main** %local_Self, align 8

    %owner = alloca %struct.obj_IO*, align 4
    %local_1 = load %struct.obj_IO* (...)** getelementptr inbounds (%struct.class_IO* @the_class_IO, i32 0, i32 1), align 4
    %callee.knr.cast0 = bitcast %struct.obj_IO* (...)* %local_1 to %struct.obj_IO* ()*
    %call0 = call %struct.obj_IO* %callee.knr.cast0()
    store %struct.obj_IO* %call0, %struct.obj_IO** %owner, align 4
    %local_2 = alloca %struct.obj_String*, align 4
    %local_3 = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 4
    %callee.knr.cast1 = bitcast %struct.obj_String* (...)* %local_3 to %struct.obj_String* (i8*)*
    %call1 = call %struct.obj_String* %callee.knr.cast1(i8* getelementptr inbounds ([14 x i8]* @.strs0, i32 0, i32 0))
    store %struct.obj_String* %call1, %struct.obj_String** %local_2, align 4
    %local_4 = load %struct.obj_IO** %owner, align 4
    %local_5 = getelementptr inbounds %struct.obj_IO* %local_4, i32 0, i32 0
    %local_6 = load %struct.class_IO** %local_5, align 4
    %local_7 = getelementptr inbounds %struct.class_IO* %local_6, i32 0, i32 3
    %local_8 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %local_7, align 4
    %local_9 = load %struct.obj_IO** %owner, align 4
    %local_10 = load %struct.obj_String** %local_2, align 4
    %local_11 = bitcast %struct.obj_String* %local_10 to %struct.obj_Object*
    %call2 = call %struct.obj_IO* %local_8(%struct.obj_IO* %local_9, %struct.obj_Object* %local_11)
    %local_12 = load %struct.obj_Object* (...)** getelementptr inbounds (%struct.class_Object* @the_class_Object, i32 0, i32 1), align 4
    %callee.knr.cast2 = bitcast %struct.obj_Object* (...)* %local_12 to %struct.obj_Object* ()*
    %call_3 = call %struct.obj_Object* %callee.knr.cast2()
    ret %struct.obj_Object* %call_3
}
define %struct.obj_Main* @Main_new() #0 {
entry:
     %new_obj = alloca %struct.obj_Main*, align 4
     %call = call noalias i8* @malloc(i32 4) #2
     %0 = bitcast i8* %call to %struct.obj_Main*
     store %struct.obj_Main* %0, %struct.obj_Main** %new_obj, align 4
     %1 = load %struct.obj_Main** %new_obj, align 4
     %clazz = getelementptr inbounds %struct.obj_Main* %1, i32 0, i32 0
     store %struct.class_Main* @the_class_Main, %struct.class_Main** %clazz, align 4
     %2 = load %struct.obj_Main** %new_obj, align 4
     ret %struct.obj_Main* %2
}
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
   %retval = alloca i32, align 4
   %argc.addr = alloca i32, align 4
   %argv.addr = alloca i8**, align 4
   store i32 0, i32* %retval
   store i32 %argc, i32* %argc.addr, align 4
   store i8** %argv, i8*** %argv.addr, align 4
   %call1 = call %struct.obj_Main* @Main_new()
   %call = call %struct.obj_Object* @Main_main(%struct.obj_Main* %call1)
   ret i32 0
}