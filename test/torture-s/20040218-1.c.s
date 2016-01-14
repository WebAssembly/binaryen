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
	i32.load8_u	$push0=, 0($0)
	i32.load	$push1=, 4($0)
	i32.add 	$push2=, $pop0, $pop1
	return  	$pop2
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
	i32.load16_u	$push0=, 0($0)
	i32.load	$push1=, 4($0)
	i32.add 	$push2=, $pop0, $pop1
	return  	$pop2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 16
	i32.load8_u	$push0=, 0($0)
	i32.load16_u	$push1=, 2($0)
	i32.add 	$push2=, $pop0, $pop1
	i32.shl 	$push3=, $pop2, $1
	i32.shr_s	$push4=, $pop3, $1
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	yb, .Lfunc_end2-yb

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	i32.const	$push1=, 1048641535
	i32.store	$discard=, 4($7), $pop1
	i64.const	$push0=, 68723771703295
	i64.store	$discard=, 8($7), $pop0
	i32.const	$4=, 8
	i32.add 	$4=, $7, $4
	i32.call	$0=, xb@FUNCTION, $4
	i32.const	$1=, 16255
	block
	i32.ne  	$push2=, $0, $1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$5=, 8
	i32.add 	$5=, $7, $5
	i32.call	$push3=, xw@FUNCTION, $5
	i32.const	$push4=, 81535
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.const	$6=, 4
	i32.add 	$6=, $7, $6
	i32.call	$push6=, yb@FUNCTION, $6
	i32.const	$push7=, 65535
	i32.and 	$push8=, $pop6, $pop7
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, 0        # 0: down to label0
# BB#3:                                 # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
