module AddressesHelper
  def integer?(str)
    /\A[+-]?d+\z/ === str
  end
end
