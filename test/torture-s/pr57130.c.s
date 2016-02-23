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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 48
	i32.sub 	$5=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $5
	i32.const	$push2=, 8
	i32.const	$2=, 32
	i32.add 	$2=, $5, $2
	i32.add 	$push23=, $2, $pop2
	tee_local	$push22=, $1=, $pop23
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.r+8($pop0)
	i32.store	$discard=, 0($pop22):p2align=3, $pop1
	i32.const	$push21=, 0
	i64.load	$push3=, .Lmain.r($pop21):p2align=2
	i64.store	$discard=, 32($5), $pop3
	i32.const	$push20=, 8
	i32.const	$3=, 16
	i32.add 	$3=, $5, $3
	i32.add 	$push4=, $3, $pop20
	i32.const	$push19=, 0
	i64.load	$push5=, .Lmain.r+8($pop19):p2align=2
	i64.store	$discard=, 0($pop4):p2align=2, $pop5
	i32.const	$push18=, 0
	i64.load	$push6=, .Lmain.r($pop18):p2align=2
	i64.store	$discard=, 16($5):p2align=2, $pop6
	i32.const	$4=, 16
	i32.add 	$4=, $5, $4
	call    	foo@FUNCTION, $4
	i32.const	$push9=, -1
	i32.store	$discard=, 0($1):p2align=3, $pop9
	i32.const	$push17=, 0
	i32.store	$0=, 32($5):p2align=3, $pop17
	i32.const	$push11=, 12
	i32.add 	$push12=, $5, $pop11
	i32.const	$push7=, 2
	i32.store	$push8=, 36($5), $pop7
	i32.store	$push10=, 44($5), $pop8
	i32.store	$discard=, 0($pop12), $pop10
	i32.const	$push16=, 8
	i32.add 	$push13=, $5, $pop16
	i32.load	$push14=, 0($1):p2align=3
	i32.store	$discard=, 0($pop13), $pop14
	i64.load	$push15=, 32($5)
	i64.store	$discard=, 0($5):p2align=2, $pop15
	call    	foo@FUNCTION, $5
	i32.const	$push28=, 48
	i32.add 	$5=, $5, $pop28
	i32.const	$push29=, __stack_pointer
	i32.store	$discard=, 0($pop29), $5
	return  	$0
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
