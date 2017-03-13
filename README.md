====================
listshine-bash 1.0
====================


This is app that deals with subscribe/unsubscribe in ListShine mailing list system.

Quick start guide:
------------------

1. fetch listshine.sh from github
2. export LISTSHINE_API_KEY
3. install curl ( apt-get install curl )
4. install jq ( apt-get install jq )


FUNCTIONS
---------

1. Subscribing users
   ```bash
   source listshine.sh
   subscribe <contactlist_uuid> <email_json>
   ```
   
2. Unsubscribing users
   ```bash
   source listshine.sh
   unsubscribe <contactlist_uuid> <email_address>
   ```
   
3. retrieve users
   ```bash
   source listshine.sh
   retrieve <contactlist_uuid> <email_address> | jq
   ```
   
Merge Vars
----------

When you are subscribing contacts you can use merge vars.
Following merge vars are supported:
* firstname
* lastname
* company
* website
* phone
* city
* country
* custom
* custom2
* custom3
* custom3

Example
--------

To subscribe contact test@test.com with firstname "name" and lastname "surname"
to contactlist uuid b3132322-498d-4a17-9b91-78ae3be66eb8
   ```bash 
   subscribe "b3132322-498d-4a17-9b91-78ae3be66eb8" '{"email":"test@test.com","firstname":"name","lastname":"surname"}'
   ```
To subscribe contact test@test.com to contactlist uuid b3132322-498d-4a17-9b91-78ae3be66eb8
   ```bash
   subscribe "b3132322-498d-4a17-9b91-78ae3be66eb8" '{"email": "test@test.com"}'
   ```

To unsubscribe contact test@test.com from contactlist uuid b3132322-498d-4a17-9b91-78ae3be66eb8
   ```bash
   unsubscribe "b3132322-498d-4a17-9b91-78ae3be66eb8" "test@test.com"
   ```
To retrieve contact details for test@test.com from contactlist uuid b3132322-498d-4a17-9b91-78ae3be66eb8
   ```bash
   retrieve "b3132322-498d-4a17-9b91-78ae3be66eb8" "test@test.com"
   ```
