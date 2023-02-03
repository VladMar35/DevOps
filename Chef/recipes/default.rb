# Create a mysql database
mysql_service 'database' do
  port '3306'
  version '5.7'
  initial_root_password 'change me'
  action [:create, :start]
end
