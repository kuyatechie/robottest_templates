*** Settings ***
Library         Process
Library         OperatingSystem
Library         json
Library         JSONLibrary
Library         String
Library         Collections
Library         DateTime


*** Keywords ***
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


Flush Database
  [Documentation]  A keyword to flush data from database
  Run Django Manage  flush


Load Fixture
  [Documentation]  A keyword to load data to database
  [Arguments]  ${path}
  Run Django Manage   loaddata  ${path}
  ${json}=  Load JSON From File  ${path}
  [Return]  ${json}


Dump Fixture
  [Documentation]  A keyword to dump data from database
  [Arguments]  ${app}
  ${result}=     Run Django Manage   dumpdata  ${app}
  ${json}=       Convert String to JSON 	${result.stdout}
  [Return]  ${json}

