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
	i32.store	$discard=, foo.cnt($pop0), $pop2
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
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 48
	i32.sub 	$push29=, $pop17, $pop18
	i32.store	$push38=, 0($pop19), $pop29
	tee_local	$push37=, $2=, $pop38
	i32.const	$push23=, 32
	i32.add 	$push24=, $pop37, $pop23
	i32.const	$push2=, 8
	i32.add 	$push36=, $pop24, $pop2
	tee_local	$push35=, $1=, $pop36
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.r+8($pop0)
	i32.store	$discard=, 0($pop35), $pop1
	i32.const	$push34=, 0
	i64.load	$push3=, .Lmain.r($pop34):p2align=2
	i64.store	$0=, 32($2), $pop3
	i32.const	$push25=, 16
	i32.add 	$push26=, $2, $pop25
	i32.const	$push33=, 8
	i32.add 	$push5=, $pop26, $pop33
	i32.const	$push32=, 0
	i64.load	$push4=, .Lmain.r+8($pop32):p2align=2
	i64.store	$discard=, 0($pop5):p2align=2, $pop4
	i64.store	$discard=, 16($2):p2align=2, $0
	i32.const	$push27=, 16
	i32.add 	$push28=, $2, $pop27
	call    	foo@FUNCTION, $pop28
	i64.const	$push6=, 8589934592
	i64.store	$discard=, 32($2), $pop6
	i64.const	$push7=, 12884901887
	i64.store	$discard=, 0($1), $pop7
	i32.const	$push8=, 12
	i32.add 	$push9=, $2, $pop8
	i32.const	$push10=, 2
	i32.store	$discard=, 0($pop9), $pop10
	i32.const	$push31=, 8
	i32.add 	$push11=, $2, $pop31
	i32.load	$push12=, 0($1)
	i32.store	$discard=, 0($pop11), $pop12
	i32.const	$push13=, 4
	i32.add 	$push14=, $2, $pop13
	i32.load	$push15=, 36($2)
	i32.store	$discard=, 0($pop14), $pop15
	i32.const	$push30=, 0
	i32.store	$1=, 0($2), $pop30
	call    	foo@FUNCTION, $2
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 48
	i32.add 	$push21=, $2, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return  	$1
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
