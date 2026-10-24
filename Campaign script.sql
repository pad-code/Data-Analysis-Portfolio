/* Project Topic: Google Ads Sales Performance Analysis
   Domain      : Digital Marketing
   Industry    : Advertising and Marketing
   Clients     : Management
   Scripted By : Adejumo Peter 
*/   
-- Create database
create database Google_Ads_Campaign;

-- Activate Database
use Google_Ads_Campaign;

show tables;

select * from Campaign;

rename table googleads_dataanalytics_sales_uncleaned to Campaign;

describe Campaign;

-- create Backup
create table Campaign as (select * from campaign_backup);

-- Number of records
select count(*) as Number_0f_Rows from campaign;

-- Ad_ID  add primary key
select count(distinct Ad_ID) as ID_count from Campaign;
select * from campaign where Ad_ID = '';

alter table campaign
modify column Ad_ID varchar(50) not null;

alter table campaign
add primary key (Ad_ID);


-- Data Cleaning/EDA
select distinct Campaign_Name from campaign; -- Done
select distinct Clicks from campaign;
select distinct Impressions from campaign;
select distinct Cost from campaign;
select distinct Leads from campaign;
select distinct Conversions from campaign;
select distinct `Conversion Rate` from campaign;
select distinct Sale_Amount from campaign;
select distinct Ad_Date from campaign;
select distinct Location from campaign;
select distinct Device from campaign;
select distinct Keyword from campaign;

-- Campaign Name - correct misspelled values
select * from campaign where Campaign_Name = ''; -- check for blanks
select replace(replace(replace(replace(Campaign_Name, 'DataAnalyticsCourse', 'Data Analytics Course'), 'Data Anlytics Corse', 'Data Analytics Course'), 
'Data Analytics Corse', 'Data Analytics Course'), 'Data Analytcis Course', 'Data Analytics Course') as Corrected
  from campaign;
  
  select case when Campaign_Name = 'DataAnalyticsCourse' then 'Data Analytics Course'
              when Campaign_Name = 'Data Anlytics Corse' then 'Data Analytics Course'
			  when Campaign_Name = 'Data Analytcis Course' then 'Data Analytics Course'
              when Campaign_Name = 'Data Analytics Corse' then 'Data Analytics Course'
              end as Corrected from campaign;
  
  select case when Campaign_Name in ('DataAnalyticsCourse', 'Data Anlytics Corse', 'Data Analytcis Course', 'Data Analytics Corse')
  then 'Data Analytics Course'
  end as Corrected from campaign;
 
set sql_safe_updates=0;
start transaction;
update campaign
set Campaign_Name = case when Campaign_Name in ('DataAnalyticsCourse', 'Data Anlytics Corse', 
			'Data Analytcis Course', 'Data Analytics Corse')
            then 'Data Analytics Course'
			end;

select * from campaign;


-- Clicks - Change datatype from text to int, round values
select * from campaign where Clicks = '';


update campaign
set Clicks = trim(Clicks);

SELECT CASE WHEN Clicks IS NULL OR Clicks = '' THEN '133'
ELSE Clicks END AS cleaned_column
FROM campaign;

set sql_safe_updates=0;
start transaction;
update campaign
set Clicks = Case 
        WHEN Clicks IS NULL OR Clicks = '' THEN '133'
        ELSE Clicks 
    END;

Alter table campaign
modify column Clicks int;

-- Impressions 
select * from campaign where Impressions = '';
select round(avg(Impressions)) from campaign;
select case when Impressions is null or Impressions = '' then '4429'
else Impressions end from campaign;

set sql_safe_updates=0;
start transaction;
update campaign
set Impressions = case when Impressions is null or Impressions = '' then '4429'
else Impressions end;

Alter table campaign
modify column Impressions int;

select * from campaign;

-- Cost
select * from campaign where Cost = '';

select replace(Cost, '$', '') from campaign; -- Preview

set sql_safe_updates=0;
start transaction;
update campaign
set Cost = replace(Cost, '$', '');

select round(avg(Cost), 2) from campaign;

select case when Cost is null or Cost = '' then '207.07'
else Cost end from campaign; -- Preview

update campaign
set Cost = case when Cost is null or Cost = '' then '207.07'
else Cost end; -- update with the average

alter table campaign
modify column Cost decimal(10,2); -- change datatype from text to decimal

describe campaign;
select * from campaign;

-- Leads
select replace(Leads, '.0', '') from campaign; -- Preview

update campaign
set Leads = replace(Leads, '.0', '');

update campaign
set Leads = replace(Leads, '.0', '');

select * from campaign where Leads = ''; -- check for blanks
select round(avg(Leads)) from campaign; -- check average leads

select case when Leads is null or Leads = '' then '20'
else Leads end from campaign;  -- Preview

set sql_safe_updates=0;
start transaction;
update campaign
set Leads = case when Leads is null or Leads = '' 
	then '20' else Leads 
end; -- update

alter table campaign
modify column Leads int; -- Change Datatype from text to int

select * from campaign;

-- Conversions
select * from campaign where Conversions = '';

select replace(Conversions, '.0', '') from campaign; -- Preview

set sql_safe_updates=0;
start transaction;
update campaign
set Conversions = replace(Conversions, '.0', '');  -- Update 

select round(avg(Conversions)) from campaign; -- Average Conversion

select case when Conversions is null or Conversions = ''
then '6' else Conversions
end from campaign; -- Preview

update campaign
set Conversions = case when Conversions is null or Conversions = ''
then '6' else Conversions
end;  -- Update

alter table campaign
modify column Conversions int; -- Change datatype from text to int

describe campaign;

-- Conversion Rate
select * from campaign where `Conversion Rate` = '';
select Ad_ID, `Conversion Rate`, Round(Conversions / Clicks, 3) from campaign where `Conversion Rate` = '' or `Conversion Rate` is null; -- Preview

set sql_safe_updates=0;
start transaction;
update campaign
set `Conversion Rate` = Round(Conversions / Clicks, 3) where `Conversion Rate` = '' or `Conversion Rate` is null;

rollback;

alter table campaign
modify column `Conversion Rate` decimal(10,3); -- Change datatype from text to decimal

-- Sale Amount
select * from campaign where Sale_Amount = ''; -- Check for Blanks
select round(avg(Sale_Amount)) from campaign;  -- Check for average to fill blanks
select replace(Sale_Amount, '$', '') from campaign; -- Preview

set sql_safe_updates=0;
start transaction;
update campaign
set Sale_Amount =  replace(Sale_Amount, '$', '');  -- Replaced $ with ''


select case when Sale_Amount = '' or Sale_Amount is null
then '1419' else Sale_Amount End as Amount_Update from campaign; -- Preview

update campaign
set Sale_Amount = case when Sale_Amount = '' or Sale_Amount is null
				  then '1419' else Sale_Amount End;  -- Updated blanks and null values with the AVG

alter table campaign
modify column Sale_Amount int;

-- Ad_Date
select distinct Ad_Date from campaign; 

-- Let's pick all the date formats
/* %Y-%m-%d 
   %d-%m-%Y 
   %Y/%m/%d 
   %d-%m-%Y 
   %m-%d-%Y */
   
select * from campaign where Ad_Date = ''; -- Check for Blanks

select distinct AD_Date, case when Ad_Date like '%-%' then str_to_date(Ad_Date, '%Y-%m-%d')
            when Ad_Date like '%/%' then str_to_date(Ad_Date, '%Y/%m/%d') 
             when Ad_Date like '%-%' then str_to_date(Ad_Date, '%d-%m-%Y')
             when  Ad_Date like '%-%' then str_to_date(Ad_Date, '%m-%d-%Y')
             else Ad_Date end as New_Date from campaign;  -- Preview
             
 select distinct Ad_Date, case
when Ad_Date like '%-%' and length(substring_index(Ad_Date,'-',1))= 4 then str_to_date(Ad_Date, '%Y-%m-%d')
 when Ad_Date like '%-%' and substring_index(Ad_Date,'-',1)>=12 then str_to_date(Ad_Date, '%d-%m-%Y')
when Ad_Date like '%-%' and substring_index(Ad_Date,'-',1)<=12 then str_to_date(Ad_Date, '%m-%d-%Y')
  when Ad_Date like '%/%' and substring_index(Ad_Date,'/',-1)>=12 then str_to_date(Ad_Date, '%Y/%m/%d')
when Ad_Date like '%/%' and substring_index(Ad_Date,'/',-1)<=12 then str_to_date(Ad_Date, '%Y/%m/%d')
when Ad_Date like '%-%' and substring_index(Ad_Date,'/',-1)<=12 then str_to_date(Ad_Date, '%d/%m/%Y')
 end as new_date from campaign; 
             
 set sql_safe_updates=0;
 start transaction;
 update campaign
 set Ad_Date = case
when Ad_Date like '%-%' and length(substring_index(Ad_Date,'-',1))= 4 then str_to_date(Ad_Date, '%Y-%m-%d')
 when Ad_Date like '%-%' and substring_index(Ad_Date,'-',1)>=12 then str_to_date(Ad_Date, '%d-%m-%Y')
when Ad_Date like '%-%' and substring_index(Ad_Date,'-',1)<=12 then str_to_date(Ad_Date, '%m-%d-%Y')
  when Ad_Date like '%/%' and substring_index(Ad_Date,'/',-1)>=12 then str_to_date(Ad_Date, '%Y/%m/%d')
when Ad_Date like '%/%' and substring_index(Ad_Date,'/',-1)<=12 then str_to_date(Ad_Date, '%Y/%m/%d')
when Ad_Date like '%-%' and substring_index(Ad_Date,'/',-1)<=12 then str_to_date(Ad_Date, '%d/%m/%Y')
 end; -- New Date Format
 
 alter table campaign
 modify column Ad_Date Date;
               
-- Location
select case when Location in ('hyderabad', 'Hyderbad', 'hydrebad')
               then 'Hyderabad'
               End from campaign;
               
Update campaign
set Location = case when Location in ('hyderabad', 'Hyderbad', 'hydrebad')
               then 'Hyderabad'
               End;
               
Rollback;

-- Device
select concat(upper(Substring(Device, 1, 1)), lower(Substring(Device, 2))) from campaign; -- Capitalize First Letter

set sql_safe_updates=0;
start transaction;
Update campaign
set Device = concat(upper(Substring(Device, 1, 1)), lower(Substring(Device, 2)));

-- Keyword
select replace(replace(Keyword, 'data analitics online', 'data analytics online'), 
                      'data anaytics training', 'data analytics training'
			  ) as Corrected from campaign;
              
update campaign
set Keyword = replace(replace(Keyword, 'data analitics online', 'data analytics online'), 
			  'data anaytics training', 'data analytics training');

select * from campaign;
describe campaign;