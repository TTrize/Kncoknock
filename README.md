# Kncoknock
Port Knocking bash - access and validation automation

knocking a single ip<br>
`portknock.sh -s 192.168.1.10 "22 80 443 3000`

knocking a range ip<br>
`portknock.sh -r 192.168.1 "22 80 443 3000`

The script send a packets for port knocking liberation access.<br>
Before execute program utilize netcat or other program for access a final port.

Example a portknocking:<br>
![image](https://github.com/user-attachments/assets/b32d734e-a6ae-43a8-a5c8-7e52602f083b)

<br>The function -s (--single) realize a knock for a single ip<br>

`./portknock.sh -s 192.168.1.10 "13 37 30000 3000`
