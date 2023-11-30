#!/bin/sh
IPS="
115.231.100.106
121.52.226.236
218.205.64.19
112.17.251.2
122.224.83.141
124.160.136.141
112.13.110.141
122.224.83.138
124.160.136.138
112.13.110.138
157.119.232.29
157.119.232.89"

firewall-cmd --zone=drop --permanent --add-rich-rule="rule family="ipv4" source address="0.0.0.0/0" drop"

for ips in $IPS;do
        firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="$ips/24" accept"
done
