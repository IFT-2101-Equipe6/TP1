; db.example.com

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

@ IN A 203.0.113.10

