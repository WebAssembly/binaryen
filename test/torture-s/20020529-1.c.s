	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020529-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 8
	i32.add 	$5=, $0, $pop3
	block   	
	i32.const	$push15=, 0
	i32.load	$push14=, f1.beenhere($pop15)
	tee_local	$push13=, $4=, $pop14
	i32.const	$push12=, 2
	i32.ge_s	$push0=, $pop13, $pop12
	br_if   	0, $pop0        # 0: down to label0
.LBB0_1:                                # %f1.exit
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push19=, 1
	i32.eq  	$push2=, $4, $pop19
	br_if   	1, $pop2        # 1: down to label1
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push20=, 1
	i32.add 	$4=, $4, $pop20
	block   	
	br_if   	0, $1           # 0: down to label4
# BB#3:                                 # %if.end3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push21=, 0
	i32.store	f1.beenhere($pop21), $4
	i32.store16	0($5), $3
	i32.load	$push4=, 0($0)
	br_if   	1, $pop4        # 1: down to label3
# BB#4:                                 # %if.end8
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	1, $2           # 1: down to label3
# BB#5:                                 # %for.cond.outer.backedge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 16
	i32.shl 	$push5=, $3, $pop17
	i32.const	$push16=, 16
	i32.shr_s	$3=, $pop5, $pop16
.LBB0_6:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push18=, 2
	i32.ge_s	$push1=, $4, $pop18
	br_if   	3, $pop1        # 3: down to label0
	br      	1               # 1: up to label2
.LBB0_7:                                # %if.then10
	end_block                       # label3:
	end_loop
	call    	f2@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label1:
	i32.const	$push8=, 0
	i32.const	$push6=, 1
	i32.add 	$push7=, $4, $pop6
	i32.store	f1.beenhere($pop8), $pop7
	i32.const	$push22=, 0
	return  	$pop22
.LBB0_9:                                # %if.then.i
	end_block                       # label0:
	i32.const	$push11=, 0
	i32.const	$push9=, 1
	i32.add 	$push10=, $4, $pop9
	i32.store	f1.beenhere($pop11), $pop10
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, f1.beenhere($pop8)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.add 	$push1=, $pop6, $pop5
	i32.store	f1.beenhere($pop0), $pop1
	block   	
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push9=, 1
	i32.eq  	$push4=, $1, $pop9
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push19=, $pop11, $pop12
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop13), $pop18
	i32.const	$2=, 23
	i32.const	$push17=, 23
	i32.store16	8($0), $pop17
	i32.const	$push16=, 0
	i32.store	0($0), $pop16
	i32.const	$push15=, 0
	i32.load	$1=, f1.beenhere($pop15)
	i32.store	4($0), $0
	block   	
	block   	
	i32.const	$push14=, 1
	i32.gt_s	$push0=, $1, $pop14
	br_if   	0, $pop0        # 0: down to label7
# BB#1:                                 # %f1.exit.i.preheader
	i32.const	$push2=, 8
	i32.add 	$0=, $0, $pop2
.LBB3_2:                                # %f1.exit.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label9:
	i32.const	$push20=, 1
	i32.eq  	$push1=, $1, $pop20
	br_if   	1, $pop1        # 1: down to label8
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$2=, 0
	i32.const	$push25=, 0
	i32.store16	0($0), $pop25
	i32.const	$push24=, 1
	i32.add 	$push23=, $1, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.const	$push21=, 1
	i32.le_s	$push3=, $pop22, $pop21
	br_if   	0, $pop3        # 0: up to label9
# BB#4:                                 # %if.then.i.i.loopexit
	end_loop
	i32.const	$push4=, 0
	i32.store	f1.beenhere($pop4), $1
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	br      	2               # 2: down to label6
.LBB3_5:                                # %foo.exit
	end_block                       # label8:
	i32.const	$push27=, 0
	i32.const	$push6=, 1
	i32.add 	$push7=, $1, $pop6
	i32.store	f1.beenhere($pop27), $pop7
	block   	
	i32.const	$push8=, 65535
	i32.and 	$push9=, $2, $pop8
	br_if   	0, $pop9        # 0: down to label10
# BB#6:                                 # %if.end
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB3_7:                                # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB3_8:
	end_block                       # label7:
	i32.const	$push29=, 1
	i32.add 	$1=, $1, $pop29
.LBB3_9:                                # %if.then.i.i
	end_block                       # label6:
	i32.const	$push26=, 0
	i32.store	f1.beenhere($pop26), $1
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	f1.beenhere,@object     # @f1.beenhere
	.section	.bss.f1.beenhere,"aw",@nobits
	.p2align	2
f1.beenhere:
	.int32	0                       # 0x0
	.size	f1.beenhere, 4


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
