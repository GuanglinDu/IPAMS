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
<ol>20150111: Delete migration 20141228140229_create_system_users.rb by rake db:migrate:down VERSION=20141228140229 as Devise is used now to authenticate users.</ol>
<ol>20150111: Use gem Devise to authenticate & gem Pundit to authorize, separately.</ol>
<ol>20141225: Gem awesome print added to beautify irb and rails console output.</ol>
<ol>201412: In-place editing added and Bootstrap UI used.</ol>
<ol>20141021: Scaffold pushed.</ol>
