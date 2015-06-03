; ModuleID = 'BasicClasses.c'
target datalayout = "e-m:w-p:32:32-i64:64-f80:32-n8:16:32-S32"
target triple = "i686-pc-windows-gnu"

%struct.class_Object = type { %struct.class_Object*, %struct.obj_Object* (...)*, %struct.obj_String* (%struct.obj_Object*)*, %struct.obj_String* (%struct.obj_Object*)*, %struct.obj_Object* (%struct.obj_Object*)*, %struct.obj_Object* (%struct.obj_Object*)* }
%struct.obj_Object = type { %struct.class_Object* }
%struct.obj_String = type { %struct.class_String*, [1024 x i8] }
%struct.class_String = type { %struct.class_Object*, %struct.obj_String* (...)*, %struct.obj_String* (%struct.obj_String*)*, %struct.obj_String* (%struct.obj_String*)*, %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)* }
%struct.class_Integer = type { %struct.class_Object*, %struct.obj_Integer* (i32)*, %struct.obj_String* (%struct.obj_Integer*)*, %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)* }
%struct.obj_Integer = type { %struct.class_Integer*, i32 }
%struct.class_IO = type { %struct.class_Object*, %struct.obj_IO* (...)*, %struct.obj_String* (%struct.obj_Object*)*, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)*, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_String*)*, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Integer*)*, %struct.obj_String* (%struct.obj_IO*)*, %struct.obj_Integer* (%struct.obj_IO*)* }
%struct.obj_IO = type { %struct.class_IO* }
%struct.obj_Point = type { %struct.class_Point*, %struct.obj_Integer*, %struct.obj_Integer* }
%struct.class_Point = type { %struct.class_Object*, {}*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* }

@the_class_Object = global %struct.class_Object { %struct.class_Object* @the_class_Object, %struct.obj_Object* (...)* bitcast (%struct.obj_Object* ()* @Object_new to %struct.obj_Object* (...)*), %struct.obj_String* (%struct.obj_Object*)* @Object_to_String, %struct.obj_String* (%struct.obj_Object*)* @Object_type_name, %struct.obj_Object* (%struct.obj_Object*)* @Object_abort, %struct.obj_Object* (%struct.obj_Object*)* @Object_copy }, align 4
@the_class_Integer = global %struct.class_Integer { %struct.class_Object* @the_class_Object, %struct.obj_Integer* (i32)* @Integer_new, %struct.obj_String* (%struct.obj_Integer*)* @Integer_to_String, %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)* @Integer_add }, align 4
@the_class_String = global %struct.class_String { %struct.class_Object* @the_class_Object, %struct.obj_String* (...)* bitcast (%struct.obj_String* (i8*)* @String_new to %struct.obj_String* (...)*), %struct.obj_String* (%struct.obj_String*)* @String_to_String, %struct.obj_String* (%struct.obj_String*)* @String_copy, %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)* @String_concat }, align 4
@the_class_IO = global %struct.class_IO { %struct.class_Object* @the_class_Object, %struct.obj_IO* (...)* bitcast (%struct.obj_IO* ()* @IO_new to %struct.obj_IO* (...)*), %struct.obj_String* (%struct.obj_Object*)* @Object_to_String, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)* @IO_out, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_String*)* @IO_out_string, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Integer*)* @IO_out_int, %struct.obj_String* (%struct.obj_IO*)* @IO_in_string, %struct.obj_Integer* (%struct.obj_IO*)* @IO_in_int }, align 4
@.str = private unnamed_addr constant [15 x i8] c"<Object at %d>\00", align 1
@.str1 = private unnamed_addr constant [11 x i8] c"Dummy Copy\00", align 1
@.str2 = private unnamed_addr constant [12 x i8] c"Dummy abort\00", align 1
@.str3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str4 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str5 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str6 = private unnamed_addr constant [16 x i8] c"Dummy in_string\00", align 1
@.str7 = private unnamed_addr constant [22 x i8] c"Dummy in_int gives %d\00", align 1
@the_class_Point = global { %struct.class_Object*, %struct.obj_Point* (...)*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* } { %struct.class_Object* @the_class_Object, %struct.obj_Point* (...)* bitcast (%struct.obj_Point* ()* @Point_new to %struct.obj_Point* (...)*), %struct.obj_String* (%struct.obj_Point*)* @Point_to_String, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)* @Point_init, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* @Point_translate }, align 4
@.str8 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str9 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str10 = private unnamed_addr constant [2 x i8] c")\00", align 1

; Function Attrs: nounwind
define %struct.obj_String* @Object_to_String(%struct.obj_Object* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Object*, align 4
  %the_address = alloca i32, align 4
  %rep = alloca i8*, align 4
  store %struct.obj_Object* %self, %struct.obj_Object** %self.addr, align 4
  %0 = load %struct.obj_Object** %self.addr, align 4
  %1 = ptrtoint %struct.obj_Object* %0 to i32
  store i32 %1, i32* %the_address, align 4
  %2 = load i32* %the_address, align 4
  %call = call i32 (i8**, i8*, ...)* @asprintf(i8** %rep, i8* getelementptr inbounds ([15 x i8]* @.str, i32 0, i32 0), i32 %2)
  %3 = load i8** %rep, align 4
  %call1 = call %struct.obj_String* @str_const(i8* %3)
  ret %struct.obj_String* %call1
}

; Function Attrs: nounwind
define %struct.obj_String* @Object_type_name(%struct.obj_Object* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Object*, align 4
  %the_address = alloca i32, align 4
  %rep = alloca i8*, align 4
  store %struct.obj_Object* %self, %struct.obj_Object** %self.addr, align 4
  %0 = load %struct.obj_Object** %self.addr, align 4
  %1 = ptrtoint %struct.obj_Object* %0 to i32
  store i32 %1, i32* %the_address, align 4
  %2 = load i32* %the_address, align 4
  %call = call i32 (i8**, i8*, ...)* @asprintf(i8** %rep, i8* getelementptr inbounds ([15 x i8]* @.str, i32 0, i32 0), i32 %2)
  %3 = load i8** %rep, align 4
  %call1 = call %struct.obj_String* @str_const(i8* %3)
  ret %struct.obj_String* %call1
}

; Function Attrs: nounwind
define %struct.obj_Object* @Object_abort(%struct.obj_Object* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Object*, align 4
  %rep = alloca i8*, align 4
  store %struct.obj_Object* %self, %struct.obj_Object** %self.addr, align 4
  %call = call i32 (i8**, i8*, ...)* @asprintf(i8** %rep, i8* getelementptr inbounds ([12 x i8]* @.str2, i32 0, i32 0))
  %0 = load %struct.obj_Object** %self.addr, align 4
  ret %struct.obj_Object* %0
}

; Function Attrs: nounwind
define %struct.obj_Object* @Object_copy(%struct.obj_Object* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Object*, align 4
  %rep = alloca i8*, align 4
  store %struct.obj_Object* %self, %struct.obj_Object** %self.addr, align 4
  %call = call i32 (i8**, i8*, ...)* @asprintf(i8** %rep, i8* getelementptr inbounds ([11 x i8]* @.str1, i32 0, i32 0))
  %0 = load %struct.obj_Object** %self.addr, align 4
  ret %struct.obj_Object* %0
}

; Function Attrs: nounwind
define %struct.obj_Integer* @Integer_new(i32 %value) #0 {
entry:
  %value.addr = alloca i32, align 4
  %new_obj = alloca %struct.obj_Integer*, align 4
  store i32 %value, i32* %value.addr, align 4
  %call = call noalias i8* @malloc(i32 8) #2
  %0 = bitcast i8* %call to %struct.obj_Integer*
  store %struct.obj_Integer* %0, %struct.obj_Integer** %new_obj, align 4
  %1 = load %struct.obj_Integer** %new_obj, align 4
  %clazz = getelementptr inbounds %struct.obj_Integer* %1, i32 0, i32 0
  store %struct.class_Integer* @the_class_Integer, %struct.class_Integer** %clazz, align 4
  %2 = load i32* %value.addr, align 4
  %3 = load %struct.obj_Integer** %new_obj, align 4
  %value1 = getelementptr inbounds %struct.obj_Integer* %3, i32 0, i32 1
  store i32 %2, i32* %value1, align 4
  %4 = load %struct.obj_Integer** %new_obj, align 4
  ret %struct.obj_Integer* %4
}

; Function Attrs: nounwind
define %struct.obj_String* @Integer_to_String(%struct.obj_Integer* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Integer*, align 4
  %s = alloca %struct.obj_String*, align 4
  store %struct.obj_Integer* %self, %struct.obj_Integer** %self.addr, align 4
  %call = call %struct.obj_String* @String_new(i8* getelementptr inbounds ([1 x i8]* @.str3, i32 0, i32 0))
  store %struct.obj_String* %call, %struct.obj_String** %s, align 4
  %0 = load %struct.obj_String** %s, align 4
  %text = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %1 = load %struct.obj_Integer** %self.addr, align 4
  %value = getelementptr inbounds %struct.obj_Integer* %1, i32 0, i32 1
  %2 = load i32* %value, align 4
  %call1 = call i32 (i8*, i8*, ...)* @sprintf(i8* %arraydecay, i8* getelementptr inbounds ([3 x i8]* @.str4, i32 0, i32 0), i32 %2) #2
  %3 = load %struct.obj_String** %s, align 4
  ret %struct.obj_String* %3
}

; Function Attrs: nounwind
define %struct.obj_Integer* @Integer_add(%struct.obj_Integer* %self, %struct.obj_Integer* %other) #0 {
entry:
  %self.addr = alloca %struct.obj_Integer*, align 4
  %other.addr = alloca %struct.obj_Integer*, align 4
  %result_value = alloca i32, align 4
  store %struct.obj_Integer* %self, %struct.obj_Integer** %self.addr, align 4
  store %struct.obj_Integer* %other, %struct.obj_Integer** %other.addr, align 4
  %0 = load %struct.obj_Integer** %self.addr, align 4
  %value = getelementptr inbounds %struct.obj_Integer* %0, i32 0, i32 1
  %1 = load i32* %value, align 4
  %2 = load %struct.obj_Integer** %other.addr, align 4
  %value1 = getelementptr inbounds %struct.obj_Integer* %2, i32 0, i32 1
  %3 = load i32* %value1, align 4
  %add = add nsw i32 %1, %3
  store i32 %add, i32* %result_value, align 4
  %4 = load %struct.obj_Integer** %self.addr, align 4
  %clazz = getelementptr inbounds %struct.obj_Integer* %4, i32 0, i32 0
  %5 = load %struct.class_Integer** %clazz, align 4
  %constructor = getelementptr inbounds %struct.class_Integer* %5, i32 0, i32 1
  %6 = load %struct.obj_Integer* (i32)** %constructor, align 4
  %7 = load i32* %result_value, align 4
  %call = call %struct.obj_Integer* %6(i32 %7)
  ret %struct.obj_Integer* %call
}

; Function Attrs: nounwind
define %struct.obj_String* @String_new(i8* %text) #0 {
entry:
  %text.addr = alloca i8*, align 4
  %new_obj = alloca %struct.obj_String*, align 4
  store i8* %text, i8** %text.addr, align 4
  %call = call noalias i8* @malloc(i32 1028) #2
  %0 = bitcast i8* %call to %struct.obj_String*
  store %struct.obj_String* %0, %struct.obj_String** %new_obj, align 4
  %1 = load %struct.obj_String** %new_obj, align 4
  %clazz = getelementptr inbounds %struct.obj_String* %1, i32 0, i32 0
  store %struct.class_String* @the_class_String, %struct.class_String** %clazz, align 4
  %2 = load %struct.obj_String** %new_obj, align 4
  %text1 = getelementptr inbounds %struct.obj_String* %2, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text1, i32 0, i32 0
  %3 = load i8** %text.addr, align 4
  %call2 = call i8* @strncpy(i8* %arraydecay, i8* %3, i32 1024) #2
  %4 = load %struct.obj_String** %new_obj, align 4
  ret %struct.obj_String* %4
}

; Function Attrs: nounwind
define %struct.obj_String* @String_to_String(%struct.obj_String* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_String*, align 4
  store %struct.obj_String* %self, %struct.obj_String** %self.addr, align 4
  %0 = load %struct.obj_String** %self.addr, align 4
  ret %struct.obj_String* %0
}

; Function Attrs: nounwind
define %struct.obj_String* @String_copy(%struct.obj_String* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_String*, align 4
  store %struct.obj_String* %self, %struct.obj_String** %self.addr, align 4
  %0 = load %struct.obj_String** %self.addr, align 4
  %clazz = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 0
  %1 = load %struct.class_String** %clazz, align 4
  %constructor = getelementptr inbounds %struct.class_String* %1, i32 0, i32 1
  %2 = load %struct.obj_String* (...)** %constructor, align 4
  %3 = load %struct.obj_String** %self.addr, align 4
  %text = getelementptr inbounds %struct.obj_String* %3, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %callee.knr.cast = bitcast %struct.obj_String* (...)* %2 to %struct.obj_String* (i8*)*
  %call = call %struct.obj_String* %callee.knr.cast(i8* %arraydecay)
  ret %struct.obj_String* %call
}

; Function Attrs: nounwind
define %struct.obj_String* @String_concat(%struct.obj_String* %self, %struct.obj_String* %other) #0 {
entry:
  %self.addr = alloca %struct.obj_String*, align 4
  %other.addr = alloca %struct.obj_String*, align 4
  %start_pos = alloca i32, align 4
  %max_copy = alloca i32, align 4
  store %struct.obj_String* %self, %struct.obj_String** %self.addr, align 4
  store %struct.obj_String* %other, %struct.obj_String** %other.addr, align 4
  %0 = load %struct.obj_String** %self.addr, align 4
  %text = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %call = call i32 @strlen(i8* %arraydecay) #3
  store i32 %call, i32* %start_pos, align 4
  %1 = load i32* %start_pos, align 4
  %sub = sub nsw i32 1023, %1
  store i32 %sub, i32* %max_copy, align 4
  %2 = load %struct.obj_String** %self.addr, align 4
  %text1 = getelementptr inbounds %struct.obj_String* %2, i32 0, i32 1
  %arraydecay2 = getelementptr inbounds [1024 x i8]* %text1, i32 0, i32 0
  %3 = load %struct.obj_String** %other.addr, align 4
  %text3 = getelementptr inbounds %struct.obj_String* %3, i32 0, i32 1
  %arraydecay4 = getelementptr inbounds [1024 x i8]* %text3, i32 0, i32 0
  %4 = load i32* %max_copy, align 4
  %call5 = call i8* @strncat(i8* %arraydecay2, i8* %arraydecay4, i32 %4) #2
  %5 = load %struct.obj_String** %self.addr, align 4
  ret %struct.obj_String* %5
}

; Function Attrs: nounwind
define %struct.obj_IO* @IO_out(%struct.obj_IO* %self, %struct.obj_Object* %thing) #0 {
entry:
  %self.addr = alloca %struct.obj_IO*, align 4
  %thing.addr = alloca %struct.obj_Object*, align 4
  %rep = alloca %struct.obj_String*, align 4
  store %struct.obj_IO* %self, %struct.obj_IO** %self.addr, align 4
  store %struct.obj_Object* %thing, %struct.obj_Object** %thing.addr, align 4
  %0 = load %struct.obj_Object** %thing.addr, align 4
  %clazz = getelementptr inbounds %struct.obj_Object* %0, i32 0, i32 0
  %1 = load %struct.class_Object** %clazz, align 4
  %to_String = getelementptr inbounds %struct.class_Object* %1, i32 0, i32 2
  %2 = load %struct.obj_String* (%struct.obj_Object*)** %to_String, align 4
  %3 = load %struct.obj_Object** %thing.addr, align 4
  %call = call %struct.obj_String* %2(%struct.obj_Object* %3)
  store %struct.obj_String* %call, %struct.obj_String** %rep, align 4
  %4 = load %struct.obj_String** %rep, align 4
  %text = getelementptr inbounds %struct.obj_String* %4, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str5, i32 0, i32 0), i8* %arraydecay) #2
  %5 = load %struct.obj_IO** %self.addr, align 4
  ret %struct.obj_IO* %5
}

; Function Attrs: nounwind
define %struct.obj_IO* @IO_out_string(%struct.obj_IO* %self, %struct.obj_String* %thing) #0 {
entry:
  %self.addr = alloca %struct.obj_IO*, align 4
  %thing.addr = alloca %struct.obj_String*, align 4
  %rep = alloca %struct.obj_String*, align 4
  store %struct.obj_IO* %self, %struct.obj_IO** %self.addr, align 4
  store %struct.obj_String* %thing, %struct.obj_String** %thing.addr, align 4
  %0 = load %struct.obj_String** %thing.addr, align 4
  %clazz = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 0
  %1 = load %struct.class_String** %clazz, align 4
  %to_String = getelementptr inbounds %struct.class_String* %1, i32 0, i32 2
  %2 = load %struct.obj_String* (%struct.obj_String*)** %to_String, align 4
  %3 = load %struct.obj_String** %thing.addr, align 4
  %call = call %struct.obj_String* %2(%struct.obj_String* %3)
  store %struct.obj_String* %call, %struct.obj_String** %rep, align 4
  %4 = load %struct.obj_String** %rep, align 4
  %text = getelementptr inbounds %struct.obj_String* %4, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str5, i32 0, i32 0), i8* %arraydecay) #2
  %5 = load %struct.obj_IO** %self.addr, align 4
  ret %struct.obj_IO* %5
}

; Function Attrs: nounwind
define %struct.obj_IO* @IO_out_int(%struct.obj_IO* %self, %struct.obj_Integer* %thing) #0 {
entry:
  %self.addr = alloca %struct.obj_IO*, align 4
  %thing.addr = alloca %struct.obj_Integer*, align 4
  %rep = alloca %struct.obj_String*, align 4
  store %struct.obj_IO* %self, %struct.obj_IO** %self.addr, align 4
  store %struct.obj_Integer* %thing, %struct.obj_Integer** %thing.addr, align 4
  %0 = load %struct.obj_Integer** %thing.addr, align 4
  %clazz = getelementptr inbounds %struct.obj_Integer* %0, i32 0, i32 0
  %1 = load %struct.class_Integer** %clazz, align 4
  %to_String = getelementptr inbounds %struct.class_Integer* %1, i32 0, i32 2
  %2 = load %struct.obj_String* (%struct.obj_Integer*)** %to_String, align 4
  %3 = load %struct.obj_Integer** %thing.addr, align 4
  %call = call %struct.obj_String* %2(%struct.obj_Integer* %3)
  store %struct.obj_String* %call, %struct.obj_String** %rep, align 4
  %4 = load %struct.obj_String** %rep, align 4
  %text = getelementptr inbounds %struct.obj_String* %4, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str5, i32 0, i32 0), i8* %arraydecay) #2
  %5 = load %struct.obj_IO** %self.addr, align 4
  ret %struct.obj_IO* %5
}

; Function Attrs: nounwind
define %struct.obj_String* @IO_in_string(%struct.obj_IO* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_IO*, align 4
  %rep = alloca %struct.obj_String*, align 4
  store %struct.obj_IO* %self, %struct.obj_IO** %self.addr, align 4
  %call = call %struct.obj_String* @String_new(i8* getelementptr inbounds ([16 x i8]* @.str6, i32 0, i32 0))
  store %struct.obj_String* %call, %struct.obj_String** %rep, align 4
  %0 = load %struct.obj_String** %rep, align 4
  %text = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 1
  %arraydecay = getelementptr inbounds [1024 x i8]* %text, i32 0, i32 0
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str5, i32 0, i32 0), i8* %arraydecay) #2
  %1 = load %struct.obj_String** %rep, align 4
  ret %struct.obj_String* %1
}

; Function Attrs: nounwind
define %struct.obj_Integer* @IO_in_int(%struct.obj_IO* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_IO*, align 4
  %rep = alloca %struct.obj_Integer*, align 4
  store %struct.obj_IO* %self, %struct.obj_IO** %self.addr, align 4
  %call = call %struct.obj_Integer* @Integer_new(i32 42)
  store %struct.obj_Integer* %call, %struct.obj_Integer** %rep, align 4
  %0 = load %struct.obj_Integer** %rep, align 4
  %value = getelementptr inbounds %struct.obj_Integer* %0, i32 0, i32 1
  %1 = load i32* %value, align 4
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([22 x i8]* @.str7, i32 0, i32 0), i32 %1) #2
  %2 = load %struct.obj_Integer** %rep, align 4
  ret %struct.obj_Integer* %2
}

; Function Attrs: nounwind
define %struct.obj_Integer* @int_const(i32 %c) #0 {
entry:
  %c.addr = alloca i32, align 4
  store i32 %c, i32* %c.addr, align 4
  %0 = load %struct.obj_Integer* (i32)** getelementptr inbounds (%struct.class_Integer* @the_class_Integer, i32 0, i32 1), align 4
  %1 = load i32* %c.addr, align 4
  %call = call %struct.obj_Integer* %0(i32 %1)
  ret %struct.obj_Integer* %call
}

; Function Attrs: nounwind
define %struct.obj_String* @str_const(i8* %s) #0 {
entry:
  %s.addr = alloca i8*, align 4
  store i8* %s, i8** %s.addr, align 4
  %0 = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 4
  %1 = load i8** %s.addr, align 4
  %callee.knr.cast = bitcast %struct.obj_String* (...)* %0 to %struct.obj_String* (i8*)*
  %call = call %struct.obj_String* %callee.knr.cast(i8* %1)
  ret %struct.obj_String* %call
}

; Function Attrs: nounwind
define %struct.obj_Object* @Object_new() #0 {
entry:
  %new_obj = alloca %struct.obj_Object*, align 4
  %call = call noalias i8* @malloc(i32 4) #2
  %0 = bitcast i8* %call to %struct.obj_Object*
  store %struct.obj_Object* %0, %struct.obj_Object** %new_obj, align 4
  %1 = load %struct.obj_Object** %new_obj, align 4
  %clazz = getelementptr inbounds %struct.obj_Object* %1, i32 0, i32 0
  store %struct.class_Object* @the_class_Object, %struct.class_Object** %clazz, align 4
  %2 = load %struct.obj_Object** %new_obj, align 4
  ret %struct.obj_Object* %2
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i32) #0

; Function Attrs: nounwind
define i32 @asprintf(i8** %sptr, i8* %fmt, ...) #0 {
entry:
  %sptr.addr = alloca i8**, align 4
  %fmt.addr = alloca i8*, align 4
  %retval1 = alloca i32, align 4
  %argv = alloca i8*, align 4
  store i8** %sptr, i8*** %sptr.addr, align 4
  store i8* %fmt, i8** %fmt.addr, align 4
  %argv2 = bitcast i8** %argv to i8*
  call void @llvm.va_start(i8* %argv2)
  %0 = load i8*** %sptr.addr, align 4
  %1 = load i8** %fmt.addr, align 4
  %2 = load i8** %argv, align 4
  %call = call i32 @vasprintf(i8** %0, i8* %1, i8* %2)
  store i32 %call, i32* %retval1, align 4
  %argv3 = bitcast i8** %argv to i8*
  call void @llvm.va_end(i8* %argv3)
  %3 = load i32* %retval1, align 4
  ret i32 %3
}

; Function Attrs: nounwind
declare i32 @sprintf(i8*, i8*, ...) #0

; Function Attrs: nounwind
declare i8* @strncpy(i8*, i8*, i32) #0

; Function Attrs: nounwind readonly
declare i32 @strlen(i8*) #1

; Function Attrs: nounwind
declare i8* @strncat(i8*, i8*, i32) #0

; Function Attrs: nounwind
define %struct.obj_IO* @IO_new() #0 {
entry:
  %new_obj = alloca %struct.obj_IO*, align 4
  %call = call noalias i8* @malloc(i32 4) #2
  %0 = bitcast i8* %call to %struct.obj_IO*
  store %struct.obj_IO* %0, %struct.obj_IO** %new_obj, align 4
  %1 = load %struct.obj_IO** %new_obj, align 4
  %clazz = getelementptr inbounds %struct.obj_IO* %1, i32 0, i32 0
  store %struct.class_IO* @the_class_IO, %struct.class_IO** %clazz, align 4
  %2 = load %struct.obj_IO** %new_obj, align 4
  ret %struct.obj_IO* %2
}

; Function Attrs: nounwind
declare i32 @printf(i8*, ...) #0

; Function Attrs: nounwind
define %struct.obj_String* @Point_to_String(%struct.obj_Point* %self) #0 {
entry:
  %self.addr = alloca %struct.obj_Point*, align 4
  %rep = alloca %struct.obj_String*, align 4
  store %struct.obj_Point* %self, %struct.obj_Point** %self.addr, align 4
  %call = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str8, i32 0, i32 0))
  store %struct.obj_String* %call, %struct.obj_String** %rep, align 4
  %0 = load %struct.obj_String** %rep, align 4
  %clazz = getelementptr inbounds %struct.obj_String* %0, i32 0, i32 0
  %1 = load %struct.class_String** %clazz, align 4
  %concat = getelementptr inbounds %struct.class_String* %1, i32 0, i32 4
  %2 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %concat, align 4
  %3 = load %struct.obj_String** %rep, align 4
  %4 = load %struct.obj_Point** %self.addr, align 4
  %x = getelementptr inbounds %struct.obj_Point* %4, i32 0, i32 1
  %5 = load %struct.obj_Integer** %x, align 4
  %clazz1 = getelementptr inbounds %struct.obj_Integer* %5, i32 0, i32 0
  %6 = load %struct.class_Integer** %clazz1, align 4
  %to_String = getelementptr inbounds %struct.class_Integer* %6, i32 0, i32 2
  %7 = load %struct.obj_String* (%struct.obj_Integer*)** %to_String, align 4
  %8 = load %struct.obj_Point** %self.addr, align 4
  %x2 = getelementptr inbounds %struct.obj_Point* %8, i32 0, i32 1
  %9 = load %struct.obj_Integer** %x2, align 4
  %call3 = call %struct.obj_String* %7(%struct.obj_Integer* %9)
  %call4 = call %struct.obj_String* %2(%struct.obj_String* %3, %struct.obj_String* %call3)
  %10 = load %struct.obj_String** %rep, align 4
  %clazz5 = getelementptr inbounds %struct.obj_String* %10, i32 0, i32 0
  %11 = load %struct.class_String** %clazz5, align 4
  %concat6 = getelementptr inbounds %struct.class_String* %11, i32 0, i32 4
  %12 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %concat6, align 4
  %13 = load %struct.obj_String** %rep, align 4
  %call7 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str9, i32 0, i32 0))
  %call8 = call %struct.obj_String* %12(%struct.obj_String* %13, %struct.obj_String* %call7)
  %14 = load %struct.obj_String** %rep, align 4
  %clazz9 = getelementptr inbounds %struct.obj_String* %14, i32 0, i32 0
  %15 = load %struct.class_String** %clazz9, align 4
  %concat10 = getelementptr inbounds %struct.class_String* %15, i32 0, i32 4
  %16 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %concat10, align 4
  %17 = load %struct.obj_String** %rep, align 4
  %18 = load %struct.obj_Point** %self.addr, align 4
  %y = getelementptr inbounds %struct.obj_Point* %18, i32 0, i32 2
  %19 = load %struct.obj_Integer** %y, align 4
  %clazz11 = getelementptr inbounds %struct.obj_Integer* %19, i32 0, i32 0
  %20 = load %struct.class_Integer** %clazz11, align 4
  %to_String12 = getelementptr inbounds %struct.class_Integer* %20, i32 0, i32 2
  %21 = load %struct.obj_String* (%struct.obj_Integer*)** %to_String12, align 4
  %22 = load %struct.obj_Point** %self.addr, align 4
  %y13 = getelementptr inbounds %struct.obj_Point* %22, i32 0, i32 2
  %23 = load %struct.obj_Integer** %y13, align 4
  %call14 = call %struct.obj_String* %21(%struct.obj_Integer* %23)
  %call15 = call %struct.obj_String* %16(%struct.obj_String* %17, %struct.obj_String* %call14)
  %24 = load %struct.obj_String** %rep, align 4
  %clazz16 = getelementptr inbounds %struct.obj_String* %24, i32 0, i32 0
  %25 = load %struct.class_String** %clazz16, align 4
  %concat17 = getelementptr inbounds %struct.class_String* %25, i32 0, i32 4
  %26 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %concat17, align 4
  %27 = load %struct.obj_String** %rep, align 4
  %call18 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str10, i32 0, i32 0))
  %call19 = call %struct.obj_String* %26(%struct.obj_String* %27, %struct.obj_String* %call18)
  %28 = load %struct.obj_String** %rep, align 4
  ret %struct.obj_String* %28
}

; Function Attrs: nounwind
define %struct.obj_Point* @Point_init(%struct.obj_Point* %self, %struct.obj_Integer* %xcoord, %struct.obj_Integer* %ycoord) #0 {
entry:
  %self.addr = alloca %struct.obj_Point*, align 4
  %xcoord.addr = alloca %struct.obj_Integer*, align 4
  %ycoord.addr = alloca %struct.obj_Integer*, align 4
  store %struct.obj_Point* %self, %struct.obj_Point** %self.addr, align 4
  store %struct.obj_Integer* %xcoord, %struct.obj_Integer** %xcoord.addr, align 4
  store %struct.obj_Integer* %ycoord, %struct.obj_Integer** %ycoord.addr, align 4
  %0 = load %struct.obj_Integer** %xcoord.addr, align 4
  %1 = load %struct.obj_Point** %self.addr, align 4
  %x = getelementptr inbounds %struct.obj_Point* %1, i32 0, i32 1
  store %struct.obj_Integer* %0, %struct.obj_Integer** %x, align 4
  %2 = load %struct.obj_Integer** %ycoord.addr, align 4
  %3 = load %struct.obj_Point** %self.addr, align 4
  %y = getelementptr inbounds %struct.obj_Point* %3, i32 0, i32 2
  store %struct.obj_Integer* %2, %struct.obj_Integer** %y, align 4
  %4 = load %struct.obj_Point** %self.addr, align 4
  ret %struct.obj_Point* %4
}

; Function Attrs: nounwind
define %struct.obj_Point* @Point_translate(%struct.obj_Point* %self, %struct.obj_Point* %delta) #0 {
entry:
  %self.addr = alloca %struct.obj_Point*, align 4
  %delta.addr = alloca %struct.obj_Point*, align 4
  %xd = alloca %struct.obj_Integer*, align 4
  %yd = alloca %struct.obj_Integer*, align 4
  store %struct.obj_Point* %self, %struct.obj_Point** %self.addr, align 4
  store %struct.obj_Point* %delta, %struct.obj_Point** %delta.addr, align 4
  %0 = load %struct.obj_Point** %self.addr, align 4
  %x = getelementptr inbounds %struct.obj_Point* %0, i32 0, i32 1
  %1 = load %struct.obj_Integer** %x, align 4
  %clazz = getelementptr inbounds %struct.obj_Integer* %1, i32 0, i32 0
  %2 = load %struct.class_Integer** %clazz, align 4
  %add = getelementptr inbounds %struct.class_Integer* %2, i32 0, i32 3
  %3 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %add, align 4
  %4 = load %struct.obj_Point** %self.addr, align 4
  %x1 = getelementptr inbounds %struct.obj_Point* %4, i32 0, i32 1
  %5 = load %struct.obj_Integer** %x1, align 4
  %6 = load %struct.obj_Point** %delta.addr, align 4
  %x2 = getelementptr inbounds %struct.obj_Point* %6, i32 0, i32 1
  %7 = load %struct.obj_Integer** %x2, align 4
  %call = call %struct.obj_Integer* %3(%struct.obj_Integer* %5, %struct.obj_Integer* %7)
  store %struct.obj_Integer* %call, %struct.obj_Integer** %xd, align 4
  %8 = load %struct.obj_Integer** %xd, align 4
  %9 = load %struct.obj_Point** %self.addr, align 4
  %x3 = getelementptr inbounds %struct.obj_Point* %9, i32 0, i32 1
  store %struct.obj_Integer* %8, %struct.obj_Integer** %x3, align 4
  %10 = load %struct.obj_Point** %self.addr, align 4
  %y = getelementptr inbounds %struct.obj_Point* %10, i32 0, i32 2
  %11 = load %struct.obj_Integer** %y, align 4
  %clazz4 = getelementptr inbounds %struct.obj_Integer* %11, i32 0, i32 0
  %12 = load %struct.class_Integer** %clazz4, align 4
  %add5 = getelementptr inbounds %struct.class_Integer* %12, i32 0, i32 3
  %13 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %add5, align 4
  %14 = load %struct.obj_Point** %self.addr, align 4
  %y6 = getelementptr inbounds %struct.obj_Point* %14, i32 0, i32 2
  %15 = load %struct.obj_Integer** %y6, align 4
  %16 = load %struct.obj_Point** %delta.addr, align 4
  %y7 = getelementptr inbounds %struct.obj_Point* %16, i32 0, i32 2
  %17 = load %struct.obj_Integer** %y7, align 4
  %call8 = call %struct.obj_Integer* %13(%struct.obj_Integer* %15, %struct.obj_Integer* %17)
  store %struct.obj_Integer* %call8, %struct.obj_Integer** %yd, align 4
  %18 = load %struct.obj_Integer** %yd, align 4
  %19 = load %struct.obj_Point** %self.addr, align 4
  %y9 = getelementptr inbounds %struct.obj_Point* %19, i32 0, i32 2
  store %struct.obj_Integer* %18, %struct.obj_Integer** %y9, align 4
  %20 = load %struct.obj_Point** %self.addr, align 4
  ret %struct.obj_Point* %20
}

; Function Attrs: nounwind
define %struct.obj_Point* @Point_new() #0 {
entry:
  %new_obj = alloca %struct.obj_Point*, align 4
  %call = call noalias i8* @malloc(i32 12) #2
  %0 = bitcast i8* %call to %struct.obj_Point*
  store %struct.obj_Point* %0, %struct.obj_Point** %new_obj, align 4
  %1 = load %struct.obj_Point** %new_obj, align 4
  %clazz = getelementptr inbounds %struct.obj_Point* %1, i32 0, i32 0
  store %struct.class_Point* bitcast ({ %struct.class_Object*, %struct.obj_Point* (...)*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* }* @the_class_Point to %struct.class_Point*), %struct.class_Point** %clazz, align 4
  %call1 = call %struct.obj_Integer* @int_const(i32 0)
  %2 = load %struct.obj_Point** %new_obj, align 4
  %x = getelementptr inbounds %struct.obj_Point* %2, i32 0, i32 1
  store %struct.obj_Integer* %call1, %struct.obj_Integer** %x, align 4
  %call2 = call %struct.obj_Integer* @int_const(i32 0)
  %3 = load %struct.obj_Point** %new_obj, align 4
  %y = getelementptr inbounds %struct.obj_Point* %3, i32 0, i32 2
  store %struct.obj_Integer* %call2, %struct.obj_Integer** %y, align 4
  %4 = load %struct.obj_Point** %new_obj, align 4
  ret %struct.obj_Point* %4
}

; Function Attrs: nounwind
define %struct.obj_Point* @Point_fake(%struct.obj_Point* %self, %struct.obj_Integer* %xcoord, %struct.obj_Integer* %ycoord) #0 {
entry:
  %self.addr = alloca %struct.obj_Point*, align 4
  %xcoord.addr = alloca %struct.obj_Integer*, align 4
  %ycoord.addr = alloca %struct.obj_Integer*, align 4
  store %struct.obj_Point* %self, %struct.obj_Point** %self.addr, align 4
  store %struct.obj_Integer* %xcoord, %struct.obj_Integer** %xcoord.addr, align 4
  store %struct.obj_Integer* %ycoord, %struct.obj_Integer** %ycoord.addr, align 4
  %0 = load %struct.obj_Integer** %xcoord.addr, align 4
  %1 = load %struct.obj_Point** %self.addr, align 4
  %x = getelementptr inbounds %struct.obj_Point* %1, i32 0, i32 1
  store %struct.obj_Integer* %0, %struct.obj_Integer** %x, align 4
  %2 = load %struct.obj_Point** %self.addr, align 4
  ret %struct.obj_Point* %2
}

; Function Attrs: nounwind
define %struct.obj_Integer* @extract_y(%struct.obj_Point* %pt) #0 {
entry:
  %pt.addr = alloca %struct.obj_Point*, align 4
  %field = alloca %struct.obj_Integer*, align 4
  store %struct.obj_Point* %pt, %struct.obj_Point** %pt.addr, align 4
  %0 = load %struct.obj_Point** %pt.addr, align 4
  %y = getelementptr inbounds %struct.obj_Point* %0, i32 0, i32 2
  %1 = load %struct.obj_Integer** %y, align 4
  store %struct.obj_Integer* %1, %struct.obj_Integer** %field, align 4
  %2 = load %struct.obj_Integer** %field, align 4
  ret %struct.obj_Integer* %2
}

; Function Attrs: nounwind
define %struct.obj_Integer* @silly() #0 {
entry:
  %create = alloca %struct.obj_Integer* (i32)*, align 4
  %left = alloca %struct.obj_Integer*, align 4
  %right = alloca %struct.obj_Integer*, align 4
  %sum = alloca %struct.obj_Integer*, align 4
  %0 = load %struct.obj_Integer* (i32)** getelementptr inbounds (%struct.class_Integer* @the_class_Integer, i32 0, i32 1), align 4
  store %struct.obj_Integer* (i32)* %0, %struct.obj_Integer* (i32)** %create, align 4
  %1 = load %struct.obj_Integer* (i32)** %create, align 4
  %call = call %struct.obj_Integer* %1(i32 42)
  store %struct.obj_Integer* %call, %struct.obj_Integer** %left, align 4
  %2 = load %struct.obj_Integer* (i32)** %create, align 4
  %call1 = call %struct.obj_Integer* %2(i32 18)
  store %struct.obj_Integer* %call1, %struct.obj_Integer** %right, align 4
  %3 = load %struct.obj_Integer** %left, align 4
  %clazz = getelementptr inbounds %struct.obj_Integer* %3, i32 0, i32 0
  %4 = load %struct.class_Integer** %clazz, align 4
  %add = getelementptr inbounds %struct.class_Integer* %4, i32 0, i32 3
  %5 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %add, align 4
  %6 = load %struct.obj_Integer** %left, align 4
  %7 = load %struct.obj_Integer** %right, align 4
  %call2 = call %struct.obj_Integer* %5(%struct.obj_Integer* %6, %struct.obj_Integer* %7)
  store %struct.obj_Integer* %call2, %struct.obj_Integer** %sum, align 4
  %8 = load %struct.obj_Integer** %sum, align 4
  ret %struct.obj_Integer* %8
}

; Function Attrs: nounwind
define i32 @vasprintf(i8** %sptr, i8* %fmt, i8* %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %sptr.addr = alloca i8**, align 4
  %fmt.addr = alloca i8*, align 4
  %argv.addr = alloca i8*, align 4
  %wanted = alloca i32, align 4
  store i8** %sptr, i8*** %sptr.addr, align 4
  store i8* %fmt, i8** %fmt.addr, align 4
  store i8* %argv, i8** %argv.addr, align 4
  %0 = load i8*** %sptr.addr, align 4
  store i8* null, i8** %0, align 4
  %1 = load i8** %fmt.addr, align 4
  %2 = load i8** %argv.addr, align 4
  %call = call i32 @vsnprintf(i8* null, i32 0, i8* %1, i8* %2) #2
  store i32 %call, i32* %wanted, align 4
  %3 = load i32* %wanted, align 4
  %cmp = icmp slt i32 %3, 0
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %4 = load i32* %wanted, align 4
  %add = add nsw i32 1, %4
  %call1 = call noalias i8* @malloc(i32 %add) #2
  %5 = load i8*** %sptr.addr, align 4
  store i8* %call1, i8** %5, align 4
  %cmp2 = icmp eq i8* %call1, null
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval
  br label %return

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i8*** %sptr.addr, align 4
  %7 = load i8** %6, align 4
  %8 = load i8** %fmt.addr, align 4
  %9 = load i8** %argv.addr, align 4
  %call3 = call i32 @vsprintf(i8* %7, i8* %8, i8* %9) #2
  store i32 %call3, i32* %retval
  br label %return

return:                                           ; preds = %if.end, %if.then
  %10 = load i32* %retval
  ret i32 %10
}

; Function Attrs: nounwind
declare i32 @vsnprintf(i8*, i32, i8*, i8*) #0

; Function Attrs: nounwind
declare i32 @vsprintf(i8*, i8*, i8*) #0

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #2

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #2

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind readonly }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.6.0 (tags/RELEASE_360/final)"}
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
