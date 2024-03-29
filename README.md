# KEST2LG05DU - Final Project H-2019

## Top notes

* For this installation I will be using "**Debian 10.1 32bit**" since it's the latest version from the Debian foundation which I am the most comfortable with.
* The virtual machine platform I will be using is "**VMware Workstation**"

## VMware Configuration

To ensure that the virtual machines are accurately setup for local testing, I've modified to "Virtual Network Editor" with the following, **notice how I've disabled DHCP on Host-Only**

<img src="./screenshots/conf-virt-net.png" width="600px">

## Hardware specifications

**Server1 and Client1**

- 1 CPU
- 1024MB of memory
- NAT network interface as an external interface (**Server only**)
- Host-only network interface as a private interface
- VDI virtual disk with max 8GB of space

## Server1 configuration

I chose the external interface as the Primary network interface so that the server would have internet access by default.

<img src="./screenshots/ins-net.png" width="600px">

The server hostname is "**server1**"

<img src="./screenshots/ins-host.png" width=600px>

The root password is "**1483369ABQ**"

<img src="./screenshots/ins-root.png" width="600px">

I've created the main user with the following configuration:

* Full name: **Administrator**
* User name: **administrator**
* Password: **C10H15N**

**The rest of the installation have been set to default and due to this being an example, I've decided not to install a desktop environment**

After the installation finished I update the apt repositories and make sure the latest stable versions of software has been installed.

---

Now that the installation has been successfully completed, I can go into setting up the system to act as a server as described in the assignment.

I begin with changing the hostname of the server to "**server1**" and the domain name to "**tristan.local**" (as described in the assignment, personally I wouldn't put my name into it) so that the FQDN (Fully Qualified Domain Name) of the server will be "**server1.tristan.local**"

<img src="./screenshots/conf-hostname-2.png" width="600px">

<img src="./screenshots/conf-domain.png" width="600px">

---

For the DHCP server I install dnsmasq via aptitude with the command `apt install dnsmasq`

<img src="./screenshots/ins-dhcp.png" width="600px">

With `ip a` we are able to take a look at the network interfaces

<img src="./screenshots/inf-net.png" width="600px">

With this information I am able to configure the DHCP server to use the private interface (enp0s8) we made by modifying the `/etc/dnsmasq.conf` file

<img src="./screenshots/conf-dhcp-1.png" width="600px">

Now that the configurations are set, I am able to assign a static IP address for the server itself with `ifconfig enp0s8 192.168.100.1` and enable the interface with `ifconfig enp0s8 up`

<img src="./screenshots/conf-dhcp-2.png" width="600px">

**Installing dnsmasq without additional configurations has already created a DNS (domain name server).**

---

## Client1 configuration

The installation process does not require any special modification thus I have kept the default options apart from setting the hostname to "**client1**" and the domain to "**tristan.local**" so that the FQDN is "**client1.tristan.local**"

* The root password is "**1483369ABQ**"

The main user has the following configuration:

+ Name: "**Administrator**"
+ User: "**administrator**"
+ Pass: "**C10H15N**"

**Using the same password for both the client and the server is not recommended, this is only for demonstration purposes**

With the server already setup and the client using the private interface, we've successfully finished the first part of the project!

---

## Group and user management

### Groups

**The groups we need to make are the following:**

* IT
* Management
* Accounting
* Manufacturing

To quickly create all the groups with a single command, we could use xargs by doing the following command: `echo IT Management Accounting Manufacturing | xargs -n 1 groupadd -r`

<img src="./screenshots/conf-grp.png">

### Users

Below we have a table of users needed to be made and their represented groups:

| Group         | Name                                                         | Username                                                     |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| IT            | Alexander Ragnarsson<br />Andrea Klara Hauksdóttir           | AleRag<br />AndHau                                           |
| Management    | Guðmundur Steindórsson<br />Halldór V. Jónsson<br />Harpa Hjaltested | GudSte<br />HalJon<br />HarHja                               |
| Accounting    | Hrannar Arason<br />Ingibjörg J. Guðlaugsdóttir              | HraAra<br />IngGud                                           |
| Manufacturing | Ísak Leifsson<br />Jóhanna Kristín Hafsteinsdóttir<br />Kristján Svanbergsson<br />Lárus Arnar Gunnarsson<br />Linda B. Magnúsdóttir<br />Rúdólf Björnsson<br />Sigurbjörg Ó. Stefánsdóttir<br />Sigrún Alda Jensdóttir | IsaLei<br />JohKri<br />KriSva<br />LarGun<br />LinMag<br />RudBjo<br />SigSte<br />SigJen |

The list of users is quite long and would take way too long to go through every single user by either running the `useradd` command or even the `newusers [File_Name]` alternative...
So I instead put every user into a CSV (Comma separated Value) file and combined it with a simple script I've made thanks to [an article I found about CSV parsing with Bash](https://www.cyberciti.biz/faq/unix-linux-bash-read-comma-separated-cvsfile/):

```bash
#!/bin/bash
#createusers.sh
INPUT=users.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read name grp user
do
	useradd -c "$name" -d /home/$user -G $grp $user
done < $INPUT
IFS=$OLDIFS
```

With the script made, we have to make it executable and I've done so with this command: `chmod +x createusers.sh`
Then running the script is simple: `./createusers.sh` *(the reason I put in `2> /dev/null` is because I've already ran the command and have redirected the exceptions into "The Void")*

<img src="./screenshots/conf-usr.png">