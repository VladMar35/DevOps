current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'hillel_chef'
client_key               "hillel_chef.pem"
validation_client_name   'hillel_org-validator'
validation_key           "hillel_org.pem"
chef_server_url          'https://server/organizations/hillel_org'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
