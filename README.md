IPAMS
=============

A Ruby on Rails (RoR) based IP Address Management System.

Status
------
* Feature-riched and ready for use now with fine-tunning features on the way;
* Branch develop is always the most rececent commit;
* ERD (Entity Relationship Diagram) is under folder architecture & drawn with Dia;
* Supports only IPv4 at present.
 
How-tos
------
* git clone https://github.com/guanglindu/ipams.git
* rake db:migrate
* rake db:seed (Note: for development only; for production, please create or import the VLAN data.)
* rake init:vlans (rake init:VLAN-NAME to initialize a specific VLAN)
* start the server locally: rails server
* Browse it locally: http://localhost:3000

Importing Existing Data (Administrators only)
------
* Importing templates reside public/downloads. The data should be exported in UTF-8 encoded CSV files with the same file base name as the templates and copied to fold tmp.
* File tmp/IMPORT_LOG.txt updates after each import.
* File tmp/IMPORT_DIFF.html shows the difference if there're conflicts in the IP address importing.
* The update attribute is optional in the IP address importing template to tell the importer to import this record anyway.
* On a terminal at folder ipams, use command 'rake --tasks' to show the available IPAMS-specific tasks.

Some tricks
------
Importing Existing Data (Administrators only)
------
* Please manually create tmp/IMPORT_LOG.txt & tmp/IMPORT_DIFF.txt files, creating the folder along.

History
------
<ol>20150522: Implement prefix-matching search in Addresses views & Users view. No cross-table search support at present.</ol>
<ol>20150520: Implement most of the basic features.</ol>
<ol>20150116: Implement authorization with Pundit and IP address editing in Vlans & Addresses views.</ol>
<ol>20150114: Update to Rails 4.1.8 to use ActiveRecord::Enum in role-based authorization with Pundit.</ol>
<ol>20150111: Use gem Devise to authenticate & gem Pundit to authorize, separately.</ol>
<ol>20141225: Gem awesome print added to beautify irb and rails console output.</ol>
<ol>201412: In-place editing added and Bootstrap UI used.</ol>
<ol>20141021: Scaffold pushed.</ol>
