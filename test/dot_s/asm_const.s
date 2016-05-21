	.text
	.file	"/tmp/tmpkxUaTH/a.out.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:
	i32.const	$push0=, .str
	call    	emscripten_asm_const@FUNCTION, $pop0
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.str,@object            # @.str
	.data
.str:
	.asciz	"{ Module.print(\"hello, world!\"); }"
	.size	.str, 35


	.imports
	.import emscripten_asm_const "" emscripten_asm_const (param i32)
