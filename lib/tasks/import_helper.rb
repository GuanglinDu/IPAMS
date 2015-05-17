module ImportHelper
  def output_comparision_result(old_attr, new_attr, diff_file)
    diff_file.puts "<br />*** To import ***<br />"
    0.upto(old_attr.count-1) do |i|
      arr = compare_value(old_attr[i], new_attr[i]) # an Array object
      diff_file.puts arr[1]
    end
    diff_file.puts "<br />~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br />"	 
  end

  #create html_header and html_tail
  def create_html_header(diff_file)
    diff_file.puts %{<!DOCTYPE html>}
    diff_file.puts %{<html>}
    diff_file.puts %{<head>}
    diff_file.puts %{<meta charset="utf-8" />}
    diff_file.puts %{<title></title>}
    diff_file.puts %{</head>}
    diff_file.puts %{<body>}
  end

  def append_html_tail(diff_file)
    diff_file.puts %{\n</body>}
    diff_file.puts %{</html>}
  end

  def atrribute_to_s(field)
    s1 = ""
    s1 = field.to_s if field
    s1.strip
  end

  def compare_value(v1, v2)
    result = ["", ""]
    v1 = atrribute_to_s(v1)
    v2 = atrribute_to_s(v2)
 
    if v1 == v2
      result[0] = result[1] = v1
    else
      result[0] = v1
      result[1] = %{<b>#{v2}</b>}
    end

    result
  end

  #Strips the whitespaces from both the key and the value
  def strip_whitespace(raw_row = {})
    row = {}
    raw_row.each do |k, v|
      if v.instance_of? String
        vt = nil
        vt = v.strip if v
        row[k] = vt
      else
        row[k] = v
      end
    end
    row.to_hash.with_indifferent_access
  end

  # Formats the User object to one Hash object
  def user_to_h(department_id, iph)
    {department_id: department_id,
    name: iph["name"],
    office_phone: iph["office_phone"].to_i,
    cell_phone: iph["cell_phone"].to_i,
    email: iph["email"],
    building: iph["building"],
    storey: iph["storey"].to_i,
    room: iph["room"].to_i} 
  end

  def address_hash_to_a(ip, name)
    ["IP: " + ip["ip"],
    "MAC: " + atrribute_to_s(ip["mac_address"]), 
    "Usage: " + atrribute_to_s(ip["usage"]),
    "User: " + atrribute_to_s(name),
    "start_date: " + atrribute_to_s(ip["start_date"]),
    "Assigner: " + atrribute_to_s(ip["assigner"])]
  end

  def address_to_a(ip, name)
    ["IP: " + ip.ip,
    "MAC: " + atrribute_to_s(ip.mac_address), 
    "Usage: " + atrribute_to_s(ip.usage),
    "User: " + atrribute_to_s(name),
    "start_date: " + atrribute_to_s(ip.start_date),
    "Assigner: " + atrribute_to_s(ip.assigner)]
  end

  def address_to_s(ip, name)
    "IP: " + ip.ip + ", " + 
    "MAC: " + atrribute_to_s(ip.mac_address) + ", " + 
    "Usage: " + atrribute_to_s(ip.usage) + ", " +
    "User: " + atrribute_to_s(name) + ", " +
    "start_date: " + atrribute_to_s(ip.start_date) + ", " +
    "Assigner: " + atrribute_to_s(ip.assigner) 
  end
end
