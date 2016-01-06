	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42691.c"
	.globl	add
	.type	add,@function
add:                                    # @add
	.param  	i32, i32
	.result 	i32
	.local  	f64, f64
# BB#0:                                 # %entry
	f64.load	$3=, 0($1)
	f64.load	$2=, 0($0)
	block   	BB0_5
	f64.eq  	$push0=, $3, $2
	br_if   	$pop0, BB0_5
# BB#1:                                 # %if.end.preheader
	i32.const	$0=, 8
	i32.add 	$1=, $1, $0
BB0_2:                                  # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_4
	f64.const	$push1=, infinity
	f64.ne  	$push2=, $3, $pop1
	br_if   	$pop2, BB0_4
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	f64.load	$3=, 0($1)
	i32.add 	$1=, $1, $0
	f64.ne  	$push3=, $3, $2
	br_if   	$pop3, BB0_2
	br      	BB0_5
BB0_4:                                  # %if.then3
	call    	abort
	unreachable
BB0_5:                                  # %if.end10
	i32.const	$push4=, 0
	return  	$pop4
func_end0:
	.size	add, func_end0-add

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32, i32, f64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	i64.const	$push0=, 9218868437227405312
	i64.store	$discard=, 0($8), $pop0
	f64.const	$0=, infinity
	i32.const	$1=, 8
	i32.const	$7=, 0
	i32.add 	$7=, $8, $7
	i32.or  	$2=, $7, $1
	i64.const	$push1=, 4627167142146473984
	i64.store	$discard=, 0($2), $pop1
	copy_local	$3=, $0
BB1_1:                                  # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block   	BB1_4
	loop    	BB1_3
	f64.ne  	$push2=, $3, $0
	br_if   	$pop2, BB1_4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$3=, 0($2)
	i32.add 	$2=, $2, $1
	f64.const	$push3=, 0x1.7p4
	f64.ne  	$push4=, $3, $pop3
	br_if   	$pop4, BB1_1
BB1_3:                                  # %add.exit
	i32.const	$push5=, 0
	i32.const	$6=, 16
	i32.add 	$8=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	return  	$pop5
BB1_4:                                  # %if.then3.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
