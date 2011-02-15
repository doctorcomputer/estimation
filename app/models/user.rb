class User < ActiveRecord::Base

  acts_as_authentic do |conf|
    conf.maintain_sessions= false
  end

  has_many :proposals
  has_many :requests

  attr_accessor :eula, :privacy
  
  validates_presence_of :first_name, :last_name, :address, :city
  validates_format_of   :vat, :with => /\d{11}/, :if => :is_professional?
  validates_presence_of :company_name, :if => :is_professional?
  validates_presence_of :activity, :if => :is_professional?
  validates_format_of :zip, :with => /\d{5}/
  validates_acceptance_of :eula, :privacy

  #  def after_initialize
  #    self.is_professional=true
  #  end

#  def self.find_by_verified_login(login)
#    user = find_by_smart_case_login_field(login)
#    user.is_verified ? user : nil
#  end

  
end
