	.text
	.file	"20041218-1.c"
	.section	.text.dummy1,"ax",@progbits
	.hidden	dummy1                  # -- Begin function dummy1
	.globl	dummy1
	.type	dummy1,@function
dummy1:                                 # @dummy1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, .L.str
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	dummy1, .Lfunc_end0-dummy1
                                        # -- End function
	.section	.text.dummy2,"ax",@progbits
	.hidden	dummy2                  # -- Begin function dummy2
	.globl	dummy2
	.type	dummy2,@function
dummy2:                                 # @dummy2
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	dummy2, .Lfunc_end1-dummy2
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1431655765
	i32.store	baz.v+40($pop1), $pop0
	i32.const	$push12=, 0
	i64.const	$push2=, 6148914691236517205
	i64.store	baz.v+32($pop12):p2align=2, $pop2
	i32.const	$push11=, 0
	i64.const	$push10=, 6148914691236517205
	i64.store	baz.v+24($pop11):p2align=2, $pop10
	i32.const	$push9=, 0
	i64.const	$push8=, 6148914691236517205
	i64.store	baz.v+16($pop9):p2align=2, $pop8
	i32.const	$push7=, 0
	i64.const	$push6=, 6148914691236517205
	i64.store	baz.v+8($pop7):p2align=2, $pop6
	i32.const	$push5=, 0
	i64.const	$push4=, 6148914691236517205
	i64.store	baz.v($pop5):p2align=2, $pop4
	i32.const	$push3=, baz.v
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
                                        # -- End function
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($1)
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push1=, 4($1)
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %lor.lhs.false2
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %lor.lhs.false5
	i32.const	$push5=, 12
	i32.add 	$push6=, $1, $pop5
	i32.load	$push7=, 0($pop6)
	br_if   	0, $pop7        # 0: down to label0
# %bb.4:                                # %lor.lhs.false8
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.load8_u	$push10=, 0($pop9)
	br_if   	0, $pop10       # 0: down to label0
# %bb.5:                                # %if.end
	i32.const	$push11=, 1
	return  	$pop11
.LBB3_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	check, .Lfunc_end3-check
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %for.cond
	i32.const	$push5=, 0
	i32.store	0($2), $pop5
	block   	
	block   	
	i32.eqz 	$push20=, $1
	br_if   	0, $pop20       # 0: down to label2
# %bb.1:                                # %for.body
	i32.load	$push0=, 0($0)
	i32.const	$push6=, 1
	i32.eq  	$push1=, $pop0, $pop6
	br_if   	1, $pop1        # 1: down to label1
# %bb.2:                                # %cleanup2
	i32.const	$push7=, 1
	return  	$pop7
.LBB4_3:                                # %for.end
	end_block                       # label2:
	i32.const	$push9=, 0
	i32.store	0($2), $pop9
	i32.const	$push8=, 0
	return  	$pop8
.LBB4_4:                                # %sw.bb
	end_block                       # label1:
	i32.const	$push3=, 0
	i64.const	$push2=, 0
	i64.store	baz.v+36($pop3):p2align=2, $pop2
	i32.const	$push19=, 0
	i64.const	$push18=, 0
	i64.store	baz.v+28($pop19):p2align=2, $pop18
	i32.const	$push17=, 0
	i64.const	$push16=, 0
	i64.store	baz.v+20($pop17):p2align=2, $pop16
	i32.const	$push15=, 0
	i64.const	$push14=, 0
	i64.store	baz.v+12($pop15):p2align=2, $pop14
	i32.const	$push13=, 0
	i64.const	$push12=, 0
	i64.store	baz.v+4($pop13):p2align=2, $pop12
	i32.const	$push11=, 0
	i32.const	$push4=, 1
	i32.store	baz.v($pop11), $pop4
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
	.endfunc
.Lfunc_end4:
	.size	foo, .Lfunc_end4-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$0=, $pop1, $pop3
	i32.const	$push4=, 0
	i32.store	__stack_pointer($pop4), $0
	i32.const	$push0=, 1
	i32.store	12($0), $pop0
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 1
	i32.const	$push7=, 8
	i32.add 	$push8=, $0, $pop7
	i32.call	$drop=, foo@FUNCTION, $pop6, $pop9, $pop8
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.skip	1
	.size	.L.str, 1

	.type	baz.v,@object           # @baz.v
	.section	.bss.baz.v,"aw",@nobits
	.p2align	2
baz.v:
	.skip	44
	.size	baz.v, 44


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
