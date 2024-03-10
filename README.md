### OTUS-Linux-2023-10-L34 | Туннели  

**1. сравнение производительности туннелей в режимах tun/tap**

  - статистика iperf в режиме tap:
   
  >[ ID] Interval           Transfer     Bitrate         Retr<br>
  >[  5]   0.00-40.00  sec   224 MBytes  46.9 Mbits/sec   80             sender<br>
  >[  5]   0.00-40.44  sec   221 MBytes  45.9 Mbits/sec                  receiver<br>

  - статистика iperf в режиме tun:
  
  >[ ID] Interval           Transfer     Bitrate         Retr<br>
  >[  5]   0.00-40.00  sec   220 MBytes  46.2 Mbits/sec   82             sender<br>
  >[  5]   0.00-40.65  sec   218 MBytes  45.1 Mbits/sec                  receiver  <br>

  **Вывод:** в режиме tun скорость немного меньше, т.к. туннель работает в режиме L3 и, вероятно, имеет бОльший оверхединг  

**2. RAS на базе OpenVPN**  
  - в репозитории Vagrantfile с необходимым откружением. По скрипту автоматически устанавливается и поднимается OpenVPN-сервер.
  - результаты подключения клиента с хостовой машины:
	>**falcon@ubuntu-pc:/etc/openvpn$ ip r**<br>
	>default via 192.168.255.1 dev ens33 proto dhcp metric 100 <br>
	>**10.10.10.0/24 via 10.10.10.5 dev tun0**		<--- устанавливается общий маршрут от сервера на клиентскую сеть<br>
	>10.10.10.5 dev tun0 proto kernel scope link src 10.10.10.6 <br>
	>169.254.0.0/16 dev ens33 scope link metric 1000 <br>
	>172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown <br>
	>192.168.56.0/24 dev vboxnet0 proto kernel scope link src 192.168.56.1 <br>
	>192.168.255.0/24 dev ens33 proto kernel scope link src 192.168.255.66 metric 100 <br>
	>falcon@ubuntu-pc:/etc/openvpn$ <br>
	>**falcon@ubuntu-pc:/etc/openvpn$ ping -c 4 10.10.10.1**	<--- пингуется сам сервер<br>
	>PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.<br>
	>64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.542 ms<br>
	>64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.525 ms<br>
	>64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.525 ms<br>
	>64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.540 ms<br>
	><br>
	>--- 10.10.10.1 ping statistics ---<br>
	>4 packets transmitted, 4 received, 0% packet loss, time 3077ms<br>
	>rtt min/avg/max/mdev = 0.525/0.533/0.542/0.008 ms<br>
	>falcon@ubuntu-pc:/etc/openvpn$<br>


