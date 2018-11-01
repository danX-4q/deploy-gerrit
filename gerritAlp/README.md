#gerritAlp部署说明

docker + docker-compose + gerrit + ladp + phpldapadmin + postgresql

```shell
#必须先进入此目录
cd deploy_gerrit/gerritAlp
```

要求后续的shell命令都在此目录中操作。

## 修改配置

### 定制敏感配置项

源码自带的sensitive.conf.example，仅作示例；搭建实用环境时，均需定制敏感配置项。

```shell
cp sensitive.conf.example sensitive.conf.<label> #for example: sensitive.conf.danX
```

```vi sensitive.conf.<label> ```按照配置文件逐项设置：

* DB_PASSWORD

  数据库密码。

* LDAP_ADMIN_PASSWORD

  ldap的admin密码，而不是在ldap上创建的用于登录gerrit的admin密码。

  gerrit.config中配置它，是为了可以通过ldap的接口，向ldap服务器发起请求验证登录gerrit的用户名及密码的正确性。

* CANONICAL_WEB_URL

  配置为当前服务集群面向最终用户的入口url，一般是本机开放对外访问的ip及端口(镜像的8080对应的宿主机端口)。如果当前服务集群还有前置网关或反向代理，则设置为网关或代理的ip及端口。

* SMTP_USER

  gerrit自动发送邮件时使用的email账户。

* SMTP_PASSWORD

  SMTP_USER的密码。

* SMTP_FROM

  gerrit自动发送邮件时使用的发件人。

### 生效敏感配置

```shell
./sync-sensitive-setting.sh -f sensitive.conf.<label> #for example: sensitive.conf.danX
```

### 修改通用配置项

建议专业人员根据自身需要进行深度定制，主要集中在docker-compose.yaml、support-files--gerrit/gerrit.config.tmpl两个文件；此处不展开描述。

### 补充说明

* 尝试将ldap的dn改为dn=bankledger,dn=com，调试不出来。

## 运行脚本

### setup-once

```shell
./setup-once.sh
```

此脚本只需运行一次，用于在本机通过docker-compose安装服务集群。安装过程，除了docker镜像及实例化的工作，还处理了配置更新、依赖服务的安全等待等，不能用```docker-compose up -d```命令代替。

### 启动服务

```shell
docker-compose up -d
```

### 停止服务

```shell
docker-compose stop
```

### 重置程序

仅程序，卸载docker镜像实例，不影响数据留存。

```
docker-compose down
```

### 重置数据

```
docker-compose down
./clean-volume.sh
```

## 设置gerrit超级管理员

### ldap超级管理员登录

1. 浏览器访问```https://<ip>:6443```
2. login dn: ```cn=admin,dc=example,dc=org```
3. login password，即前文```docker-compose.yaml```的```services.ldap.environment.LDAP_ADMIN_PASSWORD```

### 创建gerrit超级管理员的ldap账户

1. create new entry, 模板选择Courier Mail Account。

2. 字段填写:

   Given Name:		Gerrit

   Last name:		Admin

   Common Name:	Gerrit Admin

   User ID: 			**admin**[必须填写，且必须是admin]

   Email: 			gerrit_admin@<domain>

   Password: 		***[必须填写，登录gerrit时输入的密码]

### gerrit超级管理员登录

1. 浏览器访问```http://<ip>:8080```
2. Sigin Username: admin
3. Password: 前文在ldap创建Gerrit Admin时设置的密码
4. 首次登录，出现安装插件的页面，直接跳过(点左上角按钮)【我没有一次安装成功的，直接跳过】
5. 右上角头像区域，点击查看账户的Settings.Profile.ID，如果是1000000，则说明当前登录账户是gerrit的超级管理员

### 补充说明

网上很多资料提到，第一个登录gerrit的账户默认为超级管理员。我亲测验证，在当前版本并非如此(早前的版本也没去验证了)，而是登录账户admin(Profile.ID恒为1000000)才是超级管理员，非admin账户登录Profile.ID都只能在1000000之后递增。