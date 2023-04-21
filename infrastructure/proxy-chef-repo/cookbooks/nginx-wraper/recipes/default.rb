#
# Cookbook:: nginx-wraper
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.
script 'extract_module' do
  interpreter "bash"
  code <<-EOH
  echo "listen 9899"
  echo "Listen 8080
  Listen 81
  Listen 82
  <IfModule ssl_module>
          Listen 443
  </IfModule>
  <IfModule mod_gnutls.c>
          Listen 443
  </IfModule>
  " | sudo tee /etc/apache2/ports.conf
  echo "<VirtualHost *:82>
          ServerName server2
          ServerAlias server2
          ServerAdmin webmaster@localhost
          DocumentRoot /var/www/server2/public_html
          ErrorLog ${APACHE_LOG_DIR}/error.log
          CustomLog ${APACHE_LOG_DIR}/access.log combined
  </VirtualHost>
  # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
  " | sudo tee /etc/apache2/sites-available/server2.conf
  echo "<VirtualHost *:81>
          ServerName server1
          ServerAlias server1
          ServerAdmin webmaster@localhost
          DocumentRoot /var/www/server1/public_html
          ErrorLog ${APACHE_LOG_DIR}/error.log
          CustomLog ${APACHE_LOG_DIR}/access.log combined
  </VirtualHost>
  # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
  " | sudo tee /etc/apache2/sites-available/server1.conf
  sudo mkdir /var/www/server1
  sudo mkdir /var/www/server2
  sudo mkdir /var/www/server1/public_html
  sudo mkdir /var/www/server2/public_html
  echo "
  <h1>Servidor 1<h1>
  " | sudo tee /var/www/server1/public_html/index.html
  echo "
  <h1>Servidor 2<h1>
  " | sudo tee /var/www/server2/public_html/index.html
  sudo a2dissite 000-default.conf
  sudo a2ensite server1.conf
  sudo a2ensite server2.conf
  sudo systemctl start apache2
  sudo systemctl enable apache
  systemctl restart apache2
  EOH
end

package 'nginx' do
    action :install
  end
  
  service 'nginx' do
    action [:enable, :start]
  end
  
  template "nginx.conf" do
    path "/etc/nginx/nginx.conf"
    source "nginx.conf.erb"
    action :create
    notifies :reload, 'service[nginx]', :immediately
  end