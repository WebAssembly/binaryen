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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 48
	i32.sub 	$push30=, $pop18, $pop19
	i32.store	$push39=, __stack_pointer($pop20), $pop30
	tee_local	$push38=, $0=, $pop39
	i32.const	$push24=, 32
	i32.add 	$push25=, $pop38, $pop24
	i32.const	$push3=, 8
	i32.add 	$push37=, $pop25, $pop3
	tee_local	$push36=, $1=, $pop37
	i32.const	$push1=, 0
	i32.load	$push2=, .Lmain.r+8($pop1)
	i32.store	$drop=, 0($pop36), $pop2
	i32.const	$push26=, 16
	i32.add 	$push27=, $0, $pop26
	i32.const	$push35=, 8
	i32.add 	$push5=, $pop27, $pop35
	i32.const	$push34=, 0
	i64.load	$push4=, .Lmain.r+8($pop34):p2align=2
	i64.store	$drop=, 0($pop5):p2align=2, $pop4
	i32.const	$push33=, 0
	i64.load	$push6=, .Lmain.r($pop33):p2align=2
	i64.store	$push0=, 32($0), $pop6
	i64.store	$drop=, 16($0):p2align=2, $pop0
	i32.const	$push28=, 16
	i32.add 	$push29=, $0, $pop28
	call    	foo@FUNCTION, $pop29
	i64.const	$push7=, 12884901887
	i64.store	$drop=, 0($1), $pop7
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	i32.const	$push10=, 2
	i32.store	$drop=, 0($pop9), $pop10
	i32.const	$push32=, 8
	i32.add 	$push11=, $0, $pop32
	i32.load	$push12=, 0($1)
	i32.store	$drop=, 0($pop11), $pop12
	i64.const	$push13=, 8589934592
	i64.store	$drop=, 32($0), $pop13
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.load	$push16=, 36($0)
	i32.store	$drop=, 0($pop15), $pop16
	i32.const	$push31=, 0
	i32.store	$1=, 0($0), $pop31
	call    	foo@FUNCTION, $0
	i32.const	$push23=, 0
	i32.const	$push21=, 48
	i32.add 	$push22=, $0, $pop21
	i32.store	$drop=, __stack_pointer($pop23), $pop22
	copy_local	$push40=, $1
                                        # fallthrough-return: $pop40
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
	.lcomm	foo.cnt,4,2
	.type	.Lmain.r,@object        # @main.r
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	2
.Lmain.r:
	.int32	6                       # 0x6
	.int32	8                       # 0x8
	.int32	4294967288              # 0xfffffff8
	.int32	4294967291              # 0xfffffffb
	.size	.Lmain.r, 16


	.ident	"clang version 3.9.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
