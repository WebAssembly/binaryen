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
	i32.const	$push21=, 12
	i32.add 	$push1=, $0, $pop21
	i32.load	$4=, 0($pop1)
	i32.load	$push7=, 0($3)
	i32.load	$push8=, 0($pop7)
	i32.load	$push0=, 4($0)
	i32.const	$push9=, 3
	i32.shl 	$push10=, $pop0, $pop9
	tee_local	$push20=, $6=, $pop10
	i32.add 	$push11=, $pop8, $pop20
	tee_local	$push19=, $0=, $pop11
	i32.store	$5=, 0($pop19), $1
	i32.const	$push4=, -16
	i32.and 	$push5=, $4, $pop4
	i32.const	$push2=, 15
	i32.and 	$push3=, $2, $pop2
	i32.or  	$push6=, $pop5, $pop3
	i32.store	$0=, 4($0), $pop6
	block
	i32.const	$push13=, 2
	i32.lt_s	$push14=, $2, $pop13
	br_if   	$pop14, 0       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push12=, 4194304
	i32.or  	$4=, $0, $pop12
	i32.const	$push23=, 12
	i32.add 	$0=, $6, $pop23
	i32.const	$push22=, -1
	i32.add 	$2=, $2, $pop22
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push15=, 0($3)
	i32.load	$push16=, 0($pop15)
	i32.add 	$push17=, $pop16, $0
	tee_local	$push27=, $1=, $pop17
	i32.const	$push26=, -4
	i32.add 	$push18=, $pop27, $pop26
	i32.store	$discard=, 0($pop18), $5
	i32.store	$discard=, 0($1), $4
	i32.const	$push25=, 8
	i32.add 	$0=, $0, $pop25
	i32.const	$push24=, -1
	i32.add 	$2=, $2, $pop24
	br_if   	$2, 0           # 0: up to label1
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
	i32.store	$push7=, 0($pop6), $pop35
	tee_local	$push34=, $1=, $pop7
	i32.or  	$push8=, $16, $pop34
	i32.const	$push9=, 255
	i32.store8	$discard=, 0($pop8):p2align=2, $pop9
	i32.const	$push13=, 24
	i32.const	$6=, 16
	i32.add 	$6=, $16, $6
	i32.add 	$push14=, $6, $pop13
	i32.const	$push10=, 28
	i32.const	$7=, 16
	i32.add 	$7=, $16, $7
	i32.add 	$push11=, $7, $pop10
	i32.const	$push0=, 0
	i32.store	$push12=, 0($pop11), $pop0
	i32.store	$discard=, 0($pop14):p2align=3, $pop12
	i32.const	$push2=, 8
	i32.const	$8=, 48
	i32.add 	$8=, $16, $8
	i32.add 	$push3=, $8, $pop2
	i32.const	$push33=, 0
	i64.load	$push1=, .Lmain.e+8($pop33):p2align=2
	i64.store	$discard=, 0($pop3), $pop1
	i32.const	$push32=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $16, $9
	i32.or  	$push19=, $9, $pop32
	i32.const	$push15=, 16
	i32.const	$10=, 16
	i32.add 	$10=, $16, $10
	i32.add 	$push16=, $10, $pop15
	i64.const	$push17=, 0
	i64.store	$push18=, 0($pop16):p2align=4, $pop17
	i64.store	$0=, 0($pop19), $pop18
	i32.const	$push31=, 0
	i64.load	$push4=, .Lmain.e($pop31):p2align=2
	i64.store	$discard=, 48($16), $pop4
	i64.store	$discard=, 16($16):p2align=4, $0
	i32.const	$11=, 16
	i32.add 	$11=, $16, $11
	i32.store	$discard=, 8($16):p2align=3, $11
	i32.const	$12=, 8
	i32.add 	$12=, $16, $12
	i32.store	$discard=, 0($16):p2align=3, $12
	i32.const	$push22=, 65
	i32.const	$push21=, 2
	i32.const	$13=, 48
	i32.add 	$13=, $16, $13
	call    	foo@FUNCTION, $13, $pop22, $pop21, $16
	i32.const	$14=, 16
	i32.add 	$14=, $16, $14
	block
	i32.or  	$push20=, $14, $1
	i32.load	$push23=, 0($pop20)
	i32.const	$push30=, 1434451954
	i32.ne  	$push24=, $pop23, $pop30
	br_if   	$pop24, 0       # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push25=, 12
	i32.const	$15=, 16
	i32.add 	$15=, $16, $15
	block
	i32.or  	$push26=, $15, $pop25
	i32.load	$push27=, 0($pop26)
	i32.const	$push36=, 1434451954
	i32.ne  	$push28=, $pop27, $pop36
	br_if   	$pop28, 0       # 0: down to label4
# BB#2:                                 # %if.end13
	i32.const	$push29=, 0
	i32.const	$4=, 64
	i32.add 	$16=, $16, $4
	i32.const	$4=, __stack_pointer
	i32.store	$16=, 0($4), $16
	return  	$pop29
.LBB1_3:                                # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.then
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
