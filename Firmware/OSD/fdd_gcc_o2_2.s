#NO_APP
	.file	"fdd.c"
	.text
	.align	2
	.globl	SendSector
	.type	SendSector, @function
SendSector:
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%sp),%a2
	move.b 19(%sp),%d0
	moveq #0,%d1
	move.b %d0,%d1
	moveq #11,%d2
	sub.l %d1,%d2
	move.l %d2,%d1
	asr.l #1,%d1
	moveq #11,%d2
	sub.b %d0,%d2
	move.b %d2,%d0
	eor.b %d1,%d0
	or.b #-86,%d0
	move.b %d0,14303232
	lea (3,%a2),%a0
	lea (515,%a2),%a1
	clr.b %d2
.L2:
	move.b (%a0),%d1
	move.b %d1,%d0
	lsr.b #1,%d0
	eor.b %d1,%d0
	eor.b %d0,%d2
	addq.l #4,%a0
	cmp.l %a0,%a1
	jne .L2
	or.b #-86,%d2
	move.b %d2,14303232
	move.l %a2,%d1
	add.l #512,%d1
	move.l %a2,%a1
.L3:
	move.b (%a1)+,%d0
	lsr.b #1,%d0
	or.b #-86,%d0
	move.b %d0,14303232
	cmp.l %a1,%d1
	jne .L3
	move.l %a2,%a0
.L4:
	move.b (%a0)+,%d0
	or.b #-86,%d0
	move.b %d0,14303232
	cmp.l %a0,%d1
	jne .L4
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	rts
	.size	SendSector, .-SendSector
	.align	2
	.globl	SendGap
	.type	SendGap, @function
SendGap:
	move.b #-86,14303232
	rts
	.size	SendGap, .-SendGap
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Illegal track read: %d\r"
.LC1:
	.string	"    Illegal track read!"
.LC2:
	.string	"*%u:"
.LC3:
	.string	"(%u)[%04X]:"
.LC4:
	.string	"%X:%04X"
.LC5:
	.string	":OK\r"
	.text
	.align	2
	.globl	ReadTrack
	.type	ReadTrack, @function
ReadTrack:
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%sp),%a2
	move.b 671(%a2),%d0
	cmp.b 1(%a2),%d0
	jcc .L20
	tst.b DEBUG
	jne .L21
.L13:
	cmp.b 672(%a2),%d0
	jeq .L14
.L24:
	move.b %d0,672(%a2)
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),%a0
	move.l %a0,file+28
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,file+20
	clr.b 670(%a2)
	move.l %a0,666(%a2)
	clr.b %d2
	move.w #16,14303236
	clr.b 14303232
	move.w #17,14303236
	tst.b DEBUG
	jne .L22
.L16:
	pea sector_buffer
	pea file
	jsr FileRead
	move.w #16,14303236
	clr.b 14303232
	addq.l #8,%sp
	tst.b DEBUG
	jne .L23
	move.w #17,14303236
.L11:
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	rts
.L23:
	clr.l -(%sp)
	and.l #255,%d2
	move.l %d2,-(%sp)
	pea .LC4
	jsr printf
	move.w #17,14303236
	lea (12,%sp),%sp
	tst.b DEBUG
	jeq .L11
	move.l #.LC5,12(%sp)
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	jra printf
.L22:
	clr.l -(%sp)
	clr.l -(%sp)
	pea .LC3
	jsr printf
	lea (12,%sp),%sp
	jra .L16
.L21:
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC2
	jsr printf
	move.b 671(%a2),%d0
	addq.l #8,%sp
	cmp.b 672(%a2),%d0
	jne .L24
.L14:
	move.b 670(%a2),%d2
	move.l 666(%a2),file+28
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d0,%a0
	add.l %a0,%a0
	add.l %a0,%a0
	sub.l %d0,%a0
	moveq #0,%d0
	move.b %d2,%d0
	add.l %d0,%a0
	move.l %a0,file+20
	move.w #16,14303236
	clr.b 14303232
	move.w #17,14303236
	tst.b DEBUG
	jeq .L16
	jra .L22
.L20:
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC0
	jsr printf
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,-(%sp)
	pea .LC1
	jsr ErrorMessage
	move.b 1(%a2),%d0
	subq.b #1,%d0
	move.b %d0,671(%a2)
	lea (16,%sp),%sp
	tst.b DEBUG
	jeq .L13
	jra .L21
	.size	ReadTrack, .-ReadTrack
	.align	2
	.globl	FindSync
	.type	FindSync, @function
FindSync:
	move.l #14303236,%a0
	move.w #16,(%a0)
	clr.b 14303232
	move.w #17,(%a0)
	clr.b %d0
	rts
	.size	FindSync, .-FindSync
	.align	2
	.globl	GetHeader
	.type	GetHeader, @function
GetHeader:
	clr.b Error
	move.l #14303236,%a0
	move.w #16,(%a0)
	clr.b 14303232
	move.w #17,(%a0)
	clr.b %d0
	rts
	.size	GetHeader, .-GetHeader
	.align	2
	.globl	GetData
	.type	GetData, @function
GetData:
	clr.b Error
	move.l #14303236,%a0
	move.w #16,(%a0)
	clr.b 14303232
	move.w #17,(%a0)
	clr.b %d0
	rts
	.size	GetData, .-GetData
	.section	.rodata.str1.1
.LC6:
	.string	"*%u:\r"
.LC7:
	.string	"Write attempt to protected disk!\r"
.LC8:
	.string	"WriteTrack: error %u\r"
.LC9:
	.string	"  WriteTrack"
	.text
	.align	2
	.globl	WriteTrack
	.type	WriteTrack, @function
WriteTrack:
	subq.l #4,%sp
	movem.l #15934,-(%sp)
	move.l 48(%sp),%a2
	move.b 671(%a2),%d2
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),file+28
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,file+20
	addq.b #1,%d2
	move.b %d2,672(%a2)
	tst.b DEBUG
	jne .L47
	clr.b %d2
	lea FindSync,%a3
	moveq #43,%d4
	add.l %sp,%d4
	moveq #42,%d3
	add.l %sp,%d3
	lea GetHeader,%a4
	lea printf,%a6
	move.l #ErrorMessage,%d5
	lea FileNextSector,%a5
.L44:
	move.l %a2,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
	tst.b %d0
	jeq .L48
.L41:
	move.l %d4,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a4)
	addq.l #8,%sp
	tst.b %d0
	jeq .L32
	move.b 671(%a2),%d0
	cmp.b 42(%sp),%d0
	jeq .L49
	move.b #27,Error
	moveq #27,%d0
	move.l %d0,-(%sp)
	pea .LC8
	jsr (%a6)
	moveq #0,%d0
	move.b Error,%d0
	move.l %d0,-(%sp)
	pea .LC9
	move.l %d5,%a0
	jsr (%a0)
	lea (16,%sp),%sp
.L50:
	move.l %a2,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
	tst.b %d0
	jne .L41
.L48:
	movem.l (%sp)+,#31868
	addq.l #4,%sp
	rts
.L51:
	jsr GetData
	tst.b %d0
	jeq .L32
	btst #4,(%a2)
	jeq .L38
	pea sector_buffer
	pea file
	jsr FileWrite
	addq.l #8,%sp
.L32:
	move.b Error,%d0
	jeq .L44
.L53:
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC8
	jsr (%a6)
	moveq #0,%d0
	move.b Error,%d0
	move.l %d0,-(%sp)
	pea .LC9
	move.l %d5,%a0
	jsr (%a0)
	lea (16,%sp),%sp
	jra .L50
.L49:
	move.b 43(%sp),%d6
.L45:
	cmp.b %d2,%d6
	jeq .L51
	jhi .L52
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),file+28
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,file+20
	clr.b %d2
	jra .L45
.L52:
	pea file
	jsr (%a5)
	addq.b #1,%d2
	move.b 47(%sp),%d6
	addq.l #4,%sp
	jra .L45
.L38:
	move.b #30,Error
	pea .LC7
	jsr (%a6)
	addq.l #4,%sp
	move.b Error,%d0
	jeq .L44
	jra .L53
.L47:
	move.l %d0,-(%sp)
	pea .LC6
	jsr printf
	addq.l #8,%sp
	clr.b %d2
	lea FindSync,%a3
	moveq #43,%d4
	add.l %sp,%d4
	moveq #42,%d3
	add.l %sp,%d3
	lea GetHeader,%a4
	lea printf,%a6
	move.l #ErrorMessage,%d5
	lea FileNextSector,%a5
	jra .L44
	.size	WriteTrack, .-WriteTrack
	.align	2
	.globl	UpdateDriveStatus
	.type	UpdateDriveStatus, @function
UpdateDriveStatus:
	move.l #14303236,%a0
	move.w #16,(%a0)
	moveq #0,%d1
	move.b df+696,%d1
	add.l %d1,%d1
	moveq #0,%d0
	move.b df+1392,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	or.b %d0,%d1
	or.b df,%d1
	moveq #0,%d0
	move.b df+2088,%d0
	lsl.l #3,%d0
	or.b %d0,%d1
	move.b %d1,14303232
	move.w #17,(%a0)
	rts
	.size	UpdateDriveStatus, .-UpdateDriveStatus
	.align	2
	.globl	HandleFDD
	.type	HandleFDD, @function
HandleFDD:
	move.l %d2,-(%sp)
	move.l 12(%sp),%d2
	move.b 11(%sp),%d0
	move.b %d0,%d1
	lsr.b #4,%d1
	and.b #3,%d1
	move.b %d1,drives
	moveq #0,%d1
	move.b %d0,%d1
	btst #0,%d1
	jne .L60
	btst #1,%d1
	jne .L61
	move.l (%sp)+,%d2
	rts
.L61:
	lsr.b #6,%d0
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	lsl.l #3,%d1
	sub.l %d0,%d1
	lsl.l #3,%d1
	lea df+670,%a0
	move.b %d2,1(%a0,%d1.l)
	add.l #df,%d1
	move.l %d1,8(%sp)
	move.l (%sp)+,%d2
	jra WriteTrack
.L60:
	lsr.b #6,%d0
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	lsl.l #3,%d1
	sub.l %d0,%d1
	lsl.l #3,%d1
	lea df+670,%a0
	move.b %d2,1(%a0,%d1.l)
	add.l #df,%d1
	move.l %d1,8(%sp)
	move.l (%sp)+,%d2
	jra ReadTrack
	.size	HandleFDD, .-HandleFDD
	.globl	df
	.section	.bss
	.align	2
	.type	df, @object
	.size	df, 2784
df:
	.zero	2784
	.globl	pdfx
	.align	2
	.type	pdfx, @object
	.size	pdfx, 4
pdfx:
	.zero	4
	.globl	drives
	.type	drives, @object
	.size	drives, 1
drives:
	.zero	1
	.globl	DEBUG
	.type	DEBUG, @object
	.size	DEBUG, 1
DEBUG:
	.zero	1
	.ident	"GCC: (GNU) 4.6.2"
