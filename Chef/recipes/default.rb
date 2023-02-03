# Configure the MySQL client.
mysql_client 'default' do
  action :create
end
mysql_service 'default' do
  version '5.5'
  bind_address '0.0.0.0'
  port '3306'
  data_dir '/data'
  initial_root_password "password123"
  action [:create, :start]
end
