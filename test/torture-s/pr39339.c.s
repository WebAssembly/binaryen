	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39339.c"
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
	i32.load	$6=, 0($pop1)
	i32.load	$push3=, 0($3)
	i32.load	$push4=, 0($pop3)
	i32.load	$push0=, 4($0)
	i32.const	$push2=, 3
	i32.shl 	$push20=, $pop0, $pop2
	tee_local	$push19=, $5=, $pop20
	i32.add 	$push18=, $pop4, $pop19
	tee_local	$push17=, $0=, $pop18
	i32.store	0($pop17), $1
	i32.const	$push7=, -16
	i32.and 	$push8=, $6, $pop7
	i32.const	$push5=, 15
	i32.and 	$push6=, $2, $pop5
	i32.or  	$push16=, $pop8, $pop6
	tee_local	$push15=, $6=, $pop16
	i32.store	4($0), $pop15
	block   	
	i32.const	$push10=, 2
	i32.lt_s	$push11=, $2, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push9=, 4194304
	i32.or  	$4=, $6, $pop9
	i32.const	$push23=, -1
	i32.add 	$0=, $2, $pop23
	i32.const	$push22=, 12
	i32.add 	$2=, $5, $pop22
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push12=, 0($3)
	i32.load	$push13=, 0($pop12)
	i32.add 	$push30=, $pop13, $2
	tee_local	$push29=, $6=, $pop30
	i32.store	0($pop29), $4
	i32.const	$push28=, -4
	i32.add 	$push14=, $6, $pop28
	i32.store	0($pop14), $1
	i32.const	$push27=, 8
	i32.add 	$2=, $2, $pop27
	i32.const	$push26=, -1
	i32.add 	$push25=, $0, $pop26
	tee_local	$push24=, $0=, $pop25
	br_if   	0, $pop24       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
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
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push40=, $pop20, $pop21
	tee_local	$push39=, $0=, $pop40
	i32.store	__stack_pointer($pop22), $pop39
	i32.const	$push2=, 56
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.e+8($pop0):p2align=2
	i64.store	0($pop3), $pop1
	i32.const	$push38=, 0
	i64.load	$push4=, .Lmain.e($pop38):p2align=2
	i64.store	48($0), $pop4
	i32.const	$push5=, 4
	i32.store	12($0), $pop5
	i32.const	$push26=, 16
	i32.add 	$push27=, $0, $pop26
	i32.store	8($0), $pop27
	i32.const	$push6=, 40
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 0
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 32
	i32.add 	$push10=, $0, $pop9
	i64.const	$push37=, 0
	i64.store	0($pop10), $pop37
	i32.const	$push36=, 0
	i32.store	28($0), $pop36
	i32.const	$push35=, 0
	i32.store	24($0), $pop35
	i32.const	$push34=, 0
	i32.store	20($0), $pop34
	i32.const	$push11=, 255
	i32.store8	4($0), $pop11
	i32.const	$push28=, 8
	i32.add 	$push29=, $0, $pop28
	i32.store	0($0), $pop29
	i32.const	$push33=, 0
	i32.store	16($0), $pop33
	i32.const	$push30=, 48
	i32.add 	$push31=, $0, $pop30
	i32.const	$push13=, 65
	i32.const	$push12=, 2
	call    	foo@FUNCTION, $pop31, $pop13, $pop12, $0
	block   	
	i32.load	$push14=, 20($0)
	i32.const	$push32=, 1434451954
	i32.ne  	$push15=, $pop14, $pop32
	br_if   	0, $pop15       # 0: down to label2
# BB#1:                                 # %if.end
	i32.load	$push16=, 28($0)
	i32.const	$push41=, 1434451954
	i32.ne  	$push17=, $pop16, $pop41
	br_if   	0, $pop17       # 0: down to label2
# BB#2:                                 # %if.end13
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $0, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_3:                                # %if.then12
	end_block                       # label2:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
