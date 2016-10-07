	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/int-compare.c"
	.section	.text.gt,"ax",@progbits
	.hidden	gt
	.globl	gt
	.type	gt,@function
gt:                                     # @gt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	gt, .Lfunc_end0-gt

	.section	.text.ge,"ax",@progbits
	.hidden	ge
	.globl	ge
	.type	ge,@function
ge:                                     # @ge
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ge_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	ge, .Lfunc_end1-ge

	.section	.text.lt,"ax",@progbits
	.hidden	lt
	.globl	lt
	.type	lt,@function
lt:                                     # @lt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	lt, .Lfunc_end2-lt

	.section	.text.le,"ax",@progbits
	.hidden	le
	.globl	le
	.type	le,@function
le:                                     # @le
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.le_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	le, .Lfunc_end3-le

	.section	.text.true,"ax",@progbits
	.hidden	true
	.globl	true
	.type	true,@function
true:                                   # @true
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB4_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	true, .Lfunc_end4-true

	.section	.text.false,"ax",@progbits
	.hidden	false
	.globl	false
	.type	false,@function
false:                                  # @false
	.param  	i32
# BB#0:                                 # %entry
	block   	
	br_if   	0, $0           # 0: down to label1
# BB#1:                                 # %if.end
	return
.LBB5_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	false, .Lfunc_end5-false

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %true.exit
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	f, .Lfunc_end6-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
