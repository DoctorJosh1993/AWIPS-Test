C MODULE HRPRDN
C-----------------------------------------------------------------------
C
      SUBROUTINE HRPRDN (IRCBUF,NRCWDS,IDFBUF,NDFWDS,IDFFLG,ISTAT)
C
C          ROUTINE:  HRPRDN
C             VERSION:  1.0.0
C                DATE:  1-7-82
C              AUTHOR:  JIM ERLANDSON
C                       DATA SCIENCES INC
C
C***********************************************************************
C
C          DESCRIPTION:
C
C    ROUTINE TO WRITE HCL FUNCTION AND TECHNIQUE DEFINITIONS
C    FOR REPLACE TYPE COMMANDS. RECORD MUST EXIST AND PASSWORD
C    MUST BE THE SAME. UPDATES ALL CONTROLS. CHECKS FOR ROOM
C    IN ORIGINAL RECORD BEFORE WRITING A NEW ONE. ALSO TAKES CARE
C    OF DEFAULT RECORDS.
C
C***********************************************************************
C
C          ARGUMENT LIST:
C
C         NAME    TYPE  I/O   DIM   DESCRIPTION
C
C       IRCBUF     I     I/O   ?    ARRAY CONTAINING DEFINITION
C       NRCWDS     I      I     1   NUMBER OF WORDS USED IN IRCBUF
C       IDFBUF     I     I/O    ?   ARRAY CONTAINING DEFAULT
C       NDFWDS     I      I     1   NUMBER OF WORDS USED IN IDFBUF
C       IDFFLG     I      I     1   DEFAULT UPDATE FLAG
C                                     1=UPDATE DEFAULTS
C       ISTAT      I      O     1   STATUS INDICATOR
C                                     0=OK
C                                     OTHER=ERROR
C
C***********************************************************************
C
C          COMMON:
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'hclcommon/hcntrl'
      INCLUDE 'hclcommon/hindx'
      INCLUDE 'hclcommon/hunits'
      INCLUDE 'hclcommon/hdatas'
C
C***********************************************************************
C
C          DIMENSION AND TYPE DECLARATIONS:
C
      PARAMETER (LTMPRC=2000,LTMPDF=2000)
      DIMENSION ITMPRC(LTMPRC),ITMPDF(LTMPDF)
      DIMENSION NAME(2)
      DIMENSION IRCBUF(*),IDFBUF(*)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/db_hclrw/RCS/hrprdn.f,v $
     . $',                                                             '
     .$Id: hrprdn.f,v 1.2 1998/04/07 13:02:10 page Exp $
     . $' /
C    ===================================================================
C
C
C***********************************************************************
C
C          DATA:
C
C
C***********************************************************************
C
C
      ISTAT=0
C
      ITYPE=IRCBUF(3)
      IDFN=0
      IROOM=0
      CALL UMEMOV (IRCBUF(4),NAME,2)
C
C  FIND RECORD
      CALL HFNDDF (NAME,IREC,ITYPE,IXREC)
      IF (IREC.NE.0) GO TO 30
         WRITE (LP,20) NAME
20    FORMAT ('0**ERROR** NO DEFINITION FOUND FOR NAME ',2A4,'.')
         ISTAT=1
         GO TO 280
C
C  GET RECORD AND CHECK PASSWORD
30    IUNIT=KDEFNL
      IF (ITYPE.LT.0) IUNIT=KDEFNG
      CALL HGTRDN (IUNIT,IREC,ITMPRC,LTMPRC,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
C
      IF (IRCBUF(6).EQ.ITMPRC(6)) GO TO 50
         WRITE (LP,40) NAME
40    FORMAT ('O**ERROR** INVALID PASSWORD FOR RECORD ',2A4,'.')
         ISTAT=1
         GO TO 280
C
C  CHECK IF THERE IS A DEFAULT IN OLD RECORD
50    IF (IDFFLG.EQ.0) GO TO 210
      IDFREC=ITMPRC(7)
      IF (ITYPE.LT.0) IDFREC=ITMPRC(8)
      IF (IDFREC.EQ.0) GO TO 130
      CALL HGTRDN (IUNIT,IDFREC,ITMPDF,LTMPDF,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
C
C  IS THERE A DEFAULT IN NEW RECORD
      IF (IRCBUF(9).NE.0) GO TO 60
         IDFN=1
         GO TO 90
C
C  IS THERE ROOM IN OLD DEFAULT RECORD
60    MAXWDS=ITMPDF(1)*LRECLH
      IF (MAXWDS.GE.NDFWDS) GO TO 70
         IROOM=1
         GO TO 90
C
C  WRITE THE DEFAULT IN SAME PLACE
70    IDFBUF(2)=1
      IDFBUF(1)=ITMPDF(1)
      CALL WVLRCD (IUNIT,IDFREC,ITMPDF(1),IDFBUF,LRECLH,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
      IF (IHCLDB.EQ.3) WRITE (IOGDB,80)
80    FORMAT (' WROTE THE DEFAULT IN SAME PLACE')
      GO TO 110
C
C  DELETE THE OLD DEFAULT RECORD
90    ITMPDF(2)=0
      CALL UWRITT(IUNIT,IDFREC,ITMPDF,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
      IF (IHCLDB.EQ.3) WRITE (IOGDB,100)
100   FORMAT (' DELETED THE OLD DEFAULT')
C
C  PUT DEFAULT RECORD NUMBERS IN RECORD
110   IF (IDFN.EQ.1) GO TO 210
      IF (IROOM.EQ.1) GO TO 130
      CALL UMEMOV (ITMPRC(7),IRCBUF(7),2)
      IF (IRCBUF(3).NE.-1) GO TO 210
      IF (HCNTL(13,2)+IDFBUF(1).GT.HCNTL(12,2)) GO TO 170
      IRCBUF(7)=HCNTL(13,2)+1
      HCNTL(13,2)= HCNTL(13,2)+IDFBUF(1)
      IF (IHCLDB.EQ.3) WRITE (IOGDB,120)
120   FORMAT (' CREATED NEW SPACE FOR LOCAL DEFAULT ')
      GO TO 210
C
C  HAVE TO WRITE NEW DEFAULTS
130   IF (IRCBUF(9).EQ.0) GO TO 210
C
      IF (ITYPE.GT.0) IRCBUF(7)=HCNTL(7,1)+1
      IF (ITYPE.LT.0) IRCBUF(8)=HCNTL(7,2)+1
C
C   WRITE THE RECORD
      IDFBUF(2)=1
      CALL HPTRCD (IDFBUF(3),NDFWDS,IDFBUF,ISTAT)
      IF (ISTAT.EQ.0) GO TO 150
      WRITE (LP,140)
140   FORMAT ('0**ERROR**  UNABLE TO WRITE NEW DEFAULT RECORD')
      GO TO 280
C
150   IF (IHCLDB.EQ.3) WRITE (IOGDB,160)
160   FORMAT (' WROTE A NEW DEFAULT RECORD')
C
C  RESERVE ROOM FOR LOCAL DEFAULT
      IF (ITYPE.GT.0) GO TO 210
      IF (HCNTL(13,2)+IDFBUF(1).LE.HCNTL(12,2)) GO TO 190
170   WRITE (LP,180)
180   FORMAT ('0**ERROR** LOCAL DEFAULT FILE IS FULL')
      ISTAT=1
      GO TO 280
C
190   IRCBUF(7)=HCNTL(13,2)+1
      HCNTL(13,2)=HCNTL(13,2)+IDFBUF(1)
      IF (IHCLDB.EQ.3) WRITE (IOGDB,200)
200   FORMAT (' RESERVED ROOM FOR NEW LOCAL DEFAULT FOR GLOBAL')
C
C  CHECK IF ROOM IN OLD RECORD
210   MAXWDS=ITMPRC(1)*LRECLH
      IRCBUF(2)=ITMPRC(2)
      IF (MAXWDS.LT.NRCWDS) GO TO 230
      IRCBUF(1)=ITMPRC(1)
      NUMO=LRECLH*IRCBUF(1)-NRCWDS
      CALL UMEMST (0,IRCBUF(NRCWDS+1),NUMO)
      CALL WVLRCD (IUNIT,IREC,ITMPRC(1),IRCBUF,LRECLH,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
      IF (IHCLDB.EQ.3) WRITE (IOGDB,220)
220   FORMAT (' WROTE RECORD IN SAME PLACE')
      GO TO 280
C
C  NOT ENOUGH ROOM - DELETE RECORD
230   ITMPRC(2)=0
      CALL UWRITT(IUNIT,IREC,ITMPRC,ISTAT)
      IF (ISTAT.NE.0) GO TO 260
      IF (IHCLDB.EQ.3) WRITE (IOGDB,240)
240   FORMAT (' DELETED OLD RECORD')
C
C   WRITE THE NEW RECORD
      CALL HPTRDN (IRCBUF(3),NRCWDS,IRCBUF,ISTAT)
      IF (IHCLDB.EQ.3) WRITE (IOGDB,250)
250   FORMAT (' WROTE A NEW RECORD')
      IF (ISTAT.EQ.0) GO TO 280
C
C  SYSTEM ERROR
260   WRITE (LP,270)
270   FORMAT ('0**ERROR** SYSTEM ERROR IN HREPRD')
      ISTAT=1
      GO TO 280
C
280   RETURN
C
      END