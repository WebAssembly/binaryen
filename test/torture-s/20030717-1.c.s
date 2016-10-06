	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030717-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push28=, 4($1)
	tee_local	$push27=, $4=, $pop28
	i32.load	$push26=, 24($0)
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 20
	i32.mul 	$push0=, $pop25, $pop24
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 12($pop1)
	i32.sub 	$push23=, $pop27, $pop2
	tee_local	$push22=, $7=, $pop23
	i32.const	$push21=, 31
	i32.shr_s	$push20=, $7, $pop21
	tee_local	$push19=, $7=, $pop20
	i32.add 	$push3=, $pop22, $pop19
	i32.xor 	$5=, $pop3, $7
	i32.load16_u	$3=, 0($1)
	copy_local	$1=, $2
	copy_local	$7=, $2
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.const	$push29=, 0
	i32.gt_s	$push4=, $1, $pop29
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push30=, 20
	i32.add 	$push5=, $0, $pop30
	i32.load	$1=, 0($pop5)
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push39=, -1
	i32.add 	$push38=, $1, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 20
	i32.mul 	$push6=, $1, $pop36
	i32.add 	$push7=, $0, $pop6
	i32.load	$push8=, 12($pop7)
	i32.sub 	$push35=, $4, $pop8
	tee_local	$push34=, $6=, $pop35
	i32.const	$push33=, 31
	i32.shr_s	$push32=, $6, $pop33
	tee_local	$push31=, $6=, $pop32
	i32.add 	$push9=, $pop34, $pop31
	i32.xor 	$push10=, $pop9, $6
	i32.lt_u	$push11=, $pop10, $5
	i32.select	$7=, $pop37, $7, $pop11
	i32.ne  	$push12=, $1, $2
	br_if   	0, $pop12       # 0: up to label0
# BB#4:                                 # %do.end
	end_loop
	i32.const	$push16=, 20
	i32.mul 	$push17=, $7, $pop16
	i32.add 	$push18=, $0, $pop17
	i32.const	$push13=, 9
	i32.shr_u	$push14=, $3, $pop13
	i32.add 	$push15=, $pop14, $4
	i32.store	12($pop18), $pop15
	copy_local	$push40=, $7
                                        # fallthrough-return: $pop40
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
