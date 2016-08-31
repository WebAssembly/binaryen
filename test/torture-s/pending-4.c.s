	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pending-4.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push21=, $pop12, $pop13
	tee_local	$push20=, $4=, $pop21
	i32.store	$drop=, __stack_pointer($pop14), $pop20
	i32.const	$push0=, 0
	i32.store	$drop=, 12($4), $pop0
	i32.const	$push19=, 0
	i32.store	$drop=, 8($4), $pop19
	i32.const	$2=, 8
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push15=, 12
	i32.add 	$push16=, $4, $pop15
	copy_local	$3=, $pop16
	block
	i32.const	$push24=, 1
	i32.eq  	$push1=, $2, $pop24
	br_if   	0, $pop1        # 0: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push25=, $2
	br_if   	2, $pop25       # 2: down to label1
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 8
	i32.add 	$push18=, $4, $pop17
	copy_local	$3=, $pop18
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load	$push9=, 0($3)
	i32.const	$push23=, 1
	i32.add 	$push10=, $pop9, $pop23
	i32.store	$drop=, 0($3), $pop10
	i32.const	$push22=, -1
	i32.add 	$2=, $2, $pop22
	br      	0               # 0: up to label0
.LBB1_5:                                # %for.end
	end_loop                        # label1:
	block
	i32.load	$push4=, 12($4)
	i32.const	$push3=, 1
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label3
# BB#6:                                 # %for.end
	i32.load	$push2=, 8($4)
	i32.const	$push6=, 7
	i32.ne  	$push7=, $pop2, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#7:                                 # %if.end7
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB1_8:                                # %if.then6
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
