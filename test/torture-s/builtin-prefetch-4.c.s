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
	i32.load	$push3=, ptr($pop0)
	tee_local	$push2=, $0=, $pop3
	i32.eq  	$push1=, $pop2, $0
	return  	$pop1
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
	i32.load	$push3=, arrindex($pop0)
	tee_local	$push2=, $0=, $pop3
	i32.eq  	$push1=, $pop2, $0
	return  	$pop1
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
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
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
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
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
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
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
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, getptrcnt($pop7)
	i32.const	$push2=, 1
	i32.add 	$push6=, $pop1, $pop2
	tee_local	$push5=, $1=, $pop6
	i32.store	$discard=, getptrcnt($pop0), $pop5
	i32.const	$push4=, 1
	i32.eq  	$push3=, $1, $pop4
	return  	$pop3
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, getintcnt($pop7)
	i32.const	$push2=, 1
	i32.add 	$push6=, $pop1, $pop2
	tee_local	$push5=, $2=, $pop6
	i32.store	$discard=, getintcnt($pop0), $pop5
	i32.const	$push4=, 1
	i32.eq  	$push3=, $2, $pop4
	return  	$pop3
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
	i32.const	$push29=, 0
	i32.load	$push28=, ptr($pop29)
	tee_local	$push27=, $0=, $pop28
	i32.ne  	$push6=, $pop27, $0
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end4
	i32.const	$push32=, 0
	i32.load	$push31=, arrindex($pop32)
	tee_local	$push30=, $0=, $pop31
	i32.ne  	$push7=, $pop30, $0
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end12
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push8=, ptr($pop35)
	i32.const	$push34=, 4
	i32.add 	$push2=, $pop8, $pop34
	i32.store	$discard=, ptr($pop36), $pop2
	i32.const	$push33=, 1
	i32.const	$push73=, 0
	i32.eq  	$push74=, $pop33, $pop73
	br_if   	0, $pop74       # 0: down to label0
# BB#3:                                 # %if.end20
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load	$push3=, ptr($pop39)
	i32.const	$push38=, 4
	i32.add 	$push9=, $pop3, $pop38
	i32.store	$discard=, ptr($pop40), $pop9
	i32.const	$push37=, 1
	i32.const	$push75=, 0
	i32.eq  	$push76=, $pop37, $pop75
	br_if   	0, $pop76       # 0: down to label0
# BB#4:                                 # %if.end28
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.load	$push10=, ptr($pop43)
	i32.const	$push42=, -4
	i32.add 	$push4=, $pop10, $pop42
	i32.store	$discard=, ptr($pop44), $pop4
	i32.const	$push41=, 1
	i32.const	$push77=, 0
	i32.eq  	$push78=, $pop41, $pop77
	br_if   	0, $pop78       # 0: down to label0
# BB#5:                                 # %if.end36
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i32.load	$push5=, ptr($pop47)
	i32.const	$push46=, -4
	i32.add 	$push11=, $pop5, $pop46
	i32.store	$discard=, ptr($pop48), $pop11
	i32.const	$push45=, 1
	i32.const	$push79=, 0
	i32.eq  	$push80=, $pop45, $pop79
	br_if   	0, $pop80       # 0: down to label0
# BB#6:                                 # %if.end44
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.load	$push12=, arrindex($pop51)
	i32.const	$push50=, 1
	i32.add 	$push13=, $pop12, $pop50
	i32.store	$discard=, arrindex($pop52), $pop13
	i32.const	$push49=, 1
	i32.const	$push81=, 0
	i32.eq  	$push82=, $pop49, $pop81
	br_if   	0, $pop82       # 0: down to label0
# BB#7:                                 # %if.end52
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.load	$push14=, arrindex($pop55)
	i32.const	$push54=, 1
	i32.add 	$push15=, $pop14, $pop54
	i32.store	$discard=, arrindex($pop56), $pop15
	i32.const	$push53=, 1
	i32.const	$push83=, 0
	i32.eq  	$push84=, $pop53, $pop83
	br_if   	0, $pop84       # 0: down to label0
# BB#8:                                 # %if.end64
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.load	$push16=, arrindex($pop59)
	i32.const	$push58=, -1
	i32.add 	$push17=, $pop16, $pop58
	i32.store	$discard=, arrindex($pop60), $pop17
	i32.const	$push57=, 1
	i32.const	$push85=, 0
	i32.eq  	$push86=, $pop57, $pop85
	br_if   	0, $pop86       # 0: down to label0
# BB#9:                                 # %if.end72
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i32.load	$push18=, arrindex($pop63)
	i32.const	$push62=, -1
	i32.add 	$push19=, $pop18, $pop62
	i32.store	$discard=, arrindex($pop64), $pop19
	i32.const	$push61=, 1
	i32.const	$push87=, 0
	i32.eq  	$push88=, $pop61, $pop87
	br_if   	0, $pop88       # 0: down to label0
# BB#10:                                # %if.end76
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.load	$push20=, getptrcnt($pop67)
	i32.const	$push66=, 1
	i32.add 	$push21=, $pop20, $pop66
	i32.store	$push0=, getptrcnt($pop68), $pop21
	i32.const	$push65=, 1
	i32.ne  	$push22=, $pop0, $pop65
	br_if   	0, $pop22       # 0: down to label0
# BB#11:                                # %if.end80
	i32.const	$push72=, 0
	i32.const	$push71=, 0
	i32.load	$push23=, getintcnt($pop71)
	i32.const	$push70=, 1
	i32.add 	$push24=, $pop23, $pop70
	i32.store	$push1=, getintcnt($pop72), $pop24
	i32.const	$push69=, 1
	i32.ne  	$push25=, $pop1, $pop69
	br_if   	0, $pop25       # 0: down to label0
# BB#12:                                # %if.end84
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB24_13:                              # %if.then83
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
