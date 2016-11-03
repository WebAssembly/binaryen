	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980707-1.c"
	.section	.text.buildargv,"ax",@progbits
	.hidden	buildargv
	.globl	buildargv
	.type	buildargv,@function
buildargv:                              # @buildargv
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB0_1:                                # %while.cond1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop    	                # label0:
	block   	
	i32.load8_u	$push12=, 0($0)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 32
	i32.ne  	$push0=, $pop11, $pop10
	br_if   	0, $pop0        # 0: down to label1
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	br      	1               # 1: up to label0
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	block   	
	i32.eqz 	$push27=, $1
	br_if   	0, $pop27       # 0: down to label2
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 2
	i32.shl 	$push1=, $2, $pop17
	i32.const	$push16=, buildargv.arglist
	i32.add 	$push2=, $pop1, $pop16
	i32.store	0($pop2), $0
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
	i32.load8_u	$push14=, 0($0)
	tee_local	$push13=, $1=, $pop14
	i32.eqz 	$push28=, $pop13
	br_if   	0, $pop28       # 0: down to label2
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label4:
	i32.const	$push23=, 32
	i32.eq  	$push3=, $1, $pop23
	br_if   	1, $pop3        # 1: down to label3
# BB#6:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push22=, 1
	i32.add 	$push21=, $0, $pop22
	tee_local	$push20=, $0=, $pop21
	i32.load8_u	$push19=, 0($pop20)
	tee_local	$push18=, $1=, $pop19
	i32.eqz 	$push29=, $pop18
	br_if   	2, $pop29       # 2: down to label2
	br      	0               # 0: up to label4
.LBB0_7:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push25=, 0
	i32.store8	0($0), $pop25
	i32.const	$push24=, 1
	i32.add 	$0=, $0, $pop24
	br      	1               # 1: up to label0
.LBB0_8:                                # %while.end23
	end_block                       # label2:
	end_loop
	i32.const	$push4=, 2
	i32.shl 	$push5=, $2, $pop4
	i32.const	$push6=, buildargv.arglist
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, 0
	i32.store	0($pop7), $pop8
	i32.const	$push26=, buildargv.arglist
                                        # fallthrough-return: $pop26
	.endfunc
.Lfunc_end0:
	.size	buildargv, .Lfunc_end0-buildargv

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 256
	i32.sub 	$push24=, $pop18, $pop19
	tee_local	$push23=, $0=, $pop24
	i32.store	__stack_pointer($pop20), $pop23
	i32.const	$push22=, 0
	i32.load8_u	$push0=, .L.str+4($pop22)
	i32.store8	4($0), $pop0
	i32.const	$push21=, 0
	i32.load	$push1=, .L.str($pop21):p2align=0
	i32.store	0($0), $pop1
	copy_local	$0=, $0
	i32.const	$2=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	loop    	                # label5:
	block   	
	i32.load8_u	$push28=, 0($0)
	tee_local	$push27=, $1=, $pop28
	i32.const	$push26=, 32
	i32.ne  	$push2=, $pop27, $pop26
	br_if   	0, $pop2        # 0: down to label6
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push25=, 1
	i32.add 	$0=, $0, $pop25
	br      	1               # 1: up to label5
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	block   	
	i32.eqz 	$push43=, $1
	br_if   	0, $pop43       # 0: down to label7
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push31=, 2
	i32.shl 	$push3=, $2, $pop31
	i32.const	$push30=, buildargv.arglist
	i32.add 	$push4=, $pop3, $pop30
	i32.store	0($pop4), $0
	i32.const	$push29=, 1
	i32.add 	$2=, $2, $pop29
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label9:
	i32.load8_u	$push35=, 0($0)
	tee_local	$push34=, $1=, $pop35
	i32.const	$push33=, 32
	i32.eq  	$push5=, $pop34, $pop33
	br_if   	1, $pop5        # 1: down to label8
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.eqz 	$push44=, $1
	br_if   	2, $pop44       # 2: down to label7
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push32=, 1
	i32.add 	$0=, $0, $pop32
	br      	0               # 0: up to label9
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	end_block                       # label8:
	i32.const	$push37=, 0
	i32.store8	0($0), $pop37
	i32.const	$push36=, 1
	i32.add 	$0=, $0, $pop36
	br      	1               # 1: up to label5
.LBB1_9:                                # %buildargv.exit
	end_block                       # label7:
	end_loop
	i32.const	$push6=, 2
	i32.shl 	$push7=, $2, $pop6
	i32.const	$push8=, buildargv.arglist
	i32.add 	$push9=, $pop7, $pop8
	i32.const	$push39=, 0
	i32.store	0($pop9), $pop39
	block   	
	i32.const	$push38=, 0
	i32.load	$push10=, buildargv.arglist($pop38)
	i32.const	$push11=, .L.str.1
	i32.call	$push12=, strcmp@FUNCTION, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label10
# BB#10:                                # %if.end
	i32.const	$push40=, 0
	i32.load	$push13=, buildargv.arglist+4($pop40)
	i32.const	$push14=, .L.str.2
	i32.call	$push15=, strcmp@FUNCTION, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label10
# BB#11:                                # %if.end8
	i32.const	$push41=, 0
	i32.load	$push16=, buildargv.arglist+8($pop41)
	br_if   	0, $pop16       # 0: down to label10
# BB#12:                                # %if.end11
	i32.const	$push42=, 0
	call    	exit@FUNCTION, $pop42
	unreachable
.LBB1_13:                               # %if.then10
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	buildargv.arglist,@object # @buildargv.arglist
	.section	.bss.buildargv.arglist,"aw",@nobits
	.p2align	4
buildargv.arglist:
	.skip	1024
	.size	buildargv.arglist, 1024

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	" a b"
	.size	.L.str, 5

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"a"
	.size	.L.str.1, 2

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"b"
	.size	.L.str.2, 2


	.ident	"clang version 4.0.0 "
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
