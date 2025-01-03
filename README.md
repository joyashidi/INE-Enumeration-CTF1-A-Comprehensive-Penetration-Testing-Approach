# INE-Enumeration-CTF1-A-Comprehensive-Penetration-Testing-Approach
This repository contains the detailed process of solving Enumeration CTF1, where I captured four flags using a variety of penetration testing techniques, including SMB enumeration, brute-forcing services, and leveraging Metasploit and Hydra.

Tools Used:
- Nmap for scanning services
- smbclient, rpcclient, and enum4linux for SMB enumeration
- Metasploit and Hydra for brute-forcing credentials
- Custom Bash scripts for automation

I started with the information gathering phase which is the first step in any penetration testing process. 
- cat /etc/hosts 
- nmap –sVSC –O target.ine.local 

From the results of the nmap scan (footprinting and scanning step), I was able to see samba (port 139,445) and ssh (port 22) services running on the target system. These ports and services are for .... 
 
Enumerating with this information I got; 
- smbclient -L target.ine.local -N (to view the shares present on the target system) 
- rpcclient -U "" -N target.ine.local (to view the users present on the target system) 
- enum4linux -a target.ine.local () 

I enumerated using the shares given to check whether I could get any information but they were both empty. From the task given, a directory of wordlists was made available at /root/Desktop/wordlists, which I looked into and I saw two wordlists one with shares and the other with passwords. 
 
Since the shares I got initially gave a dead end I decided to come up with a script that would go through every share in the list and be used alongside smbclient to see which one would enable an anonymous access (this was the hint for the first flag). I was able to get a share named pubfiles.  

- smbclient \\\\target.ine.local\\pubfiles -U josh (username gotten from the enumeration done earlier) 
-  ls
-  get flag1.txt 

After this, I did a bruteforce on smb to get valid credentials using the smb_login auxiliary module in metasploit framework. I got 4 valid credentials. From the clue given for the next flag, trying each username present as a share name to find any flag; 

- smbclient \\\\target.ine.local\\josh -U josh (there was a flag present here) 

In the content of the flag2 file, it says that there is an ftp service running. I missed it because I didn’t scan the entire port range initially (that’s something to always watch out for). 

- nmap -sVSC -p- -O target.ine.local 

Trying to see if the ftp service permits anonymous login; 

- ftp target.ine.local 5554 

It didn’t work but it gave me hints that there were more users present on the network, which I added to the users.txt file which I created earlier for brueforcing. I made use of hydra to bruteforce and gain valid credentials for the ftp service; 

- hydra -L users.txt -P /root/Desktop/wordlists/unix_passwords.txt ftp://target.ine.local:5554 
- valid credentials; alice:pretty 

Attempting to login with the credentials; 

- ftp target.ine.local 5554 

It logged me in and I was able to capture another flag. 

From the nmap results, ssh service is also running on the target system. Making use of my custom users.txt wordlist and the unix_passwords.txt wordlist to gain valid credentials for ssh via bruteforcing; 

- hydra -L users.txt -P /root/Desktop/wordlists/unix_passwords.txt ssh://target.ine.local 
- ssh alice@target.ine.local (making use of the credentials I got and I was able to capture another flag) 


The end. 
