puts "Loading defaults"

puts "Creating default user"

if User.find_by_username("admin").blank?
  user = User.create({:username => "admin", :password => "test"})
else
  puts "User :  'admin' already exists"
end

puts "Creating default definitions types"
definition_types = ["Validation rule"]

(definition_types || []).each do |type|
  if DefinitionType.find_by_name(type).blank?
    new_type = DefinitionType.create({:name => type, :creator => 1})
  else
    puts "Definition type : #{type} already exists"
  end
end

puts "Creating user roles"
roles =[["Administrator", "This is the system administrator who handles all system functions"],
  ["Other", "Other system user"] ]

(roles || []).each do |role|
  if Role.find_by_role(role).blank?
    new_role = Role.where({:role => role[0], :description => role[1]}).first_or_create
  else
    puts "Role : #{role[0]} already exists"
  end
end
