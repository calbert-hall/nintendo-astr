
set batchID=%YYYYMMDD%-%HHMM%
set batchID=%batchID: =%

@REM Reccomend that this be a PR / version name, more descriptive than date. 
set batchName="Compare - %date%"
set batchName=%batchName: =%

call RunSiteMap.bat prod %batchName% baseline

call RunSiteMap.bat dev-17 %batchName% compare prod

set APPLITOOLS_SERVER_URL=https://eyesapi.applitools.com
echo %batchID%
curl -v --location --request DELETE "%APPLITOOLS_SERVER_URL%/api/sessions/batches/%batchID%/close/bypointerid?apiKey=%APPLITOOLS_API_KEY%"