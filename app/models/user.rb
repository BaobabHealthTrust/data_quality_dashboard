require 'digest/sha1'
require 'digest/sha2'

class User < ActiveRecord::Base
  require 'digest/sha1'

  validates_presence_of :username, :password
  validates_uniqueness_of :username
  set_primary_key :user_id
  has_one :user_role
  cattr_accessor :current
  before_save :encrypt_password
  self.default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def encrypt_password
    self.salt = User.random_string(10)
    self.password = encrypt(self.password, self.salt)
  end

  def encrypt(password,salt)
    Digest::SHA1.hexdigest(password+salt)
  end

  def self.authenticate(username, password)

    user = User.find_by_username(username) rescue nil

    if !user.nil?

      salt = Digest::SHA1.hexdigest(password + user.salt)

      if salt == user.password

        return true
      else
        return false
      end

    else

      return false

    end
  end

  def self.create_user(username, password, user_role)
    exists = User.where("voided = 0 AND username = ?", username)

    if !exists.blank?
      return ["Username is already taken", nil]
    else
      new_user = User.new()
      new_user.password = password
      new_user.username = username
      if new_user.save
        role = Role.find_by_role(user_role).id
        UserRole.create({:user_id => new_user.id, :role_id => role})
        return ["User successfully created", true]
      else
        return ["User could not be created",nil]
      end
    end
  end

  def User.update_user(user_name_old, username, password, user_role)
  user = User.where(:username => user_name_old).first
  user.update_attributes({:username => username, :password => password})
  role = Role.find_by_role(user_role).id
  user_role = user.user_role
  user_role.update_attributes({:role_id => role})
  end

end
