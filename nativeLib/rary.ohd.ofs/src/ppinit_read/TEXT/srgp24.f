C MEMBER SRGP24
C-----------------------------------------------------------------------
C
C DESC READ GP24 PARAMETERS
C
      SUBROUTINE SRGP24 (IVGP24,MGP24,IGP24,NGP24,MSGP24,ISGP24,NSGP24,
     *   UNUSED,LARRAY,ARRAY,IPRERR,IPTR,IPTRNX,ISTAT)
C
C
      REAL XGP24/4HGP24/
      REAL*8 BLNK8/8H        /
      INTEGER*2 IGP24(1),ISGP24(MSGP24)
C
      DIMENSION ARRAY(LARRAY),UNUSED(1)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_read/RCS/srgp24.f,v $
     . $',                                                             '
     .$Id: srgp24.f,v 1.1 1995/09/17 19:14:50 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) WRITE (IOSDBG,90)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG(XGP24)
C
      IF (LDEBUG.GT.0) WRITE (IOSDBG,100) LARRAY
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
      ISTAT=0
C
C  READ PARAMETER ARRAY
      CALL SUDOPN (1,4HPPP ,IERR)
      CALL RPPREC (BLNK8,XGP24,IPTR,LARRAY,ARRAY,NFILL,IPTRNX,IERR)
      IF (IERR.EQ.0) GO TO 10
         ISTAT=IERR
         IF (IPRERR.EQ.0) GO TO 80
            CALL SRPPST (BLNK8,XGP24,IPTR,LARRAY,NFILL,IPTRNX,IERR)
            WRITE (LP,180)
            CALL SUERRS (LP,2,-1)
            ISTAT=1
            GO TO 80
C
C  SET PARAMETER ARRAY VERSION NUMBER
10    IVGP24=ARRAY(1)
C
C  SET NUMBER OF STATIONS
      NGP24=ARRAY(2)
C
C  SET NUMBER OF STATIONS THAT SHARE SAME GRID-POINT ADDRESS
      NSGP24=ARRAY(3)
C
C  POSITIONS 4 AND 5 ARE UNUSED
      UNUSED(1)=ARRAY(4)
      UNUSED(2)=ARRAY(5)
C
      NPOS=5
C
C  CHECK FOR SUFFICIENT SPACE FOR FORECAST GROUP IDENTIFIERS
      IF (NGP24.LE.MGP24) GO TO 30
         WRITE (LP,140) NGP24,MGP24
         CALL SUERRS (LP,2,-1)
         ISTAT=3
         GO TO 80
C
C  SET FORECAST GROUP IDENTIFIERS
30    CALL SUBSTR (ARRAY(NPOS+1),1,NGP24*4,IGP24(1),1)
      NPOS=NPOS+NGP24
C
      IF (NSGP24.EQ.0) GO TO 70
C
C  CHECK FOR SUFFICIENT SPACE FOR DUPLICATE MAP IDENTIFIERS
      IF (NSGP24.LE.MSGP24) GO TO 50
         WRITE (LP,150) NSGP24,MSGP24
         CALL SULINE (LP,2)
         ISTAT=2
         GO TO 80
C
C  SET IDENTIFIER OF MAP AREAS IN MORE THAN ONE FORECAST GROUP
50    CALL SUBSTR (ARRAY(NPOS+1),1,NSGP24*2,ISGP24(1),1)
      NPOS=NPOS+(NSGP24+1)/2
C
70    IF (LDEBUG.EQ.0) GO TO 80
         WRITE (IOSDBG,110) NPOS,NFILL,IPTRNX,NGP24,NSGP24
         CALL SULINE (IOSDBG,1)
         CALL SUPDMP (XGP24,4HREAL,0,NPOS,ARRAY,ARRAY)
         CALL SUPDMP (XGP24,4HINT2,0,NPOS,ARRAY,ARRAY)
C
80    IF (ISTRCE.GT.0) WRITE (IOSDBG,200)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
      RETURN
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
90    FORMAT (' *** ENTER SRGP24')
100   FORMAT (' LARRAY=',I5)
110   FORMAT (' NPOS=',I3,3X,'NFILL=',I3,3X,'IPTRNX=',I3,3X,
     *   'NGP24=',I3,3X,'NSGP24=',I3)
130   FORMAT (15X,'GP24 PARAMETER RECORD POINTER NUMBER=',I3)
140   FORMAT ('0*** ERROR - IN SRGP24 - ',I4,' STATIONS IN GRID-POINT ',
     *   'LIST. MAXIMUM NUMBER THAT CAN BE PROCESSED IS ',I4,'.')
150   FORMAT ('0*** ERROR - IN SRGP24 - ',I4,' STATIONS IN DUPLICATE ',
     *   'GRID-POINT LIST. MAXIMUM NUMBER THAT CAN BE PROCESSED IS ',
     *   I4,'.')
170   FORMAT ('0*** ERROR - IN SRGP24 - UNSUCCESSFUL CALL TO RPPREC ',
     *   ': STATUS CODE=',I2)
180   FORMAT ('0*** ERROR - GP24 PARAMETERS NOT SUCCESSFULLY READ.')
200   FORMAT (' *** EXIT SRGP24')
C
      END
