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
	br_if   	0, $pop3        # 0: down to label0
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
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	i32.const	$push19=, 0
	i32.load	$push1=, entry_calls($pop19)
	i32.const	$push18=, 2
	i32.ne  	$push2=, $pop1, $pop18
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %entry
	i32.const	$push21=, 0
	i32.load	$push0=, exit_calls($pop21)
	i32.const	$push20=, 2
	i32.ne  	$push3=, $pop0, $pop20
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %if.end
	i32.const	$push22=, 0
	i32.load	$push4=, last_fn_entered($pop22)
	i32.const	$push5=, foo@FUNCTION
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label5
# BB#3:                                 # %if.end4
	i32.const	$push23=, 0
	i32.load	$push7=, last_fn_exited($pop23)
	i32.const	$push8=, foo2@FUNCTION
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label4
# BB#4:                                 # %if.end7
	call    	foo@FUNCTION
	i32.const	$push25=, 0
	i32.load	$push11=, entry_calls($pop25)
	i32.const	$push24=, 3
	i32.ne  	$push12=, $pop11, $pop24
	br_if   	3, $pop12       # 3: down to label3
# BB#5:                                 # %if.end7
	i32.const	$push27=, 0
	i32.load	$push10=, exit_calls($pop27)
	i32.const	$push26=, 3
	i32.ne  	$push13=, $pop10, $pop26
	br_if   	3, $pop13       # 3: down to label3
# BB#6:                                 # %if.end12
	i32.const	$push29=, 0
	i32.load	$push14=, last_fn_entered($pop29)
	i32.const	$push28=, foo@FUNCTION
	i32.ne  	$push15=, $pop14, $pop28
	br_if   	4, $pop15       # 4: down to label2
# BB#7:                                 # %if.end15
	i32.const	$push31=, 0
	i32.load	$push16=, last_fn_exited($pop31)
	i32.const	$push30=, foo@FUNCTION
	i32.ne  	$push17=, $pop16, $pop30
	br_if   	5, $pop17       # 5: down to label1
# BB#8:                                 # %if.end18
	return
.LBB1_9:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.then3
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then6
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then11
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then14
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %if.then17
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
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	i32.const	$push21=, 0
	i32.load	$push1=, exit_calls($pop21)
	i32.const	$push20=, 0
	i32.load	$push0=, entry_calls($pop20)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label12
# BB#1:                                 # %if.end
	call    	foo2@FUNCTION
	i32.const	$push23=, 0
	i32.load	$push4=, entry_calls($pop23)
	i32.const	$push22=, 2
	i32.ne  	$push5=, $pop4, $pop22
	br_if   	1, $pop5        # 1: down to label11
# BB#2:                                 # %if.end
	i32.const	$push25=, 0
	i32.load	$push3=, exit_calls($pop25)
	i32.const	$push24=, 2
	i32.ne  	$push6=, $pop3, $pop24
	br_if   	1, $pop6        # 1: down to label11
# BB#3:                                 # %if.end6
	i32.const	$push26=, 0
	i32.load	$push7=, last_fn_entered($pop26)
	i32.const	$push8=, foo@FUNCTION
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label10
# BB#4:                                 # %if.end9
	i32.const	$push27=, 0
	i32.load	$push10=, last_fn_exited($pop27)
	i32.const	$push11=, foo2@FUNCTION
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	3, $pop12       # 3: down to label9
# BB#5:                                 # %if.end12
	call    	nfoo@FUNCTION
	i32.const	$push29=, 0
	i32.load	$push14=, entry_calls($pop29)
	i32.const	$push28=, 3
	i32.ne  	$push15=, $pop14, $pop28
	br_if   	4, $pop15       # 4: down to label8
# BB#6:                                 # %if.end12
	i32.const	$push31=, 0
	i32.load	$push13=, exit_calls($pop31)
	i32.const	$push30=, 3
	i32.ne  	$push16=, $pop13, $pop30
	br_if   	4, $pop16       # 4: down to label8
# BB#7:                                 # %if.end17
	i32.const	$push32=, 0
	i32.load	$push17=, last_fn_entered($pop32)
	i32.const	$push18=, foo@FUNCTION
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	5, $pop19       # 5: down to label7
# BB#8:                                 # %if.end20
	i32.const	$push33=, 0
	return  	$pop33
.LBB2_9:                                # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then5
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then8
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %if.then11
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB2_13:                               # %if.then16
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then19
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, entry_calls($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, entry_calls($pop0), $pop3
	i32.const	$push4=, 0
	i32.store	$discard=, last_fn_entered($pop4), $0
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, exit_calls($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, exit_calls($pop0), $pop3
	i32.const	$push4=, 0
	i32.store	$discard=, last_fn_exited($pop4), $0
	return
	.endfunc
.Lfunc_end4:
	.size	__cyg_profile_func_exit, .Lfunc_end4-__cyg_profile_func_exit

	.section	.text.foo2,"ax",@progbits
	.type	foo2,@function
foo2:                                   # @foo2
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	i32.const	$push17=, 0
	i32.load	$push1=, entry_calls($pop17)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label17
# BB#1:                                 # %entry
	i32.const	$push18=, 0
	i32.load	$push0=, exit_calls($pop18)
	br_if   	0, $pop0        # 0: down to label17
# BB#2:                                 # %if.end
	i32.const	$push19=, 0
	i32.load	$push4=, last_fn_entered($pop19)
	i32.const	$push5=, foo2@FUNCTION
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label16
# BB#3:                                 # %if.end4
	call    	foo@FUNCTION
	i32.const	$push20=, 0
	i32.load	$push8=, entry_calls($pop20)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	2, $pop10       # 2: down to label15
# BB#4:                                 # %if.end4
	i32.const	$push21=, 0
	i32.load	$push7=, exit_calls($pop21)
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop7, $pop11
	br_if   	2, $pop12       # 2: down to label15
# BB#5:                                 # %if.end9
	i32.const	$push23=, 0
	i32.load	$push13=, last_fn_entered($pop23)
	i32.const	$push22=, foo@FUNCTION
	i32.ne  	$push14=, $pop13, $pop22
	br_if   	3, $pop14       # 3: down to label14
# BB#6:                                 # %if.end12
	i32.const	$push25=, 0
	i32.load	$push15=, last_fn_exited($pop25)
	i32.const	$push24=, foo@FUNCTION
	i32.ne  	$push16=, $pop15, $pop24
	br_if   	4, $pop16       # 4: down to label13
# BB#7:                                 # %if.end15
	return
.LBB5_8:                                # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB5_9:                                # %if.then3
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB5_10:                               # %if.then8
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB5_11:                               # %if.then11
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB5_12:                               # %if.then14
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
	.p2align	2
last_fn_entered:
	.int32	0
	.size	last_fn_entered, 4

	.hidden	entry_calls             # @entry_calls
	.type	entry_calls,@object
	.section	.bss.entry_calls,"aw",@nobits
	.globl	entry_calls
	.p2align	2
entry_calls:
	.int32	0                       # 0x0
	.size	entry_calls, 4

	.hidden	exit_calls              # @exit_calls
	.type	exit_calls,@object
	.section	.bss.exit_calls,"aw",@nobits
	.globl	exit_calls
	.p2align	2
exit_calls:
	.int32	0                       # 0x0
	.size	exit_calls, 4

	.hidden	last_fn_exited          # @last_fn_exited
	.type	last_fn_exited,@object
	.section	.bss.last_fn_exited,"aw",@nobits
	.globl	last_fn_exited
	.p2align	2
last_fn_exited:
	.int32	0
	.size	last_fn_exited, 4


	.ident	"clang version 3.9.0 "
