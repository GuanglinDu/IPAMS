IPAMS
=============

A Ruby on Rails (RoR) based IP Address Management System. 基于Ruby on Rails (RoR)的IP地址管理系统。

Status
------
* Is under intense development and far from maturity;
* Branch develop is always the most rececent commit;
* ERD (Entity Relationship Diagram) is under folder architecture & drawn with Dia;
 
How-tos
------
* git clone ...
* rake db:migrate
* rake db:seed
* start the server: rails server
* Browse it locally: http://localhost:3000

History
------
<ol>20150116: Implement authorization with Pundit and IP address editing in Vlans & Addresses views.</ol>
<ol>20150114: Update to Rails 4.1.8 to use ActiveRecord::Enum in role-based authorization with Pundit.</ol>
<ol>20150111: Use gem Devise to authenticate & gem Pundit to authorize, separately.</ol>
<ol>20141225: Gem awesome print added to beautify irb and rails console output.</ol>
<ol>201412: In-place editing added and Bootstrap UI used.</ol>
<ol>20141021: Scaffold pushed.</ol>
