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
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load8_u	$push0=, line+2($pop29)
	i32.const	$push28=, 1
	i32.add 	$push1=, $pop0, $pop28
	tee_local	$push27=, $0=, $pop1
	i32.store8	$discard=, line+2($pop30), $pop27
	i32.const	$1=, line+1
	block
	i32.const	$push26=, 24
	i32.shl 	$push2=, $0, $pop26
	i32.const	$push25=, 24
	i32.shr_s	$push23=, $pop2, $pop25
	tee_local	$push24=, $0=, $pop23
	i32.const	$push3=, 58
	i32.lt_s	$push4=, $pop24, $pop3
	br_if   	0, $pop4        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$0=, 0($1)
	i32.const	$push35=, 1
	i32.add 	$push5=, $1, $pop35
	i32.const	$push6=, 48
	i32.store8	$discard=, 0($pop5), $pop6
	i32.const	$push34=, 1
	i32.add 	$push7=, $0, $pop34
	tee_local	$push33=, $0=, $pop7
	i32.store8	$discard=, 0($1), $pop33
	i32.const	$push12=, -1
	i32.add 	$1=, $1, $pop12
	i32.const	$push32=, 24
	i32.shl 	$push8=, $0, $pop32
	i32.const	$push31=, 24
	i32.shr_s	$push9=, $pop8, $pop31
	i32.const	$push10=, 57
	i32.gt_s	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: up to label1
# BB#2:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.const	$push13=, 0
	i32.load8_u	$0=, line+2($pop13)
.LBB0_3:                                # %while.end
	end_block                       # label0:
	block
	i32.const	$push36=, 0
	i32.load8_u	$push15=, line($pop36)
	i32.const	$push16=, 50
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label3
# BB#4:                                 # %while.end
	i32.const	$push39=, 0
	i32.load8_u	$push14=, line+1($pop39)
	i32.const	$push38=, 255
	i32.and 	$push18=, $pop14, $pop38
	i32.const	$push37=, 48
	i32.ne  	$push19=, $pop18, $pop37
	br_if   	0, $pop19       # 0: down to label3
# BB#5:                                 # %while.end
	i32.const	$push41=, 255
	i32.and 	$push20=, $0, $pop41
	i32.const	$push40=, 48
	i32.ne  	$push21=, $pop20, $pop40
	br_if   	0, $pop21       # 0: down to label3
# BB#6:                                 # %if.end
	i32.const	$push22=, 0
	return  	$pop22
.LBB0_7:                                # %if.then
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
