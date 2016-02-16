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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 48
	i32.sub 	$10=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
	i32.const	$push2=, 8
	i32.const	$6=, 32
	i32.add 	$6=, $10, $6
	i32.add 	$push24=, $6, $pop2
	tee_local	$push23=, $2=, $pop24
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.r+8($pop0)
	i32.store	$discard=, 0($pop23):p2align=3, $pop1
	i32.const	$push22=, 0
	i64.load	$push3=, .Lmain.r($pop22):p2align=2
	i64.store	$discard=, 32($10), $pop3
	i32.const	$push21=, 8
	i32.const	$7=, 16
	i32.add 	$7=, $10, $7
	i32.add 	$push6=, $7, $pop21
	i32.const	$push20=, 0
	i64.load	$push7=, .Lmain.r+8($pop20):p2align=2
	i64.store	$discard=, 0($pop6):p2align=2, $pop7
	i32.const	$push19=, 0
	i64.load	$push8=, .Lmain.r($pop19):p2align=2
	i64.store	$discard=, 16($10):p2align=2, $pop8
	i32.const	$8=, 16
	i32.add 	$8=, $10, $8
	call    	foo@FUNCTION, $8
	i32.const	$push4=, 4
	i32.const	$9=, 32
	i32.add 	$9=, $10, $9
	i32.or  	$push5=, $9, $pop4
	i32.const	$push9=, 2
	i32.store	$1=, 0($pop5), $pop9
	i32.const	$push10=, -1
	i32.store	$discard=, 0($2):p2align=3, $pop10
	i32.const	$push18=, 0
	i32.store	$0=, 32($10):p2align=3, $pop18
	i32.const	$push12=, 12
	i32.add 	$push13=, $10, $pop12
	i32.store	$push11=, 44($10), $1
	i32.store	$discard=, 0($pop13), $pop11
	i32.const	$push17=, 8
	i32.add 	$push14=, $10, $pop17
	i32.load	$push15=, 0($2):p2align=3
	i32.store	$discard=, 0($pop14), $pop15
	i64.load	$push16=, 32($10)
	i64.store	$discard=, 0($10):p2align=2, $pop16
	call    	foo@FUNCTION, $10
	i32.const	$5=, 48
	i32.add 	$10=, $10, $5
	i32.const	$5=, __stack_pointer
	i32.store	$10=, 0($5), $10
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
