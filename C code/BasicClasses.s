	.file	"BasicClasses.c"
	.globl	_the_class_object
	.data
	.align 4
_the_class_object:
	.long	_the_class_object
	.long	_object_new
	.long	_object_to_string
	.globl	_the_class_integer
	.align 4
_the_class_integer:
	.long	_the_class_object
	.long	_integer_new
	.long	_integer_to_string
	.long	_integer_add
	.globl	_the_class_string
	.align 4
_the_class_string:
	.long	_the_class_object
	.long	_string_new
	.long	_string_to_string
	.globl	_the_class_io
	.align 4
_the_class_io:
	.long	_the_class_object
	.long	_io_new
	.long	_object_to_string
	.long	_io_out
	.text
	.globl	_object_new
	.def	_object_new;	.scl	2;	.type	32;	.endef
_object_new:
LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$4, (%esp)
	call	_malloc
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$_the_class_object, (%eax)
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.section .rdata,"dr"
LC0:
	.ascii "<Object at %d>\0"
	.text
	.globl	_object_to_string
	.def	_object_to_string;	.scl	2;	.type	32;	.endef
_object_to_string:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$LC0, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_asprintf
	movl	-16(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.globl	_integer_new
	.def	_integer_new;	.scl	2;	.type	32;	.endef
_integer_new:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$8, (%esp)
	call	_malloc
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$_the_class_integer, (%eax)
	movl	-12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.section .rdata,"dr"
LC1:
	.ascii "Integer output: %d\12\0"
	.text
	.globl	_integer_out
	.def	_integer_out;	.scl	2;	.type	32;	.endef
_integer_out:
LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.section .rdata,"dr"
LC2:
	.ascii "%d\0"
	.text
	.globl	_integer_to_string
	.def	_integer_to_string;	.scl	2;	.type	32;	.endef
_integer_to_string:
LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, 8(%esp)
	movl	$LC2, 4(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_asprintf
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE16:
	.globl	_integer_add
	.def	_integer_add;	.scl	2;	.type	32;	.endef
_integer_add:
LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	4(%eax), %eax
	movl	-12(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE17:
	.globl	_string_new
	.def	_string_new;	.scl	2;	.type	32;	.endef
_string_new:
LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$1028, (%esp)
	call	_malloc
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$_the_class_string, (%eax)
	movl	-12(%ebp), %eax
	leal	4(%eax), %edx
	movl	$1024, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_strncpy
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE18:
	.globl	_string_to_string
	.def	_string_to_string;	.scl	2;	.type	32;	.endef
_string_to_string:
LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	addl	$4, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE19:
	.globl	_io_new
	.def	_io_new;	.scl	2;	.type	32;	.endef
_io_new:
LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$4, (%esp)
	call	_malloc
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$_the_class_io, (%eax)
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE20:
	.section .rdata,"dr"
LC3:
	.ascii "%s\0"
	.text
	.globl	_io_out
	.def	_io_out;	.scl	2;	.type	32;	.endef
_io_out:
LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	8(%eax), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC3, (%esp)
	call	_printf
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE21:
	.globl	_silly
	.def	_silly;	.scl	2;	.type	32;	.endef
_silly:
LFB22:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_the_class_integer+4, %eax
	movl	%eax, -12(%ebp)
	movl	$42, (%esp)
	movl	-12(%ebp), %eax
	call	*%eax
	movl	%eax, -16(%ebp)
	movl	$18, (%esp)
	movl	-12(%ebp), %eax
	call	*%eax
	movl	%eax, -20(%ebp)
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	movl	12(%eax), %eax
	movl	-20(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE22:
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC4:
	.ascii "\12\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	_the_class_io+4, %eax
	call	*%eax
	movl	%eax, 28(%esp)
	movl	_the_class_string+4, %eax
	movl	$LC4, (%esp)
	call	*%eax
	movl	%eax, 24(%esp)
	call	_silly
	movl	%eax, 20(%esp)
	movl	28(%esp), %eax
	movl	(%eax), %eax
	movl	12(%eax), %eax
	movl	20(%esp), %edx
	movl	%edx, 4(%esp)
	movl	28(%esp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	28(%esp), %eax
	movl	(%eax), %eax
	movl	12(%eax), %eax
	movl	24(%esp), %edx
	movl	%edx, 4(%esp)
	movl	28(%esp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	28(%esp), %eax
	movl	(%eax), %eax
	movl	12(%eax), %eax
	movl	28(%esp), %edx
	movl	%edx, 4(%esp)
	movl	28(%esp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	28(%esp), %eax
	movl	(%eax), %eax
	movl	12(%eax), %eax
	movl	24(%esp), %edx
	movl	%edx, 4(%esp)
	movl	28(%esp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE23:
	.ident	"GCC: (GNU) 4.8.1"
	.def	_malloc;	.scl	2;	.type	32;	.endef
	.def	_asprintf;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	_strncpy;	.scl	2;	.type	32;	.endef
