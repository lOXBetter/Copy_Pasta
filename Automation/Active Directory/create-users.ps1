$FirstName = "John"
$LastName = "Doe"
$Username = "johndoe"
$Password = ConvertTo-SecureString "Password123" -AsPlainText -Force
$OU = "OU=Users,DC=domain,DC=com"

New-ADUser -Name "$FirstName $LastName" -GivenName $FirstName -Surname $LastName -SamAccountName $Username -AccountPassword $Password -Path $OU -Enabled $true

