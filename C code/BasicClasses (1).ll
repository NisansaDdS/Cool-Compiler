; ModuleID = 'BasicClasses.c'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.10.0"

%struct.class_Object = type { %struct.class_Object*, %struct.obj_Object* (...)*, %struct.obj_String* (%struct.obj_Object*)* }
%struct.obj_Object = type { %struct.class_Object* }
%struct.obj_String = type { %struct.class_String*, [1024 x i8] }
%struct.class_String = type { %struct.class_Object*, %struct.obj_String* (...)*, %struct.obj_String* (%struct.obj_String*)*, %struct.obj_String* (%struct.obj_String*)*, %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)* }
%struct.class_Integer = type { %struct.class_Object*, %struct.obj_Integer* (i32)*, %struct.obj_String* (%struct.obj_Integer*)*, %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)* }
%struct.obj_Integer = type { %struct.class_Integer*, i32 }
%struct.class_IO = type { %struct.class_Object*, %struct.obj_IO* (...)*, %struct.obj_String* (%struct.obj_Object*)*, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)* }
%struct.obj_IO = type { %struct.class_IO* }
%struct.obj_Point = type { %struct.class_Point*, %struct.obj_Integer*, %struct.obj_Integer* }
%struct.class_Point = type { %struct.class_Object*, {}*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* }

@the_class_Object = global %struct.class_Object { %struct.class_Object* @the_class_Object, %struct.obj_Object* (...)* bitcast (%struct.obj_Object* ()* @Object_new to %struct.obj_Object* (...)*), %struct.obj_String* (%struct.obj_Object*)* @Object_to_String }, align 8
@the_class_Integer = global %struct.class_Integer { %struct.class_Object* @the_class_Object, %struct.obj_Integer* (i32)* @Integer_new, %struct.obj_String* (%struct.obj_Integer*)* @Integer_to_String, %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)* @Integer_add }, align 8
@the_class_String = global %struct.class_String { %struct.class_Object* @the_class_Object, %struct.obj_String* (...)* bitcast (%struct.obj_String* (i8*)* @String_new to %struct.obj_String* (...)*), %struct.obj_String* (%struct.obj_String*)* @String_to_String, %struct.obj_String* (%struct.obj_String*)* @String_copy, %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)* @String_concat }, align 8
@the_class_IO = global %struct.class_IO { %struct.class_Object* @the_class_Object, %struct.obj_IO* (...)* bitcast (%struct.obj_IO* ()* @IO_new to %struct.obj_IO* (...)*), %struct.obj_String* (%struct.obj_Object*)* @Object_to_String, %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)* @IO_out }, align 8
@.str = private unnamed_addr constant [15 x i8] c"<Object at %d>\00", align 1
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str2 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@the_class_Point = global { %struct.class_Object*, %struct.obj_Point* (...)*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* } { %struct.class_Object* @the_class_Object, %struct.obj_Point* (...)* bitcast (%struct.obj_Point* ()* @Point_new to %struct.obj_Point* (...)*), %struct.obj_String* (%struct.obj_Point*)* @Point_to_String, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)* @Point_init, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* @Point_translate }, align 8
@.str4 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str6 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str7 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str8 = private unnamed_addr constant [38 x i8] c"Now let's try a point object (15,25)\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @Object_to_String(%struct.obj_Object* %self) #0 {
  %1 = alloca %struct.obj_Object*, align 8
  %the_address = alloca i32, align 4
  %rep = alloca i8*, align 8
  store %struct.obj_Object* %self, %struct.obj_Object** %1, align 8
  %2 = load %struct.obj_Object** %1, align 8
  %3 = ptrtoint %struct.obj_Object* %2 to i32
  store i32 %3, i32* %the_address, align 4
  %4 = load i32* %the_address, align 4
  %5 = call i32 (i8**, i8*, ...)* @asprintf(i8** %rep, i8* getelementptr inbounds ([15 x i8]* @.str, i32 0, i32 0), i32 %4)
  %6 = load i8** %rep, align 8
  %7 = call %struct.obj_String* @str_const(i8* %6)
  ret %struct.obj_String* %7
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Integer* @Integer_new(i32 %value) #0 {
  %1 = alloca i32, align 4
  %new_obj = alloca %struct.obj_Integer*, align 8
  store i32 %value, i32* %1, align 4
  %2 = call i8* @malloc(i64 16)
  %3 = bitcast i8* %2 to %struct.obj_Integer*
  store %struct.obj_Integer* %3, %struct.obj_Integer** %new_obj, align 8
  %4 = load %struct.obj_Integer** %new_obj, align 8
  %5 = getelementptr inbounds %struct.obj_Integer* %4, i32 0, i32 0
  store %struct.class_Integer* @the_class_Integer, %struct.class_Integer** %5, align 8
  %6 = load i32* %1, align 4
  %7 = load %struct.obj_Integer** %new_obj, align 8
  %8 = getelementptr inbounds %struct.obj_Integer* %7, i32 0, i32 1
  store i32 %6, i32* %8, align 4
  %9 = load %struct.obj_Integer** %new_obj, align 8
  ret %struct.obj_Integer* %9
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @Integer_to_String(%struct.obj_Integer* %self) #0 {
  %1 = alloca %struct.obj_Integer*, align 8
  %s = alloca %struct.obj_String*, align 8
  store %struct.obj_Integer* %self, %struct.obj_Integer** %1, align 8
  %2 = call %struct.obj_String* @String_new(i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0))
  store %struct.obj_String* %2, %struct.obj_String** %s, align 8
  %3 = load %struct.obj_String** %s, align 8
  %4 = getelementptr inbounds %struct.obj_String* %3, i32 0, i32 1
  %5 = getelementptr inbounds [1024 x i8]* %4, i32 0, i32 0
  %6 = load %struct.obj_String** %s, align 8
  %7 = getelementptr inbounds %struct.obj_String* %6, i32 0, i32 1
  %8 = getelementptr inbounds [1024 x i8]* %7, i32 0, i32 0
  %9 = call i64 @llvm.objectsize.i64.p0i8(i8* %8, i1 false)
  %10 = load %struct.obj_Integer** %1, align 8
  %11 = getelementptr inbounds %struct.obj_Integer* %10, i32 0, i32 1
  %12 = load i32* %11, align 4
  %13 = call i32 (i8*, i32, i64, i8*, ...)* @__sprintf_chk(i8* %5, i32 0, i64 %9, i8* getelementptr inbounds ([3 x i8]* @.str2, i32 0, i32 0), i32 %12)
  %14 = load %struct.obj_String** %s, align 8
  ret %struct.obj_String* %14
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Integer* @Integer_add(%struct.obj_Integer* %self, %struct.obj_Integer* %other) #0 {
  %1 = alloca %struct.obj_Integer*, align 8
  %2 = alloca %struct.obj_Integer*, align 8
  %result_value = alloca i32, align 4
  store %struct.obj_Integer* %self, %struct.obj_Integer** %1, align 8
  store %struct.obj_Integer* %other, %struct.obj_Integer** %2, align 8
  %3 = load %struct.obj_Integer** %1, align 8
  %4 = getelementptr inbounds %struct.obj_Integer* %3, i32 0, i32 1
  %5 = load i32* %4, align 4
  %6 = load %struct.obj_Integer** %2, align 8
  %7 = getelementptr inbounds %struct.obj_Integer* %6, i32 0, i32 1
  %8 = load i32* %7, align 4
  %9 = add nsw i32 %5, %8
  store i32 %9, i32* %result_value, align 4
  %10 = load %struct.obj_Integer** %1, align 8
  %11 = getelementptr inbounds %struct.obj_Integer* %10, i32 0, i32 0
  %12 = load %struct.class_Integer** %11, align 8
  %13 = getelementptr inbounds %struct.class_Integer* %12, i32 0, i32 1
  %14 = load %struct.obj_Integer* (i32)** %13, align 8
  %15 = load i32* %result_value, align 4
  %16 = call %struct.obj_Integer* %14(i32 %15)
  ret %struct.obj_Integer* %16
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @String_new(i8* %text) #0 {
  %1 = alloca i8*, align 8
  %new_obj = alloca %struct.obj_String*, align 8
  store i8* %text, i8** %1, align 8
  %2 = call i8* @malloc(i64 1032)
  %3 = bitcast i8* %2 to %struct.obj_String*
  store %struct.obj_String* %3, %struct.obj_String** %new_obj, align 8
  %4 = load %struct.obj_String** %new_obj, align 8
  %5 = getelementptr inbounds %struct.obj_String* %4, i32 0, i32 0
  store %struct.class_String* @the_class_String, %struct.class_String** %5, align 8
  %6 = load %struct.obj_String** %new_obj, align 8
  %7 = getelementptr inbounds %struct.obj_String* %6, i32 0, i32 1
  %8 = getelementptr inbounds [1024 x i8]* %7, i32 0, i32 0
  %9 = load i8** %1, align 8
  %10 = load %struct.obj_String** %new_obj, align 8
  %11 = getelementptr inbounds %struct.obj_String* %10, i32 0, i32 1
  %12 = getelementptr inbounds [1024 x i8]* %11, i32 0, i32 0
  %13 = call i64 @llvm.objectsize.i64.p0i8(i8* %12, i1 false)
  %14 = call i8* @__strncpy_chk(i8* %8, i8* %9, i64 1024, i64 %13) #4
  %15 = load %struct.obj_String** %new_obj, align 8
  ret %struct.obj_String* %15
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @String_to_String(%struct.obj_String* %self) #0 {
  %1 = alloca %struct.obj_String*, align 8
  store %struct.obj_String* %self, %struct.obj_String** %1, align 8
  %2 = load %struct.obj_String** %1, align 8
  ret %struct.obj_String* %2
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @String_copy(%struct.obj_String* %self) #0 {
  %1 = alloca %struct.obj_String*, align 8
  store %struct.obj_String* %self, %struct.obj_String** %1, align 8
  %2 = load %struct.obj_String** %1, align 8
  %3 = getelementptr inbounds %struct.obj_String* %2, i32 0, i32 0
  %4 = load %struct.class_String** %3, align 8
  %5 = getelementptr inbounds %struct.class_String* %4, i32 0, i32 1
  %6 = load %struct.obj_String* (...)** %5, align 8
  %7 = load %struct.obj_String** %1, align 8
  %8 = getelementptr inbounds %struct.obj_String* %7, i32 0, i32 1
  %9 = getelementptr inbounds [1024 x i8]* %8, i32 0, i32 0
  %10 = bitcast %struct.obj_String* (...)* %6 to %struct.obj_String* (i8*, ...)*
  %11 = call %struct.obj_String* (i8*, ...)* %10(i8* %9)
  ret %struct.obj_String* %11
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @String_concat(%struct.obj_String* %self, %struct.obj_String* %other) #0 {
  %1 = alloca %struct.obj_String*, align 8
  %2 = alloca %struct.obj_String*, align 8
  %start_pos = alloca i32, align 4
  %max_copy = alloca i32, align 4
  store %struct.obj_String* %self, %struct.obj_String** %1, align 8
  store %struct.obj_String* %other, %struct.obj_String** %2, align 8
  %3 = load %struct.obj_String** %1, align 8
  %4 = getelementptr inbounds %struct.obj_String* %3, i32 0, i32 1
  %5 = getelementptr inbounds [1024 x i8]* %4, i32 0, i32 0
  %6 = call i64 @strlen(i8* %5)
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %start_pos, align 4
  %8 = load i32* %start_pos, align 4
  %9 = sub nsw i32 1023, %8
  store i32 %9, i32* %max_copy, align 4
  %10 = load %struct.obj_String** %1, align 8
  %11 = getelementptr inbounds %struct.obj_String* %10, i32 0, i32 1
  %12 = getelementptr inbounds [1024 x i8]* %11, i32 0, i32 0
  %13 = load %struct.obj_String** %2, align 8
  %14 = getelementptr inbounds %struct.obj_String* %13, i32 0, i32 1
  %15 = getelementptr inbounds [1024 x i8]* %14, i32 0, i32 0
  %16 = load i32* %max_copy, align 4
  %17 = sext i32 %16 to i64
  %18 = load %struct.obj_String** %1, align 8
  %19 = getelementptr inbounds %struct.obj_String* %18, i32 0, i32 1
  %20 = getelementptr inbounds [1024 x i8]* %19, i32 0, i32 0
  %21 = call i64 @llvm.objectsize.i64.p0i8(i8* %20, i1 false)
  %22 = call i8* @__strncat_chk(i8* %12, i8* %15, i64 %17, i64 %21) #4
  %23 = load %struct.obj_String** %1, align 8
  ret %struct.obj_String* %23
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_IO* @IO_out(%struct.obj_IO* %self, %struct.obj_Object* %thing) #0 {
  %1 = alloca %struct.obj_IO*, align 8
  %2 = alloca %struct.obj_Object*, align 8
  %rep = alloca %struct.obj_String*, align 8
  store %struct.obj_IO* %self, %struct.obj_IO** %1, align 8
  store %struct.obj_Object* %thing, %struct.obj_Object** %2, align 8
  %3 = load %struct.obj_Object** %2, align 8
  %4 = getelementptr inbounds %struct.obj_Object* %3, i32 0, i32 0
  %5 = load %struct.class_Object** %4, align 8
  %6 = getelementptr inbounds %struct.class_Object* %5, i32 0, i32 2
  %7 = load %struct.obj_String* (%struct.obj_Object*)** %6, align 8
  %8 = load %struct.obj_Object** %2, align 8
  %9 = call %struct.obj_String* %7(%struct.obj_Object* %8)
  store %struct.obj_String* %9, %struct.obj_String** %rep, align 8
  %10 = load %struct.obj_String** %rep, align 8
  %11 = getelementptr inbounds %struct.obj_String* %10, i32 0, i32 1
  %12 = getelementptr inbounds [1024 x i8]* %11, i32 0, i32 0
  %13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str3, i32 0, i32 0), i8* %12)
  %14 = load %struct.obj_IO** %1, align 8
  ret %struct.obj_IO* %14
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Integer* @int_const(i32 %c) #0 {
  %1 = alloca i32, align 4
  store i32 %c, i32* %1, align 4
  %2 = load %struct.obj_Integer* (i32)** getelementptr inbounds (%struct.class_Integer* @the_class_Integer, i32 0, i32 1), align 8
  %3 = load i32* %1, align 4
  %4 = call %struct.obj_Integer* %2(i32 %3)
  ret %struct.obj_Integer* %4
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @str_const(i8* %s) #0 {
  %1 = alloca i8*, align 8
  store i8* %s, i8** %1, align 8
  %2 = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 8
  %3 = load i8** %1, align 8
  %4 = bitcast %struct.obj_String* (...)* %2 to %struct.obj_String* (i8*, ...)*
  %5 = call %struct.obj_String* (i8*, ...)* %4(i8* %3)
  ret %struct.obj_String* %5
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Object* @Object_new() #0 {
  %new_obj = alloca %struct.obj_Object*, align 8
  %1 = call i8* @malloc(i64 8)
  %2 = bitcast i8* %1 to %struct.obj_Object*
  store %struct.obj_Object* %2, %struct.obj_Object** %new_obj, align 8
  %3 = load %struct.obj_Object** %new_obj, align 8
  %4 = getelementptr inbounds %struct.obj_Object* %3, i32 0, i32 0
  store %struct.class_Object* @the_class_Object, %struct.class_Object** %4, align 8
  %5 = load %struct.obj_Object** %new_obj, align 8
  ret %struct.obj_Object* %5
}

declare i8* @malloc(i64) #1

declare i32 @asprintf(i8**, i8*, ...) #1

declare i32 @__sprintf_chk(i8*, i32, i64, i8*, ...) #1

; Function Attrs: nounwind readnone
declare i64 @llvm.objectsize.i64.p0i8(i8*, i1) #2

; Function Attrs: nounwind
declare i8* @__strncpy_chk(i8*, i8*, i64, i64) #3

declare i64 @strlen(i8*) #1

; Function Attrs: nounwind
declare i8* @__strncat_chk(i8*, i8*, i64, i64) #3

; Function Attrs: nounwind ssp uwtable
define %struct.obj_IO* @IO_new() #0 {
  %new_obj = alloca %struct.obj_IO*, align 8
  %1 = call i8* @malloc(i64 8)
  %2 = bitcast i8* %1 to %struct.obj_IO*
  store %struct.obj_IO* %2, %struct.obj_IO** %new_obj, align 8
  %3 = load %struct.obj_IO** %new_obj, align 8
  %4 = getelementptr inbounds %struct.obj_IO* %3, i32 0, i32 0
  store %struct.class_IO* @the_class_IO, %struct.class_IO** %4, align 8
  %5 = load %struct.obj_IO** %new_obj, align 8
  ret %struct.obj_IO* %5
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind ssp uwtable
define %struct.obj_String* @Point_to_String(%struct.obj_Point* %self) #0 {
  %1 = alloca %struct.obj_Point*, align 8
  %rep = alloca %struct.obj_String*, align 8
  store %struct.obj_Point* %self, %struct.obj_Point** %1, align 8
  %2 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str4, i32 0, i32 0))
  store %struct.obj_String* %2, %struct.obj_String** %rep, align 8
  %3 = load %struct.obj_String** %rep, align 8
  %4 = getelementptr inbounds %struct.obj_String* %3, i32 0, i32 0
  %5 = load %struct.class_String** %4, align 8
  %6 = getelementptr inbounds %struct.class_String* %5, i32 0, i32 4
  %7 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %6, align 8
  %8 = load %struct.obj_String** %rep, align 8
  %9 = load %struct.obj_Point** %1, align 8
  %10 = getelementptr inbounds %struct.obj_Point* %9, i32 0, i32 1
  %11 = load %struct.obj_Integer** %10, align 8
  %12 = getelementptr inbounds %struct.obj_Integer* %11, i32 0, i32 0
  %13 = load %struct.class_Integer** %12, align 8
  %14 = getelementptr inbounds %struct.class_Integer* %13, i32 0, i32 2
  %15 = load %struct.obj_String* (%struct.obj_Integer*)** %14, align 8
  %16 = load %struct.obj_Point** %1, align 8
  %17 = getelementptr inbounds %struct.obj_Point* %16, i32 0, i32 1
  %18 = load %struct.obj_Integer** %17, align 8
  %19 = call %struct.obj_String* %15(%struct.obj_Integer* %18)
  %20 = call %struct.obj_String* %7(%struct.obj_String* %8, %struct.obj_String* %19)
  %21 = load %struct.obj_String** %rep, align 8
  %22 = getelementptr inbounds %struct.obj_String* %21, i32 0, i32 0
  %23 = load %struct.class_String** %22, align 8
  %24 = getelementptr inbounds %struct.class_String* %23, i32 0, i32 4
  %25 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %24, align 8
  %26 = load %struct.obj_String** %rep, align 8
  %27 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  %28 = call %struct.obj_String* %25(%struct.obj_String* %26, %struct.obj_String* %27)
  %29 = load %struct.obj_String** %rep, align 8
  %30 = getelementptr inbounds %struct.obj_String* %29, i32 0, i32 0
  %31 = load %struct.class_String** %30, align 8
  %32 = getelementptr inbounds %struct.class_String* %31, i32 0, i32 4
  %33 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %32, align 8
  %34 = load %struct.obj_String** %rep, align 8
  %35 = load %struct.obj_Point** %1, align 8
  %36 = getelementptr inbounds %struct.obj_Point* %35, i32 0, i32 2
  %37 = load %struct.obj_Integer** %36, align 8
  %38 = getelementptr inbounds %struct.obj_Integer* %37, i32 0, i32 0
  %39 = load %struct.class_Integer** %38, align 8
  %40 = getelementptr inbounds %struct.class_Integer* %39, i32 0, i32 2
  %41 = load %struct.obj_String* (%struct.obj_Integer*)** %40, align 8
  %42 = load %struct.obj_Point** %1, align 8
  %43 = getelementptr inbounds %struct.obj_Point* %42, i32 0, i32 2
  %44 = load %struct.obj_Integer** %43, align 8
  %45 = call %struct.obj_String* %41(%struct.obj_Integer* %44)
  %46 = call %struct.obj_String* %33(%struct.obj_String* %34, %struct.obj_String* %45)
  %47 = load %struct.obj_String** %rep, align 8
  %48 = getelementptr inbounds %struct.obj_String* %47, i32 0, i32 0
  %49 = load %struct.class_String** %48, align 8
  %50 = getelementptr inbounds %struct.class_String* %49, i32 0, i32 4
  %51 = load %struct.obj_String* (%struct.obj_String*, %struct.obj_String*)** %50, align 8
  %52 = load %struct.obj_String** %rep, align 8
  %53 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([2 x i8]* @.str6, i32 0, i32 0))
  %54 = call %struct.obj_String* %51(%struct.obj_String* %52, %struct.obj_String* %53)
  %55 = load %struct.obj_String** %rep, align 8
  ret %struct.obj_String* %55
}

declare %struct.obj_Point* @Point_init(%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*) #1

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Point* @Point_translate(%struct.obj_Point* %self, %struct.obj_Point* %delta) #0 {
  %1 = alloca %struct.obj_Point*, align 8
  %2 = alloca %struct.obj_Point*, align 8
  %xd = alloca %struct.obj_Integer*, align 8
  %yd = alloca %struct.obj_Integer*, align 8
  store %struct.obj_Point* %self, %struct.obj_Point** %1, align 8
  store %struct.obj_Point* %delta, %struct.obj_Point** %2, align 8
  %3 = load %struct.obj_Point** %1, align 8
  %4 = getelementptr inbounds %struct.obj_Point* %3, i32 0, i32 1
  %5 = load %struct.obj_Integer** %4, align 8
  %6 = getelementptr inbounds %struct.obj_Integer* %5, i32 0, i32 0
  %7 = load %struct.class_Integer** %6, align 8
  %8 = getelementptr inbounds %struct.class_Integer* %7, i32 0, i32 3
  %9 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %8, align 8
  %10 = load %struct.obj_Point** %1, align 8
  %11 = getelementptr inbounds %struct.obj_Point* %10, i32 0, i32 1
  %12 = load %struct.obj_Integer** %11, align 8
  %13 = load %struct.obj_Point** %2, align 8
  %14 = getelementptr inbounds %struct.obj_Point* %13, i32 0, i32 1
  %15 = load %struct.obj_Integer** %14, align 8
  %16 = call %struct.obj_Integer* %9(%struct.obj_Integer* %12, %struct.obj_Integer* %15)
  store %struct.obj_Integer* %16, %struct.obj_Integer** %xd, align 8
  %17 = load %struct.obj_Integer** %xd, align 8
  %18 = load %struct.obj_Point** %1, align 8
  %19 = getelementptr inbounds %struct.obj_Point* %18, i32 0, i32 1
  store %struct.obj_Integer* %17, %struct.obj_Integer** %19, align 8
  %20 = load %struct.obj_Point** %1, align 8
  %21 = getelementptr inbounds %struct.obj_Point* %20, i32 0, i32 2
  %22 = load %struct.obj_Integer** %21, align 8
  %23 = getelementptr inbounds %struct.obj_Integer* %22, i32 0, i32 0
  %24 = load %struct.class_Integer** %23, align 8
  %25 = getelementptr inbounds %struct.class_Integer* %24, i32 0, i32 3
  %26 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %25, align 8
  %27 = load %struct.obj_Point** %1, align 8
  %28 = getelementptr inbounds %struct.obj_Point* %27, i32 0, i32 2
  %29 = load %struct.obj_Integer** %28, align 8
  %30 = load %struct.obj_Point** %2, align 8
  %31 = getelementptr inbounds %struct.obj_Point* %30, i32 0, i32 2
  %32 = load %struct.obj_Integer** %31, align 8
  %33 = call %struct.obj_Integer* %26(%struct.obj_Integer* %29, %struct.obj_Integer* %32)
  store %struct.obj_Integer* %33, %struct.obj_Integer** %yd, align 8
  %34 = load %struct.obj_Integer** %yd, align 8
  %35 = load %struct.obj_Point** %1, align 8
  %36 = getelementptr inbounds %struct.obj_Point* %35, i32 0, i32 2
  store %struct.obj_Integer* %34, %struct.obj_Integer** %36, align 8
  %37 = load %struct.obj_Point** %1, align 8
  ret %struct.obj_Point* %37
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Point* @Point_new() #0 {
  %new_obj = alloca %struct.obj_Point*, align 8
  %1 = call i8* @malloc(i64 24)
  %2 = bitcast i8* %1 to %struct.obj_Point*
  store %struct.obj_Point* %2, %struct.obj_Point** %new_obj, align 8
  %3 = load %struct.obj_Point** %new_obj, align 8
  %4 = getelementptr inbounds %struct.obj_Point* %3, i32 0, i32 0
  store %struct.class_Point* bitcast ({ %struct.class_Object*, %struct.obj_Point* (...)*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* }* @the_class_Point to %struct.class_Point*), %struct.class_Point** %4, align 8
  %5 = call %struct.obj_Integer* @int_const(i32 0)
  %6 = load %struct.obj_Point** %new_obj, align 8
  %7 = getelementptr inbounds %struct.obj_Point* %6, i32 0, i32 1
  store %struct.obj_Integer* %5, %struct.obj_Integer** %7, align 8
  %8 = call %struct.obj_Integer* @int_const(i32 0)
  %9 = load %struct.obj_Point** %new_obj, align 8
  %10 = getelementptr inbounds %struct.obj_Point* %9, i32 0, i32 2
  store %struct.obj_Integer* %8, %struct.obj_Integer** %10, align 8
  %11 = load %struct.obj_Point** %new_obj, align 8
  ret %struct.obj_Point* %11
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Integer* @extract_y(%struct.obj_Point* %pt) #0 {
  %1 = alloca %struct.obj_Point*, align 8
  %field = alloca %struct.obj_Integer*, align 8
  store %struct.obj_Point* %pt, %struct.obj_Point** %1, align 8
  %2 = load %struct.obj_Point** %1, align 8
  %3 = getelementptr inbounds %struct.obj_Point* %2, i32 0, i32 2
  %4 = load %struct.obj_Integer** %3, align 8
  store %struct.obj_Integer* %4, %struct.obj_Integer** %field, align 8
  %5 = load %struct.obj_Integer** %field, align 8
  ret %struct.obj_Integer* %5
}

; Function Attrs: nounwind ssp uwtable
define %struct.obj_Integer* @silly() #0 {
  %create = alloca %struct.obj_Integer* (i32)*, align 8
  %left = alloca %struct.obj_Integer*, align 8
  %right = alloca %struct.obj_Integer*, align 8
  %sum = alloca %struct.obj_Integer*, align 8
  %1 = load %struct.obj_Integer* (i32)** getelementptr inbounds (%struct.class_Integer* @the_class_Integer, i32 0, i32 1), align 8
  store %struct.obj_Integer* (i32)* %1, %struct.obj_Integer* (i32)** %create, align 8
  %2 = load %struct.obj_Integer* (i32)** %create, align 8
  %3 = call %struct.obj_Integer* %2(i32 42)
  store %struct.obj_Integer* %3, %struct.obj_Integer** %left, align 8
  %4 = load %struct.obj_Integer* (i32)** %create, align 8
  %5 = call %struct.obj_Integer* %4(i32 18)
  store %struct.obj_Integer* %5, %struct.obj_Integer** %right, align 8
  %6 = load %struct.obj_Integer** %left, align 8
  %7 = getelementptr inbounds %struct.obj_Integer* %6, i32 0, i32 0
  %8 = load %struct.class_Integer** %7, align 8
  %9 = getelementptr inbounds %struct.class_Integer* %8, i32 0, i32 3
  %10 = load %struct.obj_Integer* (%struct.obj_Integer*, %struct.obj_Integer*)** %9, align 8
  %11 = load %struct.obj_Integer** %left, align 8
  %12 = load %struct.obj_Integer** %right, align 8
  %13 = call %struct.obj_Integer* %10(%struct.obj_Integer* %11, %struct.obj_Integer* %12)
  store %struct.obj_Integer* %13, %struct.obj_Integer** %sum, align 8
  %14 = load %struct.obj_Integer** %sum, align 8
  ret %struct.obj_Integer* %14
}

; Function Attrs: nounwind ssp uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %io = alloca %struct.obj_IO*, align 8
  %cr = alloca %struct.obj_String*, align 8
  %num = alloca %struct.obj_Integer*, align 8
  %pt = alloca %struct.obj_Point*, align 8
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  %4 = load %struct.obj_IO* (...)** getelementptr inbounds (%struct.class_IO* @the_class_IO, i32 0, i32 1), align 8
  %5 = call %struct.obj_IO* (...)* %4()
  store %struct.obj_IO* %5, %struct.obj_IO** %io, align 8
  %6 = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 8
  %7 = bitcast %struct.obj_String* (...)* %6 to %struct.obj_String* (i8*, ...)*
  %8 = call %struct.obj_String* (i8*, ...)* %7(i8* getelementptr inbounds ([2 x i8]* @.str7, i32 0, i32 0))
  store %struct.obj_String* %8, %struct.obj_String** %cr, align 8
  %9 = call %struct.obj_Integer* @silly()
  store %struct.obj_Integer* %9, %struct.obj_Integer** %num, align 8
  %10 = load %struct.obj_IO** %io, align 8
  %11 = getelementptr inbounds %struct.obj_IO* %10, i32 0, i32 0
  %12 = load %struct.class_IO** %11, align 8
  %13 = getelementptr inbounds %struct.class_IO* %12, i32 0, i32 3
  %14 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %13, align 8
  %15 = load %struct.obj_IO** %io, align 8
  %16 = load %struct.obj_Integer** %num, align 8
  %17 = bitcast %struct.obj_Integer* %16 to %struct.obj_Object*
  %18 = call %struct.obj_IO* %14(%struct.obj_IO* %15, %struct.obj_Object* %17)
  %19 = load %struct.obj_IO** %io, align 8
  %20 = getelementptr inbounds %struct.obj_IO* %19, i32 0, i32 0
  %21 = load %struct.class_IO** %20, align 8
  %22 = getelementptr inbounds %struct.class_IO* %21, i32 0, i32 3
  %23 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %22, align 8
  %24 = load %struct.obj_IO** %io, align 8
  %25 = load %struct.obj_String** %cr, align 8
  %26 = bitcast %struct.obj_String* %25 to %struct.obj_Object*
  %27 = call %struct.obj_IO* %23(%struct.obj_IO* %24, %struct.obj_Object* %26)
  %28 = load %struct.obj_IO** %io, align 8
  %29 = getelementptr inbounds %struct.obj_IO* %28, i32 0, i32 0
  %30 = load %struct.class_IO** %29, align 8
  %31 = getelementptr inbounds %struct.class_IO* %30, i32 0, i32 3
  %32 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %31, align 8
  %33 = load %struct.obj_IO** %io, align 8
  %34 = load %struct.obj_IO** %io, align 8
  %35 = bitcast %struct.obj_IO* %34 to %struct.obj_Object*
  %36 = call %struct.obj_IO* %32(%struct.obj_IO* %33, %struct.obj_Object* %35)
  %37 = load %struct.obj_IO** %io, align 8
  %38 = getelementptr inbounds %struct.obj_IO* %37, i32 0, i32 0
  %39 = load %struct.class_IO** %38, align 8
  %40 = getelementptr inbounds %struct.class_IO* %39, i32 0, i32 3
  %41 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %40, align 8
  %42 = load %struct.obj_IO** %io, align 8
  %43 = load %struct.obj_String** %cr, align 8
  %44 = bitcast %struct.obj_String* %43 to %struct.obj_Object*
  %45 = call %struct.obj_IO* %41(%struct.obj_IO* %42, %struct.obj_Object* %44)
  %46 = load %struct.obj_IO** %io, align 8
  %47 = getelementptr inbounds %struct.obj_IO* %46, i32 0, i32 0
  %48 = load %struct.class_IO** %47, align 8
  %49 = getelementptr inbounds %struct.class_IO* %48, i32 0, i32 3
  %50 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %49, align 8
  %51 = load %struct.obj_IO** %io, align 8
  %52 = call %struct.obj_String* @str_const(i8* getelementptr inbounds ([38 x i8]* @.str8, i32 0, i32 0))
  %53 = bitcast %struct.obj_String* %52 to %struct.obj_Object*
  %54 = call %struct.obj_IO* %50(%struct.obj_IO* %51, %struct.obj_Object* %53)
  %55 = load %struct.obj_Point* (...)** bitcast ({}** getelementptr inbounds (%struct.class_Point* bitcast ({ %struct.class_Object*, %struct.obj_Point* (...)*, %struct.obj_String* (%struct.obj_Point*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)*, %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Point*)* }* @the_class_Point to %struct.class_Point*), i32 0, i32 1) to %struct.obj_Point* (...)**), align 8
  %56 = call %struct.obj_Point* (...)* %55()
  store %struct.obj_Point* %56, %struct.obj_Point** %pt, align 8
  %57 = load %struct.obj_Point** %pt, align 8
  %58 = getelementptr inbounds %struct.obj_Point* %57, i32 0, i32 0
  %59 = load %struct.class_Point** %58, align 8
  %60 = getelementptr inbounds %struct.class_Point* %59, i32 0, i32 3
  %61 = load %struct.obj_Point* (%struct.obj_Point*, %struct.obj_Integer*, %struct.obj_Integer*)** %60, align 8
  %62 = load %struct.obj_Point** %pt, align 8
  %63 = call %struct.obj_Integer* @int_const(i32 15)
  %64 = call %struct.obj_Integer* @int_const(i32 25)
  %65 = call %struct.obj_Point* %61(%struct.obj_Point* %62, %struct.obj_Integer* %63, %struct.obj_Integer* %64)
  %66 = load %struct.obj_IO** %io, align 8
  %67 = getelementptr inbounds %struct.obj_IO* %66, i32 0, i32 0
  %68 = load %struct.class_IO** %67, align 8
  %69 = getelementptr inbounds %struct.class_IO* %68, i32 0, i32 3
  %70 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %69, align 8
  %71 = load %struct.obj_IO** %io, align 8
  %72 = load %struct.obj_Point** %pt, align 8
  %73 = bitcast %struct.obj_Point* %72 to %struct.obj_Object*
  %74 = call %struct.obj_IO* %70(%struct.obj_IO* %71, %struct.obj_Object* %73)
  %75 = load %struct.obj_IO** %io, align 8
  %76 = getelementptr inbounds %struct.obj_IO* %75, i32 0, i32 0
  %77 = load %struct.class_IO** %76, align 8
  %78 = getelementptr inbounds %struct.class_IO* %77, i32 0, i32 3
  %79 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %78, align 8
  %80 = load %struct.obj_IO** %io, align 8
  %81 = load %struct.obj_String** %cr, align 8
  %82 = bitcast %struct.obj_String* %81 to %struct.obj_Object*
  %83 = call %struct.obj_IO* %79(%struct.obj_IO* %80, %struct.obj_Object* %82)
  ret i32 0
}

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Apple LLVM version 6.0 (clang-600.0.56) (based on LLVM 3.5svn)"}
