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
