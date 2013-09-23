class PwRequest < ActiveRecord::Base
  include UniqueToken
  
  has_secure_password
  
  has_many :pw_responses
  
  
  serialize :input_options, Hash
  after_initialize :init

  def init
    self.input_options ||= {}
  end
  
  before_save :set_token
  
  def set_token
    self.set_unique_token(:list_token)
    self.set_unique_token(:form_token)
  end
  
end
