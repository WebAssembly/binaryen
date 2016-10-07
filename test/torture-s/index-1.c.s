	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/index-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a-400000
	i32.add 	$push3=, $pop1, $pop2
	i32.load	$push4=, 0($pop3)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, a+120($pop3)
	i32.const	$push1=, 30
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.int32	16                      # 0x10
	.int32	17                      # 0x11
	.int32	18                      # 0x12
	.int32	19                      # 0x13
	.int32	20                      # 0x14
	.int32	21                      # 0x15
	.int32	22                      # 0x16
	.int32	23                      # 0x17
	.int32	24                      # 0x18
	.int32	25                      # 0x19
	.int32	26                      # 0x1a
	.int32	27                      # 0x1b
	.int32	28                      # 0x1c
	.int32	29                      # 0x1d
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	32                      # 0x20
	.int32	33                      # 0x21
	.int32	34                      # 0x22
	.int32	35                      # 0x23
	.int32	36                      # 0x24
	.int32	37                      # 0x25
	.int32	38                      # 0x26
	.int32	39                      # 0x27
	.size	a, 160


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
