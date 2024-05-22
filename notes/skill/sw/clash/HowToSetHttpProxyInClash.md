# 如何在Clash中设置HttpProxy

## 在设置下，需要打开两项设置

![alt text](image.png)

## 在WSL下，使用对应的端口7897就可以了

```bash
local_ip=`ip route | awk '/^default via / {print $3}'`
export http_proxy=http://$local_ip:7897
export https_proxy=http://$local_ip:7897
```

注意，上面那条指令是在WSL 2.0下特定的定位本地ip地址的命令。

测试命令可以使用`curl`

```bash
    curl -I www.google.com
```

如果代理设置成功会输出如下的一些信息：

```bash
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Cache-Control: private
Connection: keep-alive
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-LuySVWiC8Tdy68EGDlnUog' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
Content-Type: text/html; charset=ISO-8859-1
Date: Wed, 22 May 2024 08:04:03 GMT
Expires: Wed, 22 May 2024 08:04:03 GMT
Keep-Alive: timeout=4
P3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Proxy-Connection: keep-alive
Server: gws
Set-Cookie: 1P_JAR=2024-05-22-08; expires=Fri, 21-Jun-2024 08:04:03 GMT; path=/; domain=.google.com; Secure
Set-Cookie: AEC=AQTF6HxzT2AY2MlA_3OZoERoPoKx9csPzpTQbVCm_3tTpXxxM7aQ0JIXyw; expires=Mon, 18-Nov-2024 08:04:03 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
Set-Cookie: NID=514=HCXjSJLMoVFBErf1ubIlEv97RCJeiPf3X-SS1SM7jpeTQMeUP-qffpzkZN2LM4xJR7hkO5pK3DMiL2pPaORA61snMgVS_OHPZsLdKJ-ksbwQoxII0YtvRV2bet5JJu5oK0qMdeHF_FqV8b4O8G13ZbFRLYyg6Jo4GIOe6D1vbCA; expires=Thu, 21-Nov-2024 08:04:03 GMT; path=/; domain=.google.com; HttpOnly
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 0
```

同时，在clash的连接中，可以看到对应的连接信息，不过需要`curl www.google.com`