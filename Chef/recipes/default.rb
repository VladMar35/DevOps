mysql_service 'mysql' do
  port '3306'
  version '8.0'
  initial_root_password 'your_strong_password'
  action [:create, :start]
end
