	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27073.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 65535
	i32.and 	$push1=, $4, $pop0
	i32.eqz 	$push15=, $pop1
	br_if   	0, $pop15       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push2=, 0
	i32.sub 	$4=, $pop2, $4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.store	$drop=, 0($0), $5
	i32.const	$push14=, 4
	i32.add 	$push3=, $0, $pop14
	i32.store	$drop=, 0($pop3), $6
	i32.const	$push13=, 8
	i32.add 	$push4=, $0, $pop13
	i32.store	$drop=, 0($pop4), $7
	i32.const	$push12=, 12
	i32.add 	$push5=, $0, $pop12
	i32.store	$drop=, 0($pop5), $8
	i32.const	$push11=, 16
	i32.add 	$push6=, $0, $pop11
	i32.store	$drop=, 0($pop6), $9
	i32.const	$push10=, 20
	i32.add 	$0=, $0, $pop10
	i32.const	$push9=, 1
	i32.add 	$push8=, $4, $pop9
	tee_local	$push7=, $4=, $pop8
	br_if   	0, $pop7        # 0: up to label1
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
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 48
	i32.sub 	$push38=, $pop35, $pop36
	i32.store	$push42=, __stack_pointer($pop37), $pop38
	tee_local	$push41=, $0=, $pop42
	i32.const	$push4=, 2
	i32.const	$push3=, 100
	i32.const	$push40=, 200
	i32.const	$push2=, 300
	i32.const	$push1=, 400
	i32.const	$push0=, 500
	call    	foo@FUNCTION, $pop41, $0, $0, $0, $pop4, $pop3, $pop40, $pop2, $pop1, $pop0
	block
	i32.load	$push5=, 0($0)
	i32.const	$push39=, 100
	i32.ne  	$push6=, $pop5, $pop39
	br_if   	0, $pop6        # 0: down to label3
# BB#1:                                 # %for.cond
	i32.load	$push7=, 4($0)
	i32.const	$push43=, 200
	i32.ne  	$push8=, $pop7, $pop43
	br_if   	0, $pop8        # 0: down to label3
# BB#2:                                 # %for.cond.1
	i32.load	$push10=, 8($0)
	i32.const	$push9=, 300
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label3
# BB#3:                                 # %for.cond.2
	i32.load	$push13=, 12($0)
	i32.const	$push12=, 400
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label3
# BB#4:                                 # %for.cond.3
	i32.load	$push16=, 16($0)
	i32.const	$push15=, 500
	i32.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label3
# BB#5:                                 # %for.cond.4
	i32.load	$push19=, 20($0)
	i32.const	$push18=, 100
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label3
# BB#6:                                 # %for.cond.5
	i32.load	$push22=, 24($0)
	i32.const	$push21=, 200
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label3
# BB#7:                                 # %for.cond.6
	i32.load	$push25=, 28($0)
	i32.const	$push24=, 300
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label3
# BB#8:                                 # %for.cond.7
	i32.load	$push28=, 32($0)
	i32.const	$push27=, 400
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label3
# BB#9:                                 # %for.cond.8
	i32.load	$push31=, 36($0)
	i32.const	$push30=, 500
	i32.ne  	$push32=, $pop31, $pop30
	br_if   	0, $pop32       # 0: down to label3
# BB#10:                                # %for.cond.9
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB1_11:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
