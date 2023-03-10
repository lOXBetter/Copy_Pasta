Add-Type -AssemblyName System.Windows.Forms

# Create the form and add a label
$form = New-Object System.Windows.Forms.Form
$form.Text = "Menu"
$form.Size = New-Object System.Drawing.Size(200,150)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select an option:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(30,30)
$form.Controls.Add($label)

# Create the menu options
$option1 = New-Object System.Windows.Forms.Button
$option1.Text = "Option 1"
$option1.Location = New-Object System.Drawing.Point(30,60)
$option1.Size = New-Object System.Drawing.Size(120,30)
$option1.Add_Click({ Write-Host "Option 1 selected" })
$form.Controls.Add($option1)

$option2 = New-Object System.Windows.Forms.Button
$option2.Text = "Option 2"
$option2.Location = New-Object System.Drawing.Point(30,100)
$option2.Size = New-Object System.Drawing.Size(120,30)
$option2.Add_Click({ Write-Host "Option 2 selected" })
$form.Controls.Add($option2)

$option3 = New-Object System.Windows.Forms.Button
$option3.Text = "Option 3"
$option3.Location = New-Object System.Drawing.Point(150,60)
$option3.Size = New-Object System.Drawing.Size(120,30)
$option3.Add_Click({ Write-Host "Option 3 selected" })
$form.Controls.Add($option3)

$option4 = New-Object System.Windows.Forms.Button
$option4.Text = "Option 4"
$option4.Location = New-Object System.Drawing.Point(150,100)
$option4.Size = New-Object System.Drawing.Size(120,30)
$option4.Add_Click({ Write-Host "Option 4 selected" })
$form.Controls.Add($option4)

# Show the form
$form.ShowDialog()
