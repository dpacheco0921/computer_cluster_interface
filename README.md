# pu_cluster_interface

Matlab functions to interface with PNI cluster

# Usage

Using server_interface, you can:
1) submit *.slurm files
2) check status of submitted jobs
3) cancel jobs
4) clear output directory (in server/cluster)
5) pull files from server/cluster
6) push matlab startup file

For examples see pu_cluster_interface_demo.m

# Dependencies

This code in windowds requires openssh, installing using [scoop](http://scoop.sh)
Run the following command from your terminal

```
powershell
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
set-executionpolicy unrestricted -s cu
scoop openssh
```

After installin ssh, you need to modify 'ssh_config'. This files is usually at
*\scoop\apps\openssh\5.4p1-1\etc\ssh\ssh_config.

Setup passwordless SSH key, see info at [Cluster wiki](https://npcdocs.princeton.edu/index.php/SSH_Information)

In ssh_config add/edit the following lines

```
Host *
    IdentityFile 'add path of id_rsa file'

Host 'add short name for host, example 'spock''
    User 'add username'
    HostName 'add host name'
    Port 22
    ForwardX11 yes
    ForwardX11Trusted yes
    IdentityFile 'add path of id_rsa file'
```
