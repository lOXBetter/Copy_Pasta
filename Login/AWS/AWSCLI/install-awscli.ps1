Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -OutFile AWSCLIV2.msi
Start-Process msiexec.exe -ArgumentList '/i', 'AWSCLIV2.msi', '/quiet' -Wait

aws configure
