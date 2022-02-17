# Ngrok

https://ngrok.com/ A literal life saver.

When you are working on a remote server (VM, VNC, etc.), and you launch a localhost web application - how do you access it easily on your browser? You can't just type in `localhost:80` to access it as you would if you launched the web application on your local machine.


1. Download ngrok (look on the website for instructions)

2. Launch the web application on a separate terminal and make sure its running on localhost on your remote machine.

3. Launch ngrok: `ngrok http <port>`.

4. Access the given ngrok URL to access the remote localhost on your browser :)
