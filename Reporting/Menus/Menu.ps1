


# Display the main menu
do {
    Write-Host "Main Menu:"
    Write-Host "1. Option 1"
    Write-Host "2. Option 2"
    Write-Host "3. Exit"
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" {
            # Display sub-menu 1
            do {
                Write-Host "Sub-Menu 1:"
                Write-Host "A. Sub-Option 1A"
                Write-Host "B. Sub-Option 1B"
                Write-Host "C. Back to Main Menu"
                $subChoice = Read-Host "Enter your choice"
                switch ($subChoice) {
                    "A" {
                        # Perform action for Sub-Option 1A
                        Write-Host "Performing action for Sub-Option 1A"
                    }
                    "B" {
                        # Perform action for Sub-Option 1B
                        Write-Host "Performing action for Sub-Option 1B"
                    }
                }
            } until ($subChoice -eq "C")
        }
        "2" {
            # Display sub-menu 2
            do {
                Write-Host "Sub-Menu 2:"
                Write-Host "X. Sub-Option 2X"
                Write-Host "Y. Sub-Option 2Y"
                Write-Host "Z. Back to Main Menu"
                $subChoice = Read-Host "Enter your choice"
                switch ($subChoice) {
                    "X" {
                        # Perform action for Sub-Option 2X
                        Write-Host "Performing action for Sub-Option 2X"
                    }
                    "Y" {
                        # Perform action for Sub-Option 2Y
                        Write-Host "Performing action for Sub-Option 2Y"
                    }
                }
            } until ($subChoice -eq "Z")
        }
    }
} until ($choice -eq "3")

