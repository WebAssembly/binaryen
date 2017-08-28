	.text
	.file	"980707-1.c"
	.section	.text.buildargv,"ax",@progbits
	.hidden	buildargv               # -- Begin function buildargv
	.globl	buildargv
	.type	buildargv,@function
buildargv:                              # @buildargv
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
.LBB0_1:                                # %while.cond1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop    	                # label0:
	block   	
	i32.load8_u	$push16=, 0($0)
	tee_local	$push15=, $2=, $pop16
	i32.const	$push14=, 32
	i32.ne  	$push1=, $pop15, $pop14
	br_if   	0, $pop1        # 0: down to label1
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 1
	i32.add 	$0=, $0, $pop13
	br      	1               # 1: up to label0
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	block   	
	i32.eqz 	$push30=, $2
	br_if   	0, $pop30       # 0: down to label2
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push18=, 2
	i32.shl 	$push2=, $3, $pop18
	i32.const	$push17=, buildargv.arglist
	i32.add 	$push3=, $pop2, $pop17
	i32.store	0($pop3), $0
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	i32.load8_u	$2=, 0($0)
	i32.const	$push24=, 1
	i32.add 	$push23=, $0, $pop24
	tee_local	$push22=, $1=, $pop23
	copy_local	$0=, $pop22
	i32.const	$push21=, 32
	i32.or  	$push4=, $2, $pop21
	i32.const	$push20=, 255
	i32.and 	$push5=, $pop4, $pop20
	i32.const	$push19=, 32
	i32.ne  	$push6=, $pop5, $pop19
	br_if   	0, $pop6        # 0: up to label3
# BB#6:                                 # %while.end16
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push26=, 1
	i32.add 	$3=, $3, $pop26
	i32.const	$push25=, 255
	i32.and 	$push7=, $2, $pop25
	i32.eqz 	$push31=, $pop7
	br_if   	0, $pop31       # 0: down to label2
# BB#7:                                 # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push28=, -1
	i32.add 	$push0=, $1, $pop28
	i32.const	$push27=, 0
	i32.store8	0($pop0), $pop27
	copy_local	$0=, $1
	br      	1               # 1: up to label0
.LBB0_8:                                # %while.end23
	end_block                       # label2:
	end_loop
	i32.const	$push8=, 2
	i32.shl 	$push9=, $3, $pop8
	i32.const	$push10=, buildargv.arglist
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push12=, 0
	i32.store	0($pop11), $pop12
	i32.const	$push29=, buildargv.arglist
                                        # fallthrough-return: $pop29
	.endfunc
.Lfunc_end0:
	.size	buildargv, .Lfunc_end0-buildargv
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, __stack_pointer($pop22)
	i32.const	$push23=, 256
	i32.sub 	$push28=, $pop21, $pop23
	tee_local	$push27=, $3=, $pop28
	i32.store	__stack_pointer($pop24), $pop27
	i32.const	$push26=, 0
	i32.load8_u	$push1=, .L.str+4($pop26)
	i32.store8	4($3), $pop1
	i32.const	$push25=, 0
	i32.load	$push2=, .L.str($pop25):p2align=0
	i32.store	0($3), $pop2
	copy_local	$3=, $3
	i32.const	$2=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_4 Depth 2
	block   	
	loop    	                # label5:
	block   	
	i32.load8_u	$push33=, 0($3)
	tee_local	$push32=, $0=, $pop33
	i32.const	$push31=, 32
	i32.eq  	$push3=, $pop32, $pop31
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push50=, $0
	br_if   	2, $pop50       # 2: down to label4
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push35=, 2
	i32.shl 	$push4=, $2, $pop35
	i32.const	$push34=, buildargv.arglist
	i32.add 	$push5=, $pop4, $pop34
	i32.store	0($pop5), $3
.LBB1_4:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label7:
	i32.load8_u	$0=, 0($3)
	i32.const	$push41=, 1
	i32.add 	$push40=, $3, $pop41
	tee_local	$push39=, $1=, $pop40
	copy_local	$3=, $pop39
	i32.const	$push38=, 32
	i32.or  	$push6=, $0, $pop38
	i32.const	$push37=, 255
	i32.and 	$push7=, $pop6, $pop37
	i32.const	$push36=, 32
	i32.ne  	$push8=, $pop7, $pop36
	br_if   	0, $pop8        # 0: up to label7
# BB#5:                                 # %while.end16.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	i32.const	$push43=, 1
	i32.add 	$2=, $2, $pop43
	i32.const	$push42=, 255
	i32.and 	$push9=, $0, $pop42
	i32.eqz 	$push51=, $pop9
	br_if   	2, $pop51       # 2: down to label4
# BB#6:                                 # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, -1
	i32.add 	$push0=, $1, $pop30
	i32.const	$push29=, 0
	i32.store8	0($pop0), $pop29
	copy_local	$3=, $1
	br      	1               # 1: up to label5
.LBB1_7:                                # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push44=, 1
	i32.add 	$3=, $3, $pop44
	br      	0               # 0: up to label5
.LBB1_8:                                # %buildargv.exit
	end_loop
	end_block                       # label4:
	i32.const	$push10=, 2
	i32.shl 	$push11=, $2, $pop10
	i32.const	$push12=, buildargv.arglist
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push46=, 0
	i32.store	0($pop13), $pop46
	block   	
	i32.const	$push45=, 0
	i32.load	$push14=, buildargv.arglist($pop45)
	i32.const	$push15=, .L.str.1
	i32.call	$push16=, strcmp@FUNCTION, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label8
# BB#9:                                 # %if.end
	i32.const	$push47=, 0
	i32.load	$push17=, buildargv.arglist+4($pop47)
	i32.const	$push18=, .L.str.2
	i32.call	$push19=, strcmp@FUNCTION, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label8
# BB#10:                                # %if.end8
	i32.const	$push48=, 0
	i32.load	$push20=, buildargv.arglist+8($pop48)
	br_if   	0, $pop20       # 0: down to label8
# BB#11:                                # %if.end11
	i32.const	$push49=, 0
	call    	exit@FUNCTION, $pop49
	unreachable
.LBB1_12:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
