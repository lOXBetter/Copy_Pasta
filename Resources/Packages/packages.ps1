# Will need to sort out OS somewhere ; Potentially use a label or Tag method 

$ResourceFolder = ".\Resources\Packages"

curl https://bootstrap.pypa.io/get-pip.py -o $ResourceFolder\get-pip.py
python get-pip.py

pip install PyQt6

Add-AppxPackage -Path Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
