# Import the necessary libraries
import sys
from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.network import NetworkManagementClient

# Define the credentials and subscription ID
TENANT_ID = '<your tenant ID>'
CLIENT_ID = '<your client ID>'
CLIENT_SECRET = '<your client secret>'
SUBSCRIPTION_ID = '<your subscription ID>'

# Define the resource group and virtual machine name
RESOURCE_GROUP_NAME = '<your resource group name>'
VIRTUAL_MACHINE_NAME = '<your virtual machine name>'

# Define the Azure region where the virtual machine is located
LOCATION = '<your virtual machine location>'

# Define the action to perform on the virtual machine
ACTION = sys.argv[1]

# Create the credentials object
credentials = ServicePrincipalCredentials(
    client_id=CLIENT_ID,
    secret=CLIENT_SECRET,
    tenant=TENANT_ID
)

# Create the compute, resource, and network management clients
compute_client = ComputeManagementClient(credentials, SUBSCRIPTION_ID)
resource_client = ResourceManagementClient(credentials, SUBSCRIPTION_ID)
network_client = NetworkManagementClient(credentials, SUBSCRIPTION_ID)

# Get the virtual machine object
virtual_machine = compute_client.virtual_machines.get(
    RESOURCE_GROUP_NAME,
    VIRTUAL_MACHINE_NAME
)

# Perform the action on the virtual machine
if ACTION == 'start':
    async_vm_start = compute_client.virtual_machines.start(RESOURCE_GROUP_NAME, VIRTUAL_MACHINE_NAME)
    async_vm_start.wait()
    print('Virtual machine has been started')
elif ACTION == 'stop':
    async_vm_stop = compute_client.virtual_machines.power_off(RESOURCE_GROUP_NAME, VIRTUAL_MACHINE_NAME)
    async_vm_stop.wait()
    print('Virtual machine has been stopped')
elif ACTION == 'reboot':
    async_vm_reboot = compute_client.virtual_machines.restart(RESOURCE_GROUP_NAME, VIRTUAL_MACHINE_NAME)
    async_vm_reboot.wait()
    print('Virtual machine has been rebooted')
else:
    print('Invalid action specified')
