	.text
	.file	"export_malloc_free.bc"
	.hidden	main
	.globl	main
	.type	main,@function
main:
	.result 	i32
	i32.const	$push0=, 0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.weak	malloc
	.type	malloc,@function
malloc:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	.endfunc
.Lfunc_end20:
	.size	malloc, .Lfunc_end20-malloc

	.weak	free
	.type	free,@function
free:
	.param  	i32
	.endfunc
.Lfunc_end21:
	.size	free, .Lfunc_end21-free
