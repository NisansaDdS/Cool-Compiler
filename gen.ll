%struct.obj_Main = type { %struct.class_Main*}
%struct.class_Main = type { %struct.class_IO*,  %struct.obj_String* (%struct.obj_Main* )*,  %struct.obj_Main* (%struct.obj_Main* )*,  %struct.obj_Object* (%struct.obj_Main* )*,  %struct.obj_Int* (%struct.obj_Main* )*,  %struct.obj_Main* (%struct.obj_Main* %struct.obj_Int* )*,  %struct.obj_String* (%struct.obj_Main* )*,  %struct.obj_Main* (%struct.obj_Main* %struct.obj_String* )*,  %struct.obj_Main* (%struct.obj_Main* )*}
@the_class_Main = global %struct.class_Main {%struct.class_IO* @the_class_IO,  %struct.obj_String* (%struct.obj_Main* ) @Main_type_name,  %struct.obj_Main* (%struct.obj_Main* ) @Main_copy,  %struct.obj_Object* (%struct.obj_Main* ) @Main_abort,  %struct.obj_Int* (%struct.obj_Main* ) @Main_in_int,  %struct.obj_Main* (%struct.obj_Main* %struct.obj_Int* ) @Main_out_int,  %struct.obj_String* (%struct.obj_Main* ) @Main_in_string,  %struct.obj_Main* (%struct.obj_Main* %struct.obj_String* ) @Main_out_string,  %struct.obj_Main* (%struct.obj_Main* ) @Main_main }, align 8
%struct.obj_Power = type { %struct.class_Power*, %struct.obj_Int*, %struct.obj_Int*, %struct.obj_Int*, %struct.obj_Int*, %struct.obj_String*}
%struct.class_Power = type { %struct.class_IO*,  %struct.obj_String* (%struct.obj_Power* )*,  %struct.obj_Power* (%struct.obj_Power* )*,  %struct.obj_Object* (%struct.obj_Power* )*,  %struct.obj_Int* (%struct.obj_Power* )*,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_Int* )*,  %struct.obj_String* (%struct.obj_Power* )*,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_String* )*,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_Int*,  %struct.obj_String*,  %struct.obj_Int* )*,  %struct.obj_Int* (%struct.obj_Power* )*,  %struct.obj_Power* (%struct.obj_Power* )*,  %struct.obj_Int* (%struct.obj_Power* )*}
@the_class_Power = global %struct.class_Power {%struct.class_IO* @the_class_IO,  %struct.obj_String* (%struct.obj_Power* ) @Power_type_name,  %struct.obj_Power* (%struct.obj_Power* ) @Power_copy,  %struct.obj_Object* (%struct.obj_Power* ) @Power_abort,  %struct.obj_Int* (%struct.obj_Power* ) @Power_in_int,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_Int* ) @Power_out_int,  %struct.obj_String* (%struct.obj_Power* ) @Power_in_string,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_String* ) @Power_out_string,  %struct.obj_Power* (%struct.obj_Power* %struct.obj_Int*,  %struct.obj_String*,  %struct.obj_Int* ) @Power_test1,  %struct.obj_Int* (%struct.obj_Power* ) @Power_test,  %struct.obj_Power* (%struct.obj_Power* ) @Power_init,  %struct.obj_Int* (%struct.obj_Power* ) @Power_test2 }, align 8
