	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-9.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 0($2)
	i32.const	$push7=, 11
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.load8_u	$push9=, 1($2)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end18
	i32.load8_u	$push12=, 0($3)
	i32.const	$push13=, 12
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end24
	i32.load8_u	$push15=, 1($3)
	i32.const	$push16=, 22
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end30
	i32.const	$push18=, 123
	i32.ne  	$push19=, $4, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#7:                                 # %if.end34
	return  	$1
.LBB0_8:                                # %if.then33
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push20=, $pop11, $pop12
	i32.store	$push22=, 0($pop13), $pop20
	tee_local	$push21=, $0=, $pop22
	i32.const	$push0=, 5130
	i32.store16	$discard=, 8($pop21), $pop0
	i32.const	$push1=, 11
	i32.store8	$discard=, 10($0), $pop1
	i32.const	$push2=, 12
	i32.store8	$discard=, 12($0), $pop2
	i32.const	$push3=, 21
	i32.store8	$discard=, 11($0), $pop3
	i32.const	$push4=, 22
	i32.store8	$discard=, 13($0), $pop4
	i32.load16_u	$push5=, 8($0)
	i32.store16	$discard=, 6($0), $pop5
	i32.load16_u	$push6=, 10($0)
	i32.store16	$discard=, 4($0), $pop6
	i32.load16_u	$push7=, 12($0)
	i32.store16	$discard=, 2($0), $pop7
	i32.const	$push14=, 6
	i32.add 	$push15=, $0, $pop14
	i32.const	$push16=, 4
	i32.add 	$push17=, $0, $pop16
	i32.const	$push18=, 2
	i32.add 	$push19=, $0, $pop18
	i32.const	$push8=, 123
	i32.call	$discard=, f@FUNCTION, $0, $pop15, $pop17, $pop19, $pop8
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
