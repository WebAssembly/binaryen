	.text
	.file	"pr57130.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, foo.cnt($pop0)
	i32.const	$push9=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $1, $pop1
	i32.store	foo.cnt($pop9), $pop2
	block   	
	i32.const	$push3=, 4
	i32.shl 	$push4=, $1, $pop3
	i32.const	$push5=, s
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, 16
	i32.call	$push8=, memcmp@FUNCTION, $0, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 48
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
	i32.const	$push15=, 16
	i32.add 	$push16=, $0, $pop15
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop16, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.r+8($pop0):p2align=2
	i64.store	0($pop3), $pop1
	i32.const	$push23=, 0
	i64.load	$push4=, .Lmain.r($pop23):p2align=2
	i64.store	16($0), $pop4
	i32.const	$push17=, 16
	i32.add 	$push18=, $0, $pop17
	call    	foo@FUNCTION, $pop18
	i32.const	$push22=, 8
	i32.add 	$push5=, $0, $pop22
	i64.const	$push6=, 12884901887
	i64.store	0($pop5), $pop6
	i64.const	$push21=, 12884901887
	i64.store	40($0), $pop21
	i64.const	$push7=, 8589934592
	i64.store	0($0), $pop7
	i64.const	$push20=, 8589934592
	i64.store	32($0), $pop20
	call    	foo@FUNCTION, $0
	i32.const	$push14=, 0
	i32.const	$push12=, 48
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push19=, 0
                                        # fallthrough-return: $pop19
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	4
s:
	.int32	6                       # 0x6
	.int32	8                       # 0x8
	.int32	4294967288              # 0xfffffff8
	.int32	4294967291              # 0xfffffffb
	.int32	0                       # 0x0
	.int32	2                       # 0x2
	.int32	4294967295              # 0xffffffff
	.int32	2                       # 0x2
	.size	s, 32

	.type	foo.cnt,@object         # @foo.cnt
	.section	.bss.foo.cnt,"aw",@nobits
	.p2align	2
foo.cnt:
	.int32	0                       # 0x0
	.size	foo.cnt, 4

	.type	.Lmain.r,@object        # @main.r
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	2
.Lmain.r:
	.int32	6                       # 0x6
	.int32	8                       # 0x8
	.int32	4294967288              # 0xfffffff8
	.int32	4294967291              # 0xfffffffb
	.size	.Lmain.r, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
