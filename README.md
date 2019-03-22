IPAMS
=============

A Ruby on Rails (RoR) based IP Address Management System.

Status
------
* Feature-riched and ready for use now with fine-tunning features on the way;
* Branch develop is always the latest commit;
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

Tests Based On MiniTest & Rspec
------
* Run the unit and functional tests: bundle exec rake test (MiniTest based)
* Run all the tests under dir test/: bundle exec rake test:all
* Run the integration tests based on Rspec: bundle exec rspec (Based on Rspect, Capybara and FactoryGirl)

Testing Tips when sunspot and devise are integrated
------
* Configure the rake task with the test environment: rake sunspot:solr:run RAILS_ENV=test (See [sunspot_rails gem - “ Errno:: ECONNREFUSED (Connection refused - connect (2)) ”](http://stackoverflow.com/questions/7687343/sunspot-rails-gem-errno-econnrefused-connection-refused-connect-2) )
* The above sunspot test instance can run along with the development instance.
* To sign in a user with devise by the following 2 lines (See : [Making functional tests in Rails with Devise](http://stackoverflow.com/questions/3187287/making-functional-tests-in-rails-with-devise) )
   include Devise::TestHelpers
   sign_in username
* Before running the test, please start Sunspot for the test environment:
bundle exec rake sunspot:solr:start RAILS_ENV=test

Populate the development db
------
* bundle exec rake db:seed
This populates table lans, vlans and system_users. It also creates a root user/password tom.cat@example.com/password, and the admin user jerry.mouse@example.com/password.
* bundle exec rake -T
To show the IPAMS-specific tasks to populate tables such as addresses, departments. Table users is populated by populating a specific department.

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
<ol>2019: Nested searching & statistics.</ol>
<ol>2017-2018: Bug fixes.</ol>
<ol>2016: Search with any arbitrary string implemented.</ol>
<ol>20150522: Prefix-matching search in Addresses views & Users view.</ol>
<ol>20150520: Most of the basic features implemented.</ol>
<ol>20150114: Upgraded to Rails 4.1.8 to use ActiveRecord::Enum in role-based authorization with Pundit.</ol>
<ol>20150111: Devise & Pundit added.</ol>
<ol>20141225: Gem awesome_print added.</ol>
<ol>201412: In-place editing with Bootstrap.</ol>
<ol>20141021: Scaffold pushed.</ol>
