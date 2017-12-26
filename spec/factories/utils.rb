module Utils
  # TODO: only IPv4 is supported. How to support IPv6?
  # Fortunately, testing data is not much, and only a few records will do.
  def create_ip_address(vlan, num=1)
    ip_start = vlan.static_ip_start.split(".") # Array
    index = ip_start.length - 1
    num2 = ip_start[index].to_i + num
    ip_start[index] = num2.to_s
  
    ip = ""
    length = ip_start.length - 1
    ip_start.each_with_index do |elem, index|
      index < length ? ip += elem + "." : ip += elem
    end
  end

  def ip_prefix(vlan)
    index = vlan.static_ip_start.rindex(".")
    vlan.static_ip_start.slice(0..index)
  end
end
