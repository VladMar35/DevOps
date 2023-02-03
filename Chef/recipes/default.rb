# Create a mysql database
mysql_database 'mysql' do
  connection(
    :host     => '127.0.0.1',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end
