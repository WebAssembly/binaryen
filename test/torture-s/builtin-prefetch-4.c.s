	.text
	.file	"builtin-prefetch-4.c"
	.section	.text.assign_arg_ptr,"ax",@progbits
	.hidden	assign_arg_ptr          # -- Begin function assign_arg_ptr
	.globl	assign_arg_ptr
	.type	assign_arg_ptr,@function
assign_arg_ptr:                         # @assign_arg_ptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	assign_arg_ptr, .Lfunc_end0-assign_arg_ptr
                                        # -- End function
	.section	.text.assign_glob_ptr,"ax",@progbits
	.hidden	assign_glob_ptr         # -- Begin function assign_glob_ptr
	.globl	assign_glob_ptr
	.type	assign_glob_ptr,@function
assign_glob_ptr:                        # @assign_glob_ptr
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	assign_glob_ptr, .Lfunc_end1-assign_glob_ptr
                                        # -- End function
	.section	.text.assign_arg_idx,"ax",@progbits
	.hidden	assign_arg_idx          # -- Begin function assign_arg_idx
	.globl	assign_arg_idx
	.type	assign_arg_idx,@function
assign_arg_idx:                         # @assign_arg_idx
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	assign_arg_idx, .Lfunc_end2-assign_arg_idx
                                        # -- End function
	.section	.text.assign_glob_idx,"ax",@progbits
	.hidden	assign_glob_idx         # -- Begin function assign_glob_idx
	.globl	assign_glob_idx
	.type	assign_glob_idx,@function
assign_glob_idx:                        # @assign_glob_idx
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	assign_glob_idx, .Lfunc_end3-assign_glob_idx
                                        # -- End function
	.section	.text.preinc_arg_ptr,"ax",@progbits
	.hidden	preinc_arg_ptr          # -- Begin function preinc_arg_ptr
	.globl	preinc_arg_ptr
	.type	preinc_arg_ptr,@function
preinc_arg_ptr:                         # @preinc_arg_ptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	preinc_arg_ptr, .Lfunc_end4-preinc_arg_ptr
                                        # -- End function
	.section	.text.preinc_glob_ptr,"ax",@progbits
	.hidden	preinc_glob_ptr         # -- Begin function preinc_glob_ptr
	.globl	preinc_glob_ptr
	.type	preinc_glob_ptr,@function
preinc_glob_ptr:                        # @preinc_glob_ptr
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end5:
	.size	preinc_glob_ptr, .Lfunc_end5-preinc_glob_ptr
                                        # -- End function
	.section	.text.postinc_arg_ptr,"ax",@progbits
	.hidden	postinc_arg_ptr         # -- Begin function postinc_arg_ptr
	.globl	postinc_arg_ptr
	.type	postinc_arg_ptr,@function
postinc_arg_ptr:                        # @postinc_arg_ptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	postinc_arg_ptr, .Lfunc_end6-postinc_arg_ptr
                                        # -- End function
	.section	.text.postinc_glob_ptr,"ax",@progbits
	.hidden	postinc_glob_ptr        # -- Begin function postinc_glob_ptr
	.globl	postinc_glob_ptr
	.type	postinc_glob_ptr,@function
postinc_glob_ptr:                       # @postinc_glob_ptr
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end7:
	.size	postinc_glob_ptr, .Lfunc_end7-postinc_glob_ptr
                                        # -- End function
	.section	.text.predec_arg_ptr,"ax",@progbits
	.hidden	predec_arg_ptr          # -- Begin function predec_arg_ptr
	.globl	predec_arg_ptr
	.type	predec_arg_ptr,@function
predec_arg_ptr:                         # @predec_arg_ptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	predec_arg_ptr, .Lfunc_end8-predec_arg_ptr
                                        # -- End function
	.section	.text.predec_glob_ptr,"ax",@progbits
	.hidden	predec_glob_ptr         # -- Begin function predec_glob_ptr
	.globl	predec_glob_ptr
	.type	predec_glob_ptr,@function
predec_glob_ptr:                        # @predec_glob_ptr
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end9:
	.size	predec_glob_ptr, .Lfunc_end9-predec_glob_ptr
                                        # -- End function
	.section	.text.postdec_arg_ptr,"ax",@progbits
	.hidden	postdec_arg_ptr         # -- Begin function postdec_arg_ptr
	.globl	postdec_arg_ptr
	.type	postdec_arg_ptr,@function
postdec_arg_ptr:                        # @postdec_arg_ptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	postdec_arg_ptr, .Lfunc_end10-postdec_arg_ptr
                                        # -- End function
	.section	.text.postdec_glob_ptr,"ax",@progbits
	.hidden	postdec_glob_ptr        # -- Begin function postdec_glob_ptr
	.globl	postdec_glob_ptr
	.type	postdec_glob_ptr,@function
postdec_glob_ptr:                       # @postdec_glob_ptr
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, ptr($pop5)
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ptr($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end11:
	.size	postdec_glob_ptr, .Lfunc_end11-postdec_glob_ptr
                                        # -- End function
	.section	.text.preinc_arg_idx,"ax",@progbits
	.hidden	preinc_arg_idx          # -- Begin function preinc_arg_idx
	.globl	preinc_arg_idx
	.type	preinc_arg_idx,@function
preinc_arg_idx:                         # @preinc_arg_idx
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end12:
	.size	preinc_arg_idx, .Lfunc_end12-preinc_arg_idx
                                        # -- End function
	.section	.text.preinc_glob_idx,"ax",@progbits
	.hidden	preinc_glob_idx         # -- Begin function preinc_glob_idx
	.globl	preinc_glob_idx
	.type	preinc_glob_idx,@function
preinc_glob_idx:                        # @preinc_glob_idx
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end13:
	.size	preinc_glob_idx, .Lfunc_end13-preinc_glob_idx
                                        # -- End function
	.section	.text.postinc_arg_idx,"ax",@progbits
	.hidden	postinc_arg_idx         # -- Begin function postinc_arg_idx
	.globl	postinc_arg_idx
	.type	postinc_arg_idx,@function
postinc_arg_idx:                        # @postinc_arg_idx
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end14:
	.size	postinc_arg_idx, .Lfunc_end14-postinc_arg_idx
                                        # -- End function
	.section	.text.postinc_glob_idx,"ax",@progbits
	.hidden	postinc_glob_idx        # -- Begin function postinc_glob_idx
	.globl	postinc_glob_idx
	.type	postinc_glob_idx,@function
postinc_glob_idx:                       # @postinc_glob_idx
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end15:
	.size	postinc_glob_idx, .Lfunc_end15-postinc_glob_idx
                                        # -- End function
	.section	.text.predec_arg_idx,"ax",@progbits
	.hidden	predec_arg_idx          # -- Begin function predec_arg_idx
	.globl	predec_arg_idx
	.type	predec_arg_idx,@function
predec_arg_idx:                         # @predec_arg_idx
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	predec_arg_idx, .Lfunc_end16-predec_arg_idx
                                        # -- End function
	.section	.text.predec_glob_idx,"ax",@progbits
	.hidden	predec_glob_idx         # -- Begin function predec_glob_idx
	.globl	predec_glob_idx
	.type	predec_glob_idx,@function
predec_glob_idx:                        # @predec_glob_idx
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end17:
	.size	predec_glob_idx, .Lfunc_end17-predec_glob_idx
                                        # -- End function
	.section	.text.postdec_arg_idx,"ax",@progbits
	.hidden	postdec_arg_idx         # -- Begin function postdec_arg_idx
	.globl	postdec_arg_idx
	.type	postdec_arg_idx,@function
postdec_arg_idx:                        # @postdec_arg_idx
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end18:
	.size	postdec_arg_idx, .Lfunc_end18-postdec_arg_idx
                                        # -- End function
	.section	.text.postdec_glob_idx,"ax",@progbits
	.hidden	postdec_glob_idx        # -- Begin function postdec_glob_idx
	.globl	postdec_glob_idx
	.type	postdec_glob_idx,@function
postdec_glob_idx:                       # @postdec_glob_idx
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, arrindex($pop5)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	arrindex($pop0), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end19:
	.size	postdec_glob_idx, .Lfunc_end19-postdec_glob_idx
                                        # -- End function
	.section	.text.getptr,"ax",@progbits
	.hidden	getptr                  # -- Begin function getptr
	.globl	getptr
	.type	getptr,@function
getptr:                                 # @getptr
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, getptrcnt($pop6)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	getptrcnt($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$push5=, $0, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end20:
	.size	getptr, .Lfunc_end20-getptr
                                        # -- End function
	.section	.text.funccall_arg_ptr,"ax",@progbits
	.hidden	funccall_arg_ptr        # -- Begin function funccall_arg_ptr
	.globl	funccall_arg_ptr
	.type	funccall_arg_ptr,@function
funccall_arg_ptr:                       # @funccall_arg_ptr
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, getptrcnt($pop0)
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $1, $pop1
	i32.store	getptrcnt($pop4), $pop2
	i32.eqz 	$push3=, $1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end21:
	.size	funccall_arg_ptr, .Lfunc_end21-funccall_arg_ptr
                                        # -- End function
	.section	.text.getint,"ax",@progbits
	.hidden	getint                  # -- Begin function getint
	.globl	getint
	.type	getint,@function
getint:                                 # @getint
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, getintcnt($pop6)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	getintcnt($pop0), $pop3
	i32.const	$push5=, 1
	i32.add 	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end22:
	.size	getint, .Lfunc_end22-getint
                                        # -- End function
	.section	.text.funccall_arg_idx,"ax",@progbits
	.hidden	funccall_arg_idx        # -- Begin function funccall_arg_idx
	.globl	funccall_arg_idx
	.type	funccall_arg_idx,@function
funccall_arg_idx:                       # @funccall_arg_idx
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$2=, getintcnt($pop0)
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $2, $pop1
	i32.store	getintcnt($pop4), $pop2
	i32.eqz 	$push3=, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end23:
	.size	funccall_arg_idx, .Lfunc_end23-funccall_arg_idx
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.end76
	i32.const	$push5=, 0
	i32.load	$0=, getptrcnt($pop5)
	i32.const	$push4=, 0
	i32.const	$push3=, 1
	i32.add 	$push0=, $0, $pop3
	i32.store	getptrcnt($pop4), $pop0
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end80
	i32.const	$push8=, 0
	i32.load	$0=, getintcnt($pop8)
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.add 	$push1=, $0, $pop6
	i32.store	getintcnt($pop7), $pop1
	br_if   	0, $0           # 0: down to label0
# %bb.2:                                # %if.end84
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB24_3:                               # %if.then79
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end24:
	.size	main, .Lfunc_end24-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
