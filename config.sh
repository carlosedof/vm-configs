#!/bin/bash
clear

prompts () {
	echo what is the vm ip?
	read serverIp

	echo please place .pem file in the same folder this sh is running 
	echo what is the .pem filename with extension?
	read chave
	chmod 400 $chave ;

	while true; do
		read -p "do you have a pre defined nginx config file? (yes/no): " choice

		if [[ "$choice" == "yes" || "$choice" == "Yes" || "$choice" == "YES" ]]; then
		    echo please place a file named default into the same location this script is located, it will replace nginx default conf
			ngin=true;
			break;
		elif [[ "$choice" == "no" || "$choice" == "No" || "$choice" == "NO" ]]; then
		    echo "Okay."
		    ngin=false;
		    break;
		else
		    echo "Invalid input. Please choose either 'yes' or 'no'."
		fi
	done

	while true; do
		read -p "after installing docker, do you want to login into dockerhub? (yes/no): " choice


		if [[ "$choice" == "yes" || "$choice" == "Yes" || "$choice" == "YES" ]]; then
		    echo what is your dockerhub login?
			read dockerlogin
			echo what is your dockerhub password?
			read dockerpwd
			dockerhub=true;
			break;
		elif [[ "$choice" == "no" || "$choice" == "No" || "$choice" == "NO" ]]; then
		    echo "Okay."
		    dockerhub=false;
		    break;
		else
		    echo "Invalid input. Please choose either 'yes' or 'no'."
		fi
	done

	while true; do
		read -p "do you want to register any https domain with certbot? (yes/no): " choice

		if [[ "$choice" == "yes" || "$choice" == "Yes" || "$choice" == "YES" ]]; then
		    echo inform full url
			read certdomain
			echo inform email to perform registration
			read certmail
			certb=true;
			break;
		elif [[ "$choice" == "no" || "$choice" == "No" || "$choice" == "NO" ]]; then
		    echo "Okay."
		    certb=false;
		    break;
		else
		    echo "Invalid input. Please choose either 'yes' or 'no'."
		fi
	done

	echo =======================================
	echo Server ip: ${serverIp}
	echo Pem file: ${chave}
	echo Dockerhub login? ${dockerhub}
	echo Copy nginx conf? ${ngin}
	echo Register https with certbot? ${certb}
	echo =======================================
}


replaceNginxConf() {
	LOCAL_FILE_PATH="default"
	scp -i $chave $LOCAL_FILE_PATH $serverUser@$serverIp:/home/ubuntu
	yes | ssh -o StrictHostKeyChecking=no -i $chave $serverUser@$serverIp '	
		sudo rm -rf /etc/nginx/sites-available/*
		sudo mv default /etc/nginx/sites-available/
		sudo service nginx reload
	'
}

setInitialPage() {
		yes | ssh -o StrictHostKeyChecking=no -i $chave $serverUser@$serverIp '	
			echo "
			<html>
				<head><title>Ready!</title></head>
				<body>
					<h1>Hello user!</h1>
					<h2>You are ready to go! Your vm is fully setup.</h2>
				</body>
			</html>" > index.html
			file_name=index.html
			sudo rm -rf /var/www/html/*
			sudo mv $file_name /var/www/html/
			sudo service nginx reload
		'
}


flow (){
	yes | ssh -o StrictHostKeyChecking=no -i $chave $serverUser@$serverIp "	
		echo '$serverIp'
		sudo apt-get update
		yes | sudo apt-get upgrade 
		sudo wget -qO- https://get.docker.com/ | sh
       	sudo usermod -aG docker ubuntu
       	sudo curl -L 'https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        yes | sudo apt install nginx
        sudo ufw allow 'Nginx HTTP'
        sudo ufw allow 'Nginx HTTPS'

		if [[ '$dockerhub' == 'true' ]]; then
	        echo '$dockerpwd' | docker login --username='$dockerlogin' --password-stdin
		fi
"

	if [[ '$ngin' == 'true' ]]; then
        replaceNginxConf
    else
    	setInitialPage
	fi

	yes | ssh -o StrictHostKeyChecking=no -i $chave $serverUser@$serverIp "	
		if [[ '$certb' == 'true' ]]; then
	        yes | sudo add-apt-repository ppa:certbot/certbot
	        yes | sudo apt-get update
	        yes | sudo apt-get install python-certbot-nginx
	        yes | sudo apt-get install python3-certbot-nginx
	        sudo certbot --nginx -d '$certdomain' --agree-tos -m '$certmail' --redirect --non-interactive
		fi
"
}

serverUser="ubuntu"

prompts
flow












