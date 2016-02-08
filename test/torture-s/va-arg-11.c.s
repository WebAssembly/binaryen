	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 32
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 20
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i64.const	$push0=, 12884901892
	i64.store	$discard=, 0($8):p2align=2, $pop0
	i32.const	$push1=, 16
	i32.add 	$0=, $8, $pop1
	i32.const	$push2=, 0
	i32.store	$1=, 0($0), $pop2
	i32.const	$push3=, 8
	i32.add 	$0=, $8, $pop3
	i64.const	$push4=, 4294967298
	i64.store	$discard=, 0($0):p2align=2, $pop4
	i32.call	$0=, foo@FUNCTION, $0
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 20
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $1
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
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $6
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push36=, $1=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop36, $pop5
	i32.store	$discard=, 12($5), $pop6
	i32.const	$push7=, 7
	i32.add 	$push8=, $1, $pop7
	i32.const	$push35=, -4
	i32.and 	$push9=, $pop8, $pop35
	tee_local	$push34=, $1=, $pop9
	i32.const	$push33=, 4
	i32.add 	$push10=, $pop34, $pop33
	i32.store	$discard=, 12($5), $pop10
	i32.const	$push32=, 7
	i32.add 	$push11=, $1, $pop32
	i32.const	$push31=, -4
	i32.and 	$push12=, $pop11, $pop31
	tee_local	$push30=, $1=, $pop12
	i32.const	$push29=, 4
	i32.add 	$push13=, $pop30, $pop29
	i32.store	$discard=, 12($5), $pop13
	i32.const	$push28=, 7
	i32.add 	$push14=, $1, $pop28
	i32.const	$push27=, -4
	i32.and 	$push15=, $pop14, $pop27
	tee_local	$push26=, $1=, $pop15
	i32.const	$push25=, 4
	i32.add 	$push16=, $pop26, $pop25
	i32.store	$discard=, 12($5), $pop16
	i32.const	$push24=, 7
	i32.add 	$push17=, $1, $pop24
	i32.const	$push23=, -4
	i32.and 	$push18=, $pop17, $pop23
	tee_local	$push22=, $1=, $pop18
	i32.const	$push21=, 4
	i32.add 	$push19=, $pop22, $pop21
	i32.store	$discard=, 12($5), $pop19
	i32.load	$push20=, 0($1)
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop20
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo


	.ident	"clang version 3.9.0 "
