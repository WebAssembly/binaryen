@echo off
:: Entry point for running gen-exprs.py on windows systems.

if "%PYTHON%"=="" (
  set PYTHON=python
)

"%PYTHON%" "%~dp0\%~n0.py" %*
