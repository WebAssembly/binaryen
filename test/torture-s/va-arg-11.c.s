	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 16
	i32.add 	$push1=, $3, $pop0
	i32.const	$push2=, 0
	i32.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 8
	i32.or  	$push4=, $3, $pop3
	i64.const	$push5=, 4294967298
	i64.store	$discard=, 0($pop4), $pop5
	i64.const	$push6=, 12884901892
	i64.store	$discard=, 0($3):p2align=4, $pop6
	block
	i32.call	$push7=, foo@FUNCTION, $0, $3
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push36=, $pop2, $pop3
	tee_local	$push35=, $1=, $pop36
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop35, $pop4
	i32.store	$discard=, 12($5), $pop5
	i32.const	$push6=, 7
	i32.add 	$push7=, $1, $pop6
	i32.const	$push34=, -4
	i32.and 	$push33=, $pop7, $pop34
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 4
	i32.add 	$push8=, $pop32, $pop31
	i32.store	$discard=, 12($5), $pop8
	i32.const	$push30=, 7
	i32.add 	$push9=, $1, $pop30
	i32.const	$push29=, -4
	i32.and 	$push28=, $pop9, $pop29
	tee_local	$push27=, $1=, $pop28
	i32.const	$push26=, 4
	i32.add 	$push10=, $pop27, $pop26
	i32.store	$discard=, 12($5), $pop10
	i32.const	$push25=, 7
	i32.add 	$push11=, $1, $pop25
	i32.const	$push24=, -4
	i32.and 	$push23=, $pop11, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.const	$push21=, 4
	i32.add 	$push12=, $pop22, $pop21
	i32.store	$discard=, 12($5), $pop12
	i32.const	$push20=, 7
	i32.add 	$push13=, $1, $pop20
	i32.const	$push19=, -4
	i32.and 	$push18=, $pop13, $pop19
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 4
	i32.add 	$push14=, $pop17, $pop16
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($1)
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop15
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo


	.ident	"clang version 3.9.0 "
