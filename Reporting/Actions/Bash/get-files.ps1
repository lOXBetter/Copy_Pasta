az vm run-command invoke -g "resource-group-name" -n "vm-name" --command-id RunShellScript --scripts "ls /home/user/documents"

az vm run-command invoke -g "resource-group-name" -n "vm-name" --command-id RunShellScript --scripts "cp /home/user/documents/* /tmp/"

az storage blob upload-batch --destination my-container --account-name my-storage-account --source /tmp/
