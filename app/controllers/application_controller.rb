class ApplicationController < ActionController::API

  def valid_date?(date)
    date.to_date rescue nil
  end
end
