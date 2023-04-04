saveFailedTests=true
baselineEnv=.com
compareEnv=.com/fr-ca
batchId=$(openssl rand -base64 16)

echo "batch Id:"
echo $batchId
echo "Config values:"
echo $saveFailedTests
echo $baselineEnv
echo $compareEnv

echo "Staring ASTR..."

java -jar ApplitoolsSimpleTestRunner.jar nintendo-job.xml "-var[saveFailedTests,true]" "-var[deleteOnFinish,finish]" "-var[matchLevel,Strict]" "-var[sitemapUrl,$baselineEnv]" "-var[siteLanguage, english]"  "-var[batchId,$batchId]"  
java -jar ApplitoolsSimpleTestRunner.jar nintendo-job.xml "-var[saveFailedTests,false]" "-var[deleteOnFinish,false]" "-var[matchLevel,Layout]" "-var[sitemapUrl,$compareEnv]" "-var[siteLanguage, fr-ca]" "-var[batchId,$batchId]" 
compareEnv=.com/es-mx
java -jar ApplitoolsSimpleTestRunner.jar nintendo-job.xml "-var[saveFailedTests,false]" "-var[deleteOnFinish,false]" "-var[matchLevel,Layout]" "-var[sitemapUrl,$compareEnv]" "-var[siteLanguage, es-mx]" "-var[batchId,$batchId]" 

curl -v --location --request DELETE "https://eyes.applitools.com/api/sessions/batches/$batchId/close/bypointerid?apiKey=$APPLITOOLS_API_KEY"  