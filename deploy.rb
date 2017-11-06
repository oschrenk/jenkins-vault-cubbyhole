require 'vault'

vault_cubbyhole = ENV['VAULT_CUBBYHOLE'] || "app-token"
vault_ttl       = ENV['VAULT_TTL'] || "60s"
vault_address   = ENV['VAULT_ADDR'] || "http://127.0.0.1:8200"
vault_token     = ENV['VAULT_TOKEN']

input_path  = ENV['INPUT_PATH']  || "/work/service.json"
output_path = ENV['OUTPUT_PATH'] || "/work/service-with-token.json"
env_key     = ENV['ENV_KEY']     || "VAULT_TEMP_TOKEN"

if (vault_token.nil?)
  abort("No VAULT_TOKEN")
end

puts "Connecting to #{ENV['VAULT_ADDR']}"

deployer_client = Vault::Client.new(
  # make defaults, explicit
  address: vault_address,
  token: vault_token,
  ssl_verify: false
)

# create temp token can only be used 2 times, and has a short ttl.
temp_token = deployer_client.auth_token.create({ :ttl => vault_ttl, :num_uses => 2 })
# permanent token can be used any number of times w/ no ttl.
perm_token = deployer_client.auth_token.create({})

# using the first use of token #1, store the permanent token in cubbyhole
temp_client = Vault::Client.new(
  address: vault_address,
  token: temp_token.auth.client_token,
  ssl_verify: false)
temp_client.logical.write(
  "cubbyhole/#{vault_cubbyhole}",
  { :token => perm_token.auth.client_token})

# inject the temp token into the service definition
service = JSON.parse(File.read(input_path))
old_env = service["env"]
if (old_env.nil?)
  old_env = {}
end

new_env_variable = {env_key => temp_token.auth.client_token}
new_env = old_env.merge(new_env_variable)
service["env"] = new_env

File.open(output_path, "w") do |f|
  f.write(JSON.pretty_generate(service))
end

