module FileHelper
  #ROOT_PATH = "../.."
  ROOT_PATH = "#{Rails.root}"

  #IMPORT_LOG = ROOT_PATH.join('tmp/IMPORT_LOG.txt')

  IMPORT_LOG = "#{ROOT_PATH}/tmp/IMPORT_LOG.txt"
 
  IMPORT_DIFF = "#{ROOT_PATH}/tmp/IMPORT_DIFF.html" 

  LAN_IMPORT_SOURCE_FILE = "#{ROOT_PATH}/tmp/lan_import_template.csv" 

  VLAN_IMPORT_SOURCE_FILE = "#{ROOT_PATH}/tmp/vlan_import_template.csv" 

  DEPARTMENT_IMPORT_SOURCE_FILE = "#{ROOT_PATH}/tmp/department_import_template.csv" 

  IP_IMPORT_SOURCE_FILE = "#{ROOT_PATH}/tmp/ip_address_import_template.csv" 
end
