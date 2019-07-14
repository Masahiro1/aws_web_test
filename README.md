## バージョン

Rails: 5.2.3

Ruby: 2.5.1

## データベース

MySQL

## セットアップ

```bash
bundle exec rails db:migrate
```

---

# EC2での作業内容

参考：[(デプロイ編①)世界一丁寧なAWS解説。EC2を利用して、RailsアプリをAWSにあげるまで](https://qiita.com/naoki_mochizuki/items/814e0979217b1a25aa3e)

```bash
# libraries
sudo yum install git make gcc-c++ patch openssl-devel libyaml-devel libffi-devel libicu-devel libxml2 libxslt libxml2-devel libxslt-devel zlib-devel readline-devel mysql mysql-server mysql-devel ImageMagick ImageMagick-devel epel-releasea

# node.js
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

# rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile  
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv rehash

# ruby
rbenv install -v 2.5.1
rbenv global 2.5.1
rbenv rehash
ruby -v

# git
cd ~/.ssh
ssh-keygen -t rsa -f git_rsa
sudo vi ~/.ssh/config # 設定内容は省略
chmod 600 config

# git clone
sudo mkdir -p /var/www/rails
sudo chown ec2-user /var/www/rails
cd /var/www/rails
git clone git@github.com:Masahiro1/aws_web_test.git

# create database.yml and master.key
vi /var/www/rails/aws_web_test/config/master # localのmaster.keyの中身を貼り付け
vi /var/www/rails/aws_web_test/config/database.yml # localのdatabase.ymlの中身を貼り付け

# nginx
sudo yum install nginx
cd /etc/nginx/conf.d/
sudo vi aws_web_test.conf # 設定内容は省略
cd /var/lib
sudo chmod -R 775 nginx

# MySQL
sudo service mysqld start
ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock

# bundle install
cd /var/www/rails
gem install bundler -v 2.0.1
bundle

# create database
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production

# start unicorn
bundle exec unicorn_rails -c /var/www/rails/aws_web_test/config/unicorn.conf.rb -D -E production

# start nginx
sudo service nginx start

# add initialize command to bash_profile
echo 'sudo service mysqld start' >> ~/.bash_profile
echo 'unicorn_rails -c /var/www/rails/aws_web_test/config/unicorn.conf.rb -D -E production' >> ~/.bash_profile
echo 'sudo service nginx start' >> ~/.bash_profile
```
