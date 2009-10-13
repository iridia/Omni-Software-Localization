@ECHO OFF
REM gittrb - git track remote branch
REM Usage:
REM  gittrb <branch-to-track>

git.exe checkout --track -b %1 origin/%1