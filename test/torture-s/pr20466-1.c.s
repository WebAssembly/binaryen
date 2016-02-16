	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20466-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$5=, 0($0)
	i32.store	$discard=, 0($0), $2
	i32.load	$2=, 0($1)
	i32.load	$push0=, 0($4)
	i32.store	$discard=, 0($3), $pop0
	i32.load	$0=, 0($0)
	i32.store	$discard=, 0($5), $2
	i32.const	$push1=, 99
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push2=, 3
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 32
	i32.sub 	$13=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$13=, 0($3), $13
	i32.const	$push3=, 42
	i32.store	$discard=, 28($13), $pop3
	i32.const	$push5=, 1
	i32.store	$discard=, 20($13), $pop5
	i32.const	$push6=, -1
	i32.store	$discard=, 16($13), $pop6
	i32.const	$push7=, 55
	i32.store	$discard=, 12($13), $pop7
	i32.const	$push4=, 66
	i32.store	$1=, 24($13), $pop4
	i32.const	$4=, 28
	i32.add 	$4=, $13, $4
	i32.store	$discard=, 8($13), $4
	i32.const	$5=, 16
	i32.add 	$5=, $13, $5
	i32.store	$discard=, 4($13), $5
	i32.const	$6=, 12
	i32.add 	$6=, $13, $6
	i32.store	$discard=, 0($13), $6
	i32.const	$7=, 8
	i32.add 	$7=, $13, $7
	i32.const	$8=, 24
	i32.add 	$8=, $13, $8
	i32.const	$9=, 20
	i32.add 	$9=, $13, $9
	i32.const	$10=, 4
	i32.add 	$10=, $13, $10
	i32.call	$discard=, f@FUNCTION, $7, $8, $9, $10, $13
	i32.const	$11=, 20
	i32.add 	$11=, $13, $11
	copy_local	$0=, $11
	block
	i32.load	$push8=, 28($13)
	i32.ne  	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, 8($13)
	i32.ne  	$push10=, $pop0, $0
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %entry
	i32.load	$push1=, 20($13)
	i32.const	$push11=, 99
	i32.ne  	$push12=, $pop1, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %entry
	i32.load	$push2=, 16($13)
	i32.const	$push13=, -1
	i32.ne  	$push14=, $pop2, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %lor.lhs.false6
	i32.load	$push16=, 4($13)
	i32.const	$12=, 12
	i32.add 	$12=, $13, $12
	i32.ne  	$push17=, $pop16, $12
	br_if   	0, $pop17       # 0: down to label0
# BB#5:                                 # %lor.lhs.false6
	i32.load	$push15=, 12($13)
	i32.const	$push18=, 55
	i32.ne  	$push19=, $pop15, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#6:                                 # %if.end
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
