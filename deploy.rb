require 'vault'

vault_cubbyhole = ENV['VAULT_CUBBYHOLE'] || "app-token"
vault_address = ENV['VAULT_ADDR'] || "http://127.0.0.1:8200"
vault_token = ENV['VAULT_TOKEN']

puts "Connecting to #{ENV['VAULT_ADDR']}"

deployer_client = Vault::Client.new(
  # make defaults, explicit
  address: vault_address,
  token: vault_token,
  ssl_verify: false
)

# create temp token can only be used 2 times, and has a short ttl.
temp_token = deployer_client.auth_token.create({ :ttl => '120s', :num_uses => 2 })
# permanent token can be used any number of times w/ no ttl.
perm_token = deployer_client.auth_token.create({})

puts "The temp_token is #{temp_token.auth.client_token}"

# using the first use of token #1, store the permanent token in cubbyhole
temp_client = Vault::Client.new(
  address: vault_address,
  token: temp_token.auth.client_token,
  ssl_verify: false)
temp_client.logical.write(
  "cubbyhole/#{vault_cubbyhole}",
  { :token => perm_token.auth.client_token})
