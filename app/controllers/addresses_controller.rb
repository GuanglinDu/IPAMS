class AddressesController < ApplicationController
  def index
    @addresses = Address.all
  end

  def show
  end

  def edit
  end

  def destroy
  end
end
