	.text
	.file	"alias.c"

	.hidden	__exit
	.globl	__exit
	.type	__exit,@function
__exit:                           # @__exit
	.local  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	__exit, .Lfunc_end0-__exit

	.hidden	__needs_exit
	.globl	__needs_exit
	.type	__needs_exit,@function
__needs_exit:              # @__needs_exit
# BB#0:                                 # %entry
	call    	__exit_needed@FUNCTION
	return
	.endfunc
.Lfunc_end1:
	.size	__needs_exit, .Lfunc_end1-__needs_exit

	.weak	__exit_needed
	.type	__exit_needed,@function
	.hidden	__exit_needed
__exit_needed = __exit@FUNCTION
