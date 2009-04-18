      SUBROUTINE MESGBF(LUNIT,MESGTYP)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    MESGBF
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS SUBROUTINE READS AND EXAMINES SECTION 1 OF MESSAGES
C  IN A BUFR FILE IN SEQUENCE UNTIL IT FINDS THE FIRST MESSAGE THAT
C  IS NOT A BUFR TABLE (DICTIONARY) (I.E., NOT MESSAGE TYPE 11).  IT
C  THEN RETURNS THE MESSAGE TYPE FOR THIS FIRST NON-DICTIONARY MESSAGE.
C  THE BUFR FILE SHOULD NOT BE OPEN VIA BUFR ARCHIVE LIBRARY SUBROUTINE
C  OPENBF PRIOR TO CALLING THIS SUBROUTINE HOWEVER THE BUFR FILE MUST
C  BE CONNECTED TO UNIT LUNIT.  THIS SUBROUTINE IS IDENTICAL TO BUFR
C  ARCHIVE LIBRARY SUBROUTINE MESGBC EXCEPT MESGBC RETURNS THE MESSAGE
C  TYPE FOR THE FIRST NON-DICTIONARY MESSAGE THAT ACTUALLY CONTAINS
C  REPORT DATA (WHEREAS MESGBF WOULD RETURN THE REPORT TYPE OF A DUMMY
C  MESSAGE CONTAINING THE CENTER TIME FOR DUMP FILES), AND MESGBC ALSO
C  INDICATES WHETHER OR NOT THE FIRST REPORT DATA MESSAGE CONTAINS
C  REPORT DATA IS BUFR COMPRESSED.  (MESGBC ALSO HAS AN OPTION TO
C  OPERATE ON THE CURRENT BUFR STORED IN MEMORY, SOMETHING MESGBF
C  CANNOT DO.)
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 2000-09-19  J. WOOLLEN -- MAXIMUM MESSAGE LENGTH INCREASED FROM
C                           10,000 TO 20,000 BYTES
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
C                           DOCUMENTATION (INCLUDING HISTORY)
C 2004-08-09  J. ATOR    -- MAXIMUM MESSAGE LENGTH INCREASED FROM
C                           20,000 TO 50,000 BYTES
C 2005-11-29  J. ATOR    -- USE IUPBS01 AND RDMSGW
C
C USAGE:    CALL MESGBF (LUNIT, MESGTYP)
C   INPUT ARGUMENT LIST:
C     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR BUFR FILE
C
C   OUTPUT ARGUMENT LIST:
C     MESGTYP  - INTEGER: BUFR MESSAGE TYPE FOR FIRST NON-DICTIONARY
C                MESSAGE
C                      -1 = no messages read or error
C                      11 = if only BUFR table messages in BUFR file
C
C   INPUT FILES:
C     UNIT "LUNIT" - BUFR FILE
C
C REMARKS:
C    THIS ROUTINE CALLS:        IUPBS01  RDMSGW   WRDLEN
C    THIS ROUTINE IS CALLED BY: None
C                               Normally called only by application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      INCLUDE 'bufrlib.prm'

      DIMENSION    MBAY(MXMSGLD4)

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      MESGTYP = -1

C  SINCE OPENBF HAS NOT YET BEEN CALLED, MUST CALL WRDLEN TO GET 
C  MACHINE INFO NEEDED LATER
C  -------------------------------------------------------------

      CALL WRDLEN

C  READ PAST ANY BUFR TABLES AND RETURN THE FIRST MESSAGE TYPE FOUND
C  -----------------------------------------------------------------

      REWIND LUNIT

1     CALL RDMSGW(LUNIT,MBAY,IER)
      IF(IER.LT.0) GOTO 100

      MESGTYP = IUPBS01(MBAY,'MTYP')
      IF(MESGTYP.EQ.11) GOTO 1

      REWIND LUNIT

C  EXIT
C  ----

100   RETURN
      END
