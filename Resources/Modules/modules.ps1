Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name ImportExcel -AllowClobber -AcceptLicense -Scope CurrentUser -Force -ErrorAction Continue

Install-Module -Name Az -AllowClobber -AcceptLicense -Scope CurrentUser -Force -ErrorAction Continue

Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser -ErrorAction Continue

Install-Module -Name PowerHTML -Force -Scope CurrentUser -ErrorAction Continue

Install-Module -Name Selenium -Force -Scope CurrentUser -ErrorAction Continue

Install-Package Selenium.WebDriver.ChromeDriver -Version 114.0.5735.9000