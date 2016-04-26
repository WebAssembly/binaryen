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
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop7, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 3
	i32.add 	$0=, $0, $pop0
	i32.const	$push9=, 3
	i32.add 	$1=, $1, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$push5=, 0($0)
	i32.const	$push19=, 255
	i32.const	$push18=, 255
	i32.const	$push17=, 8
	i32.sub 	$push2=, $pop17, $2
	i32.shl 	$push3=, $pop18, $pop2
	i32.const	$push16=, 7
	i32.gt_s	$push15=, $2, $pop16
	tee_local	$push14=, $3=, $pop15
	i32.select	$push4=, $pop19, $pop3, $pop14
	i32.and 	$push6=, $pop5, $pop4
	i32.store8	$discard=, 0($1), $pop6
	i32.const	$push13=, -8
	i32.add 	$push1=, $2, $pop13
	i32.const	$push12=, 0
	i32.select	$2=, $pop1, $pop12, $3
	i32.const	$push11=, 1
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, 1
	i32.add 	$1=, $1, $pop10
	br_if   	0, $2           # 0: up to label1
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push36=, __stack_pointer
	i32.load	$push37=, 0($pop36)
	i32.const	$push38=, 48
	i32.sub 	$1=, $pop37, $pop38
	i32.const	$push39=, __stack_pointer
	i32.store	$discard=, 0($pop39), $1
	i32.const	$push43=, 24
	i32.add 	$push44=, $1, $pop43
	i32.const	$push2=, 18
	i32.add 	$push3=, $pop44, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+18($pop0)
	i32.store8	$discard=, 0($pop3), $pop1
	i32.const	$push45=, 24
	i32.add 	$push46=, $1, $pop45
	i32.const	$push5=, 16
	i32.add 	$push6=, $pop46, $pop5
	i32.const	$push35=, 0
	i32.load16_u	$push4=, .Lmain.x+16($pop35):p2align=0
	i32.store16	$discard=, 0($pop6), $pop4
	i32.const	$push34=, 16
	i32.add 	$push13=, $1, $pop34
	i32.const	$push33=, 18
	i32.add 	$push11=, $1, $pop33
	i32.const	$push32=, 0
	i32.store8	$push12=, 0($pop11), $pop32
	i32.store16	$discard=, 0($pop13), $pop12
	i32.const	$push47=, 24
	i32.add 	$push48=, $1, $pop47
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop48, $pop8
	i32.const	$push31=, 0
	i64.load	$push7=, .Lmain.x+8($pop31):p2align=0
	i64.store	$discard=, 0($pop9), $pop7
	i32.const	$push30=, 8
	i32.add 	$push14=, $1, $pop30
	i64.const	$push15=, 0
	i64.store	$0=, 0($pop14), $pop15
	i32.const	$push29=, 0
	i64.load	$push10=, .Lmain.x($pop29):p2align=0
	i64.store	$discard=, 24($1), $pop10
	i64.store	$discard=, 0($1), $0
	i32.const	$push49=, 24
	i32.add 	$push50=, $1, $pop49
	call    	foo@FUNCTION, $pop50, $1
	block
	i32.load8_u	$push16=, 3($1)
	i32.const	$push17=, 170
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push19=, 4($1)
	i32.const	$push20=, 187
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label3
# BB#2:                                 # %lor.lhs.false13
	i32.load8_u	$push22=, 5($1)
	i32.const	$push23=, 204
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label3
# BB#3:                                 # %lor.lhs.false22
	i32.load8_u	$push25=, 6($1)
	i32.const	$push26=, 128
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$push28=, 0
	i32.const	$push42=, __stack_pointer
	i32.const	$push40=, 48
	i32.add 	$push41=, $1, $pop40
	i32.store	$discard=, 0($pop42), $pop41
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
