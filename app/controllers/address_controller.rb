class AddressController < ApplicationController
  def index
    @addresses = Address.all
  end
end
