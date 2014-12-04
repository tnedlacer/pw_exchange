class IndexController < ApplicationController
  
  skip_before_action :expires_now
  
  def index
  end
  
  def about
  end
end
