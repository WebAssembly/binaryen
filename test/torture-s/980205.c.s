	.text
	.file	"980205.c"
	.section	.text.fdouble,"ax",@progbits
	.hidden	fdouble                 # -- Begin function fdouble
	.globl	fdouble
	.type	fdouble,@function
fdouble:                                # @fdouble
	.param  	f64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$push20=, $pop10, $pop12
	tee_local	$push19=, $2=, $pop20
	i32.store	__stack_pointer($pop13), $pop19
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push18=, $pop2, $pop3
	tee_local	$push17=, $1=, $pop18
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop17, $pop4
	i32.store	12($2), $pop5
	block   	
	f64.const	$push6=, 0x1p0
	f64.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %entry
	f64.load	$push0=, 0($1)
	f64.const	$push8=, 0x1p1
	f64.ne  	$push9=, $pop0, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $2, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fdouble, .Lfunc_end0-fdouble
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$push8=, $pop3, $pop5
	tee_local	$push7=, $0=, $pop8
	i32.store	__stack_pointer($pop6), $pop7
	i64.const	$push0=, 4611686018427387904
	i64.store	0($0), $pop0
	f64.const	$push1=, 0x1p0
	call    	fdouble@FUNCTION, $pop1, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
