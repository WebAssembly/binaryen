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
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load8_u	$push1=, line+2($pop26)
	i32.const	$push25=, 1
	i32.add 	$push2=, $pop1, $pop25
	i32.store8	$push0=, line+2($pop27), $pop2
	i32.const	$push24=, 24
	i32.shl 	$push3=, $pop0, $pop24
	i32.const	$push23=, 24
	i32.shr_s	$push22=, $pop3, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push4=, 58
	i32.lt_s	$push5=, $pop21, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$0=, 0($1)
	i32.const	$push34=, 1
	i32.add 	$push6=, $1, $pop34
	i32.const	$push33=, 48
	i32.store8	$discard=, 0($pop6), $pop33
	i32.const	$push32=, 1
	i32.add 	$push7=, $0, $pop32
	i32.store8	$0=, 0($1), $pop7
	i32.const	$push31=, -1
	i32.add 	$1=, $1, $pop31
	i32.const	$push30=, 24
	i32.shl 	$push8=, $0, $pop30
	i32.const	$push29=, 24
	i32.shr_s	$push9=, $pop8, $pop29
	i32.const	$push28=, 57
	i32.gt_s	$push10=, $pop9, $pop28
	br_if   	0, $pop10       # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.const	$push11=, 0
	i32.load8_u	$1=, line+2($pop11)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block
	i32.const	$push35=, 0
	i32.load8_u	$push13=, line($pop35)
	i32.const	$push14=, 50
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#5:                                 # %while.end
	i32.const	$push38=, 0
	i32.load8_u	$push12=, line+1($pop38)
	i32.const	$push37=, 255
	i32.and 	$push16=, $pop12, $pop37
	i32.const	$push36=, 48
	i32.ne  	$push17=, $pop16, $pop36
	br_if   	0, $pop17       # 0: down to label3
# BB#6:                                 # %while.end
	i32.const	$push40=, 255
	i32.and 	$push18=, $1, $pop40
	i32.const	$push39=, 48
	i32.ne  	$push19=, $pop18, $pop39
	br_if   	0, $pop19       # 0: down to label3
# BB#7:                                 # %if.end
	i32.const	$push20=, 0
	return  	$pop20
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
