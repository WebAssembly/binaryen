	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030717-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load16_u	$2=, 0($1):p2align=2
	i32.load	$push26=, 4($1)
	tee_local	$push25=, $7=, $pop26
	i32.load	$push24=, 24($0)
	tee_local	$push23=, $6=, $pop24
	i32.const	$push22=, 20
	i32.mul 	$push0=, $pop23, $pop22
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 12($pop1)
	i32.sub 	$1=, $pop25, $pop2
	i32.const	$push21=, 31
	i32.shr_s	$push20=, $1, $pop21
	tee_local	$push19=, $4=, $pop20
	i32.add 	$push3=, $1, $pop19
	i32.xor 	$3=, $pop3, $4
	copy_local	$1=, $6
	copy_local	$5=, $6
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push27=, 0
	i32.gt_s	$push4=, $1, $pop27
	br_if   	0, $pop4        # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push28=, 20
	i32.add 	$push5=, $0, $pop28
	i32.load	$1=, 0($pop5)
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push33=, -1
	i32.add 	$1=, $1, $pop33
	i32.const	$push32=, 20
	i32.mul 	$push6=, $1, $pop32
	i32.add 	$push7=, $0, $pop6
	i32.load	$push8=, 12($pop7)
	i32.sub 	$4=, $7, $pop8
	i32.const	$push31=, 31
	i32.shr_s	$push30=, $4, $pop31
	tee_local	$push29=, $8=, $pop30
	i32.add 	$push9=, $4, $pop29
	i32.xor 	$push10=, $pop9, $8
	i32.lt_u	$push11=, $pop10, $3
	i32.select	$5=, $1, $5, $pop11
	i32.ne  	$push12=, $1, $6
	br_if   	0, $pop12       # 0: up to label0
# BB#4:                                 # %do.end
	end_loop                        # label1:
	i32.const	$push16=, 20
	i32.mul 	$push17=, $5, $pop16
	i32.add 	$push18=, $0, $pop17
	i32.const	$push13=, 9
	i32.shr_u	$push14=, $2, $pop13
	i32.add 	$push15=, $pop14, $7
	i32.store	$discard=, 12($pop18), $pop15
	return  	$5
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bar.exit
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
