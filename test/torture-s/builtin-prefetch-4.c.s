	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-4.c"
	.section	.text.assign_arg_ptr,"ax",@progbits
	.hidden	assign_arg_ptr
	.globl	assign_arg_ptr
	.type	assign_arg_ptr,@function
assign_arg_ptr:                         # @assign_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	assign_arg_ptr, .Lfunc_end0-assign_arg_ptr

	.section	.text.assign_glob_ptr,"ax",@progbits
	.hidden	assign_glob_ptr
	.globl	assign_glob_ptr
	.type	assign_glob_ptr,@function
assign_glob_ptr:                        # @assign_glob_ptr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, ptr($pop0)
	tee_local	$push3=, $0=, $pop1
	i32.eq  	$push2=, $pop3, $0
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	assign_glob_ptr, .Lfunc_end1-assign_glob_ptr

	.section	.text.assign_arg_idx,"ax",@progbits
	.hidden	assign_arg_idx
	.globl	assign_arg_idx
	.type	assign_arg_idx,@function
assign_arg_idx:                         # @assign_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	assign_arg_idx, .Lfunc_end2-assign_arg_idx

	.section	.text.assign_glob_idx,"ax",@progbits
	.hidden	assign_glob_idx
	.globl	assign_glob_idx
	.type	assign_glob_idx,@function
assign_glob_idx:                        # @assign_glob_idx
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, arrindex($pop0)
	tee_local	$push3=, $0=, $pop1
	i32.eq  	$push2=, $pop3, $0
	return  	$pop2
	.endfunc
.Lfunc_end3:
	.size	assign_glob_idx, .Lfunc_end3-assign_glob_idx

	.section	.text.preinc_arg_ptr,"ax",@progbits
	.hidden	preinc_arg_ptr
	.globl	preinc_arg_ptr
	.type	preinc_arg_ptr,@function
preinc_arg_ptr:                         # @preinc_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	preinc_arg_ptr, .Lfunc_end4-preinc_arg_ptr

	.section	.text.preinc_glob_ptr,"ax",@progbits
	.hidden	preinc_glob_ptr
	.globl	preinc_glob_ptr
	.type	preinc_glob_ptr,@function
preinc_glob_ptr:                        # @preinc_glob_ptr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, ptr($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end5:
	.size	preinc_glob_ptr, .Lfunc_end5-preinc_glob_ptr

	.section	.text.postinc_arg_ptr,"ax",@progbits
	.hidden	postinc_arg_ptr
	.globl	postinc_arg_ptr
	.type	postinc_arg_ptr,@function
postinc_arg_ptr:                        # @postinc_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	postinc_arg_ptr, .Lfunc_end6-postinc_arg_ptr

	.section	.text.postinc_glob_ptr,"ax",@progbits
	.hidden	postinc_glob_ptr
	.globl	postinc_glob_ptr
	.type	postinc_glob_ptr,@function
postinc_glob_ptr:                       # @postinc_glob_ptr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, ptr($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end7:
	.size	postinc_glob_ptr, .Lfunc_end7-postinc_glob_ptr

	.section	.text.predec_arg_ptr,"ax",@progbits
	.hidden	predec_arg_ptr
	.globl	predec_arg_ptr
	.type	predec_arg_ptr,@function
predec_arg_ptr:                         # @predec_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	predec_arg_ptr, .Lfunc_end8-predec_arg_ptr

	.section	.text.predec_glob_ptr,"ax",@progbits
	.hidden	predec_glob_ptr
	.globl	predec_glob_ptr
	.type	predec_glob_ptr,@function
predec_glob_ptr:                        # @predec_glob_ptr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, ptr($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end9:
	.size	predec_glob_ptr, .Lfunc_end9-predec_glob_ptr

	.section	.text.postdec_arg_ptr,"ax",@progbits
	.hidden	postdec_arg_ptr
	.globl	postdec_arg_ptr
	.type	postdec_arg_ptr,@function
postdec_arg_ptr:                        # @postdec_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	postdec_arg_ptr, .Lfunc_end10-postdec_arg_ptr

	.section	.text.postdec_glob_ptr,"ax",@progbits
	.hidden	postdec_glob_ptr
	.globl	postdec_glob_ptr
	.type	postdec_glob_ptr,@function
postdec_glob_ptr:                       # @postdec_glob_ptr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, ptr($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end11:
	.size	postdec_glob_ptr, .Lfunc_end11-postdec_glob_ptr

	.section	.text.preinc_arg_idx,"ax",@progbits
	.hidden	preinc_arg_idx
	.globl	preinc_arg_idx
	.type	preinc_arg_idx,@function
preinc_arg_idx:                         # @preinc_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	preinc_arg_idx, .Lfunc_end12-preinc_arg_idx

	.section	.text.preinc_glob_idx,"ax",@progbits
	.hidden	preinc_glob_idx
	.globl	preinc_glob_idx
	.type	preinc_glob_idx,@function
preinc_glob_idx:                        # @preinc_glob_idx
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push5=, arrindex($pop0)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, arrindex($pop7)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, arrindex($pop8), $pop3
	i32.eq  	$push6=, $pop5, $pop4
	return  	$pop6
	.endfunc
.Lfunc_end13:
	.size	preinc_glob_idx, .Lfunc_end13-preinc_glob_idx

	.section	.text.postinc_arg_idx,"ax",@progbits
	.hidden	postinc_arg_idx
	.globl	postinc_arg_idx
	.type	postinc_arg_idx,@function
postinc_arg_idx:                        # @postinc_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	postinc_arg_idx, .Lfunc_end14-postinc_arg_idx

	.section	.text.postinc_glob_idx,"ax",@progbits
	.hidden	postinc_glob_idx
	.globl	postinc_glob_idx
	.type	postinc_glob_idx,@function
postinc_glob_idx:                       # @postinc_glob_idx
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push5=, arrindex($pop0)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, arrindex($pop7)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, arrindex($pop8), $pop3
	i32.eq  	$push6=, $pop5, $pop4
	return  	$pop6
	.endfunc
.Lfunc_end15:
	.size	postinc_glob_idx, .Lfunc_end15-postinc_glob_idx

	.section	.text.predec_arg_idx,"ax",@progbits
	.hidden	predec_arg_idx
	.globl	predec_arg_idx
	.type	predec_arg_idx,@function
predec_arg_idx:                         # @predec_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end16:
	.size	predec_arg_idx, .Lfunc_end16-predec_arg_idx

	.section	.text.predec_glob_idx,"ax",@progbits
	.hidden	predec_glob_idx
	.globl	predec_glob_idx
	.type	predec_glob_idx,@function
predec_glob_idx:                        # @predec_glob_idx
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push5=, arrindex($pop0)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, arrindex($pop7)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, arrindex($pop8), $pop3
	i32.eq  	$push6=, $pop5, $pop4
	return  	$pop6
	.endfunc
.Lfunc_end17:
	.size	predec_glob_idx, .Lfunc_end17-predec_glob_idx

	.section	.text.postdec_arg_idx,"ax",@progbits
	.hidden	postdec_arg_idx
	.globl	postdec_arg_idx
	.type	postdec_arg_idx,@function
postdec_arg_idx:                        # @postdec_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end18:
	.size	postdec_arg_idx, .Lfunc_end18-postdec_arg_idx

	.section	.text.postdec_glob_idx,"ax",@progbits
	.hidden	postdec_glob_idx
	.globl	postdec_glob_idx
	.type	postdec_glob_idx,@function
postdec_glob_idx:                       # @postdec_glob_idx
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push5=, arrindex($pop0)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, arrindex($pop7)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, arrindex($pop8), $pop3
	i32.eq  	$push6=, $pop5, $pop4
	return  	$pop6
	.endfunc
.Lfunc_end19:
	.size	postdec_glob_idx, .Lfunc_end19-postdec_glob_idx

	.section	.text.getptr,"ax",@progbits
	.hidden	getptr
	.globl	getptr
	.type	getptr,@function
getptr:                                 # @getptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, getptrcnt($pop6)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, getptrcnt($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$push5=, $0, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end20:
	.size	getptr, .Lfunc_end20-getptr

	.section	.text.funccall_arg_ptr,"ax",@progbits
	.hidden	funccall_arg_ptr
	.globl	funccall_arg_ptr
	.type	funccall_arg_ptr,@function
funccall_arg_ptr:                       # @funccall_arg_ptr
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, getptrcnt($pop7)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, getptrcnt($pop0), $pop3
	i32.const	$push6=, 1
	i32.eq  	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end21:
	.size	funccall_arg_ptr, .Lfunc_end21-funccall_arg_ptr

	.section	.text.getint,"ax",@progbits
	.hidden	getint
	.globl	getint
	.type	getint,@function
getint:                                 # @getint
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, getintcnt($pop6)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, getintcnt($pop0), $pop3
	i32.const	$push5=, 1
	i32.add 	$push4=, $0, $pop5
	return  	$pop4
	.endfunc
.Lfunc_end22:
	.size	getint, .Lfunc_end22-getint

	.section	.text.funccall_arg_idx,"ax",@progbits
	.hidden	funccall_arg_idx
	.globl	funccall_arg_idx
	.type	funccall_arg_idx,@function
funccall_arg_idx:                       # @funccall_arg_idx
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, getintcnt($pop7)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, getintcnt($pop0), $pop3
	i32.const	$push6=, 1
	i32.eq  	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end23:
	.size	funccall_arg_idx, .Lfunc_end23-funccall_arg_idx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push42=, 0
	i32.load	$push0=, ptr($pop42)
	tee_local	$push41=, $0=, $pop0
	i32.ne  	$push5=, $pop41, $0
	br_if   	$pop5, 0        # 0: down to label0
# BB#1:                                 # %if.end4
	block
	i32.const	$push44=, 0
	i32.load	$push6=, arrindex($pop44)
	tee_local	$push43=, $0=, $pop6
	i32.ne  	$push7=, $pop43, $0
	br_if   	$pop7, 0        # 0: down to label1
# BB#2:                                 # %if.end12
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i32.load	$push8=, ptr($pop47)
	i32.const	$push46=, 4
	i32.add 	$push1=, $pop8, $pop46
	i32.store	$discard=, ptr($pop48), $pop1
	block
	i32.const	$push45=, 1
	i32.const	$push85=, 0
	i32.eq  	$push86=, $pop45, $pop85
	br_if   	$pop86, 0       # 0: down to label2
# BB#3:                                 # %if.end20
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.load	$push2=, ptr($pop51)
	i32.const	$push50=, 4
	i32.add 	$push9=, $pop2, $pop50
	i32.store	$discard=, ptr($pop52), $pop9
	block
	i32.const	$push49=, 1
	i32.const	$push87=, 0
	i32.eq  	$push88=, $pop49, $pop87
	br_if   	$pop88, 0       # 0: down to label3
# BB#4:                                 # %if.end28
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.load	$push10=, ptr($pop55)
	i32.const	$push54=, -4
	i32.add 	$push3=, $pop10, $pop54
	i32.store	$discard=, ptr($pop56), $pop3
	block
	i32.const	$push53=, 1
	i32.const	$push89=, 0
	i32.eq  	$push90=, $pop53, $pop89
	br_if   	$pop90, 0       # 0: down to label4
# BB#5:                                 # %if.end36
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.load	$push4=, ptr($pop59)
	i32.const	$push58=, -4
	i32.add 	$push11=, $pop4, $pop58
	i32.store	$discard=, ptr($pop60), $pop11
	block
	i32.const	$push57=, 1
	i32.const	$push91=, 0
	i32.eq  	$push92=, $pop57, $pop91
	br_if   	$pop92, 0       # 0: down to label5
# BB#6:                                 # %if.end44
	block
	i32.const	$push64=, 0
	i32.load	$push15=, arrindex($pop64)
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.load	$push12=, arrindex($pop62)
	i32.const	$push61=, 1
	i32.add 	$push13=, $pop12, $pop61
	i32.store	$push14=, arrindex($pop63), $pop13
	i32.ne  	$push16=, $pop15, $pop14
	br_if   	$pop16, 0       # 0: down to label6
# BB#7:                                 # %if.end52
	block
	i32.const	$push68=, 0
	i32.load	$push20=, arrindex($pop68)
	i32.const	$push67=, 0
	i32.const	$push66=, 0
	i32.load	$push17=, arrindex($pop66)
	i32.const	$push65=, 1
	i32.add 	$push18=, $pop17, $pop65
	i32.store	$push19=, arrindex($pop67), $pop18
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	$pop21, 0       # 0: down to label7
# BB#8:                                 # %if.end64
	block
	i32.const	$push72=, 0
	i32.load	$push25=, arrindex($pop72)
	i32.const	$push71=, 0
	i32.const	$push70=, 0
	i32.load	$push22=, arrindex($pop70)
	i32.const	$push69=, -1
	i32.add 	$push23=, $pop22, $pop69
	i32.store	$push24=, arrindex($pop71), $pop23
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	$pop26, 0       # 0: down to label8
# BB#9:                                 # %if.end72
	block
	i32.const	$push76=, 0
	i32.load	$push30=, arrindex($pop76)
	i32.const	$push75=, 0
	i32.const	$push74=, 0
	i32.load	$push27=, arrindex($pop74)
	i32.const	$push73=, -1
	i32.add 	$push28=, $pop27, $pop73
	i32.store	$push29=, arrindex($pop75), $pop28
	i32.ne  	$push31=, $pop30, $pop29
	br_if   	$pop31, 0       # 0: down to label9
# BB#10:                                # %if.end76
	block
	i32.const	$push80=, 0
	i32.const	$push79=, 0
	i32.load	$push32=, getptrcnt($pop79)
	i32.const	$push78=, 1
	i32.add 	$push33=, $pop32, $pop78
	i32.store	$push34=, getptrcnt($pop80), $pop33
	i32.const	$push77=, 1
	i32.ne  	$push35=, $pop34, $pop77
	br_if   	$pop35, 0       # 0: down to label10
# BB#11:                                # %if.end80
	block
	i32.const	$push84=, 0
	i32.const	$push83=, 0
	i32.load	$push36=, getintcnt($pop83)
	i32.const	$push82=, 1
	i32.add 	$push37=, $pop36, $pop82
	i32.store	$push38=, getintcnt($pop84), $pop37
	i32.const	$push81=, 1
	i32.ne  	$push39=, $pop38, $pop81
	br_if   	$pop39, 0       # 0: down to label11
# BB#12:                                # %if.end84
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
	unreachable
.LBB24_13:                              # %if.then83
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB24_14:                              # %if.then79
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB24_15:                              # %if.then75
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB24_16:                              # %if.then67
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB24_17:                              # %if.then59
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB24_18:                              # %if.then51
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB24_19:                              # %if.then43
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB24_20:                              # %if.then35
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB24_21:                              # %if.then27
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB24_22:                              # %if.then19
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB24_23:                              # %if.then11
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB24_24:                              # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end24:
	.size	main, .Lfunc_end24-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.p2align	4
arr:
	.skip	400
	.size	arr, 400

	.hidden	ptr                     # @ptr
	.type	ptr,@object
	.section	.data.ptr,"aw",@progbits
	.globl	ptr
	.p2align	2
ptr:
	.int32	arr+80
	.size	ptr, 4

	.hidden	arrindex                # @arrindex
	.type	arrindex,@object
	.section	.data.arrindex,"aw",@progbits
	.globl	arrindex
	.p2align	2
arrindex:
	.int32	4                       # 0x4
	.size	arrindex, 4

	.hidden	getptrcnt               # @getptrcnt
	.type	getptrcnt,@object
	.section	.bss.getptrcnt,"aw",@nobits
	.globl	getptrcnt
	.p2align	2
getptrcnt:
	.int32	0                       # 0x0
	.size	getptrcnt, 4

	.hidden	getintcnt               # @getintcnt
	.type	getintcnt,@object
	.section	.bss.getintcnt,"aw",@nobits
	.globl	getintcnt
	.p2align	2
getintcnt:
	.int32	0                       # 0x0
	.size	getintcnt, 4


	.ident	"clang version 3.9.0 "
