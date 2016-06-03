	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020529-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.load	$4=, f1.beenhere($pop11)
	i32.const	$push2=, 8
	i32.add 	$5=, $0, $pop2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label2:
	i32.const	$push14=, 2
	i32.ge_s	$push0=, $4, $pop14
	br_if   	3, $pop0        # 3: down to label0
# BB#2:                                 # %f1.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push15=, 1
	i32.eq  	$push1=, $4, $pop15
	br_if   	2, $pop1        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$4=, $4, $pop16
	br_if   	0, $1           # 0: up to label2
# BB#4:                                 # %if.end3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 0
	i32.store	$drop=, f1.beenhere($pop17), $4
	i32.store16	$drop=, 0($5), $3
	i32.load	$push3=, 0($0)
	br_if   	1, $pop3        # 1: down to label3
# BB#5:                                 # %if.end8
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	1, $2           # 1: down to label3
# BB#6:                                 # %for.cond.outer.backedge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 16
	i32.shl 	$push4=, $3, $pop13
	i32.const	$push12=, 16
	i32.shr_s	$3=, $pop4, $pop12
	br      	0               # 0: up to label2
.LBB0_7:                                # %if.then10
	end_loop                        # label3:
	call    	f2@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label1:
	i32.const	$push7=, 0
	i32.const	$push5=, 1
	i32.add 	$push6=, $4, $pop5
	i32.store	$drop=, f1.beenhere($pop7), $pop6
	i32.const	$push18=, 0
	return  	$pop18
.LBB0_9:                                # %if.then.i
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.const	$push8=, 1
	i32.add 	$push9=, $4, $pop8
	i32.store	$drop=, f1.beenhere($pop10), $pop9
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
	i32.store	$drop=, f1.beenhere($pop0), $pop1
	block
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push9=, 1
	i32.eq  	$push4=, $1, $pop9
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label4:
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 23
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push16=, $pop13, $pop14
	i32.store	$push22=, __stack_pointer($pop15), $pop16
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 23
	i32.store16	$drop=, 8($pop21), $pop20
	i32.const	$push1=, 0
	i32.store	$push19=, 0($1), $pop1
	tee_local	$push18=, $0=, $pop19
	i32.load	$2=, f1.beenhere($pop18)
	i32.store	$drop=, 4($1), $1
	block
	block
	i32.const	$push17=, 1
	i32.gt_s	$push2=, $2, $pop17
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %f1.exit.i.preheader
	i32.const	$push4=, 8
	i32.add 	$1=, $1, $pop4
.LBB3_2:                                # %f1.exit.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	i32.const	$push23=, 1
	i32.eq  	$push3=, $2, $pop23
	br_if   	2, $pop3        # 2: down to label7
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$3=, 0
	i32.const	$push28=, 0
	i32.store16	$drop=, 0($1), $pop28
	i32.const	$push27=, 1
	i32.add 	$push26=, $2, $pop27
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 1
	i32.le_s	$push5=, $pop25, $pop24
	br_if   	0, $pop5        # 0: up to label8
# BB#4:                                 # %if.then.i.i.loopexit
	end_loop                        # label9:
	i32.const	$push6=, 0
	i32.store	$push0=, f1.beenhere($pop6), $2
	i32.const	$push7=, 1
	i32.add 	$2=, $pop0, $pop7
	br      	2               # 2: down to label5
.LBB3_5:                                # %foo.exit
	end_block                       # label7:
	i32.const	$push29=, 0
	i32.const	$push8=, 1
	i32.add 	$push9=, $2, $pop8
	i32.store	$drop=, f1.beenhere($pop29), $pop9
	block
	i32.const	$push10=, 65535
	i32.and 	$push11=, $3, $pop10
	br_if   	0, $pop11       # 0: down to label10
# BB#6:                                 # %if.end
	i32.const	$push30=, 0
	call    	exit@FUNCTION, $pop30
	unreachable
.LBB3_7:                                # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB3_8:
	end_block                       # label6:
	i32.const	$push31=, 1
	i32.add 	$2=, $2, $pop31
.LBB3_9:                                # %if.then.i.i
	end_block                       # label5:
	i32.store	$drop=, f1.beenhere($0), $2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	f1.beenhere,@object     # @f1.beenhere
	.lcomm	f1.beenhere,4,2

	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
