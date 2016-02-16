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
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i32.const	$push2=, 18
	i32.const	$4=, 24
	i32.add 	$4=, $8, $4
	i32.add 	$push3=, $4, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+18($pop0)
	i32.store8	$discard=, 0($pop3):p2align=1, $pop1
	i32.const	$push5=, 16
	i32.const	$5=, 24
	i32.add 	$5=, $8, $5
	i32.add 	$push6=, $5, $pop5
	i32.const	$push43=, 0
	i32.load16_u	$push4=, .Lmain.x+16($pop43):p2align=0
	i32.store16	$discard=, 0($pop6):p2align=3, $pop4
	i32.const	$push42=, 16
	i32.add 	$push13=, $8, $pop42
	i32.const	$push41=, 18
	i32.add 	$push11=, $8, $pop41
	i32.const	$push40=, 0
	i32.store8	$push12=, 0($pop11):p2align=1, $pop40
	i32.store16	$discard=, 0($pop13):p2align=3, $pop12
	i32.const	$push8=, 8
	i32.const	$6=, 24
	i32.add 	$6=, $8, $6
	i32.add 	$push9=, $6, $pop8
	i32.const	$push39=, 0
	i64.load	$push7=, .Lmain.x+8($pop39):p2align=0
	i64.store	$discard=, 0($pop9), $pop7
	i32.const	$push38=, 8
	i32.add 	$push14=, $8, $pop38
	i64.const	$push15=, 0
	i64.store	$0=, 0($pop14), $pop15
	i32.const	$push37=, 0
	i64.load	$push10=, .Lmain.x($pop37):p2align=0
	i64.store	$discard=, 24($8), $pop10
	i64.store	$discard=, 0($8), $0
	i32.const	$7=, 24
	i32.add 	$7=, $8, $7
	call    	foo@FUNCTION, $7, $8
	block
	i32.const	$push16=, 3
	i32.or  	$push17=, $8, $pop16
	i32.load8_u	$push18=, 0($pop17)
	i32.const	$push19=, 170
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.const	$push21=, 4
	i32.or  	$push22=, $8, $pop21
	i32.load8_u	$push23=, 0($pop22):p2align=2
	i32.const	$push24=, 187
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label3
# BB#2:                                 # %lor.lhs.false13
	i32.const	$push26=, 5
	i32.or  	$push27=, $8, $pop26
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push29=, 204
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label3
# BB#3:                                 # %lor.lhs.false22
	i32.const	$push31=, 6
	i32.or  	$push32=, $8, $pop31
	i32.load8_u	$push33=, 0($pop32):p2align=1
	i32.const	$push34=, 128
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$3=, 48
	i32.add 	$8=, $8, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	return  	$pop36
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
