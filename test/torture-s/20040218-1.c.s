	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040218-1.c"
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
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push24=, $pop15, $pop16
	i32.store	$push26=, __stack_pointer($pop17), $pop24
	tee_local	$push25=, $0=, $pop26
	i64.const	$push0=, 68723771703295
	i64.store	$drop=, 8($pop25), $pop0
	i32.const	$push1=, 1048641535
	i32.store	$drop=, 4($0), $pop1
	block
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	i32.call	$push3=, xb@FUNCTION, $pop19
	i32.const	$push2=, 16255
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push20=, 8
	i32.add 	$push21=, $0, $pop20
	i32.call	$push6=, xw@FUNCTION, $pop21
	i32.const	$push5=, 81535
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.const	$push22=, 4
	i32.add 	$push23=, $0, $pop22
	i32.call	$push9=, yb@FUNCTION, $pop23
	i32.const	$push8=, 65535
	i32.and 	$push10=, $pop9, $pop8
	i32.const	$push11=, 16255
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
