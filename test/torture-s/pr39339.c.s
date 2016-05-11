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
	i32.load	$5=, 0($pop1)
	i32.load	$push7=, 0($3)
	i32.load	$push8=, 0($pop7)
	i32.load	$push0=, 4($0)
	i32.const	$push9=, 3
	i32.shl 	$push19=, $pop0, $pop9
	tee_local	$push18=, $6=, $pop19
	i32.add 	$push17=, $pop8, $pop18
	tee_local	$push16=, $0=, $pop17
	i32.store	$4=, 0($pop16), $1
	i32.const	$push4=, -16
	i32.and 	$push5=, $5, $pop4
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
	i32.or  	$5=, $0, $pop10
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
	i32.store	$discard=, 0($pop15), $4
	i32.store	$discard=, 0($1), $5
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 64
	i32.sub 	$push35=, $pop23, $pop24
	i32.store	$push41=, 0($pop25), $pop35
	tee_local	$push40=, $1=, $pop41
	i32.const	$push5=, 56
	i32.add 	$push6=, $pop40, $pop5
	i32.const	$push3=, 0
	i64.load	$push4=, .Lmain.e+8($pop3):p2align=2
	i64.store	$discard=, 0($pop6), $pop4
	i32.const	$push8=, 4
	i32.store	$discard=, 12($1), $pop8
	i32.const	$push9=, 255
	i32.store8	$discard=, 4($1), $pop9
	i32.const	$push13=, 32
	i32.add 	$push14=, $1, $pop13
	i32.const	$push10=, 40
	i32.add 	$push11=, $1, $pop10
	i64.const	$push12=, 0
	i64.store	$push0=, 0($pop11), $pop12
	i64.store	$discard=, 0($pop14), $pop0
	i32.const	$push39=, 0
	i32.store	$push38=, 28($1), $pop39
	tee_local	$push37=, $0=, $pop38
	i32.store	$push1=, 24($1), $pop37
	i32.store	$push2=, 20($1), $pop1
	i32.store	$discard=, 16($1), $pop2
	i64.load	$push7=, .Lmain.e($0):p2align=2
	i64.store	$discard=, 48($1), $pop7
	i32.const	$push29=, 16
	i32.add 	$push30=, $1, $pop29
	i32.store	$discard=, 8($1), $pop30
	i32.const	$push31=, 8
	i32.add 	$push32=, $1, $pop31
	i32.store	$discard=, 0($1), $pop32
	i32.const	$push33=, 48
	i32.add 	$push34=, $1, $pop33
	i32.const	$push16=, 65
	i32.const	$push15=, 2
	call    	foo@FUNCTION, $pop34, $pop16, $pop15, $1
	block
	i32.load	$push17=, 20($1)
	i32.const	$push36=, 1434451954
	i32.ne  	$push18=, $pop17, $pop36
	br_if   	0, $pop18       # 0: down to label3
# BB#1:                                 # %if.end
	i32.load	$push19=, 28($1)
	i32.const	$push42=, 1434451954
	i32.ne  	$push20=, $pop19, $pop42
	br_if   	0, $pop20       # 0: down to label3
# BB#2:                                 # %if.end13
	i32.const	$push28=, __stack_pointer
	i32.const	$push26=, 64
	i32.add 	$push27=, $1, $pop26
	i32.store	$discard=, 0($pop28), $pop27
	i32.const	$push21=, 0
	return  	$pop21
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
