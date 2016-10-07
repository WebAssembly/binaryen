	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27073.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push13=, $4
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 0
	i32.sub 	$4=, $pop0, $4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.store	0($0), $5
	i32.const	$push12=, 4
	i32.add 	$push1=, $0, $pop12
	i32.store	0($pop1), $6
	i32.const	$push11=, 8
	i32.add 	$push2=, $0, $pop11
	i32.store	0($pop2), $7
	i32.const	$push10=, 12
	i32.add 	$push3=, $0, $pop10
	i32.store	0($pop3), $8
	i32.const	$push9=, 16
	i32.add 	$push4=, $0, $pop9
	i32.store	0($pop4), $9
	i32.const	$push8=, 20
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $4, $pop7
	tee_local	$push5=, $4=, $pop6
	br_if   	0, $pop5        # 0: up to label1
.LBB0_3:                                # %while.end
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
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 48
	i32.sub 	$push41=, $pop35, $pop36
	tee_local	$push40=, $0=, $pop41
	i32.store	__stack_pointer($pop37), $pop40
	i32.const	$push4=, 2
	i32.const	$push3=, 100
	i32.const	$push39=, 200
	i32.const	$push2=, 300
	i32.const	$push1=, 400
	i32.const	$push0=, 500
	call    	foo@FUNCTION, $0, $0, $0, $0, $pop4, $pop3, $pop39, $pop2, $pop1, $pop0
	block   	
	i32.load	$push5=, 0($0)
	i32.const	$push38=, 100
	i32.ne  	$push6=, $pop5, $pop38
	br_if   	0, $pop6        # 0: down to label2
# BB#1:                                 # %for.cond
	i32.load	$push7=, 4($0)
	i32.const	$push42=, 200
	i32.ne  	$push8=, $pop7, $pop42
	br_if   	0, $pop8        # 0: down to label2
# BB#2:                                 # %for.cond.1
	i32.load	$push10=, 8($0)
	i32.const	$push9=, 300
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label2
# BB#3:                                 # %for.cond.2
	i32.load	$push13=, 12($0)
	i32.const	$push12=, 400
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label2
# BB#4:                                 # %for.cond.3
	i32.load	$push16=, 16($0)
	i32.const	$push15=, 500
	i32.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label2
# BB#5:                                 # %for.cond.4
	i32.load	$push19=, 20($0)
	i32.const	$push18=, 100
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label2
# BB#6:                                 # %for.cond.5
	i32.load	$push22=, 24($0)
	i32.const	$push21=, 200
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label2
# BB#7:                                 # %for.cond.6
	i32.load	$push25=, 28($0)
	i32.const	$push24=, 300
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label2
# BB#8:                                 # %for.cond.7
	i32.load	$push28=, 32($0)
	i32.const	$push27=, 400
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label2
# BB#9:                                 # %for.cond.8
	i32.load	$push31=, 36($0)
	i32.const	$push30=, 500
	i32.ne  	$push32=, $pop31, $pop30
	br_if   	0, $pop32       # 0: down to label2
# BB#10:                                # %for.cond.9
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB1_11:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
