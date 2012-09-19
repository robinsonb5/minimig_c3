#NO_APP
	.file	"fdd.c"
	.text
	.align	2
	.globl	SendSector
	.type	SendSector, @function
SendSector:
	movem.l #15872,-(%sp)
	move.l 24(%sp),%a0
	move.l 36(%sp),%d2
	move.l 40(%sp),%d1
	move.b 31(%sp),%d0
	move.b 35(%sp),%d4
	move.b #-86,14303232
	move.b 14303232,%d3
	move.b #-86,14303232
	move.b 14303232,%d3
	move.b #-86,14303232
	move.b 14303232,%d3
	move.b #-86,14303232
	move.b 14303232,%d3
	move.b %d2,14303232
	move.b 14303232,%d3
	move.b %d1,14303232
	move.b 14303232,%d3
	move.b %d2,14303232
	move.b 14303232,%d2
	move.b %d1,14303232
	move.b 14303232,%d1
	move.b #85,14303232
	move.b 14303232,%d1
	move.b %d4,%d2
	lsr.b #1,%d2
	and.b #85,%d2
	move.b %d2,14303232
	move.b 14303232,%d1
	move.b %d0,%d1
	lsr.b #1,%d1
	and.b #85,%d1
	move.b %d1,14303232
	move.b 14303232,%d3
	moveq #0,%d3
	move.b %d0,%d3
	moveq #11,%d5
	sub.l %d3,%d5
	move.l %d5,%d3
	asr.l #1,%d3
	and.b #85,%d3
	move.b %d3,14303232
	move.b 14303232,%d5
	move.b #85,14303232
	move.b 14303232,%d5
	and.b #85,%d4
	eor.b %d4,%d2
	move.b %d4,14303232
	move.b 14303232,%d4
	move.b %d0,%d4
	and.b #85,%d4
	eor.b %d4,%d1
	move.b %d4,14303232
	move.b 14303232,%d4
	moveq #11,%d4
	sub.b %d0,%d4
	move.b %d4,%d0
	and.b #85,%d0
	eor.b %d0,%d3
	move.b %d0,14303232
	move.b 14303232,%d0
	moveq #33,%d0
	jra .L2
.L3:
	move.b 14303232,%d4
.L2:
	subq.w #1,%d0
	move.b #-86,14303232
	tst.w %d0
	jne .L3
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	or.b #-86,%d2
	move.b %d2,14303232
	move.b 14303232,%d0
	or.b #-86,%d1
	move.b %d1,14303232
	move.b 14303232,%d0
	or.b #-86,%d3
	move.b %d3,14303232
	move.b 14303232,%d0
	clr.b %d4
	clr.b %d3
	clr.b %d2
	clr.b %d1
	moveq #0,%d0
.L4:
	move.b (%a0,%d0.l),%d6
	move.b %d6,%d5
	lsr.b #1,%d5
	eor.b %d6,%d5
	eor.b %d5,%d4
	move.b 1(%a0,%d0.l),%d6
	move.b %d6,%d5
	lsr.b #1,%d5
	eor.b %d6,%d5
	eor.b %d5,%d3
	move.b 2(%a0,%d0.l),%d6
	move.b %d6,%d5
	lsr.b #1,%d5
	eor.b %d6,%d5
	eor.b %d5,%d2
	move.b 3(%a0,%d0.l),%d6
	move.b %d6,%d5
	lsr.b #1,%d5
	eor.b %d6,%d5
	eor.b %d5,%d1
	addq.l #4,%d0
	cmp.l #512,%d0
	jne .L4
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	move.b #-86,14303232
	move.b 14303232,%d0
	or.b #-86,%d4
	move.b %d4,14303232
	move.b 14303232,%d0
	or.b #-86,%d3
	move.b %d3,14303232
	move.b 14303232,%d0
	or.b #-86,%d2
	move.b %d2,14303232
	move.b 14303232,%d0
	or.b #-86,%d1
	move.b %d1,14303232
	move.b 14303232,%d0
	move.l %a0,%a1
	move.w #513,%d1
	jra .L5
.L6:
	move.b (%a1)+,%d0
	lsr.b #1,%d0
	or.b #-86,%d0
	move.b %d0,14303232
	move.b 14303232,%d0
.L5:
	subq.w #1,%d1
	jne .L6
	move.w #513,%d0
	jra .L7
.L8:
	move.b (%a0)+,%d1
	or.b #-86,%d1
	move.b %d1,14303232
	move.b 14303232,%d1
.L7:
	subq.w #1,%d0
	jne .L8
	movem.l (%sp)+,#124
	rts
	.size	SendSector, .-SendSector
	.align	2
	.globl	SendGap
	.type	SendGap, @function
SendGap:
	move.w #701,%d0
	jra .L11
.L12:
	move.b #-86,14303232
	move.b 14303232,%d1
.L11:
	subq.w #1,%d0
	jne .L12
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
	.string	"->"
.LC6:
	.string	":OK\r"
	.text
	.align	2
	.globl	ReadTrack
	.type	ReadTrack, @function
ReadTrack:
	movem.l #16190,-(%sp)
	move.l 48(%sp),%a2
	move.b 671(%a2),%d0
	cmp.b 1(%a2),%d0
	jcs .L14
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
.L14:
	tst.b DEBUG
	jeq .L15
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,-(%sp)
	pea .LC2
	jsr printf
	addq.l #8,%sp
.L15:
	move.b 671(%a2),%d1
	moveq #0,%d0
	move.b %d1,%d0
	cmp.b 672(%a2),%d1
	jeq .L16
	move.b %d1,672(%a2)
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
	jra .L17
.L16:
	move.b 670(%a2),%d2
	move.l 666(%a2),file+28
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
.L17:
	move.w #16,14303236
	move.b #0,14303232
	move.b 14303232,%d1
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d3
	move.b #0,14303232
	move.b 14303232,%d4
	move.b #0,14303232
	move.b 14303232,%d4
	move.w #17,14303236
	tst.b DEBUG
	jeq .L33
	lsl.w #8,%d0
	and.w #255,%d3
	or.w %d3,%d0
	move.w %d0,-(%sp)
	clr.w -(%sp)
	move.b %d1,%d0
	lsr.b #6,%d0
	moveq #3,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	pea .LC3
	jsr printf
	lea (12,%sp),%sp
.L33:
	move.l #FileRead,%d6
	lea printf,%a3
	lea SendSector,%a6
	lea SendGap,%a5
	lea FileNextSector,%a4
.L35:
	pea sector_buffer
	pea file
	move.l %d6,%a0
	jsr (%a0)
	move.w #16,14303236
	move.b #0,14303232
	move.b 14303232,%d5
	move.b #0,14303232
	move.b 14303232,%d4
	move.b #0,14303232
	move.b 14303232,%d3
	lsl.w #8,%d3
	move.b #0,14303232
	move.b 14303232,%d0
	and.w #255,%d0
	or.w %d0,%d3
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d7
	move.b 1(%a2),%d1
	addq.l #8,%sp
	cmp.b %d4,%d1
	jhi .L20
	move.b %d1,%d4
	subq.b #1,%d4
.L20:
	tst.w %d3
	jeq .L31
	cmp.w #-30444,%d3
	jeq .L31
	cmp.w #-24252,%d3
	jne .L21
.L31:
	move.w #17545,%d3
.L21:
	tst.b DEBUG
	jeq .L22
	lsl.w #8,%d0
	and.w #16128,%d0
	clr.w %d1
	move.b %d7,%d1
	or.w %d1,%d0
	move.l %d0,%d1
	and.l #16383,%d1
	move.l %d1,-(%sp)
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea .LC4
	jsr (%a3)
	lea (12,%sp),%sp
.L22:
	cmp.b 671(%a2),%d4
	jne .L23
	btst #0,%d5
	jeq .L23
	moveq #0,%d0
	move.b %d3,%d0
	move.l %d0,-(%sp)
	lsr.l #8,%d3
	moveq #0,%d0
	not.b %d0
	and.l %d3,%d0
	move.l %d0,-(%sp)
	moveq #0,%d0
	move.b %d4,%d0
	move.l %d0,-(%sp)
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea sector_buffer
	jsr (%a6)
	lea (20,%sp),%sp
	cmp.b #10,%d2
	jne .L23
	jsr (%a5)
.L23:
	move.w #17,14303236
	cmp.b 671(%a2),%d4
	jne .L24
	btst #0,%d5
	jeq .L24
	addq.b #1,%d2
	cmp.b #10,%d2
	jhi .L25
	pea file
	jsr (%a4)
	addq.l #4,%sp
	jra .L26
.L25:
	and.l #255,%d4
	move.l %d4,%d0
	add.l %d4,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l 2(%a2,%d1.l),file+28
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	sub.l %d4,%d0
	move.l %d0,file+20
	clr.b %d2
.L26:
	move.b %d2,670(%a2)
	move.l file+28,666(%a2)
	tst.b DEBUG
	jeq .L35
	pea .LC5
	jsr (%a3)
	addq.l #4,%sp
	jra .L35
.L24:
	tst.b DEBUG
	jeq .L13
	move.l #.LC6,48(%sp)
	movem.l (%sp)+,#31996
	jra printf
.L13:
	movem.l (%sp)+,#31996
	rts
	.size	ReadTrack, .-ReadTrack
	.section	.rodata.str1.1
.LC7:
	.string	"#SYNC:"
	.text
	.align	2
	.globl	FindSync
	.type	FindSync, @function
FindSync:
	move.l %d2,-(%sp)
	move.l 8(%sp),%a0
.L43:
	move.w #16,14303236
	move.b #0,14303232
	move.b 14303232,%d1
	move.b #0,14303232
	move.b 14303232,%d0
	btst #1,%d1
	jeq .L37
	cmp.b 671(%a0),%d0
	jne .L37
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	and.b #-65,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	tst.b %d0
	jne .L38
	tst.b %d1
	jeq .L37
.L38:
	and.w #63,%d0
	lsl.w #8,%d0
	and.w #255,%d1
	add.w %d1,%d0
	jra .L39
.L42:
	move.b #0,14303232
	move.b 14303232,%d2
	move.b #0,14303232
	move.b 14303232,%d1
	cmp.b #68,%d2
	jne .L40
	cmp.b #-119,%d1
	jne .L40
	move.w #17,14303236
	tst.b DEBUG
	jeq .L44
	pea .LC7
	jsr printf
	addq.l #4,%sp
	jra .L44
.L40:
	subq.w #1,%d0
.L39:
	tst.w %d0
	jne .L42
	move.w #17,14303236
	jra .L43
.L37:
	move.w #17,14303236
	clr.b %d0
	jra .L41
.L44:
	moveq #1,%d0
.L41:
	move.l (%sp)+,%d2
	rts
	.size	FindSync, .-FindSync
	.section	.rodata.str1.1
.LC8:
	.string	"\rSecond sync word missing...\r"
.LC9:
	.string	"\rWrong header: %u.%u.%u.%u\r"
.LC10:
	.string	"T%uS%u\r"
	.text
	.align	2
	.globl	GetHeader
	.type	GetHeader, @function
GetHeader:
	movem.l #16190,-(%sp)
	clr.b Error
.L62:
	move.w #16,14303236
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	btst #1,%d0
	jeq .L46
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	moveq #63,%d2
	and.l %d0,%d2
	jne .L47
	cmp.b #24,%d1
	jls .L48
.L47:
	move.b #0,14303232
	move.b 14303232,%d1
	move.b #0,14303232
	move.b 14303232,%d0
	cmp.b #68,%d1
	jne .L49
	cmp.b #-119,%d0
	jeq .L50
.L49:
	move.b #21,Error
	pea .LC8
	jsr printf
	addq.l #4,%sp
	jra .L46
.L50:
	move.b #0,14303232
	move.b 14303232,%d0
	move.w %d0,%a4
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a2
	move.b #0,14303232
	move.b 14303232,%d6
	move.b #0,14303232
	move.b 14303232,%d2
	move.w %d2,%a6
	move.b #0,14303232
	move.b 14303232,%d3
	move.w %d3,%a5
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d3,%d1
	and.b #85,%d1
	or.b %d1,%d0
	move.b #0,14303232
	move.b 14303232,%d4
	move.w %d4,%a3
	move.w %a2,%d3
	and.b #85,%d3
	add.b %d3,%d3
	move.b %d4,%d1
	and.b #85,%d1
	or.b %d1,%d3
	move.b #0,14303232
	move.b 14303232,%d7
	move.b %d6,%d2
	and.b #85,%d2
	add.b %d2,%d2
	move.b %d7,%d1
	and.b #85,%d1
	or.b %d1,%d2
	move.b #0,14303232
	move.b 14303232,%d5
	move.w %a6,%d1
	and.b #85,%d1
	add.b %d1,%d1
	move.b %d5,%d4
	and.b #85,%d4
	or.b %d4,%d1
	cmp.b #-1,%d0
	jeq .L51
	move.b #22,Error
	jra .L52
.L51:
	cmp.b #-97,%d3
	jls .L53
	move.b #23,Error
	jra .L52
.L53:
	cmp.b #10,%d2
	jls .L54
	move.b #24,Error
	jra .L52
.L54:
	move.b %d1,%d4
	subq.b #1,%d4
	cmp.b #10,%d4
	jls .L52
	move.b #25,Error
.L52:
	tst.b Error
	jeq .L55
	and.l #255,%d1
	move.l %d1,-(%sp)
	and.l #255,%d2
	move.l %d2,-(%sp)
	and.l #255,%d3
	move.l %d3,-(%sp)
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC9
	jsr printf
	lea (20,%sp),%sp
	jra .L46
.L55:
	tst.b DEBUG
	jeq .L56
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	move.b %d3,%d0
	move.l %d0,-(%sp)
	pea .LC10
	jsr printf
	lea (12,%sp),%sp
.L56:
	move.w %a5,%d0
	move.w %a4,%d1
	eor.b %d1,%d0
	move.w %d0,%a4
	move.w %a3,%d1
	move.w %a2,%d4
	eor.b %d4,%d1
	eor.b %d7,%d6
	move.w %a6,%d4
	eor.b %d5,%d4
	move.l 48(%sp),%a0
	move.b %d3,(%a0)
	move.l 52(%sp),%a0
	move.b %d2,(%a0)
	moveq #8,%d0
.L57:
	move.b #0,14303232
	move.b 14303232,%d2
	move.w %a4,%d3
	eor.b %d2,%d3
	move.w %d3,%a4
	move.b #0,14303232
	move.b 14303232,%d2
	eor.b %d2,%d1
	move.b #0,14303232
	move.b 14303232,%d2
	eor.b %d2,%d6
	move.b #0,14303232
	move.b 14303232,%d2
	eor.b %d2,%d4
	subq.b #1,%d0
	jne .L57
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d2
	move.w %d2,%a2
	move.b #0,14303232
	move.b 14303232,%d3
	move.w %d3,%a0
	move.b #0,14303232
	move.b 14303232,%d5
	move.b #0,14303232
	move.b 14303232,%d3
	and.b #85,%d0
	add.b %d0,%d0
	and.b #85,%d3
	or.b %d3,%d0
	move.b #0,14303232
	move.b 14303232,%d2
	move.w %d2,%a1
	move.b #0,14303232
	move.b 14303232,%d7
	move.b #0,14303232
	move.b 14303232,%d3
	move.w %a4,%d2
	and.b #85,%d2
	cmp.b %d0,%d2
	jne .L58
	move.w %a2,%d2
	and.b #85,%d2
	add.b %d2,%d2
	move.w %a1,%d0
	and.b #85,%d0
	or.b %d0,%d2
	and.b #85,%d1
	cmp.b %d2,%d1
	jne .L58
	move.w %a0,%d1
	and.b #85,%d1
	add.b %d1,%d1
	move.b %d7,%d0
	and.b #85,%d0
	or.b %d0,%d1
	and.b #85,%d6
	cmp.b %d1,%d6
	jne .L58
	move.b %d5,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d3,%d1
	and.b #85,%d1
	or.b %d1,%d0
	and.b #85,%d4
	cmp.b %d0,%d4
	jeq .L59
.L58:
	move.b #26,Error
	jra .L46
.L59:
	move.w #17,14303236
	moveq #1,%d0
	jra .L60
.L48:
	tst.b %d0
	jlt .L61
	move.b #20,Error
	jra .L46
.L61:
	move.w #17,14303236
	jra .L62
.L46:
	move.w #17,14303236
	clr.b %d0
.L60:
	movem.l (%sp)+,#31996
	rts
	.size	GetHeader, .-GetHeader
	.align	2
	.globl	GetData
	.type	GetData, @function
GetData:
	movem.l #16190,-(%sp)
	clr.b Error
.L73:
	move.w #16,14303236
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	btst #1,%d0
	jeq .L65
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	move.b #0,14303232
	move.b 14303232,%d2
	move.w %d1,%d0
	and.w #63,%d0
	lsl.w #8,%d0
	and.w #255,%d2
	add.w %d2,%d0
	cmp.w #515,%d0
	jls .L66
	move.b #0,14303232
	move.b 14303232,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a4
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a2
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a0
	move.b #0,14303232
	move.b 14303232,%d1
	and.b #85,%d0
	add.b %d0,%d0
	and.b #85,%d1
	or.b %d1,%d0
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a3
	move.b #0,14303232
	move.b 14303232,%d1
	move.w %d1,%a1
	move.b #0,14303232
	move.b 14303232,%d7
	moveq #0,%d1
	clr.b %d2
	clr.b %d3
	clr.b %d4
	clr.b %d5
	lea sector_buffer,%a6
.L67:
	move.b #0,14303232
	move.b 14303232,%d6
	eor.b %d6,%d5
	and.b #85,%d6
	add.b %d6,%d6
	move.b %d6,(%a6,%d1.l)
	move.b #0,14303232
	move.b 14303232,%d6
	eor.b %d6,%d4
	and.b #85,%d6
	add.b %d6,%d6
	lea sector_buffer+1,%a5
	move.b %d6,(%a5,%d1.l)
	move.b #0,14303232
	move.b 14303232,%d6
	eor.b %d6,%d3
	and.b #85,%d6
	add.b %d6,%d6
	lea sector_buffer+2,%a5
	move.b %d6,(%a5,%d1.l)
	move.b #0,14303232
	move.b 14303232,%d6
	eor.b %d6,%d2
	and.b #85,%d6
	add.b %d6,%d6
	lea sector_buffer+3,%a5
	move.b %d6,(%a5,%d1.l)
	addq.l #4,%d1
	cmp.l #512,%d1
	jne .L67
	lea sector_buffer,%a5
.L68:
	move.b #0,14303232
	move.b 14303232,%d1
	eor.b %d1,%d5
	and.b #85,%d1
	or.b %d1,(%a5)
	move.b #0,14303232
	move.b 14303232,%d1
	eor.b %d1,%d4
	and.b #85,%d1
	or.b %d1,1(%a5)
	move.b #0,14303232
	move.b 14303232,%d1
	eor.b %d1,%d3
	and.b #85,%d1
	or.b %d1,2(%a5)
	move.b #0,14303232
	move.b 14303232,%d1
	eor.b %d1,%d2
	and.b #85,%d1
	or.b %d1,3(%a5)
	addq.l #4,%a5
	cmp.l #sector_buffer+512,%a5
	jne .L68
	and.b #85,%d5
	cmp.b %d0,%d5
	jne .L69
	move.w %a4,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.w %a3,%d1
	and.b #85,%d1
	or.b %d1,%d0
	and.b #85,%d4
	cmp.b %d0,%d4
	jne .L69
	move.w %a2,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.w %a1,%d1
	and.b #85,%d1
	or.b %d1,%d0
	and.b #85,%d3
	cmp.b %d0,%d3
	jne .L69
	move.w %a0,%d0
	and.b #85,%d0
	add.b %d0,%d0
	and.b #85,%d7
	or.b %d7,%d0
	and.b #85,%d2
	cmp.b %d0,%d2
	jeq .L70
.L69:
	move.b #29,Error
	jra .L65
.L70:
	move.w #17,14303236
	moveq #1,%d0
	jra .L71
.L66:
	tst.b %d1
	jlt .L72
	move.b #28,Error
	jra .L65
.L72:
	move.w #17,14303236
	jra .L73
.L65:
	move.w #17,14303236
	clr.b %d0
.L71:
	movem.l (%sp)+,#31996
	rts
	.size	GetData, .-GetData
	.section	.rodata.str1.1
.LC11:
	.string	"*%u:\r"
.LC12:
	.string	"Write attempt to protected disk!\r"
.LC13:
	.string	"WriteTrack: error %u\r"
.LC14:
	.string	"  WriteTrack"
	.text
	.align	2
	.globl	WriteTrack
	.type	WriteTrack, @function
WriteTrack:
	subq.l #4,%sp
	movem.l #14398,-(%sp)
	move.l 40(%sp),%a2
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
	jeq .L77
	move.l %d0,-(%sp)
	pea .LC11
	jsr printf
	addq.l #8,%sp
.L77:
	clr.b %d2
	lea FindSync,%a6
	moveq #35,%d4
	add.l %sp,%d4
	moveq #34,%d3
	add.l %sp,%d3
	lea GetHeader,%a5
	lea FileNextSector,%a4
	lea GetData,%a3
	jra .L90
.L87:
	move.l %d4,-(%sp)
	move.l %d3,-(%sp)
	jsr (%a5)
	addq.l #8,%sp
	tst.b %d0
	jeq .L79
	move.b 34(%sp),%d0
	cmp.b 671(%a2),%d0
	jne .L80
	jra .L91
.L84:
	cmp.b %d2,%d0
	jls .L82
	pea file
	jsr (%a4)
	addq.b #1,%d2
	addq.l #4,%sp
	jra .L91
.L82:
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
.L91:
	move.b 35(%sp),%d0
	cmp.b %d2,%d0
	jne .L84
	jsr (%a3)
	tst.b %d0
	jeq .L79
	btst #4,(%a2)
	jeq .L85
	pea sector_buffer
	pea file
	jsr FileWrite
	addq.l #8,%sp
	jra .L79
.L85:
	move.b #30,Error
	pea .LC12
	jsr printf
	addq.l #4,%sp
	jra .L79
.L80:
	move.b #27,Error
.L79:
	move.b Error,%d0
	jeq .L90
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC13
	jsr printf
	moveq #0,%d0
	move.b Error,%d0
	move.l %d0,-(%sp)
	pea .LC14
	jsr ErrorMessage
	lea (16,%sp),%sp
.L90:
	move.l %a2,-(%sp)
	jsr (%a6)
	addq.l #4,%sp
	tst.b %d0
	jne .L87
	movem.l (%sp)+,#31772
	addq.l #4,%sp
	rts
	.size	WriteTrack, .-WriteTrack
	.align	2
	.globl	UpdateDriveStatus
	.type	UpdateDriveStatus, @function
UpdateDriveStatus:
	move.l #14303236,%a1
	move.w #16,(%a1)
	move.l #14303232,%a0
	move.b #16,(%a0)
	move.b (%a0),%d0
	moveq #0,%d0
	move.b df+696,%d0
	add.l %d0,%d0
	moveq #0,%d1
	move.b df+1392,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	or.b %d1,%d0
	or.b df,%d0
	moveq #0,%d1
	move.b df+2088,%d1
	lsl.l #3,%d1
	or.b %d1,%d0
	move.b %d0,(%a0)
	move.b (%a0),%d0
	move.w #17,(%a1)
	rts
	.size	UpdateDriveStatus, .-UpdateDriveStatus
	.align	2
	.globl	HandleFDD
	.type	HandleFDD, @function
HandleFDD:
	move.l %d2,-(%sp)
	move.l 12(%sp),%d2
	move.b 11(%sp),%d1
	move.b %d1,%d0
	lsr.b #4,%d0
	and.b #3,%d0
	move.b %d0,drives
	moveq #0,%d0
	move.b %d1,%d0
	btst #0,%d0
	jeq .L94
	lsr.b #6,%d1
	and.l #255,%d1
	move.l %d1,%d0
	add.l %d1,%d0
	add.l %d1,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	sub.l %d1,%d0
	lsl.l #3,%d0
	sub.l %d1,%d0
	lsl.l #3,%d0
	lea df+670,%a0
	move.b %d2,1(%a0,%d0.l)
	add.l #df,%d0
	move.l %d0,8(%sp)
	move.l (%sp)+,%d2
	jra ReadTrack
.L94:
	btst #1,%d0
	jeq .L93
	lsr.b #6,%d1
	and.l #255,%d1
	move.l %d1,%d0
	add.l %d1,%d0
	add.l %d1,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	sub.l %d1,%d0
	lsl.l #3,%d0
	sub.l %d1,%d0
	lsl.l #3,%d0
	lea df+670,%a0
	move.b %d2,1(%a0,%d0.l)
	add.l #df,%d0
	move.l %d0,8(%sp)
	move.l (%sp)+,%d2
	jra WriteTrack
.L93:
	move.l (%sp)+,%d2
	rts
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
