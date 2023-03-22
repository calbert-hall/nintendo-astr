@echo off 
@REM cd C:\Applitools\SiteMapDEV
@REM curl https://www.phs.org/sitemap.xml -o proper-sitemap.xml

@REM curl https://presbyterian-hospital.phs.org/sitemap.xml -o presbyterian-sitemap.xml

curl https://kaseman-hospital.phs.org/sitemap.xml -o kaseman-sitemap.xml

@REM curl https://rust-medical-center.phs.org/sitemap.xml -o rust-sitemap.xml

@REM curl https://espanola-hospital.phs.org/sitemap.xml -o espanola-sitemap.xml

@REM curl https://danctrigg-memorial-hospital.phs.org/sitemap.xml -o danctrigg-sitemap.xml

@REM curl https://socorro-general-hospital.phs.org/sitemap.xml -o socorro-sitemap.xml

@REM curl https://lincoln-county-medical-center.phs.org/sitemap.xml -o lincoln-sitemap.xml

@REM curl https://plains-regional-medical-center.phs.org/sitemap.xml -o plains-sitemap.xml

@REM curl https://santa-fe-medical-center.phs.org/sitemap.xml -o santafe-sitemap.xml

set env=%1
set batchName=%2
set appName=%2
set runType=%3
set compareEnv=%4
set YYYYMMDD=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
set HHMM=%time:~0,2%%time:~3,2%
@REM set batchID=%YYYYMMDD%-%HHMM%
@REM set batchID=%batchID: =%
set protocol=https://
set url=.phs.org
set config=chromeGrid
set baselineBranch=prod
set saveFailTests=false
set deleteOnFinish=false

if %env%==dev-07 (
    set protocol=http://
    set url=-07.phs.org
    if %runType%==baseline (
        set baselineBranch=%env%
    )
    if %runType%==compare (
        set batchName=%batchName%-Compare
        if [%compareEnv%]==[] ( set baselineBranch=prod ) else ( set baselineBranch=%compareEnv% )
    )
)
if %env%==prod (
    set protocol=https://
    set url=.phs.org
    if %runType%==baseline (
        set saveFailTests=true
        set deleteOnFinish=finish
    )
    if %runType%==compare (
        set batchName=%batchName%-Compare
        set saveFailTests=false
    )
)
if %env%==test (
    set protocol=https://
    set url=-test.phs.org
    if %runType%==baseline (
        set baselineBranch=%env%
        set deleteOnFinish=finish
    )
    if %runType%==compare (
        set batchName=%batchName%-Compare
        if [%compareEnv%]==[] ( set baselineBranch=prod ) else ( set baselineBranch=%compareEnv% )
    )
) else (
    echo "Please enter prod or test or dev-07 only"
)

echo "Config: "
echo %env%
echo %batchName%
echo %protocol%
echo %url%
echo %config%
echo %baselineBranch%
echo %batchID%
echo %deleteOnFinish%

start Java -jar ApplitoolsSimpleTestRunner.jar job-sitemap.xml "-var[batchName,%batchName%]" "-var[batchId,%batchID%]" "-var[appName,presbyterian-hospital]" "-var[sitemapUrl,presbyterian-sitemap.xml]" "-var[protocol,%protocol%]" "-var[urlString,%url%]" "-var[configName,%config%]" "-var[envName,%env%]" "-var[siteUrl,%protocol%presbyterian-hospital%url%]" "-var[prodUrl,https://presbyterian-hospital.phs.org]" "-var[baselineBranch,%baselineBranch%]" "-var[saveFailedTests,%saveFailTests%]" "-var[deleteOnFinish,%deleteOnFinish%]"
start Java -jar ApplitoolsSimpleTestRunner.jar job-sitemap.xml "-var[batchName,%batchName%]" "-var[batchId,%batchID%]" "-var[appName,kaseman-hospital]" "-var[sitemapUrl,kaseman-sitemap.xml]" "-var[protocol,%protocol%]" "-var[urlString,%url%]" "-var[configName,%config%]" "-var[envName,%env%]" "-var[siteUrl,%protocol%kaseman-hospital%url%]" "-var[prodUrl,https://kaseman-hospital.phs.org]" "-var[baselineBranch,%baselineBranch%]" "-var[saveFailedTests,%saveFailTests%]" "-var[deleteOnFinish,%deleteOnFinish%]"
call Java -jar ApplitoolsSimpleTestRunner.jar job-sitemap.xml "-var[batchName,%batchName%]" "-var[batchId,%batchID%]" "-var[appName,proper]" "-var[sitemapUrl,proper-sitemap.xml]" "-var[protocol,%protocol%]" "-var[urlString,%url%]" "-var[configName,%config%]" "-var[envName,%env%]" "-var[siteUrl,%protocol%www%url%]" "-var[prodUrl,https://www.phs.org]" "-var[baselineBranch,%baselineBranch%]" "-var[saveFailedTests,%saveFailTests%]" "-var[deleteOnFinish,%deleteOnFinish%]"

@REM We're commenting this out as we can close the batch after the larger run. 
@REM set APPLITOOLS_SERVER_URL=https://eyesapi.applitools.com
@REM echo %batchID%
@REM curl -v --location --request DELETE "%APPLITOOLS_SERVER_URL%/api/sessions/batches/%batchID%/close/bypointerid?apiKey=%APPLITOOLS_API_KEY%"