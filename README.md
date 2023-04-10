# Shell Script - VM Setup with Docker, Nginx, and Certbot
This shell script is designed to set up a virtual machine (VM) with Docker, Nginx, and Certbot. It prompts the user for various inputs, such as the VM IP, .pem filename with extension, DockerHub login credentials, whether to copy an Nginx configuration file, and whether to register an HTTPS domain with Certbot.

## Prerequisites
- VM with Ubuntu OS
- .pem file in the same folder where the script is running
- Pre-defined Nginx configuration file (optional)
- DockerHub login credentials (optional)
- HTTPS domain and email for Certbot registration (optional)

## Usage
- Run the script using bash command: bash setup.sh
- Follow the prompts to provide the necessary inputs.
The script will perform the following actions on the remote VM:
- Update and upgrade the system
- Install Docker and Docker Compose
- Install Nginx and configure firewall rules
- Optionally, copy an Nginx configuration file to replace the default configuration
- Optionally, set an initial page for Nginx
- Optionally, register an HTTPS domain with Certbot

Note: The script uses SSH to connect to the remote VM and perform the setup tasks. Make sure you have the necessary SSH access and permissions on the remote VM before running the script.

Please note that this script requires user inputs for various configuration settings, and it may need to be modified to suit your specific use case.
## Support

Please use github issues area.


## Melhorias

Feel free to suggest any improvements.

## 🚀 About me
Check my profile clicking [here](https://cadu.dtdevs.com/)!


## 🔗 Links

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/cadu-olivera-89a632110/)
