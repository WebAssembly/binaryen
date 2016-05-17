	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27285.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push8=, 1($0)
	tee_local	$push7=, $2=, $pop8
	i32.eqz 	$push22=, $pop7
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 3
	i32.add 	$0=, $0, $pop0
	i32.const	$push9=, 3
	i32.add 	$1=, $1, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$push5=, 0($0)
	i32.const	$push21=, 255
	i32.const	$push20=, 255
	i32.const	$push19=, 8
	i32.sub 	$push2=, $pop19, $2
	i32.shl 	$push3=, $pop20, $pop2
	i32.const	$push18=, 7
	i32.gt_s	$push17=, $2, $pop18
	tee_local	$push16=, $3=, $pop17
	i32.select	$push4=, $pop21, $pop3, $pop16
	i32.and 	$push6=, $pop5, $pop4
	i32.store8	$drop=, 0($1), $pop6
	i32.const	$push15=, 1
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	i32.const	$push13=, -8
	i32.add 	$push1=, $2, $pop13
	i32.const	$push12=, 0
	i32.select	$push11=, $pop1, $pop12, $3
	tee_local	$push10=, $2=, $pop11
	br_if   	0, $pop10       # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push32=, __stack_pointer
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 48
	i32.sub 	$push44=, $pop30, $pop31
	i32.store	$push52=, 0($pop32), $pop44
	tee_local	$push51=, $2=, $pop52
	i32.const	$push36=, 24
	i32.add 	$push37=, $pop51, $pop36
	i32.const	$push3=, 18
	i32.add 	$push4=, $pop37, $pop3
	i32.const	$push1=, 0
	i32.load8_u	$push2=, .Lmain.x+18($pop1)
	i32.store8	$drop=, 0($pop4), $pop2
	i32.const	$push38=, 24
	i32.add 	$push39=, $2, $pop38
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop39, $pop6
	i32.const	$push50=, 0
	i32.load16_u	$push5=, .Lmain.x+16($pop50):p2align=0
	i32.store16	$drop=, 0($pop7), $pop5
	i32.const	$push40=, 24
	i32.add 	$push41=, $2, $pop40
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop41, $pop9
	i32.const	$push49=, 0
	i64.load	$push8=, .Lmain.x+8($pop49):p2align=0
	i64.store	$drop=, 0($pop10), $pop8
	i32.const	$push48=, 16
	i32.add 	$push13=, $2, $pop48
	i32.const	$push47=, 18
	i32.add 	$push12=, $2, $pop47
	i32.const	$push46=, 0
	i32.store8	$push0=, 0($pop12), $pop46
	i32.store16	$0=, 0($pop13), $pop0
	i32.const	$push45=, 8
	i32.add 	$push14=, $2, $pop45
	i64.const	$push15=, 0
	i64.store	$1=, 0($pop14), $pop15
	i64.load	$push11=, .Lmain.x($0):p2align=0
	i64.store	$drop=, 24($2), $pop11
	i64.store	$drop=, 0($2), $1
	i32.const	$push42=, 24
	i32.add 	$push43=, $2, $pop42
	call    	foo@FUNCTION, $pop43, $2
	block
	i32.load8_u	$push16=, 3($2)
	i32.const	$push17=, 170
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push19=, 4($2)
	i32.const	$push20=, 187
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label3
# BB#2:                                 # %lor.lhs.false13
	i32.load8_u	$push22=, 5($2)
	i32.const	$push23=, 204
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label3
# BB#3:                                 # %lor.lhs.false22
	i32.load8_u	$push25=, 6($2)
	i32.const	$push26=, 128
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$push35=, __stack_pointer
	i32.const	$push33=, 48
	i32.add 	$push34=, $2, $pop33
	i32.store	$drop=, 0($pop35), $pop34
	i32.const	$push28=, 0
	return  	$pop28
.LBB1_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.x,@object        # @main.x
	.section	.rodata..Lmain.x,"a",@progbits
.Lmain.x:
	.int8	0                       # 0x0
	.int8	25                      # 0x19
	.int8	0                       # 0x0
	.asciz	"\252\273\314\335\000\000\000\000\000\000\000\000\000\000\000"
	.size	.Lmain.x, 19


	.ident	"clang version 3.9.0 "
