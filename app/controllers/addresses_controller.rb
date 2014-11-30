class AddressesController < ApplicationController
  def index
    @addresses = Address.all
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
  end
end
