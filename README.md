# Example of how to create AMI with Consul installed on AWS with Packer

## You beed 1st to install packer

`brew install packer`

## Fork this repo

You need to make env variables for your AWS keys
```
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```

**Execute below build command**

`packer build -var'CONSUL_VER=X.X.X' createaminginx.json`


## After AMI is created

## Install kitchen
-  gem install inspec
-  gem install bundler
-  gem install kitchen-ec2
-  gem install test-kitchen
-  bundle install


- kitchen test
