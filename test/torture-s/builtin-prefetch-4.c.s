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
	i32.load	$0=, ptr($pop0)
	i32.eq  	$push1=, $0, $0
	return  	$pop1
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
	i32.load	$0=, arrindex($pop0)
	i32.eq  	$push1=, $0, $0
	return  	$pop1
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
.Lfunc_end4:
	.size	preinc_arg_ptr, .Lfunc_end4-preinc_arg_ptr

	.section	.text.preinc_glob_ptr,"ax",@progbits
	.hidden	preinc_glob_ptr
	.globl	preinc_glob_ptr
	.type	preinc_glob_ptr,@function
preinc_glob_ptr:                        # @preinc_glob_ptr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, ptr($0)
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, ptr($0), $pop2
	i32.const	$push3=, 1
	return  	$pop3
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
.Lfunc_end6:
	.size	postinc_arg_ptr, .Lfunc_end6-postinc_arg_ptr

	.section	.text.postinc_glob_ptr,"ax",@progbits
	.hidden	postinc_glob_ptr
	.globl	postinc_glob_ptr
	.type	postinc_glob_ptr,@function
postinc_glob_ptr:                       # @postinc_glob_ptr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, ptr($0)
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, ptr($0), $pop2
	i32.const	$push3=, 1
	return  	$pop3
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
.Lfunc_end8:
	.size	predec_arg_ptr, .Lfunc_end8-predec_arg_ptr

	.section	.text.predec_glob_ptr,"ax",@progbits
	.hidden	predec_glob_ptr
	.globl	predec_glob_ptr
	.type	predec_glob_ptr,@function
predec_glob_ptr:                        # @predec_glob_ptr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, ptr($0)
	i32.const	$push1=, -4
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, ptr($0), $pop2
	i32.const	$push3=, 1
	return  	$pop3
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
.Lfunc_end10:
	.size	postdec_arg_ptr, .Lfunc_end10-postdec_arg_ptr

	.section	.text.postdec_glob_ptr,"ax",@progbits
	.hidden	postdec_glob_ptr
	.globl	postdec_glob_ptr
	.type	postdec_glob_ptr,@function
postdec_glob_ptr:                       # @postdec_glob_ptr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, ptr($0)
	i32.const	$push1=, -4
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, ptr($0), $pop2
	i32.const	$push3=, 1
	return  	$pop3
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
.Lfunc_end12:
	.size	preinc_arg_idx, .Lfunc_end12-preinc_arg_idx

	.section	.text.preinc_glob_idx,"ax",@progbits
	.hidden	preinc_glob_idx
	.globl	preinc_glob_idx
	.type	preinc_glob_idx,@function
preinc_glob_idx:                        # @preinc_glob_idx
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, arrindex($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$1=, arrindex($0), $pop2
	i32.load	$push3=, arrindex($0)
	i32.eq  	$push4=, $pop3, $1
	return  	$pop4
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
.Lfunc_end14:
	.size	postinc_arg_idx, .Lfunc_end14-postinc_arg_idx

	.section	.text.postinc_glob_idx,"ax",@progbits
	.hidden	postinc_glob_idx
	.globl	postinc_glob_idx
	.type	postinc_glob_idx,@function
postinc_glob_idx:                       # @postinc_glob_idx
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, arrindex($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$1=, arrindex($0), $pop2
	i32.load	$push3=, arrindex($0)
	i32.eq  	$push4=, $pop3, $1
	return  	$pop4
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
.Lfunc_end16:
	.size	predec_arg_idx, .Lfunc_end16-predec_arg_idx

	.section	.text.predec_glob_idx,"ax",@progbits
	.hidden	predec_glob_idx
	.globl	predec_glob_idx
	.type	predec_glob_idx,@function
predec_glob_idx:                        # @predec_glob_idx
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, arrindex($0)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$1=, arrindex($0), $pop2
	i32.load	$push3=, arrindex($0)
	i32.eq  	$push4=, $pop3, $1
	return  	$pop4
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
.Lfunc_end18:
	.size	postdec_arg_idx, .Lfunc_end18-postdec_arg_idx

	.section	.text.postdec_glob_idx,"ax",@progbits
	.hidden	postdec_glob_idx
	.globl	postdec_glob_idx
	.type	postdec_glob_idx,@function
postdec_glob_idx:                       # @postdec_glob_idx
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, arrindex($0)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$1=, arrindex($0), $pop2
	i32.load	$push3=, arrindex($0)
	i32.eq  	$push4=, $pop3, $1
	return  	$pop4
.Lfunc_end19:
	.size	postdec_glob_idx, .Lfunc_end19-postdec_glob_idx

	.section	.text.getptr,"ax",@progbits
	.hidden	getptr
	.globl	getptr
	.type	getptr,@function
getptr:                                 # @getptr
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, getptrcnt($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, getptrcnt($1), $pop2
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	return  	$pop4
.Lfunc_end20:
	.size	getptr, .Lfunc_end20-getptr

	.section	.text.funccall_arg_ptr,"ax",@progbits
	.hidden	funccall_arg_ptr
	.globl	funccall_arg_ptr
	.type	funccall_arg_ptr,@function
funccall_arg_ptr:                       # @funccall_arg_ptr
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 1
	i32.load	$push0=, getptrcnt($1)
	i32.add 	$push1=, $pop0, $2
	i32.store	$push2=, getptrcnt($1), $pop1
	i32.eq  	$push3=, $pop2, $2
	return  	$pop3
.Lfunc_end21:
	.size	funccall_arg_ptr, .Lfunc_end21-funccall_arg_ptr

	.section	.text.getint,"ax",@progbits
	.hidden	getint
	.globl	getint
	.type	getint,@function
getint:                                 # @getint
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 1
	i32.load	$push0=, getintcnt($1)
	i32.add 	$push1=, $pop0, $2
	i32.store	$discard=, getintcnt($1), $pop1
	i32.add 	$push2=, $0, $2
	return  	$pop2
.Lfunc_end22:
	.size	getint, .Lfunc_end22-getint

	.section	.text.funccall_arg_idx,"ax",@progbits
	.hidden	funccall_arg_idx
	.globl	funccall_arg_idx
	.type	funccall_arg_idx,@function
funccall_arg_idx:                       # @funccall_arg_idx
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$3=, 1
	i32.load	$push0=, getintcnt($2)
	i32.add 	$push1=, $pop0, $3
	i32.store	$push2=, getintcnt($2), $pop1
	i32.eq  	$push3=, $pop2, $3
	return  	$pop3
.Lfunc_end23:
	.size	funccall_arg_idx, .Lfunc_end23-funccall_arg_idx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, ptr($1)
	block   	.LBB24_24
	i32.ne  	$push4=, $0, $0
	br_if   	$pop4, .LBB24_24
# BB#1:                                 # %if.end4
	i32.load	$0=, arrindex($1)
	block   	.LBB24_23
	i32.ne  	$push5=, $0, $0
	br_if   	$pop5, .LBB24_23
# BB#2:                                 # %if.end12
	i32.const	$2=, 4
	i32.load	$push6=, ptr($1)
	i32.add 	$push0=, $pop6, $2
	i32.store	$discard=, ptr($1), $pop0
	i32.const	$0=, 1
	block   	.LBB24_22
	i32.const	$push34=, 0
	i32.eq  	$push35=, $0, $pop34
	br_if   	$pop35, .LBB24_22
# BB#3:                                 # %if.end20
	block   	.LBB24_21
	i32.load	$push1=, ptr($1)
	i32.add 	$push7=, $pop1, $2
	i32.store	$discard=, ptr($1), $pop7
	i32.const	$push36=, 0
	i32.eq  	$push37=, $0, $pop36
	br_if   	$pop37, .LBB24_21
# BB#4:                                 # %if.end28
	i32.const	$2=, -4
	block   	.LBB24_20
	i32.load	$push8=, ptr($1)
	i32.add 	$push2=, $pop8, $2
	i32.store	$discard=, ptr($1), $pop2
	i32.const	$push38=, 0
	i32.eq  	$push39=, $0, $pop38
	br_if   	$pop39, .LBB24_20
# BB#5:                                 # %if.end36
	block   	.LBB24_19
	i32.load	$push3=, ptr($1)
	i32.add 	$push9=, $pop3, $2
	i32.store	$discard=, ptr($1), $pop9
	i32.const	$push40=, 0
	i32.eq  	$push41=, $0, $pop40
	br_if   	$pop41, .LBB24_19
# BB#6:                                 # %if.end44
	block   	.LBB24_18
	i32.load	$push10=, arrindex($1)
	i32.add 	$push11=, $pop10, $0
	i32.store	$2=, arrindex($1), $pop11
	i32.load	$push12=, arrindex($1)
	i32.ne  	$push13=, $pop12, $2
	br_if   	$pop13, .LBB24_18
# BB#7:                                 # %if.end52
	block   	.LBB24_17
	i32.load	$push14=, arrindex($1)
	i32.add 	$push15=, $pop14, $0
	i32.store	$2=, arrindex($1), $pop15
	i32.load	$push16=, arrindex($1)
	i32.ne  	$push17=, $pop16, $2
	br_if   	$pop17, .LBB24_17
# BB#8:                                 # %if.end64
	i32.const	$2=, -1
	block   	.LBB24_16
	i32.load	$push18=, arrindex($1)
	i32.add 	$push19=, $pop18, $2
	i32.store	$3=, arrindex($1), $pop19
	i32.load	$push20=, arrindex($1)
	i32.ne  	$push21=, $pop20, $3
	br_if   	$pop21, .LBB24_16
# BB#9:                                 # %if.end72
	block   	.LBB24_15
	i32.load	$push22=, arrindex($1)
	i32.add 	$push23=, $pop22, $2
	i32.store	$2=, arrindex($1), $pop23
	i32.load	$push24=, arrindex($1)
	i32.ne  	$push25=, $pop24, $2
	br_if   	$pop25, .LBB24_15
# BB#10:                                # %if.end76
	block   	.LBB24_14
	i32.load	$push26=, getptrcnt($1)
	i32.add 	$push27=, $pop26, $0
	i32.store	$push28=, getptrcnt($1), $pop27
	i32.ne  	$push29=, $pop28, $0
	br_if   	$pop29, .LBB24_14
# BB#11:                                # %if.end80
	block   	.LBB24_13
	i32.load	$push30=, getintcnt($1)
	i32.add 	$push31=, $pop30, $0
	i32.store	$push32=, getintcnt($1), $pop31
	i32.ne  	$push33=, $pop32, $0
	br_if   	$pop33, .LBB24_13
# BB#12:                                # %if.end84
	call    	exit@FUNCTION, $1
	unreachable
.LBB24_13:                              # %if.then83
	call    	abort@FUNCTION
	unreachable
.LBB24_14:                              # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB24_15:                              # %if.then75
	call    	abort@FUNCTION
	unreachable
.LBB24_16:                              # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB24_17:                              # %if.then59
	call    	abort@FUNCTION
	unreachable
.LBB24_18:                              # %if.then51
	call    	abort@FUNCTION
	unreachable
.LBB24_19:                              # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB24_20:                              # %if.then35
	call    	abort@FUNCTION
	unreachable
.LBB24_21:                              # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB24_22:                              # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB24_23:                              # %if.then11
	call    	abort@FUNCTION
	unreachable
.LBB24_24:                              # %if.then3
	call    	abort@FUNCTION
	unreachable
.Lfunc_end24:
	.size	main, .Lfunc_end24-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.align	4
arr:
	.skip	400
	.size	arr, 400

	.hidden	ptr                     # @ptr
	.type	ptr,@object
	.section	.data.ptr,"aw",@progbits
	.globl	ptr
	.align	2
ptr:
	.int32	arr+80
	.size	ptr, 4

	.hidden	arrindex                # @arrindex
	.type	arrindex,@object
	.section	.data.arrindex,"aw",@progbits
	.globl	arrindex
	.align	2
arrindex:
	.int32	4                       # 0x4
	.size	arrindex, 4

	.hidden	getptrcnt               # @getptrcnt
	.type	getptrcnt,@object
	.section	.bss.getptrcnt,"aw",@nobits
	.globl	getptrcnt
	.align	2
getptrcnt:
	.int32	0                       # 0x0
	.size	getptrcnt, 4

	.hidden	getintcnt               # @getintcnt
	.type	getintcnt,@object
	.section	.bss.getintcnt,"aw",@nobits
	.globl	getintcnt
	.align	2
getintcnt:
	.int32	0                       # 0x0
	.size	getintcnt, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
