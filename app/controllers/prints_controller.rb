class PrintsController < ApplicationController

  def show
    @print = Print.new(params.fetch(:username))
  end

  def create
    redirect_to print_path(params[:username])
  end

end
