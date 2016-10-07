	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load8_u	$push0=, line+2($pop26)
	i32.const	$push25=, 1
	i32.add 	$push24=, $pop0, $pop25
	tee_local	$push23=, $1=, $pop24
	i32.store8	line+2($pop27), $pop23
	block   	
	i32.const	$push22=, 24
	i32.shl 	$push1=, $1, $pop22
	i32.const	$push21=, 24
	i32.shr_s	$push20=, $pop1, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.const	$push2=, 58
	i32.lt_s	$push3=, $pop19, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push36=, 1
	i32.add 	$push4=, $1, $pop36
	i32.const	$push35=, 48
	i32.store8	0($pop4), $pop35
	i32.load8_u	$push5=, 0($1)
	i32.const	$push34=, 1
	i32.add 	$push33=, $pop5, $pop34
	tee_local	$push32=, $0=, $pop33
	i32.store8	0($1), $pop32
	i32.const	$push31=, -1
	i32.add 	$1=, $1, $pop31
	i32.const	$push30=, 24
	i32.shl 	$push6=, $0, $pop30
	i32.const	$push29=, 24
	i32.shr_s	$push7=, $pop6, $pop29
	i32.const	$push28=, 57
	i32.gt_s	$push8=, $pop7, $pop28
	br_if   	0, $pop8        # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.const	$push9=, 0
	i32.load8_u	$1=, line+2($pop9)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block   	
	i32.const	$push37=, 0
	i32.load8_u	$push11=, line($pop37)
	i32.const	$push12=, 50
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label2
# BB#5:                                 # %while.end
	i32.const	$push40=, 0
	i32.load8_u	$push10=, line+1($pop40)
	i32.const	$push39=, 255
	i32.and 	$push14=, $pop10, $pop39
	i32.const	$push38=, 48
	i32.ne  	$push15=, $pop14, $pop38
	br_if   	0, $pop15       # 0: down to label2
# BB#6:                                 # %while.end
	i32.const	$push42=, 255
	i32.and 	$push16=, $1, $pop42
	i32.const	$push41=, 48
	i32.ne  	$push17=, $pop16, $pop41
	br_if   	0, $pop17       # 0: down to label2
# BB#7:                                 # %if.end
	i32.const	$push18=, 0
	return  	$pop18
.LBB0_8:                                # %if.then
	end_block                       # label2:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
