class Proposal < ActiveRecord::Base

	belongs_to :user  	# foreign key: user_id
  belongs_to :request  # foreign key: request_id

  validates_presence_of :description, :amount
  
end
