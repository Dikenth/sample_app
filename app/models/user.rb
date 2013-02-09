# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :nom, :email, :password, :password_confirmation, :poids, :poids_ideal, :date
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	date_regex = /^(19|20)\d\d([- \.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$/i
	
	validates :nom, :presence => true,
						 :length => { :maximum => 50 }
						 
	validates :email, :presence => true,
                     :format   => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false }
                     
  	# Crée automatique l'attribut virtuel 'password_confirmation'.
  	validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
 	
 	validates :poids, :presence => true
 	
 	validates :poids_ideal, :presence => true
   
   validates :date, :presence => true,
   			 		  :format => { :with => date_regex}
   
	before_save :encrypt_password
	
	# Retour true (vrai) si le mot de passe correspond.
	
	def test_poids?(poids,poids_ideal)
		return false if poids < poids_ideal
		return true if poids > poids_ideal
	end
	
	def has_password?(password_soumis)
		encrypted_password == encrypt(password_soumis)
	end
	
	def self.authenticate(email, submitted_password)
    	user = find_by_email(email)
    	return nil  if user.nil?
    	return user if user.has_password?(submitted_password)
  	end
	
	private
	
	def encrypt_password
		self.salt = make_salt if new_record?
		self.encrypted_password = encrypt(password)
	end
	
	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end
	
	def make_salt
		secure_hash("#{Time.now.utc}--#{password}")
	end

	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end
end
