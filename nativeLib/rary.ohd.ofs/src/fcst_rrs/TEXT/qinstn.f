C MODULE QINSTN
C-----------------------------------------------------------------------
C
C  ROUTINE QINSTN CONVERTS OBSERVED INSTANTANEOUS DATA INTO A TIME 
C  SERIES.
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  INPUT ARGUMENTS:
C         STAID - STATION IDENTIFIER
C         DTYPE - DATA TYPE CODE
C        INTVAL - TIME INTERVAL
C        UNITIN - DATA INPUT UNITS
C        UNITOT - DATA OUTPUT UNITS
C        NCOUNT - NUMBER OF OBS TIMES THE NUMBER OF VALUES PER OBS
C          LOBS - LENGTH OF OBSERVED DATA ARRAY
C           OBS - OBSERVED DATA ARRAY
C        IHOURF - FIRST HOUR OF OBS DATA
C        IHOURL - LAST HOUR OF OBS DATA
C          IOBS - INTEGER PORTION OF OBS ARRAY
C         LWORK - LENGTH OF WORK ARRAY
C          WORK - WORK ARRAY
C        LWKBUF - LENGTH OF IWKBUF ARRAY
C        IWKBUF - WORK ARRAY USED IN WRITING TO THE PDB
C          IREC - RECORD NUMBER OF TIME SERIES IN PROCESSED DATA BASE
C         AINIT - VALUE USED TO INITIALIZE TIME SERIES AND WORK ARRAYS
C        LERDTP - LENGTH OF ARRAY ERDTP
C         ERDTP - ARRAY OF DATA TYPES WITH ERRORS
C        NERDTP - NUMBER OF DATA TYPES IN ARRAY ERDTP
C
C  OUTPUT ARGUMENTS:
C         JHOUR - FIRST HOUR OF DATA IN TSDAT
C        LTSDAT - LENGTH OF TSDAT ARRAY
C         TSDAT - TIME SERIES DATA ARRAY
C          IERR - LENGTH OF WORK ARRAY EXCEEDED
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      SUBROUTINE QINSTN (STAID,DTYPE,INTVAL,UNITIN,UNITOT,NCOUNT,LOBS,
     *   OBS,IOBS,IHOURF,IHOURL,LWORK,WORK,LWKBUF,IWKBUF,
     *   LTSDAT,TSDAT,JHOUR,NSTEP,IREC,AINIT,LERDTP,ERDTP,NERDTP,IERR)
C
      DIMENSION STAID(2),OLDOPN(2)
      DIMENSION OBS(LOBS),IOBS(LOBS)
      DIMENSION WORK(LWORK),TSDAT(LTSDAT),IWKBUF(LWKBUF),ERDTP(LERDTP)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fctim2'
      INCLUDE 'common/pudbug'
      INCLUDE 'common/pptime'
      INCLUDE 'prdcommon/pdatas'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_rrs/RCS/qinstn.f,v $
     . $',                                                             '
     .$Id: qinstn.f,v 1.6 1999/07/06 15:55:51 page Exp $
     . $' /
C    ===================================================================
C
C
      IERR=0
C      
      IOPNUM=-3
      CALL FSTWHR ('QINSTN  ',IOPNUM,OLDOPN,IOLDOP)
C
C  THE TRACE LEVEL FOR THIS ROUITNE IS 1
      IF (IPTRCE.GT.0) WRITE (IOPDBG,220)
C
C  CHECK DEBUG CODES
      IBUG=IPBUG('QINS')
C
C  CHECK IF THE DATA WILL REQUIRE UNITS CONVERSION
      ICONVT=0
      IF (UNITIN.NE.UNITOT) ICONVT=1
C
      IF (IBUG.GT.0.AND.NCOUNT.GT.0) WRITE (IOPDBG,270)
      IF (IBUG.GT.0.AND.NCOUNT.GT.0) WRITE (IOPDBG,280) (IOBS(I),
     *   OBS(I+1),I=1,NCOUNT,2)
C
C  DETERMINE THE NUMBER OF TIME STEPS TO PROCESS
      NSTEP=((IDERUN-IDSRUN)+1)/INTVAL
      IF (IBUG.GT.0) WRITE (IOPDBG,230) NSTEP
C
C  CHECK IF ANY DATA WAS READ FROM THE PPDB
C  IF NO DATA WERE RETURNED - SET THE TIME SERIES TO MISSING
      IF (NCOUNT.GT.0) GO TO 20
      DO 10 I=1,NSTEP
         TSDAT(I)=-999.
10       CONTINUE
      GO TO 190
C
C  GET THE INSTANTANEOUS VALUES FROM THE OBSERVED DATA ARRAY
20    DO 40 L=1,NCOUNT,2
      ITIME=IOBS(L)-NHOPDB
      DATA=OBS(L+1)
C
C  DETERMINE WHERE IN THE WORK ARRAY TO WRITE THE VALUES
      IF (IDSRUN.LT.IHOURF) IWRITE=(ITIME-IHOURF)+(IHOURF-IDSRUN)+1
      IF (IDSRUN.EQ.IHOURF) IWRITE=(ITIME-IHOURF)+1
      IF (IWRITE.LE.LWORK) GO TO 30
         WRITE (IPR,260) DTYPE,STAID,IWRITE,LWORK
         CALL ERROR
         NSTEP=0
         IERR=1
         GO TO 210
C
C  IF THE VALUE IN THE WORK ARRAY HAS NOT BEEN SET TO MISSING,
C  WRITE THE OBSERVED VALUE TO THE WORK ARRAY
30    IF (WORK(IWRITE).LT.-999.) WORK(IWRITE)=DATA
      IF (IBUG.GT.0) WRITE (IOPDBG,250) IWRITE,WORK(IWRITE)
40    CONTINUE
C
C  LOOP TO PROCESS DATA FOR A DATA TYPE
      DO 180 I=1,NSTEP
      ISTEP=INTVAL*I
      IWSTEP=ISTEP+1
C
C  IF THERE IS A VALID OBSERVATION AT THE TIME STEP WRITE IT
C  TO THE TSDAT ARRAY
      IF (WORK(IWSTEP).GT.AINIT) GO TO 170
C
C  DETERMINE THE LOWER AND UPPER LIMITS FOR THE INTERVAL ABOUT
C  THE TIME STEP
      LRANGE=ISTEP-INTVAL/2
      IF (INTVAL/2*2.EQ.INTVAL) LRANGE=LRANGE+1
      IF (LRANGE.LT.0) LRANGE=0
      IURANG=ISTEP+INTVAL/2
C
C  DETERMINE THE NUMBER OF VALID OBSERVATIONS IN THE LOWER
C  PORTION OF THE TIME INTERVAL
      LCOUNT=0
      IF (LRANGE.EQ.0) GO TO 70
      DO 60 J=LRANGE,ISTEP
         IF (WORK(J+1).GT.-999.) LCOUNT=LCOUNT+1
60       CONTINUE
C
C  DETERMINE THE NUMBER OF VALID OBSERVATIONS IN THE UPPER
C  PORTION OF THE TIME INTERVAL
70    IUCONT=0
      IF (ISTEP.EQ.0) GO TO 90
         DO 80 J=ISTEP,IURANG
            IF (WORK(J+1).GT.-999.) IUCONT=IUCONT+1
80          CONTINUE
C
90    IF (IBUG.GT.0) WRITE (IOPDBG,290) LRANGE,IURANG,LCOUNT,IUCONT
C
C  IF THERE ARE NO NON-MISSING OBSERVATIONS WITHIN THE TIME INTERVAL
C  SET THE VALUE IN THE TSDAT ARRAY TO MISSING
      IF ((LCOUNT+IUCONT).GT.0) GO TO 100
         IF (IBUG.GT.0) WRITE (IOPDBG,300) LRANGE,IURANG
         TSDAT(I)=-999.
         GO TO 180
C
C  IF THERE IS ONLY ONE VALID OBSERVATION IN THE TIME INTERVAL
C  SET THE VALUE IN THE TSDAT ARRAY TO IT
100   IF ((LCOUNT+IUCONT).NE.1) GO TO 120
         DO 110 J=LRANGE,IURANG
            IF (WORK(J+1).GT.-999.) TSDAT(I)=WORK(J+1)
            IF (IBUG.GT.0.AND.WORK(J+1).GT.-999.) WRITE (IOPDBG,310)
            IF (WORK(J+1).GT.-999.) GO TO 180
110         CONTINUE
C
C  DETERMINE THE OBSERVATION IN THE LOWER PORTION OF THE TIME INTERVAL
C  THAT IS CLOSEST TO THE TIME STEP
120   PREOBS=-999.
      IF (LCOUNT.EQ.0) GO TO 140
         IBOUND=INTVAL/2
         IF (INTVAL/2*2.EQ.INTVAL) IBOUND=IBOUND-1
         DO 130 J=1,IBOUND
            IF (WORK(IWSTEP-J).LT.-998) GO TO 130
               PREOBS=WORK(IWSTEP-J)
               IPREVT=ISTEP-J
               IF (IBUG.GT.0) WRITE (IOPDBG,330) IPREVT,PREOBS
               GO TO 140
130         CONTINUE
C
C  DETERMINE THE OBSERVATION IN THE UPPER PORTION OF THE TIME INTERVAL
C  THAT IS CLOSEST TO THE TIME STEP
140   XTOBS=-999.
      IF (IUCONT.EQ.0) GO TO 160
         INTV=INTVAL/2
         DO 150 J=1,INTV
            IF (WORK(IWSTEP+J).LT.-998) GO TO 150
               XTOBS=WORK(IWSTEP+J)
               INEXT=ISTEP+J
               IF (IBUG.GT.0) WRITE (IOPDBG,340) INEXT,XTOBS
               GO TO 160
150         CONTINUE
C
160   IF (LCOUNT.EQ.0) TSDAT(I)=XTOBS
      IF (IUCONT.EQ.0) TSDAT(I)=PREOBS
      IF (LCOUNT.EQ.0.OR.IUCONT.EQ.0) GO TO 180
C
C  USE LINEAR INTERPOLATION
      DIFF=INEXT-IPREVT
      PREWGT=1-((ISTEP-IPREVT)/DIFF)
      XTWGT=1-((INEXT-ISTEP)/DIFF)
      TSDAT(I)=PREOBS*PREWGT + XTOBS*XTWGT
      IF (IBUG.GT.0) WRITE (IOPDBG,350) PREOBS,XTOBS,IPREVT,INEXT,ISTEP,
     *   DIFF,TSDAT(I)
      GO TO 180
C
170   TSDAT(I)=WORK(IWSTEP)
      IF (IBUG.GT.0) WRITE (IOPDBG,240) WORK(IWSTEP),ISTEP
180   CONTINUE
C
C  NX IS THE AMOUNT OF EXTRA SPACE NEEDED IN THE TIME SERIES HEADER
C  NPDTX IS THE NUMBER OF VALUES PER TIME STEP
190   NX=0
      NPDTX=1
      MAXDAY=IPRDMD(DTYPE)
      LWBUFF=((((24/INTVAL)*NPDTX*MAXDAY+22+NX-1)/LRECLT)+1)*
     *   LRECLT
      IF (LWBUFF.LT.LWKBUF) GO TO 200
         WRITE (IPR,320) LWKBUF,STAID,DTYPE,LWBUFF
         CALL WARN
         GO TO 210
C
200   IF (IBUG.GT.0) THEN
         WRITE (IOPDBG,360)
         WRITE (IOPDBG,370) (TSDAT(I),I=1,NSTEP)
         ENDIF
C
C  DETERMINE THE BEGINING AND ENDING HOURS OF DATA
      IHOURF=IDSRUN+INTVAL
      IHOURL=IDERUN
C
C  DETERMINE THE FIRST HOUR THAT IS WRITTEN INTO THE PDB
      JHOUR=IDSRUN+INTVAL+NHOPDB
C
C  DETERMINE THE FIRST HOUR OF FUTURE DATA
      IF (IFPTR.LT.ISTRUN+NHOPDB) IFPTR=JHOUR
      IF (IFPTR.GT.IDERUN+NHOPDB) IFPTR=0
C
C  WRITE TIME SERIES TO PROCESSED DATA BASE
      CALL QXWPRD (STAID,DTYPE,JHOUR,INTVAL,UNITOT,NSTEP,
     *   LTSDAT,TSDAT,IFPTR,LWKBUF,IWKBUF,IREC,LERDTP,ERDTP,NERDTP)
C
210   CALL FSTWHR (OLDOPN,IOLDOP,OLDOPN,IOLDOP)
      IF (IPTRCE.GT.0) WRITE (IOPDBG,380)
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
220   FORMAT ('0*** ENTER QINSTN')
230   FORMAT ('0NSTEP= ',I4)
240   FORMAT ('0THERE WAS A VALUE ',G15.7,' AT TIME STEP ',I6)
250   FORMAT ('0WORK(',I4,') IS ',G15.7)
260   FORMAT ('0**ERROR** COUNTER FOR WRITING DATA TYPE ',A4,
     *      ' FOR STATION ',2A4,' INTO WORK ARRAY IS ',I6,
     *      ' AND EXCEEDS THE ARRAY SIZE (',I6,').' /
     *   11X,'PROCESSING WILL CONTINUE WITH THE NEXT DATA TYPE.')
270   FORMAT ('0THE TIMES AND OBSERVATIONS OF THE OBSERVED DATA')
280   FORMAT (1X,I6,1X,G15.7)
290   FORMAT ('0THE LOWER RANGE IS ',I6,2X,' THE UPPER RANGE IS ',I6,2X/
     * '0THE NUMBER OF OBS IN THE LOWER RANGE IS ',I3,2X,' THE NUMBER',
     * ' OF OBS IN THE UPPER RANGE IS ',I3)
300   FORMAT ('0THERE ARE NO OBSERVATIONS BETWEEN ',I6,' AND ',I6,
     * ' THE PERIOD WILL BE SET TO MISSING')
310   FORMAT ('0THERE IS ONLY ONE OBSERVATION IN THE RANGE SO ITS',
     * ' VALUE WILL BE ASSIGNED TO THE PERIOD')
320   FORMAT ('0**WARNING** SIZE OF WORK ARRAY (',I5,') TOO SMALL FOR ',
     *   'STATION ',2A4,' AND DATA TYPE ',A4,'. ',I5,' WORDS NEEDED.' /
     *   11X,'PROCESSING WILL CONTINUE WITH THE NEXT DATA TYPE.')
330   FORMAT ('0THE CLOSEST OBSERVATION IN THE LOWER RANGE IS AT TIME',
     * I6,' AND HAS A VALUE OF ',G15.7)
340   FORMAT ('0THE CLOSEST OBSERVATION IN THE UPPER RANGE IS AT TIME',
     * I6,' AND HAS A VALUE OF ',G15.7)
350   FORMAT ('0PREOBS= ',G15.7,' XTOBS= ',G15.7,' IPREVT= ',I6,
     * ' INEXT= ',I6,' ISTEP= ',I6,/'0DIFF= ',F5.1,' THE INTERPOLATED',
     * ' VALUE= ',G15.7)
360   FORMAT ('0THE VALUES IN THE TSDAT ARRAY ')
370   FORMAT (1H0,5G15.7)
380   FORMAT ('0*** EXIT QINSTN')
C
      END
