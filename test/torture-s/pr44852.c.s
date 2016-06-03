	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44852.c"
	.section	.text.sf,"ax",@progbits
	.hidden	sf
	.globl	sf
	.type	sf,@function
sf:                                     # @sf
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	copy_local	$push15=, $0
	tee_local	$push14=, $2=, $pop15
	i32.const	$push13=, -1
	i32.add 	$push12=, $pop14, $pop13
	tee_local	$push11=, $0=, $pop12
	i32.load8_u	$push10=, 0($pop11)
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 57
	i32.ne  	$push0=, $pop9, $pop8
	br_if   	2, $pop0        # 2: down to label0
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.ne  	$push3=, $1, $0
	br_if   	0, $pop3        # 0: up to label1
# BB#3:                                 # %if.then
	end_loop                        # label2:
	i32.const	$push4=, 48
	i32.store8	$drop=, 0($1), $pop4
	i32.const	$push6=, 49
	i32.store8	$drop=, 0($1), $pop6
	return  	$2
.LBB0_4:                                # %while.end.loopexit
	end_block                       # label0:
	i32.const	$push1=, -1
	i32.add 	$push7=, $2, $pop1
	i32.const	$push2=, 1
	i32.add 	$push5=, $3, $pop2
	i32.store8	$drop=, 0($pop7), $pop5
	copy_local	$push16=, $2
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end0:
	.size	sf, .Lfunc_end0-sf

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push32=, $pop18, $pop19
	i32.store	$push36=, __stack_pointer($pop20), $pop32
	tee_local	$push35=, $0=, $pop36
	i32.const	$push2=, 14
	i32.add 	$push3=, $pop35, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.s+6($pop0)
	i32.store8	$drop=, 0($pop3), $pop1
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.const	$push34=, 0
	i32.load16_u	$push4=, .Lmain.s+4($pop34):p2align=0
	i32.store16	$drop=, 0($pop6), $pop4
	i32.const	$push33=, 0
	i32.load	$push7=, .Lmain.s($pop33):p2align=0
	i32.store	$drop=, 8($0), $pop7
	block
	i32.const	$push26=, 8
	i32.add 	$push27=, $0, $pop26
	i32.const	$push10=, 2
	i32.or  	$push11=, $pop27, $pop10
	i32.const	$push28=, 8
	i32.add 	$push29=, $0, $pop28
	i32.call	$push12=, sf@FUNCTION, $pop11, $pop29
	i32.const	$push24=, 8
	i32.add 	$push25=, $0, $pop24
	i32.const	$push8=, 1
	i32.or  	$push9=, $pop25, $pop8
	i32.ne  	$push13=, $pop12, $pop9
	br_if   	0, $pop13       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.const	$push30=, 8
	i32.add 	$push31=, $0, $pop30
	i32.const	$push14=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $pop31, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.store	$drop=, __stack_pointer($pop23), $pop22
	i32.const	$push16=, 0
	return  	$pop16
.LBB1_3:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.s:
	.asciz	"999999"
	.size	.Lmain.s, 7

	.type	.L.str,@object          # @.str
.L.str:
	.asciz	"199999"
	.size	.L.str, 7


	.ident	"clang version 3.9.0 "
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
