	.text
	.file	"local_align.bc"
	.type	foo,@function
foo:
	.param  	i32
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.hidden	main
	.globl	main
	.type	main,@function
main:
	.result 	i32
	i32.const	$push0=, buf
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	temp,@object
	.lcomm	temp,1,1

	.type	buf,@object
	.lcomm	buf,156,4
