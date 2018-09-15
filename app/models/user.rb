class User < ApplicationRecord
  has_many :przebiegi
  has_many :messages
  enum role: [:patient, :doctor, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :patient
  end

  def hash_password
    require 'digest/sha2'
    self.password = Digest::SHA2.new << password
  end
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :pesel, :presence => true
  validates_uniqueness_of :pesel
  validates :login, :presence => true, :length => { :minimum => 4, :maximum => 15 }
  validates_uniqueness_of :login

  #validates :email, :format => { :with => /\A[a-zA-Z0-9.\-_]+\@[a-zA-Z0-9.\-_]+\.[a-z]{2,4}\Z/ }
  #validates_uniqueness_of :email

  validates :password, :length => { :minimum=> 4 }
  after_validation :hash_password

end
