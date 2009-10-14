@ECHO OFF
REM Merge Branch %1 into Branch %2
git.exe checkout %2
git.exe pull . %1