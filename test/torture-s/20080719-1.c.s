	.text
	.file	"20080719-1.c"
	.section	.text.xxx,"ax",@progbits
	.hidden	xxx                     # -- Begin function xxx
	.globl	xxx
	.type	xxx,@function
xxx:                                    # @xxx
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push7=, cfb_tab8_be
	i32.const	$push3=, cfb_tab16_be
	i32.const	$push2=, cfb_tab32
	i32.const	$push0=, 16
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
	i32.const	$push5=, 8
	i32.eq  	$push6=, $0, $pop5
	i32.select	$push8=, $pop7, $pop4, $pop6
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	xxx, .Lfunc_end0-xxx
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
	.type	cfb_tab8_be,@object     # @cfb_tab8_be
	.section	.rodata.cfb_tab8_be,"a",@progbits
	.p2align	4
cfb_tab8_be:
	.int32	0                       # 0x0
	.int32	255                     # 0xff
	.int32	65280                   # 0xff00
	.int32	65535                   # 0xffff
	.int32	16711680                # 0xff0000
	.int32	16711935                # 0xff00ff
	.int32	16776960                # 0xffff00
	.int32	16777215                # 0xffffff
	.int32	4278190080              # 0xff000000
	.int32	4278190335              # 0xff0000ff
	.int32	4278255360              # 0xff00ff00
	.int32	4278255615              # 0xff00ffff
	.int32	4294901760              # 0xffff0000
	.int32	4294902015              # 0xffff00ff
	.int32	4294967040              # 0xffffff00
	.int32	4294967295              # 0xffffffff
	.size	cfb_tab8_be, 64

	.type	cfb_tab16_be,@object    # @cfb_tab16_be
	.section	.rodata.cfb_tab16_be,"a",@progbits
	.p2align	4
cfb_tab16_be:
	.int32	0                       # 0x0
	.int32	65535                   # 0xffff
	.int32	4294901760              # 0xffff0000
	.int32	4294967295              # 0xffffffff
	.size	cfb_tab16_be, 16

	.type	cfb_tab32,@object       # @cfb_tab32
	.section	.rodata.cfb_tab32,"a",@progbits
	.p2align	2
cfb_tab32:
	.int32	0                       # 0x0
	.int32	4294967295              # 0xffffffff
	.size	cfb_tab32, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
