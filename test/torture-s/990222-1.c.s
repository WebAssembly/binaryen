	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load8_u	$push1=, line+2($pop27)
	i32.const	$push26=, 1
	i32.add 	$push2=, $pop1, $pop26
	i32.store8	$push0=, line+2($pop28), $pop2
	i32.const	$push25=, 24
	i32.shl 	$push3=, $pop0, $pop25
	i32.const	$push24=, 24
	i32.shr_s	$push23=, $pop3, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.const	$push4=, 58
	i32.lt_s	$push5=, $pop22, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push35=, 1
	i32.add 	$push6=, $1, $pop35
	i32.const	$push34=, 48
	i32.store8	$drop=, 0($pop6), $pop34
	i32.load8_u	$push7=, 0($1)
	i32.const	$push33=, 1
	i32.add 	$push8=, $pop7, $pop33
	i32.store8	$0=, 0($1), $pop8
	i32.const	$push32=, -1
	i32.add 	$1=, $1, $pop32
	i32.const	$push31=, 24
	i32.shl 	$push9=, $0, $pop31
	i32.const	$push30=, 24
	i32.shr_s	$push10=, $pop9, $pop30
	i32.const	$push29=, 57
	i32.gt_s	$push11=, $pop10, $pop29
	br_if   	0, $pop11       # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.const	$push12=, 0
	i32.load8_u	$1=, line+2($pop12)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block
	i32.const	$push36=, 0
	i32.load8_u	$push14=, line($pop36)
	i32.const	$push15=, 50
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label3
# BB#5:                                 # %while.end
	i32.const	$push39=, 0
	i32.load8_u	$push13=, line+1($pop39)
	i32.const	$push38=, 255
	i32.and 	$push17=, $pop13, $pop38
	i32.const	$push37=, 48
	i32.ne  	$push18=, $pop17, $pop37
	br_if   	0, $pop18       # 0: down to label3
# BB#6:                                 # %while.end
	i32.const	$push41=, 255
	i32.and 	$push19=, $1, $pop41
	i32.const	$push40=, 48
	i32.ne  	$push20=, $pop19, $pop40
	br_if   	0, $pop20       # 0: down to label3
# BB#7:                                 # %if.end
	i32.const	$push21=, 0
	return  	$pop21
.LBB0_8:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	line                    # @line
	.type	line,@object
	.section	.data.line,"aw",@progbits
	.globl	line
line:
	.asciz	"199"
	.size	line, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
