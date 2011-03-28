$ORIGIN test.com.
$TTL 604800
@	604800	IN		SOA		ns1.test.com. admin.test.com. (
			2011031600 	; Serial
			28800 		; Refresh
			7200 		; Retry
			1209600 	; Expire
			604800) 	; Negative Cache TTL
;
@		IN		NS		ns1.test.com.
@		IN		NS		ns2.test.com.
@	IN	A		127.0.0.1
@	IN	MX	10	mail.test.com.
mail	IN	A		10.0.1.1
google  IN      CNAME           google.com.
