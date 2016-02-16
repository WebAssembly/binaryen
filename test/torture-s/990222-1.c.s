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
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load8_u	$push0=, line+2($pop28)
	i32.const	$push27=, 1
	i32.add 	$push26=, $pop0, $pop27
	tee_local	$push25=, $0=, $pop26
	i32.store8	$discard=, line+2($pop29), $pop25
	i32.const	$1=, line+1
	block
	i32.const	$push24=, 24
	i32.shl 	$push1=, $0, $pop24
	i32.const	$push23=, 24
	i32.shr_s	$push22=, $pop1, $pop23
	tee_local	$push21=, $0=, $pop22
	i32.const	$push2=, 58
	i32.lt_s	$push3=, $pop21, $pop2
	br_if   	0, $pop3        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$0=, 0($1)
	i32.const	$push35=, 1
	i32.add 	$push4=, $1, $pop35
	i32.const	$push5=, 48
	i32.store8	$discard=, 0($pop4), $pop5
	i32.const	$push34=, 1
	i32.add 	$push33=, $0, $pop34
	tee_local	$push32=, $0=, $pop33
	i32.store8	$discard=, 0($1), $pop32
	i32.const	$push10=, -1
	i32.add 	$1=, $1, $pop10
	i32.const	$push31=, 24
	i32.shl 	$push6=, $0, $pop31
	i32.const	$push30=, 24
	i32.shr_s	$push7=, $pop6, $pop30
	i32.const	$push8=, 57
	i32.gt_s	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: up to label1
# BB#2:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.const	$push11=, 0
	i32.load8_u	$0=, line+2($pop11)
.LBB0_3:                                # %while.end
	end_block                       # label0:
	block
	i32.const	$push36=, 0
	i32.load8_u	$push13=, line($pop36)
	i32.const	$push14=, 50
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#4:                                 # %while.end
	i32.const	$push39=, 0
	i32.load8_u	$push12=, line+1($pop39)
	i32.const	$push38=, 255
	i32.and 	$push16=, $pop12, $pop38
	i32.const	$push37=, 48
	i32.ne  	$push17=, $pop16, $pop37
	br_if   	0, $pop17       # 0: down to label3
# BB#5:                                 # %while.end
	i32.const	$push41=, 255
	i32.and 	$push18=, $0, $pop41
	i32.const	$push40=, 48
	i32.ne  	$push19=, $pop18, $pop40
	br_if   	0, $pop19       # 0: down to label3
# BB#6:                                 # %if.end
	i32.const	$push20=, 0
	return  	$pop20
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
