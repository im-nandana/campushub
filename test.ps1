# PowerShell test runner script
$portableJdk = "$env:USERPROFILE\.tools\jdk-17.0.20.1+1"
$portableMvn = "$env:USERPROFILE\.tools\apache-maven-3.9.6"

if (Test-Path "$portableMvn\bin\mvn.cmd") {
    $env:JAVA_HOME = $portableJdk
    $env:M2_HOME = $portableMvn
    $env:PATH = "$portableJdk\bin;$portableMvn\bin;$env:PATH"
}

mvn test
