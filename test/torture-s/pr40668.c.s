	.text
	.file	"pr40668.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -1
	i32.add 	$push15=, $0, $pop0
	tee_local	$push14=, $0=, $pop15
	i32.const	$push1=, 8
	i32.gt_u	$push2=, $pop14, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %switch.hole_check
	i32.const	$push5=, 449
	i32.const	$push3=, 65535
	i32.and 	$push4=, $0, $pop3
	i32.shr_u	$push6=, $pop5, $pop4
	i32.const	$push7=, 1
	i32.and 	$push8=, $pop6, $pop7
	i32.eqz 	$push16=, $pop8
	br_if   	0, $pop16       # 0: down to label0
# BB#2:                                 # %switch.lookup
	i32.const	$push9=, 2
	i32.shl 	$push10=, $0, $pop9
	i32.const	$push11=, .Lswitch.table.bar
	i32.add 	$push12=, $pop10, $pop11
	i32.load	$push13=, 0($pop12)
	i32.store	0($1):p2align=0, $pop13
.LBB0_3:                                # %sw.epilog
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lswitch.table.bar,@object # @switch.table.bar
	.section	.rodata..Lswitch.table.bar,"a",@progbits
	.p2align	4
.Lswitch.table.bar:
	.int32	305419896               # 0x12345678
	.int32	305419896               # 0x12345678
	.int32	305419896               # 0x12345678
	.int32	305419896               # 0x12345678
	.int32	305419896               # 0x12345678
	.int32	305419896               # 0x12345678
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.size	.Lswitch.table.bar, 36


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
