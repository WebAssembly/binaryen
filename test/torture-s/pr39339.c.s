	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39339.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 12
	i32.add 	$push1=, $0, $pop20
	i32.load	$4=, 0($pop1)
	i32.load	$push7=, 0($3)
	i32.load	$push8=, 0($pop7)
	i32.load	$push0=, 4($0)
	i32.const	$push9=, 3
	i32.shl 	$push19=, $pop0, $pop9
	tee_local	$push18=, $6=, $pop19
	i32.add 	$push17=, $pop8, $pop18
	tee_local	$push16=, $0=, $pop17
	i32.store	$5=, 0($pop16), $1
	i32.const	$push4=, -16
	i32.and 	$push5=, $4, $pop4
	i32.const	$push2=, 15
	i32.and 	$push3=, $2, $pop2
	i32.or  	$push6=, $pop5, $pop3
	i32.store	$0=, 4($0), $pop6
	block
	i32.const	$push11=, 2
	i32.lt_s	$push12=, $2, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push10=, 4194304
	i32.or  	$4=, $0, $pop10
	i32.const	$push22=, 12
	i32.add 	$0=, $6, $pop22
	i32.const	$push21=, -1
	i32.add 	$2=, $2, $pop21
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push13=, 0($3)
	i32.load	$push14=, 0($pop13)
	i32.add 	$push27=, $pop14, $0
	tee_local	$push26=, $1=, $pop27
	i32.const	$push25=, -4
	i32.add 	$push15=, $pop26, $pop25
	i32.store	$discard=, 0($pop15), $5
	i32.store	$discard=, 0($1), $4
	i32.const	$push24=, 8
	i32.add 	$0=, $0, $pop24
	i32.const	$push23=, -1
	i32.add 	$2=, $2, $pop23
	br_if   	0, $2           # 0: up to label1
.LBB0_3:                                # %for.end
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
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 64
	i32.sub 	$16=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$16=, 0($3), $16
	i32.const	$push5=, 4
	i32.const	$5=, 8
	i32.add 	$5=, $16, $5
	i32.or  	$push6=, $5, $pop5
	i32.const	$push35=, 4
	i32.store	$push34=, 0($pop6), $pop35
	tee_local	$push33=, $1=, $pop34
	i32.or  	$push7=, $16, $pop33
	i32.const	$push8=, 255
	i32.store8	$discard=, 0($pop7):p2align=2, $pop8
	i32.const	$push12=, 24
	i32.const	$6=, 16
	i32.add 	$6=, $16, $6
	i32.add 	$push13=, $6, $pop12
	i32.const	$push9=, 28
	i32.const	$7=, 16
	i32.add 	$7=, $16, $7
	i32.add 	$push10=, $7, $pop9
	i32.const	$push0=, 0
	i32.store	$push11=, 0($pop10), $pop0
	i32.store	$discard=, 0($pop13):p2align=3, $pop11
	i32.const	$push2=, 8
	i32.const	$8=, 48
	i32.add 	$8=, $16, $8
	i32.add 	$push3=, $8, $pop2
	i32.const	$push32=, 0
	i64.load	$push1=, .Lmain.e+8($pop32):p2align=2
	i64.store	$discard=, 0($pop3), $pop1
	i32.const	$push31=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $16, $9
	i32.or  	$push18=, $9, $pop31
	i32.const	$push14=, 16
	i32.const	$10=, 16
	i32.add 	$10=, $16, $10
	i32.add 	$push15=, $10, $pop14
	i64.const	$push16=, 0
	i64.store	$push17=, 0($pop15):p2align=4, $pop16
	i64.store	$0=, 0($pop18), $pop17
	i32.const	$push30=, 0
	i64.load	$push4=, .Lmain.e($pop30):p2align=2
	i64.store	$discard=, 48($16), $pop4
	i64.store	$discard=, 16($16):p2align=4, $0
	i32.const	$11=, 16
	i32.add 	$11=, $16, $11
	i32.store	$discard=, 8($16):p2align=3, $11
	i32.const	$12=, 8
	i32.add 	$12=, $16, $12
	i32.store	$discard=, 0($16):p2align=3, $12
	i32.const	$push21=, 65
	i32.const	$push20=, 2
	i32.const	$13=, 48
	i32.add 	$13=, $16, $13
	call    	foo@FUNCTION, $13, $pop21, $pop20, $16
	i32.const	$14=, 16
	i32.add 	$14=, $16, $14
	block
	block
	i32.or  	$push19=, $14, $1
	i32.load	$push22=, 0($pop19)
	i32.const	$push29=, 1434451954
	i32.ne  	$push23=, $pop22, $pop29
	br_if   	0, $pop23       # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push24=, 12
	i32.const	$15=, 16
	i32.add 	$15=, $16, $15
	i32.or  	$push25=, $15, $pop24
	i32.load	$push26=, 0($pop25)
	i32.const	$push36=, 1434451954
	i32.ne  	$push27=, $pop26, $pop36
	br_if   	1, $pop27       # 1: down to label3
# BB#2:                                 # %if.end13
	i32.const	$push28=, 0
	i32.const	$4=, 64
	i32.add 	$16=, $16, $4
	i32.const	$4=, __stack_pointer
	i32.store	$16=, 0($4), $16
	return  	$pop28
.LBB1_3:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.then12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.e,@object        # @main.e
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	2
.Lmain.e:
	.int32	5                       # 0x5
	.int32	0                       # 0x0
	.int32	6                       # 0x6
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	127                     # 0x7f
	.int8	85                      # 0x55
	.size	.Lmain.e, 16


	.ident	"clang version 3.9.0 "
