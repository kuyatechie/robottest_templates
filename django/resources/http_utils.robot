*** Settings ***
Library         REST  ${HOSTNAME}:${PORT}  ssl_verify=false
Library         Process
Library         OperatingSystem
Library         json
Library         JSONLibrary
Library         String
Library         Collections
Library         DateTime

*** Variables ***
${HTTP_OK}              ${200}
${HTTP_CREATED}         ${201}
${HTTP_BAD_REQUEST}     ${400}
${HTTP_NOT_FOUND}       ${404}

*** Keywords ***
Set Environment Variables
  [Documentation]  A keyword to initialize environment variables
  Set Environment Variable        API_TIMEOUT_LIMIT                 5
  Set Environment Variable        DB_HOST                           ${DB_HOST}
  Set Environment Variable        DB_NAME                           ${TESTDB_NAME}
  Set Environment Variable        DB_USER                           ${TESTDB_USER}
  Set Environment Variable        DB_PASSWORD                       ${TESTDB_PASSWORD}


Set User
  [Documentation]  A keyword to initialize HTTP request headers
  [Arguments]  ${USER}    ${PASSWORD}
  ${USERPASS}=    Convert To Bytes    ${USER}:${PASSWORD}
  ${USERPASS}=    Evaluate    base64.b64encode($userpass)    base64
  ${USERPASS}=    Catenate  "Basic ${USERPASS}"
  Set Headers  { "Authorization": ${USERPASS}}
  Set Headers  { "Accept": "application/json"}
  Set Headers  { "Content-Type": "application/json"}
  Set Headers  { "charset": "utf-8"}


HTTP POST
  [Arguments]    ${post_request_dict}    ${API_UNDER_TEST}
  ${test_input}=                            Input    ${post_request_dict}
  ${result}=                                POST      ${API_UNDER_TEST}       ${test_input}       timeout=%{API_TIMEOUT_LIMIT}
  ${response}                               Object  response
  [Return]    ${response}

HTTP PUT
  [Arguments]    ${put_request_dict}    ${API_UNDER_TEST}
  ${test_input}=                            Input    ${put_request_dict}
  ${result}=                                PUT      ${API_UNDER_TEST}       ${test_input}       timeout=%{API_TIMEOUT_LIMIT}
  ${response}                               Object  response
  [Return]    ${response}

HTTP PATCH
  [Arguments]    ${patch_request_dict}    ${API_UNDER_TEST}
  ${test_input}=                            Input    ${patch_request_dict}
  ${result}=                                PATCH      ${API_UNDER_TEST}       ${test_input}       timeout=%{API_TIMEOUT_LIMIT}
  ${response}                               Object  response
  [Return]    ${response}

HTTP GET
  [Arguments]    ${API_UNDER_TEST}
  GET                                       ${API_UNDER_TEST}          timeout=%{API_TIMEOUT_LIMIT}
  ${response}                               Object  response
  [Return]    ${response}

HTTP DELETE
  [Arguments]    ${API_UNDER_TEST}
  DELETE                                    ${API_UNDER_TEST}          timeout=%{API_TIMEOUT_LIMIT}
  Output                                    response

