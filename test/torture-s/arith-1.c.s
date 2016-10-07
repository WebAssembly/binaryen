	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-1.c"
	.section	.text.sat_add,"ax",@progbits
	.hidden	sat_add
	.globl	sat_add
	.type	sat_add,@function
sat_add:                                # @sat_add
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.const	$push5=, -1
	i32.eq  	$push1=, $0, $pop5
	i32.select	$push4=, $pop0, $pop3, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	sat_add, .Lfunc_end0-sat_add

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
