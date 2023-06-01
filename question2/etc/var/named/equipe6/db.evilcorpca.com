; db.evilcorpca.com

$TTL 86400
@ IN SOA ns1.evilcorpca.com. admin.evilcorpca.com. (
	2023053101 ; serial
	3600	   ; refresh
	1800	   ; retry
	604800	   ; expire
	86400      ; minimum TTL
	)

@ IN NS ns1.evilcorpca.com.
@ IN NS ns2.evilcorpca.com.

@ IN A 199.48.22.99

www.evilcorp.ca. IN CNAME www.evilcorpca.com.

secure.evilcorpca.com. IN A 192.168.100.100
payment.evilcorpca.com. IN A 199.48.22.100
courriel.evilcorpca.com. IN A 199.48.22.55

webmail.evilcorpca.com. IN A 199.48.22.36
courrielweb.evilcorpca.com. IN A 199.48.22.36

ns1.evilcorpca.com. IN A 127.0.0.1
ns2.evilcorpca.com. IN A 199.48.22.98

maria.evilcorpca.local. IN A 172.16.15.15
gateway.evilcorpca.local. IN A 172.16.15.1 
