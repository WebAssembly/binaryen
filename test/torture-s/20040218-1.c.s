	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040218-1.c"
	.section	.text.xb,"ax",@progbits
	.hidden	xb
	.globl	xb
	.type	xb,@function
xb:                                     # @xb
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.add 	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	xb, .Lfunc_end0-xb

	.section	.text.xw,"ax",@progbits
	.hidden	xw
	.globl	xw
	.type	xw,@function
xw:                                     # @xw
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.add 	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	xw, .Lfunc_end1-xw

	.section	.text.yb,"ax",@progbits
	.hidden	yb
	.globl	yb
	.type	yb,@function
yb:                                     # @yb
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load16_u	$push0=, 2($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 16
	i32.shl 	$push4=, $pop2, $pop3
	i32.const	$push6=, 16
	i32.shr_s	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	yb, .Lfunc_end2-yb

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push23=, $pop13, $pop14
	tee_local	$push22=, $0=, $pop23
	i32.store	__stack_pointer($pop15), $pop22
	i64.const	$push0=, 68723771703295
	i64.store	8($0), $pop0
	i32.const	$push1=, 1048641535
	i32.store	4($0), $pop1
	block   	
	i32.const	$push16=, 8
	i32.add 	$push17=, $0, $pop16
	i32.call	$push3=, xb@FUNCTION, $pop17
	i32.const	$push2=, 16255
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	i32.call	$push6=, xw@FUNCTION, $pop19
	i32.const	$push5=, 81535
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.const	$push20=, 4
	i32.add 	$push21=, $0, $pop20
	i32.call	$push9=, yb@FUNCTION, $pop21
	i32.const	$push8=, 16255
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label0
# BB#3:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
