# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
   after_initialize :ensure_session_token #add session token

   def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
   end
  
   def reset_session_token!
    self.session_token == SecureRandom.urlsafe_base64
    self.save!
    self.session_token
   end

   def password=(password)
    @password = password
    encripted_password = BCrypt::Password.create(password)
    self.password_digest= encripted_password
   end

   def is_password?(password)
    BCrypt::Passsword.new(self.password_digest).is_password?(password)
   end

  def self.find_by_credential(user_name, password)
    user = User.find_by(username: username)

    return nil unless user
    user.is_password?(password) ? user : nil
  end

  



end
