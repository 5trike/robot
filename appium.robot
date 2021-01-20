*** Settings ***
Library               AppiumLibrary       15      run_on_failure=Log Source
Library               Process

Suite Setup           Spawn Appium Server
Suite Teardown        Close Appium Server
Test Teardown         Close Application 

*** Variables ***
## Go here to download the apk for the app used in this test -> https://drive.google.com/file/d/19FxLjux8ZtumweXzBA_CYrL0Va-BL4gY/view?usp=sharing
## The app test is using recycler view app example from google
${APP_PACKAGE}            com.electrolux.ecp.client.sdk.app.selector
${APP_ACTIVITY}           com.electrolux.ecp.client.sdk.app.activity.LoginActivity

${APPIUM_PORT}            49152
${APPIUM_SERVER}          http://127.0.0.1:${APPIUM_PORT}/wd/hub
${PLATFORM}               Android
${UDID}                   4731324a37333098    #LGLS9935584bd
${ALIAS}                  Android

*** Keywords ***
Start Appium
  Sleep  1s
  #Process.Start Process    appium      stdout=appium_stdout.txt   
  #-a 127.0.0.1 -p 4723  --shell  --session-override

Close Appium
    Sleep  1s

#Get Working Path
#  Process.Run Process         pwd  shell=True  alias=proc1
#  ${WORKING_PATH}=    Get Process Result  proc1  stdout=true
#  Set Suite Variable  ${WORKING_PATH}

Spawn Appium Server
  #Get Working Path
  Start Process  appium  -p  ${APPIUM_PORT}   shell=true    #stdout=${WORKING_PATH}/appium-log-${ALIAS}.txt  
  Sleep   5

Close Appium Server
  Run Keyword And Ignore Error  Close All Applications
  Terminate All Processes   kill=True
  Sleep   5

*** Tasks ***
T1
    Sleep  1s