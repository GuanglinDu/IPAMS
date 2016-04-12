module FileHelper
  # Rails.root is not accessible in the tests
  TMP_PATH = File.expand_path("../../../tmp", __FILE__)

  IMPORT_LOG = "#{TMP_PATH}/IMPORT_LOG.txt"
 
  IMPORT_DIFF = "#{TMP_PATH}/IMPORT_DIFF.html" 

  LAN_IMPORT_SOURCE_FILE = "#{TMP_PATH}/lan_import_template.csv" 

  VLAN_IMPORT_SOURCE_FILE = "#{TMP_PATH}/vlan_import_template.csv" 

  DEPARTMENT_IMPORT_SOURCE_FILE = 
    "#{TMP_PATH}/department_import_template.csv" 

  IP_IMPORT_SOURCE_FILE = "#{TMP_PATH}/ip_address_import_template.csv" 

  MAC_FORMAT_LOG = "#{TMP_PATH}/MAC_FORMAT_LOG.txt"
end
