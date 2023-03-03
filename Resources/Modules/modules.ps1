Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name ImportExcel -AllowClobber -AcceptLicense -Scope CurrentUser -Force -ErrorAction Continue

Install-Module -Name Az -AllowClobber -AcceptLicense -Scope CurrentUser -Force -ErrorAction Continue

Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser -ErrorAction Continue