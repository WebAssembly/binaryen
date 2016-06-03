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
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return: $pop1
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
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return: $pop1
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
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
	i32.store	$drop=, getptrcnt($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$push5=, $0, $pop4
                                        # fallthrough-return: $pop5
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
	i32.const	$push6=, 0
	i32.load	$push5=, getptrcnt($pop6)
	tee_local	$push4=, $1=, $pop5
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop4, $pop1
	i32.store	$drop=, getptrcnt($pop0), $pop2
	i32.eqz 	$push3=, $1
                                        # fallthrough-return: $pop3
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
	i32.store	$drop=, getintcnt($pop0), $pop3
	i32.const	$push5=, 1
	i32.add 	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
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
	i32.const	$push1=, 0
	i32.const	$push7=, 0
	i32.load	$push2=, getintcnt($pop7)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$push0=, getintcnt($pop1), $pop4
	i32.const	$push6=, 1
	i32.eq  	$push5=, $pop0, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end23:
	.size	funccall_arg_idx, .Lfunc_end23-funccall_arg_idx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push10=, 0
	i32.load	$push9=, ptr($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.ne  	$push1=, $pop8, $1
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end4
	i32.const	$push13=, 0
	i32.load	$push12=, arrindex($pop13)
	tee_local	$push11=, $1=, $pop12
	i32.ne  	$push2=, $pop11, $1
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %if.end44
	i32.const	$push16=, 0
	i32.const	$push15=, 1
	i32.add 	$push0=, $1, $pop15
	i32.store	$0=, arrindex($pop16), $pop0
	i32.const	$push14=, 1
	i32.eqz 	$push33=, $pop14
	br_if   	0, $pop33       # 0: down to label0
# BB#3:                                 # %if.end52
	i32.const	$push18=, 0
	i32.const	$push3=, 2
	i32.add 	$push4=, $1, $pop3
	i32.store	$drop=, arrindex($pop18), $pop4
	i32.const	$push17=, 1
	i32.eqz 	$push34=, $pop17
	br_if   	0, $pop34       # 0: down to label0
# BB#4:                                 # %if.end64
	i32.const	$push20=, 0
	i32.store	$drop=, arrindex($pop20), $0
	i32.const	$push19=, 1
	i32.eqz 	$push35=, $pop19
	br_if   	0, $pop35       # 0: down to label0
# BB#5:                                 # %if.end72
	i32.const	$push22=, 0
	i32.store	$drop=, arrindex($pop22), $1
	i32.const	$push21=, 1
	i32.eqz 	$push36=, $pop21
	br_if   	0, $pop36       # 0: down to label0
# BB#6:                                 # %if.end76
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load	$push25=, getptrcnt($pop26)
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, 1
	i32.add 	$push5=, $pop24, $pop23
	i32.store	$drop=, getptrcnt($pop27), $pop5
	br_if   	0, $1           # 0: down to label0
# BB#7:                                 # %if.end80
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.load	$push30=, getintcnt($pop31)
	tee_local	$push29=, $1=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push6=, $pop29, $pop28
	i32.store	$drop=, getintcnt($pop32), $pop6
	br_if   	0, $1           # 0: down to label0
# BB#8:                                 # %if.end84
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB24_9:                               # %if.then83
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
	.functype	abort, void
	.functype	exit, void, i32
