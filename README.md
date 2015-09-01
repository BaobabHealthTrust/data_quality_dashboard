data_quality_dashboard
======================

Dashboard for display data quality issues in applications

INSTALLATION INSTRUCTIONS
--------------------------


======== In National-ART ========

A. Initialise database requirements by running the following in terminal
	1. rake db:migrate
	2. rake db:seed
B. Make sure you have the latest views by loading bart2_views_schema_additions.sql, run
	1.  mysql -u mysqluser -p db_name < db/bart2_views_schema_additions.sql

C. Setup a cronjob to run data consistency checks. Include a crontab command that looks like the following. You may adjust to suite your environment.

	00 18 * * * cd /var/www/National-ART/ && script/runner -e development script/data_consistency_checks.rb >> log/crolog 2>&1


======= In Data Quality Monitoring Dashboard ======

A. Initialise database requirements by running the following in terminal
	1. rake db:migrate
	2. rake db:seed
B. Run the app, login and create associated site of the National-ART above
 
   login default username = dqd_admin
   login_default_password = dqd_admin_default
C. Setup a cronjob on server with data quality dashbboard to pull data from National-ART, cronjob may appear like this. Note the times. cronjob in 	National-ART has to run first.
	00 19 * * * cd /var/www/data_quality_dashboard/ && rails runner -e development script/update_details.rb >> log/crolog 2>&1

Setup Done!
