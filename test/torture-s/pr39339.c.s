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
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 64
	i32.sub 	$8=, $pop28, $pop29
	i32.const	$push30=, __stack_pointer
	i32.store	$discard=, 0($pop30), $8
	i32.const	$push10=, 24
	i32.const	$1=, 16
	i32.add 	$1=, $8, $1
	i32.add 	$push11=, $1, $pop10
	i32.const	$push7=, 28
	i32.const	$2=, 16
	i32.add 	$2=, $8, $2
	i32.add 	$push8=, $2, $pop7
	i32.const	$push0=, 0
	i32.store	$push9=, 0($pop8), $pop0
	i32.store	$discard=, 0($pop11):p2align=3, $pop9
	i32.const	$push2=, 8
	i32.const	$3=, 48
	i32.add 	$3=, $8, $3
	i32.add 	$push3=, $3, $pop2
	i32.const	$push25=, 0
	i64.load	$push1=, .Lmain.e+8($pop25):p2align=2
	i64.store	$discard=, 0($pop3), $pop1
	i32.const	$push5=, 4
	i32.store	$discard=, 12($8), $pop5
	i32.const	$push6=, 255
	i32.store8	$discard=, 4($8):p2align=2, $pop6
	i32.const	$push12=, 16
	i32.const	$4=, 16
	i32.add 	$4=, $8, $4
	i32.add 	$push13=, $4, $pop12
	i64.const	$push14=, 0
	i64.store	$0=, 0($pop13):p2align=4, $pop14
	i32.const	$push24=, 0
	i64.load	$push4=, .Lmain.e($pop24):p2align=2
	i64.store	$discard=, 48($8), $pop4
	i64.store	$push15=, 24($8), $0
	i64.store	$discard=, 16($8):p2align=4, $pop15
	i32.const	$5=, 16
	i32.add 	$5=, $8, $5
	i32.store	$discard=, 8($8):p2align=3, $5
	i32.const	$6=, 8
	i32.add 	$6=, $8, $6
	i32.store	$discard=, 0($8):p2align=3, $6
	i32.const	$push17=, 65
	i32.const	$push16=, 2
	i32.const	$7=, 48
	i32.add 	$7=, $8, $7
	call    	foo@FUNCTION, $7, $pop17, $pop16, $8
	block
	i32.load	$push18=, 20($8)
	i32.const	$push23=, 1434451954
	i32.ne  	$push19=, $pop18, $pop23
	br_if   	0, $pop19       # 0: down to label3
# BB#1:                                 # %if.end
	i32.load	$push20=, 28($8)
	i32.const	$push26=, 1434451954
	i32.ne  	$push21=, $pop20, $pop26
	br_if   	0, $pop21       # 0: down to label3
# BB#2:                                 # %if.end13
	i32.const	$push22=, 0
	i32.const	$push31=, 64
	i32.add 	$8=, $8, $pop31
	i32.const	$push32=, __stack_pointer
	i32.store	$discard=, 0($pop32), $8
	return  	$pop22
.LBB1_3:                                # %if.then12
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
