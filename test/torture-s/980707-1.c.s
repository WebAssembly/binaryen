	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980707-1.c"
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
	loop                            # label0:
	block
	i32.load8_u	$push10=, 0($0)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 32
	i32.ne  	$push0=, $pop9, $pop8
	br_if   	0, $pop0        # 0: down to label2
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push7=, 1
	i32.add 	$0=, $0, $pop7
	br      	1               # 1: up to label0
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.eqz 	$push19=, $1
	br_if   	1, $pop19       # 1: down to label1
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 2
	i32.shl 	$push1=, $2, $pop12
	i32.store	$drop=, buildargv.arglist($pop1), $0
	i32.const	$push11=, 1
	i32.add 	$2=, $2, $pop11
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.load8_u	$push15=, 0($0)
	tee_local	$push14=, $1=, $pop15
	i32.eqz 	$push20=, $pop14
	br_if   	3, $pop20       # 3: down to label1
# BB#6:                                 # %while.cond7
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push16=, 32
	i32.eq  	$push2=, $1, $pop16
	br_if   	1, $pop2        # 1: down to label4
# BB#7:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push13=, 1
	i32.add 	$0=, $0, $pop13
	br      	0               # 0: up to label3
.LBB0_8:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push18=, 0
	i32.store8	$drop=, 0($0), $pop18
	i32.const	$push17=, 1
	i32.add 	$0=, $0, $pop17
	br      	0               # 0: up to label0
.LBB0_9:                                # %while.end23
	end_loop                        # label1:
	i32.const	$push3=, 2
	i32.shl 	$push4=, $2, $pop3
	i32.const	$push5=, 0
	i32.store	$drop=, buildargv.arglist($pop4), $pop5
	i32.const	$push6=, buildargv.arglist
                                        # fallthrough-return: $pop6
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
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 256
	i32.sub 	$push19=, $pop16, $pop17
	i32.store	$push23=, __stack_pointer($pop18), $pop19
	tee_local	$push22=, $0=, $pop23
	i32.const	$push21=, 0
	i32.load8_u	$push0=, .L.str+4($pop21)
	i32.store8	$drop=, 4($pop22), $pop0
	i32.const	$push20=, 0
	i32.load	$push1=, .L.str($pop20):p2align=0
	i32.store	$drop=, 0($0), $pop1
	copy_local	$0=, $0
	i32.const	$2=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	loop                            # label5:
	block
	i32.load8_u	$push27=, 0($0)
	tee_local	$push26=, $1=, $pop27
	i32.const	$push25=, 32
	i32.ne  	$push2=, $pop26, $pop25
	br_if   	0, $pop2        # 0: down to label7
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 1
	i32.add 	$0=, $0, $pop24
	br      	1               # 1: up to label5
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.eqz 	$push40=, $1
	br_if   	1, $pop40       # 1: down to label6
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push29=, 2
	i32.shl 	$push3=, $2, $pop29
	i32.store	$drop=, buildargv.arglist($pop3), $0
	i32.const	$push28=, 1
	i32.add 	$2=, $2, $pop28
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.load8_u	$push33=, 0($0)
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 32
	i32.eq  	$push4=, $pop32, $pop31
	br_if   	1, $pop4        # 1: down to label9
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.eqz 	$push41=, $1
	br_if   	3, $pop41       # 3: down to label6
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push30=, 1
	i32.add 	$0=, $0, $pop30
	br      	0               # 0: up to label8
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.const	$push35=, 0
	i32.store8	$drop=, 0($0), $pop35
	i32.const	$push34=, 1
	i32.add 	$0=, $0, $pop34
	br      	0               # 0: up to label5
.LBB1_9:                                # %buildargv.exit
	end_loop                        # label6:
	block
	i32.const	$push5=, 2
	i32.shl 	$push6=, $2, $pop5
	i32.const	$push7=, 0
	i32.store	$push37=, buildargv.arglist($pop6), $pop7
	tee_local	$push36=, $0=, $pop37
	i32.load	$push8=, buildargv.arglist($pop36)
	i32.const	$push9=, .L.str.1
	i32.call	$push10=, strcmp@FUNCTION, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label10
# BB#10:                                # %if.end
	i32.load	$push11=, buildargv.arglist+4($0)
	i32.const	$push12=, .L.str.2
	i32.call	$push13=, strcmp@FUNCTION, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label10
# BB#11:                                # %if.end8
	i32.const	$push38=, 0
	i32.load	$push14=, buildargv.arglist+8($pop38)
	br_if   	0, $pop14       # 0: down to label10
# BB#12:                                # %if.end11
	i32.const	$push39=, 0
	call    	exit@FUNCTION, $pop39
	unreachable
.LBB1_13:                               # %if.then10
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	buildargv.arglist,@object # @buildargv.arglist
	.lcomm	buildargv.arglist,1024,4
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


	.ident	"clang version 3.9.0 "
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
