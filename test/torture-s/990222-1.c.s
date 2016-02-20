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
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load8_u	$push0=, line+2($pop25)
	i32.const	$push24=, 1
	i32.add 	$push23=, $pop0, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.store8	$discard=, line+2($pop26), $pop22
	block
	i32.const	$push21=, 24
	i32.shl 	$push1=, $1, $pop21
	i32.const	$push20=, 24
	i32.shr_s	$push19=, $pop1, $pop20
	tee_local	$push18=, $1=, $pop19
	i32.const	$push2=, 58
	i32.lt_s	$push3=, $pop18, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$0=, 0($1)
	i32.const	$push35=, 1
	i32.add 	$push4=, $1, $pop35
	i32.const	$push34=, 48
	i32.store8	$discard=, 0($pop4), $pop34
	i32.const	$push33=, 1
	i32.add 	$push32=, $0, $pop33
	tee_local	$push31=, $0=, $pop32
	i32.store8	$discard=, 0($1), $pop31
	i32.const	$push30=, -1
	i32.add 	$1=, $1, $pop30
	i32.const	$push29=, 24
	i32.shl 	$push5=, $0, $pop29
	i32.const	$push28=, 24
	i32.shr_s	$push6=, $pop5, $pop28
	i32.const	$push27=, 57
	i32.gt_s	$push7=, $pop6, $pop27
	br_if   	0, $pop7        # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.const	$push8=, 0
	i32.load8_u	$1=, line+2($pop8)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block
	i32.const	$push36=, 0
	i32.load8_u	$push10=, line($pop36)
	i32.const	$push11=, 50
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label3
# BB#5:                                 # %while.end
	i32.const	$push39=, 0
	i32.load8_u	$push9=, line+1($pop39)
	i32.const	$push38=, 255
	i32.and 	$push13=, $pop9, $pop38
	i32.const	$push37=, 48
	i32.ne  	$push14=, $pop13, $pop37
	br_if   	0, $pop14       # 0: down to label3
# BB#6:                                 # %while.end
	i32.const	$push41=, 255
	i32.and 	$push15=, $1, $pop41
	i32.const	$push40=, 48
	i32.ne  	$push16=, $pop15, $pop40
	br_if   	0, $pop16       # 0: down to label3
# BB#7:                                 # %if.end
	i32.const	$push17=, 0
	return  	$pop17
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
