class User < ActiveRecord::Base
  validates :email, :user_name, :password, presence: true
  validates :email, :user_name, uniqueness: true

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

end


## Must create user migration file...
# bundle exec rake generate:migration NAME=create_users"
# paste below into user migration file:

#     create_table :users do |t|
#       t.string :user_name, :null => false
#       t.string :email, :null => false
#       t.string :password_hash, :null => false
#       t.timestamps
#     end
