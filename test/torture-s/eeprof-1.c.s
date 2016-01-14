	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/eeprof-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.load	$push1=, last_fn_entered($pop0)
	i32.const	$push2=, foo@FUNCTION
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.nfoo,"ax",@progbits
	.hidden	nfoo
	.globl	nfoo
	.type	nfoo,@function
nfoo:                                   # @nfoo
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 2
	block
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	i32.ne  	$push3=, $pop0, $1
	br_if   	$pop3, 0        # 0: down to label1
# BB#2:                                 # %if.end
	i32.const	$1=, foo@FUNCTION
	block
	i32.load	$push4=, last_fn_entered($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, 0        # 0: down to label2
# BB#3:                                 # %if.end4
	block
	i32.load	$push6=, last_fn_exited($0)
	i32.const	$push7=, foo2@FUNCTION
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label3
# BB#4:                                 # %if.end7
	call    	foo@FUNCTION
	i32.const	$2=, 3
	block
	i32.load	$push10=, entry_calls($0)
	i32.ne  	$push11=, $pop10, $2
	br_if   	$pop11, 0       # 0: down to label4
# BB#5:                                 # %if.end7
	i32.load	$push9=, exit_calls($0)
	i32.ne  	$push12=, $pop9, $2
	br_if   	$pop12, 0       # 0: down to label4
# BB#6:                                 # %if.end12
	block
	i32.load	$push13=, last_fn_entered($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, 0       # 0: down to label5
# BB#7:                                 # %if.end15
	block
	i32.load	$push15=, last_fn_exited($0)
	i32.ne  	$push16=, $pop15, $1
	br_if   	$pop16, 0       # 0: down to label6
# BB#8:                                 # %if.end18
	return
.LBB1_9:                                # %if.then17
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.then14
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then11
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then6
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then3
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	nfoo, .Lfunc_end1-nfoo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push1=, exit_calls($0)
	i32.load	$push0=, entry_calls($0)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	$pop2, 0        # 0: down to label7
# BB#1:                                 # %if.end
	call    	foo2@FUNCTION
	i32.const	$1=, 2
	block
	i32.load	$push4=, entry_calls($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, 0        # 0: down to label8
# BB#2:                                 # %if.end
	i32.load	$push3=, exit_calls($0)
	i32.ne  	$push6=, $pop3, $1
	br_if   	$pop6, 0        # 0: down to label8
# BB#3:                                 # %if.end6
	i32.const	$1=, foo@FUNCTION
	block
	i32.load	$push7=, last_fn_entered($0)
	i32.ne  	$push8=, $pop7, $1
	br_if   	$pop8, 0        # 0: down to label9
# BB#4:                                 # %if.end9
	block
	i32.load	$push9=, last_fn_exited($0)
	i32.const	$push10=, foo2@FUNCTION
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label10
# BB#5:                                 # %if.end12
	call    	nfoo@FUNCTION
	i32.const	$2=, 3
	block
	i32.load	$push13=, entry_calls($0)
	i32.ne  	$push14=, $pop13, $2
	br_if   	$pop14, 0       # 0: down to label11
# BB#6:                                 # %if.end12
	i32.load	$push12=, exit_calls($0)
	i32.ne  	$push15=, $pop12, $2
	br_if   	$pop15, 0       # 0: down to label11
# BB#7:                                 # %if.end17
	block
	i32.load	$push16=, last_fn_entered($0)
	i32.ne  	$push17=, $pop16, $1
	br_if   	$pop17, 0       # 0: down to label12
# BB#8:                                 # %if.end20
	return  	$0
.LBB2_9:                                # %if.then19
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then16
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then11
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %if.then8
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB2_13:                               # %if.then5
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.section	.text.__cyg_profile_func_enter,"ax",@progbits
	.hidden	__cyg_profile_func_enter
	.globl	__cyg_profile_func_enter
	.type	__cyg_profile_func_enter,@function
__cyg_profile_func_enter:               # @__cyg_profile_func_enter
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$push0=, entry_calls($2)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, entry_calls($2), $pop2
	i32.store	$discard=, last_fn_entered($2), $0
	return
	.endfunc
.Lfunc_end3:
	.size	__cyg_profile_func_enter, .Lfunc_end3-__cyg_profile_func_enter

	.section	.text.__cyg_profile_func_exit,"ax",@progbits
	.hidden	__cyg_profile_func_exit
	.globl	__cyg_profile_func_exit
	.type	__cyg_profile_func_exit,@function
__cyg_profile_func_exit:                # @__cyg_profile_func_exit
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$push0=, exit_calls($2)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, exit_calls($2), $pop2
	i32.store	$discard=, last_fn_exited($2), $0
	return
	.endfunc
.Lfunc_end4:
	.size	__cyg_profile_func_exit, .Lfunc_end4-__cyg_profile_func_exit

	.section	.text.foo2,"ax",@progbits
	.type	foo2,@function
foo2:                                   # @foo2
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 1
	block
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, 0        # 0: down to label13
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	br_if   	$pop0, 0        # 0: down to label13
# BB#2:                                 # %if.end
	block
	i32.load	$push3=, last_fn_entered($0)
	i32.const	$push4=, foo2@FUNCTION
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label14
# BB#3:                                 # %if.end4
	call    	foo@FUNCTION
	block
	i32.load	$push7=, entry_calls($0)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label15
# BB#4:                                 # %if.end4
	i32.load	$push6=, exit_calls($0)
	i32.ne  	$push10=, $pop6, $1
	br_if   	$pop10, 0       # 0: down to label15
# BB#5:                                 # %if.end9
	i32.const	$1=, foo@FUNCTION
	block
	i32.load	$push11=, last_fn_entered($0)
	i32.ne  	$push12=, $pop11, $1
	br_if   	$pop12, 0       # 0: down to label16
# BB#6:                                 # %if.end12
	block
	i32.load	$push13=, last_fn_exited($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, 0       # 0: down to label17
# BB#7:                                 # %if.end15
	return
.LBB5_8:                                # %if.then14
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB5_9:                                # %if.then11
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB5_10:                               # %if.then8
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB5_11:                               # %if.then3
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB5_12:                               # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	foo2, .Lfunc_end5-foo2

	.hidden	last_fn_entered         # @last_fn_entered
	.type	last_fn_entered,@object
	.section	.bss.last_fn_entered,"aw",@nobits
	.globl	last_fn_entered
	.align	2
last_fn_entered:
	.int32	0
	.size	last_fn_entered, 4

	.hidden	entry_calls             # @entry_calls
	.type	entry_calls,@object
	.section	.bss.entry_calls,"aw",@nobits
	.globl	entry_calls
	.align	2
entry_calls:
	.int32	0                       # 0x0
	.size	entry_calls, 4

	.hidden	exit_calls              # @exit_calls
	.type	exit_calls,@object
	.section	.bss.exit_calls,"aw",@nobits
	.globl	exit_calls
	.align	2
exit_calls:
	.int32	0                       # 0x0
	.size	exit_calls, 4

	.hidden	last_fn_exited          # @last_fn_exited
	.type	last_fn_exited,@object
	.section	.bss.last_fn_exited,"aw",@nobits
	.globl	last_fn_exited
	.align	2
last_fn_exited:
	.int32	0
	.size	last_fn_exited, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
