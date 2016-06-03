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
	tee_local	$push7=, $3=, $pop8
	i32.eqz 	$push22=, $pop7
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 3
	i32.add 	$1=, $1, $pop0
	i32.const	$push9=, 3
	i32.add 	$0=, $0, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$push4=, 0($0)
	i32.const	$push21=, 255
	i32.const	$push20=, 255
	i32.const	$push19=, 8
	i32.sub 	$push1=, $pop19, $3
	i32.shl 	$push2=, $pop20, $pop1
	i32.const	$push18=, 7
	i32.gt_s	$push17=, $3, $pop18
	tee_local	$push16=, $2=, $pop17
	i32.select	$push3=, $pop21, $pop2, $pop16
	i32.and 	$push5=, $pop4, $pop3
	i32.store8	$drop=, 0($1), $pop5
	i32.const	$push15=, 1
	i32.add 	$1=, $1, $pop15
	i32.const	$push14=, 1
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, -8
	i32.add 	$push6=, $3, $pop13
	i32.const	$push12=, 0
	i32.select	$push11=, $pop6, $pop12, $2
	tee_local	$push10=, $3=, $pop11
	br_if   	0, $pop10       # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push33=, 0
	i32.const	$push30=, 0
	i32.load	$push31=, __stack_pointer($pop30)
	i32.const	$push32=, 48
	i32.sub 	$push45=, $pop31, $pop32
	i32.store	$push54=, __stack_pointer($pop33), $pop45
	tee_local	$push53=, $0=, $pop54
	i32.const	$push37=, 24
	i32.add 	$push38=, $pop53, $pop37
	i32.const	$push4=, 18
	i32.add 	$push5=, $pop38, $pop4
	i32.const	$push2=, 0
	i32.load8_u	$push3=, .Lmain.x+18($pop2)
	i32.store8	$drop=, 0($pop5), $pop3
	i32.const	$push39=, 24
	i32.add 	$push40=, $0, $pop39
	i32.const	$push7=, 16
	i32.add 	$push8=, $pop40, $pop7
	i32.const	$push52=, 0
	i32.load16_u	$push6=, .Lmain.x+16($pop52):p2align=0
	i32.store16	$drop=, 0($pop8), $pop6
	i32.const	$push41=, 24
	i32.add 	$push42=, $0, $pop41
	i32.const	$push10=, 8
	i32.add 	$push11=, $pop42, $pop10
	i32.const	$push51=, 0
	i64.load	$push9=, .Lmain.x+8($pop51):p2align=0
	i64.store	$drop=, 0($pop11), $pop9
	i32.const	$push50=, 0
	i64.load	$push12=, .Lmain.x($pop50):p2align=0
	i64.store	$drop=, 24($0), $pop12
	i32.const	$push49=, 16
	i32.add 	$push14=, $0, $pop49
	i32.const	$push48=, 18
	i32.add 	$push13=, $0, $pop48
	i32.const	$push47=, 0
	i32.store8	$push0=, 0($pop13), $pop47
	i32.store16	$drop=, 0($pop14), $pop0
	i32.const	$push46=, 8
	i32.add 	$push15=, $0, $pop46
	i64.const	$push16=, 0
	i64.store	$push1=, 0($pop15), $pop16
	i64.store	$drop=, 0($0), $pop1
	i32.const	$push43=, 24
	i32.add 	$push44=, $0, $pop43
	call    	foo@FUNCTION, $pop44, $0
	block
	i32.load8_u	$push18=, 3($0)
	i32.const	$push17=, 170
	i32.ne  	$push19=, $pop18, $pop17
	br_if   	0, $pop19       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push21=, 4($0)
	i32.const	$push20=, 187
	i32.ne  	$push22=, $pop21, $pop20
	br_if   	0, $pop22       # 0: down to label3
# BB#2:                                 # %lor.lhs.false13
	i32.load8_u	$push24=, 5($0)
	i32.const	$push23=, 204
	i32.ne  	$push25=, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label3
# BB#3:                                 # %lor.lhs.false22
	i32.load8_u	$push27=, 6($0)
	i32.const	$push26=, 128
	i32.ne  	$push28=, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push34=, 48
	i32.add 	$push35=, $0, $pop34
	i32.store	$drop=, __stack_pointer($pop36), $pop35
	i32.const	$push29=, 0
	return  	$pop29
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
	.functype	abort, void
