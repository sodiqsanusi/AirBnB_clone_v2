#!/usr/bin/env bash
# Configure Nginx web servers for deployment

command -v nginx > /dev/null
if [[ $? -eq 1 ]]; then
    apt install nginx -y
fi

mkdir -p /data/web_static/shared 2> /dev/null
mkdir -p /data/web_static/releases/test 2> /dev/null
echo "
<html lang='en'>
    <head>
        <title>Airbnb Clone</title>
        <style>
        .container {
            margin: 0 auto;
        }

        .text {
            font-size: 2em;
            text-align: center;
        }

        hr {
            border: 2px solid black;
        }
        </style>
    </head>
    <body>
        <div class='container'>
            <h1 class='text'>Welcome to AirBnB</h1>
	    <br>
            <hr>
        </div>
    </body>
</html>
" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test /data/web_static/current
chown -R ubuntu:ubuntu /data
grep -q "location /hbnb_static {" /etc/nginx/sites-available/default
if [[ $? -eq 1 ]]; then
    sed -i "/server_name _;/a \\\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}" /etc/nginx/sites-available/default
fi

service nginx restart
