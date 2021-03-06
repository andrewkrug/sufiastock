#!/bin/bash
source /usr/local/rvm/scripts/rvm
cd /rails
sleep 5;
export TERM=xterm
created=$( mysql -uroot -pmysqlPassword -h ${HYDRAPRODUCTIONDB_PORT_3306_TCP_ADDR} -e "show databases;" | grep -ic "${OSFSUFIA_DATABASE}" )
if [ $created -eq 0 ]
then
    mysql -uroot -pmysqlPassword -h ${HYDRAPRODUCTIONDB_PORT_3306_TCP_ADDR} -e "CREATE DATABASE ${OSFSUFIA_DATABASE} DEFAULT CHARACTER SET utf8;";
    mysql -uroot -pmysqlPassword -h ${HYDRAPRODUCTIONDB_PORT_3306_TCP_ADDR} -e "GRANT ALL PRIVILEGES ON $OSFSUFIA_DATABASE.* to '$OSFSUFIA_DATABASE_USER'@'localhost' IDENTIFIED BY '$OSFSUFIA_DATABASE_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;";
    mysql -uroot -pmysqlPassword -h ${HYDRAPRODUCTIONDB_PORT_3306_TCP_ADDR} -e "GRANT ALL PRIVILEGES ON $OSFSUFIA_DATABASE.* to '$OSFSUFIA_DATABASE_USER'@'%' IDENTIFIED BY '$OSFSUFIA_DATABASE_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;";
else
    echo "database already created... moving on";
fi

rake db:migrate
rake db:seed
nginx -c /rails/config/container/nginx.conf -g "pid /rails/tmp/pids/nginx.pid;" &
bundle exec unicorn -c /rails/config/container/unicorn.rb -E production
