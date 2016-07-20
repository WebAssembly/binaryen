	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57130.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, foo.cnt($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop9, $pop1
	i32.store	$drop=, foo.cnt($pop0), $pop2
	block
	i32.const	$push3=, 4
	i32.shl 	$push4=, $1, $pop3
	i32.const	$push5=, s
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, 16
	i32.call	$push8=, memcmp@FUNCTION, $0, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 48
	i32.sub 	$push21=, $pop11, $pop12
	i32.store	$push26=, __stack_pointer($pop13), $pop21
	tee_local	$push25=, $0=, $pop26
	i32.const	$push17=, 16
	i32.add 	$push18=, $pop25, $pop17
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop18, $pop4
	i32.const	$push2=, 0
	i64.load	$push3=, .Lmain.r+8($pop2):p2align=2
	i64.store	$drop=, 0($pop5):p2align=2, $pop3
	i32.const	$push24=, 0
	i64.load	$push6=, .Lmain.r($pop24):p2align=2
	i64.store	$drop=, 16($0):p2align=2, $pop6
	i32.const	$push19=, 16
	i32.add 	$push20=, $0, $pop19
	call    	foo@FUNCTION, $pop20
	i32.const	$push23=, 8
	i32.add 	$push8=, $0, $pop23
	i64.const	$push7=, 12884901887
	i64.store	$push0=, 40($0), $pop7
	i64.store	$drop=, 0($pop8):p2align=2, $pop0
	i64.const	$push9=, 8589934592
	i64.store	$push1=, 32($0), $pop9
	i64.store	$drop=, 0($0):p2align=2, $pop1
	call    	foo@FUNCTION, $0
	i32.const	$push16=, 0
	i32.const	$push14=, 48
	i32.add 	$push15=, $0, $pop14
	i32.store	$drop=, __stack_pointer($pop16), $pop15
	i32.const	$push22=, 0
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 4.0.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
