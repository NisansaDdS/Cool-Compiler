;
; A skeleton for executing LLVM code emitted from the Cool compiler.
; Expects to be called as a C function, rather than a Cool method
; (so there is no 'self' object passed as the first argument).
;

; The following line is copied from Clang-generated code
; Function Attrs: nounwind ssp uwtable
define i32 @_CoolMain( ) #0 {
   ; We'll just have it return the constant value 42 to get started  
   ret i32 42
}