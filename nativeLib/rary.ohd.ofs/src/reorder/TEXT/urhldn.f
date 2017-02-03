C MEMBER URHLDN
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 05/02/94.13:20:04 BY $WC20SV
C
C @PROCESS LVL(77)
C
      SUBROUTINE URHLDN (NEOFRC,ISTAT)
C
C          ROUTINE:  URHLDN
C
C             VERSION:  1.0.1  UPDATED FOR THE REORDER AND COMPRESS
C                              PROGRAM.  11-5-85  JF
C
C                DATE:  8-2-82
C
C              AUTHOR:  JONATHAN D GERSHAN
C                       DATA SCIENCES INC
C
C***********************************************************************
C
C          DESCRIPTION:
C      THIS ROUTINE COMPRESSES THE LOCAL DEFINITIONS FILE
C      FOR THE REORDER AND COMPRESS PROGRAM.
C
C
C
C
C
C
C
C***********************************************************************
C
C          ARGUMENT LIST:
C
C         NAME    TYPE  I/O   DIM   DESCRIPTION
C
C       NEOFRC     I     I    1       NEW END OF FILE POINTER
C       ISTAT      I     O    1       STATUS O=OK (NOT 0=ERROR
C
C
C
C
C
C
C
C
C
C***********************************************************************
C
C          COMMON:
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'hclcommon/hdatas'
      INCLUDE 'hclcommon/hldrpt'
      INCLUDE 'hclcommon/hcuuno'
      INCLUDE 'hclcommon/hindx'
C
C***********************************************************************
C
C          DIMENSION AND TYPE DECLARATIONS:
C
       DIMENSION IBUF(4),KBUF(512),JBUF(16),IZERO(16)
C
       INTEGER DUMMY(16),FSTLST(4,2),TYPENM(4),DEFBUF(512)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/reorder/RCS/urhldn.f,v $
     . $',                                                             '
     .$Id: urhldn.f,v 1.1 1995/09/17 19:17:48 dws Exp $
     . $' /
C    ===================================================================
C
C
C
C***********************************************************************
C
C          DATA:
C
       DATA TYPENM/4HPROC,4HFUNC,4HTECH,4HOPTN/
       DATA IDEFN/4HDEFN/,IZERO/16*0/
       DATA DUMMY/16*0/
C
C
C***********************************************************************
C       VARIABLE DEFINITIONS:
C
C***********************************************************************
C
C
C   INITIALIZE:
C
C
C   WRITE OUT SKELETAL RECS TO FILE ON UNIT 53
C
       CALL UWRITT(KLOFUO,1,DUMMY ,ISTAT)
C
       MAX   =512
       LRECJ =16
       LRECLI=4
       IOUTNO=1
       IPOS  =0
C
C
       IF (IHCLTR.GT.0) WRITE (IOGDB,180)
C   GET CONTROL RECORD FROM INDEX FILE AND SET FIRST AND
C   LAST POINTERS TO EACH TYPE OF RECORD IN THE HCL
C   LOCAL DEFINTION FILE. THE RECORD TYPES ARE:
C      1.    PROCEDURES
C      2.    FUNCTIONS
C      3.    TECHNIQUES
C      4.    DEFINED OPTIONS
C
       DO 10 ITYPE=1,4
          CALL UREADT (KLOXUI,ITYPE,IBUF,ISTAT)
          FSTLST(ITYPE,1)=IBUF(2)
          FSTLST(ITYPE,2)=IBUF(3)
10     CONTINUE
C
       IF (IHCLDB.GT.0) THEN
          WRITE (IOGDB,190)
          DO 20 ITYPE=1,4
             WRITE (IOGDB,210) ITYPE,TYPENM(ITYPE),(FSTLST
     *      (ITYPE,ICOL),ICOL=1,2)
20        CONTINUE
          ENDIF
C
C   COPY CONTROL RECORD FOR DEFINITION FILE:
C
       CALL UREADT (KLOFUI,1,JBUF,ISTAT)
       IF (IHCLDB.GT.0) WRITE (IOGDB,200) (JBUF(J),J=1,7),JBUF(13)
C
       IF (JBUF(3).EQ.IDEFN.AND.JBUF(2).EQ.1) GO TO 30
C
C   THIS IS NOT A LOCAL DEFINITION FILE
C
       WRITE (IOGDB,220) KLOFUI
       ISTAT=1
       GO TO 170
C
C   SET THE FILE IN USE INDICATOR (WORD 1) AND PRINT:
C
30     CONTINUE
       JBUF(1)=1
       CALL UWRITT (KLOFUO,1,JBUF,ISTAT)
       IOUTNO=2
C
C   ENTER MAIN LOOP --- FOR EACH DEFINITION RECORD TYPE, GO THROUGH
C   THE INDEX AND GET A DEFINITION RECORD IF NOT DELETED. THEN
C   WRITE OUT THE GOOD RECORD AND UPDATE THE POINTER IN THE INDEX
C   FILE.
C
       DO 150 ITYPE=1,4
          ISTART=FSTLST(ITYPE,1)
          ISTOP =FSTLST(ITYPE,2)
C
          DO 140 IIXREC=ISTART,ISTOP
             CALL UREADT (KLOXUI,IIXREC,IBUF,ISTAT)
             IF (IBUF(4).GT.0) GO TO 40
             IF (IHCLDB.GT.0) WRITE (IOGDB,230) IIXREC,(IBUF(I),I=1,4)
                GO TO 140
40           CONTINUE
C
C   PRINT INDEX RECORD FOR DEBUG:
C
             IF (IHCLDB.GT.0) WRITE (IOGDB,50)IIXREC,(IBUF(I),I=1,4)
50           FORMAT (' INDEX RECORD ',I4,' : ',3X,
     *        2A4,2(3X,I4))
C
             IF (IBUF(1).EQ.IDELE.AND.IBUF(2).EQ.ITED) GO TO 140
             IRECNO=IBUF(3)
C
C   READ IN DEFINITION RECORD
C
             CALL HGTRDN (KLOFUI,IRECNO,KBUF,MAX,ISTAT)
C
C   PRINT DEFINITION RECORD FOR DEBUG:
C
             IF (IHCLDB.GT.0) WRITE (IOGDB,60)IRECNO,(KBUF(I),I=1,9)
60           FORMAT (' DEFINITION RECORD # ',I4,' : ',
     *       3(3X,I4),3X,2A4,3X,A4,3(3X,I4))
C
             IPOS=IPOS+KBUF(1)
C
C   CHECK ACTUAL LENGTH OF RECORD HERE FOR PROCS AND FUNCS.
C
C   COPY LOCAL DEFAULTS FOR THIS DEFINITION RECORD:
C
             GO TO (70,70,80,120),ITYPE
C
70           IDFLT=KBUF(7)
             IF (IDFLT.NE.0) KBUF(7)=IOUTNO
             GO TO 90
80           IDFLT=KBUF(8)
             IF (IDFLT.NE.0) KBUF(8)=IOUTNO
C
90           IF (IDFLT.EQ.0) GO TO 120
             CALL HGTRDN (KLOFUI,IDFLT,DEFBUF,MAX,ISTAT)
C
C   PRINT DEFAULT RECORD NUMBER FOR DEBUG:
C
             IF (IHCLDB.GT.0) WRITE (IOGDB,100)IDFLT
100          FORMAT (' THE DEFAULT RECORD NUMBER IS: ',I4)
C
C   PRINT DEFAULT RECORD FOR DEBUG:
C
             IF (IHCLDB.GT.0) WRITE (IOGDB,110) (DEFBUF(I),I=1,7)
110          FORMAT (' DEFAULT RECORD: ',3(3X,I4),3X,2A4,2(3X,I4))
C
             CALL WVLRCD (KLOFUO,IOUTNO,DEFBUF(1),DEFBUF,LRECJ,ISTAT)
             IOUTNO=IOUTNO+DEFBUF(1)
C
120          CONTINUE
C
C
C   WRITE OUT DEFINITION RECORD:
C
C
C   PRINT OUTPUT RECORD NUMBER (DEFINITION RECORD) FOR DEBUG:
C
             IF (IHCLDB.GT.0) WRITE (IOGDB,130)IOUTNO
130          FORMAT (' THE DEFINITION RECORD WILL BE WRITTEN AT',
     *       'RECORD NUMBER ',I5)
C
             CALL WVLRCD (KLOFUO,IOUTNO,KBUF(1),KBUF,LRECJ,ISTAT)
C
C   RESET POINTER TO DEFINTION RECORD AND UPDATE INDEX IN PLACE:
C
             IBUF(3)=IOUTNO
             CALL UWRITT (KLOXUI,IIXREC,IBUF,ISTAT)
C
             IOUTNO=IOUTNO+KBUF(1)
C
140       CONTINUE
C
150     CONTINUE
C
C   RESET DEFINTION CONTROL RECORD VALUES
C
       JBUF(7)=IOUTNO-1
       JBUF(1)=0
C
C
C   FILE EXPANSION SECTION:
C
       IF (NEOFRC.GT.JBUF(6)) JBUF(6)=NEOFRC
C
       ICONT=IOUTNO
       IMAX=JBUF(6)
C
       IF (IHCLDB.GT.0) WRITE (IOGDB,260) ICONT,IMAX,KLOFUO
       DO 160 IOUTNO=ICONT,IMAX
            CALL UWRITT (KLOFUO,IOUTNO,IZERO,ISTAT)
160    CONTINUE
C
       CALL UWRITT (KLOFUO,1,JBUF,ISTAT)
       WRITE (IOGDB,250) JBUF(6)
       IF (IHCLTR.GT.0) WRITE (IOGDB,240)
C
170    RETURN
C
180     FORMAT (' *** ENTERING ROUTINE URHLDN')
190    FORMAT (5X,'TYPE',5X,'TYPE',5X,'STARTS AT',
     *   5X,'STOPS AT' / 4X,'NUMBER',4X,'NAME',2(5X,'INDEX POS'))
200    FORMAT (' CONTROL REC LOCDEFN FILE: ',2(3X,I4),3X,A4,3X,I4,3X,A4,
     *  3(3X,I4))
210    FORMAT (7X,I1,6X,A4,8X,I4,10X,I4)
220    FORMAT (' **ERROR** FILE OPENED ON UNIT ',I2,' IS NOT A LOCAL ',
     *  'DEFINITION FILE')
230    FORMAT (' GLOBAL DEFINITION REFERENCED IN LOCAL INDEX',/
     *   ,5X,'IX. REC. #',5X,'NAME',5X,'RECPTR',5X,'INTERNAL #' /
     *   7X,I5,5X,2A4,4X,I4,9X,I5)
240     FORMAT (' EXITING ROUTINE URHLDN')
250     FORMAT (' THE MAXIMUM RECORD NUMBER IS ',I5)
260     FORMAT (' ABOUT TO INITIALIZE RECORDS ',I4,' THRU ',
     *  I4,' FOR FILE ON UNIT ',I2)
C
      END