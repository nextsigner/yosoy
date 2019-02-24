@echo off & setlocal enableextensions disabledelayedexpansion
  if "%~3"=="" (
    echo Usage: %~0 DD MM YYYY
    echo No leading zeros!
    goto :EOF)
  ::
  :: Get the date
  set day=%~1
  set month=%~2
  set year=%~3
  ::
  :: Call the day ordinal number subroutine
  call :JDweekNumber %day% %month% %year% WeekNumber
  ::
  :: Display the result
  ::echo %day%.%month%.%year% Week number %WeekNumber%
  echo %WeekNumber%
  endlocal & goto :EOF
  ::
  :: =====================================
  :: Subroutine: Calculate the week number
  :: The weeks in the algorithm start on Mondays
  :JDweekNumber day month year return_
  setlocal enableextensions enabledelayedexpansion
  if %2 LEQ 2 (
    set /a a=%3-1
    set /a b=!a!/4-!a!/100+!a!/400
    set /a c=^(!a!-1^)/4-^(!a!-1^)/100+^(!a!-1^)/400
    set /a s=!b!-!c!
    set /a e=0
    set /a f=%1-1+31*^(%2-1^)
    ) else (
    set /a a=%3
    set /a b=!a!/4-!a!/100+!a!/400
    set /a c=^(!a!-1^)/4-^(!a!-1^)/100+^(!a!-1^)/400
    set /a s=!b!-!c!
    set /a e=!s!+1
    set /a f=%1+^(153*^(%2-3^)+2^)/5+58+!s!
    )
  set /a g=(%a%+%b%) %% 7
  set /a d=(%f%+%g%-%e%) %% 7
  set /a n=%f%+3-%d%
  set return_=
  if %n% LSS 0 set /a return_=53
  if %n% GTR 364+%s% set /a return_=1
  if not defined return_ set /a return_=%n%/7+1
  endlocal & set "%4=%return_%" & goto :EOF