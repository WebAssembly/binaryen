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
	i32.load	$push3=, 0($3)
	i32.load	$push4=, 0($pop3)
	i32.load	$push0=, 4($0)
	i32.const	$push2=, 3
	i32.shl 	$push19=, $pop0, $pop2
	tee_local	$push18=, $6=, $pop19
	i32.add 	$push17=, $pop4, $pop18
	tee_local	$push16=, $0=, $pop17
	i32.store	$4=, 0($pop16), $1
	i32.const	$push7=, -16
	i32.and 	$push8=, $5, $pop7
	i32.const	$push5=, 15
	i32.and 	$push6=, $2, $pop5
	i32.or  	$push9=, $pop8, $pop6
	i32.store	$0=, 4($0), $pop9
	block
	i32.const	$push11=, 2
	i32.lt_s	$push12=, $2, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push10=, 4194304
	i32.or  	$5=, $0, $pop10
	i32.const	$push22=, -1
	i32.add 	$0=, $2, $pop22
	i32.const	$push21=, 12
	i32.add 	$2=, $6, $pop21
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push13=, 0($3)
	i32.load	$push14=, 0($pop13)
	i32.add 	$push29=, $pop14, $2
	tee_local	$push28=, $1=, $pop29
	i32.store	$drop=, 0($pop28), $5
	i32.const	$push27=, -4
	i32.add 	$push15=, $1, $pop27
	i32.store	$drop=, 0($pop15), $4
	i32.const	$push26=, 8
	i32.add 	$2=, $2, $pop26
	i32.const	$push25=, -1
	i32.add 	$push24=, $0, $pop25
	tee_local	$push23=, $0=, $pop24
	br_if   	0, $pop23       # 0: up to label1
.LBB0_3:                                # %for.end
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 64
	i32.sub 	$push35=, $pop23, $pop24
	i32.store	$push40=, __stack_pointer($pop25), $pop35
	tee_local	$push39=, $1=, $pop40
	i32.const	$push5=, 56
	i32.add 	$push6=, $pop39, $pop5
	i32.const	$push3=, 0
	i64.load	$push4=, .Lmain.e+8($pop3):p2align=2
	i64.store	$drop=, 0($pop6), $pop4
	i32.const	$push38=, 0
	i64.load	$push7=, .Lmain.e($pop38):p2align=2
	i64.store	$drop=, 48($1), $pop7
	i32.const	$push8=, 4
	i32.store	$drop=, 12($1), $pop8
	i32.const	$push29=, 16
	i32.add 	$push30=, $1, $pop29
	i32.store	$drop=, 8($1), $pop30
	i32.const	$push12=, 32
	i32.add 	$push13=, $1, $pop12
	i32.const	$push9=, 40
	i32.add 	$push10=, $1, $pop9
	i64.const	$push11=, 0
	i64.store	$push0=, 0($pop10), $pop11
	i64.store	$drop=, 0($pop13), $pop0
	i32.const	$push37=, 0
	i32.store	$push1=, 28($1), $pop37
	i32.store	$push2=, 24($1), $pop1
	i32.store	$0=, 20($1), $pop2
	i32.const	$push14=, 255
	i32.store8	$drop=, 4($1), $pop14
	i32.const	$push31=, 8
	i32.add 	$push32=, $1, $pop31
	i32.store	$drop=, 0($1), $pop32
	i32.store	$drop=, 16($1), $0
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
	i32.const	$push41=, 1434451954
	i32.ne  	$push20=, $pop19, $pop41
	br_if   	0, $pop20       # 0: down to label3
# BB#2:                                 # %if.end13
	i32.const	$push28=, 0
	i32.const	$push26=, 64
	i32.add 	$push27=, $1, $pop26
	i32.store	$drop=, __stack_pointer($pop28), $pop27
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
	.functype	abort, void
