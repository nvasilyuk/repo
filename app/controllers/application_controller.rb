class ApplicationController < ActionController::Base

  def hello
    render html: 'HI'
  end
end
