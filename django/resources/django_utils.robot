*** Settings ***
Library         SeleniumLibrary  timeout=10  implicit_wait=0
Library         DjangoLibrary  ${HOSTNAME}  ${PORT}  path=mysite/  manage=manage.py  settings=${SETTINGS}
Library         Process
Library         OperatingSystem
Library         json
Library         JSONLibrary
Library         String
Library         Collections


*** Keywords ***
Start Django and Open Browser
  [Documentation]  A keyword to start test and open browser
  Set Environment Variables
  Flush Database
  Start Django
  Open Browser  ${SERVER}  ${BROWSER}


Stop Django and Close Browser
  [Documentation]  A keyword to end test and close browser
  Close All Browsers
  Flush Database
  Stop Django


Run Django Manage
  [Documentation]  A keyword to run django manage commands
  [Arguments]      @{command_args}
  ${result}=  Run Process
  ...   ${PROJECT_PATH}/${VIRTUALENV}/bin/python
  ...   ${PROJECT_PATH}/manage.py
  ...   @{command_args}
  ...   shell=True
  ...   env:DB_HOST=${DB_HOST}
  ...   env:DB_NAME=${TESTDB_NAME}
  ...   env:DB_USER=${TESTDB_USER}
  ...   env:DB_PASSWORD=${TESTDB_PASSWORD}
  ...   env:SECRET_KEY=${SECRET_KEY}
  ...   env:SETTINGS=${SETTINGS}
  Log    Value is ${result.stdout}
  Should Be Equal As Integers    ${result.rc}    0
  [Return]  ${result}


Create User Account
  ${result}=  Run Django Manage   shell  <  scripts/users.py


Get Django Apps
  ${result}=  Run Django Manage  shell  <  scripts/apps.py
  @{django_apps}=  Split String  ${result.stdout}  \n


Open Django Page
  [Documentation]  A keyword to test Django landing page
  Wait until page contains element  id=div_id_username
  Page Should Contain Django REST framework
  Go To  ${SERVER}

