#!/bin/sh
state="established"
timestamp=`date "+%d/%b/%Y:%X"`
tmpfile="a"

echo "'"  > $tmpfile.json
#ss2 -4itn state $state | awk '{ if(NR > 1 && $3 !~ /127.0.0.1/ && $4 !~ /192.168./) {
ss2 -4itn state $state dport = :80 or sport = :80 or dport = :443 or sport = :433 or sport = :8100 or dport = :8100 | 
awk '{ if(NR > 1 && $3 !~ /127.0.0.1/ ) {
		line=$0; getline; if($0~/minrtt/) print line""$0
  	}
}' |
awk '{  
	split($3,src,":"); Saddress=src[1];Sport=src[2];
	split($4,dst,":"); Daddress=dst[1];Dport=dst[2];
        line_state="ESTAB";
	node_type="network-attack";
        type=$5;
        split($8,a,"[:/]");
        split($13,b,"[:/]");
        if ($0 ~ /retrans:/){
                split($0,c,"retrans:");
                gsub("/.*","",c[2]);
                Retrans=c[2]
        };
        if ($0 ~ /send/){
                split($0,d,"send");
                gsub("bps.*","",d[2]);
                if(d[2] ~ /K/) {
                        gsub("K","",d[2]);
                        Send=d[2]/1000
                }
                else if(d[2] ~ /M/) {
                        gsub("M","",d[2]);
                        Send=d[2]
                }
                else {  
                        Send=d[2]
                }
        };

#{"Daddress": "192.168.98.38", "Saddress": "192.168.98.34", "SPort": "4600", "rtt": 7.77, "cwnd": 57.52, "Retrans": 1, "send": 318.16, "total": 13106, "line_state": "ESTAB", "type": "bbr", "node_type": "network-attack", "timestamp": "19/Jan/2020:17:35:58 +0800", "hostname": "hzj"}

printf("{\
\"Daddress\":\"%s\", \
\"Saddress\": \"%s\",\
\"SPort\": \"%s\",\
\"rtt\": %d,\
\"cwnd\": %d,\
\"Retrans\": %d,\
\"send\": %d,\
\"total\": %d,\
\"line_state\": \"%s\",\
\"type\": \"%s\",\
\"node_type\": \"%s\",\
\"timestamp\": \"%s +0800\",\
\"hostname\": \"%s\"\
}\n",
	Daddress,Saddress,Sport,a[2],b[2],Retrans,Send,Total,line_state,type,node_type,"'$timestamp'","'`hostname`'")
} ' >> $tmpfile.json
echo "'"  >> $tmpfile.json
