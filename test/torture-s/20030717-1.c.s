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
	i32.load	$push1=, 4($1)
	tee_local	$push27=, $7=, $pop1
	i32.load	$push0=, 24($0)
	tee_local	$push26=, $6=, $pop0
	i32.const	$push25=, 20
	i32.mul 	$push2=, $pop26, $pop25
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 12($pop3)
	i32.sub 	$1=, $pop27, $pop4
	i32.const	$push24=, 31
	i32.shr_s	$push5=, $1, $pop24
	tee_local	$push23=, $4=, $pop5
	i32.add 	$push6=, $1, $pop23
	i32.xor 	$3=, $pop6, $4
	copy_local	$1=, $6
	copy_local	$5=, $6
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push28=, 0
	i32.gt_s	$push7=, $1, $pop28
	br_if   	$pop7, 0        # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push29=, 20
	i32.add 	$push8=, $0, $pop29
	i32.load	$1=, 0($pop8)
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push33=, -1
	i32.add 	$1=, $1, $pop33
	i32.const	$push32=, 20
	i32.mul 	$push9=, $1, $pop32
	i32.add 	$push10=, $0, $pop9
	i32.load	$push11=, 12($pop10)
	i32.sub 	$4=, $7, $pop11
	i32.const	$push31=, 31
	i32.shr_s	$push12=, $4, $pop31
	tee_local	$push30=, $8=, $pop12
	i32.add 	$push13=, $4, $pop30
	i32.xor 	$push14=, $pop13, $8
	i32.lt_u	$push15=, $pop14, $3
	i32.select	$5=, $1, $5, $pop15
	i32.ne  	$push16=, $1, $6
	br_if   	$pop16, 0       # 0: up to label0
# BB#4:                                 # %do.end
	end_loop                        # label1:
	i32.const	$push20=, 20
	i32.mul 	$push21=, $5, $pop20
	i32.add 	$push22=, $0, $pop21
	i32.const	$push17=, 9
	i32.shr_u	$push18=, $2, $pop17
	i32.add 	$push19=, $pop18, $7
	i32.store	$discard=, 12($pop22), $pop19
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
