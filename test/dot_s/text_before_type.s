	.text
	.file	"text_before_type.bc"
	.hidden	main
	.globl	main
	.type	main,@function
main:
	.result 	i32
	call    	foo@FUNCTION
	i32.const	$push0=, 0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.text
	.type	foo,@function
foo:
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

