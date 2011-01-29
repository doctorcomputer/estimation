class User < ActiveRecord::Base

  acts_as_authentic

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
  
end
