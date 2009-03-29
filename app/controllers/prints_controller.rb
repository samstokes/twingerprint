class PrintsController < ApplicationController

  def show
    @print = Print.new(params.fetch(:username))
  end

end
