*** Settings ***
Library    BuiltIn
Library    AppiumLibrary
Library    XML
Library    Collections
Library    OperatingSystem
Library    ConsoleDialogs
#Resource  test.txt

*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub   #http://0.0.0.0:4723/wd/hub  #http://127.0.0.1:4723/wd/hub

${PLATFORM_NAME}    Android
#${DEVICE_NAME}    154589a0144b    #LGLS9935584bd   
${DEVICE_NAME}  4731324a37333098    #192.168.1.7:5555    #4731324a37333098
${Activity_NAME}        com.electrolux.ecp.client.sdk.app.activity.LoginActivity
${PACKAGE_NAME}     com.electrolux.ecp.client.sdk.app.selector
${TIMEWAIT}   60

*** Keywords ***
Start
  AppiumLibrary.Open Application   ${REMOTE_URL}
  ...   platformName=${PLATFORM_NAME}
  ...   deviceName=${DEVICE_NAME}
  ...   automationName=UiAutomator2
  ...   newCommandTimeout=2500
  ...   appActivity=${Activity_NAME}
  ...   appPackage=${PACKAGE_NAME}
  ...   clearDeviceLogsOnStart=true
  ...   session-override=true
  ...   autoGrantPermissions=true
  ...   accept_next_alert=false
  ...   noReset=true

  #${driver}  Get Current Application

  #Capture Screen Recording
  Login  eluxtester16@gmail.com  Elux123456  NA  LATAM stage  Frigidaire

End
  AppiumLibrary.Close Application
  #End Screen Recording
  Sleep  5s

eclick    #Wait and click
  [Arguments]   ${loc}    ${TIMEWAIT}=90
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Click Element    ${loc} 


#bclick    #Wait and click
#  [Arguments]   ${loc}    ${TIMEWAIT}=90
#  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
#  AppiumLibrary.Click button    ${loc} 

einput    #Wait, clear and input
  [Arguments]   ${loc}   ${txt}    ${TIMEWAIT}=90
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Clear Text    ${loc}
  AppiumLibrary.Input text    ${loc}    ${txt}  

Login
  [Arguments]   ${username}  ${userpass}  ${country}  ${space}  ${brand}
  ${currentuser}   Get Text    com.electrolux.ecp.client.sdk.app.selector:id/edit_text_username
  Run Keyword If   """${currentuser}"""!="""${username}"""   Input credentials    ${username}  ${userpass}  ${country}  ${space}  ${brand}
  AppiumLibrary.Click Element  com.electrolux.ecp.client.sdk.app.selector:id/button_login

Input credentials
  [Arguments]   ${username}  ${userpass}  ${country}  ${space}  ${brand}
  AppiumLibrary.Input text  com.electrolux.ecp.client.sdk.app.selector:id/edit_text_username   ${username}
  einput   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_country  ${country}    
  AppiumLibrary.Input text  com.electrolux.ecp.client.sdk.app.selector:id/edit_text_password  ${userpass}
  AppiumLibrary.Hide Keyboard
  AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/button_space  
  AppiumLibrary.Wait Until Element Is Visible    //*[contains(@text,"${space}")]
  AppiumLibrary.Click Element   //*[contains(@text,"${space}")]
  AppiumLibrary.Click Element  com.electrolux.ecp.client.sdk.app.selector:id/button_brand
  eclick    //*[contains(@text,"${brand}")]

Onboarding choose AP
  [Arguments]   ${apname}
  #AppiumLibrary.Wait Until Element Is Visible  com.electrolux.ecp.client.sdk.app.selector:id/text_empty_list    60s
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/fab
  Sleep   2s
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/button_onboard_appliance
  Sleep  10s
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/action_name
  Sleep   7s
  AppiumLibrary.Click Element    com.android.settings:id/button1
  eclick   //*[contains(@text,"${apname}")]

Onboarding enter password
  [Arguments]   ${appas}
  eclick   com.electrolux.ecp.client.sdk.app.selector:id/text_input_password_toggle
  einput    com.electrolux.ecp.client.sdk.app.selector:id/text_wifi_password    ${appas}
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Onboarding
    [Arguments]   ${apname}  ${appas}
    Onboarding choose AP   ${apname} 
    Onboarding enter password   ${appas}

Enrolling
    #Sleep   15s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive    90
    #AppiumLibrary.Wait Until Element Is Visible   //*[contains(@text,"Appliance already enrolled")]     90   #com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive   90
    #Sleep  7s  #wait for update something in the app!!
    #AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Register
    #Log to console    Wait button 
    AppiumLibrary.Wait Until Element Is Visible      //*[contains(@text,"Enrolling successful")]    90
    #Log to console    Find button, wait 7 sec
    Sleep  7s    #wait for update something in the app!!
    AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    #Log to console    Click YES
    Find parameter  Preffered Language
    einput   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_pref_language   en-EN
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/button_submit_appliance_details

Deregister
    eclick    //android.widget.ImageView[@content-desc="More options"]
    eclick    //*[contains(@text, 'Delete')]

Choose appliance
    Wait Until Element Is Visible    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity    60s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity  60s

Wait until text   
    [Arguments]   ${text}
    AppiumLibrary.Wait Until Element Is Visible   //*[contains(@text,"${text}")]   60s

Wait until element   
    [Arguments]   ${text}
    AppiumLibrary.Wait Until Element Is Visible   ${text}   60s

Check error
    [Arguments]   ${text}   ${loc}=com.electrolux.ecp.client.sdk.app.selector:id/md_title
    AppiumLibrary.Wait Until Page Contains Element    //*[contains(@text,"Error")]   180
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive    
    Sleep  1s
    #${alerttitle}=   AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/md_title    text
    #${alertcontent}=   AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/md_content    text
    AppiumLibrary.Capture Page Screenshot
    AppiumLibrary.Log Source    DEBUG
    AppiumLibrary.Element Should Contain Text    ${loc}   ${text}
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Capture Screen Recording
    ${pass}             Run Keyword And Return Status  AppiumLibrary.Start Screen Recording
    Run Keyword Unless  ${pass}     Log                 Could not start screen recording

End Screen Recording
    Run Keyword And Ignore Error    Remove Screen Recording If Pass

Remove Screen Recording If Pass
    ${filename}                     AppiumLibrary.Stop Screen Recording
    Log    ${filename}  
    Run Keyword If Test Passed      Remove File     ${filename}
    Run Keyword If Test Passed      Log             Screen recording not saved because test execution passed.

Scroll Down If Element Not Found
    [Arguments]   ${text}
    Swipe By Percent    50    90    50    30
    Page Should Contain Element  //*[contains(@text,"${text}")]

Find parameter
    [Arguments]   ${text}
    BuiltIn.Wait Until Keyword Succeeds    10x    100ms    Scroll Down If Element Not Found   ${text}

Check element
    [Arguments]   ${loc}
    Wait until element  ${loc}
    Element Should Be Visible    ${loc}

*** Comments ***
    Choose appliance
    Sleep  5s
    eclick  //android.widget.ImageButton[@content-desc="Navigate up"]
    Sleep  5s
    Choose appliance
    Find parameter   noPrnt.ExecuteCommand
    eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    eclick    //*[contains(@text,"1 (ON)")]
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive    
    Sleep  20s
    eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    eclick    //*[contains(@text,"0 (OFF)")]
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive 
    Sleep  20s
