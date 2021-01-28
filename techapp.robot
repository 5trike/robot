*** Settings ***
Library    BuiltIn
Library    AppiumLibrary
Library    XML
Library    Collections
Library    OperatingSystem
Library    ConsoleDialogs

*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub   #http://0.0.0.0:4723/wd/hub  #http://127.0.0.1:4723/wd/hub

${PLATFORM_NAME}    Android
#${DEVICE_NAME}    154589a0144b    #LGLS9935584bd   
${DEVICE_NAME}  4731324a37333098    #192.168.1.7:5555    #4731324a37333098
${Activity_NAME}        com.electrolux.ecp.client.sdk.app.activity.LoginActivity
${PACKAGE_NAME}     com.electrolux.ecp.client.sdk.app.selector
${TIMEWAIT}   60
#*** Elements ***
${applianceOnline}    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
${positiveBtn}    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
${applianceEmptyList}    com.electrolux.ecp.client.sdk.app.selector:id/text_empty_list
${navigateUp}    //android.widget.ImageButton[@content-desc="Navigate up"]

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

  Capture Screen Recording
  Login  eluxtester16@gmail.com  Elux123456  NA  LATAM stage  Frigidaire

End
  End Screen Recording
  Save logcat
  AppiumLibrary.Close Application
  Sleep  5s

Save logcat
  ${rc}   ${output} =             Run and Return RC and Output    adb logcat -d | tail -50
  Log    ${output} 

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
  ${TechAppVersion}    AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/text_version    text
  #Set To Dictionary  ${DICT}    TechAppVersion    ${TechAppVersion}
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
  #AppiumLibrary.Wait Until Element Is Visible  ${applianceEmptyList}    60s
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/fab
  Sleep   2s
  eclick    com.electrolux.ecp.client.sdk.app.selector:id/button_onboard_appliance
  Sleep  10s
  AppiumLibrary.Wait Until Element Is Visible    com.electrolux.ecp.client.sdk.app.selector:id/action_name    90s
  ${broadcastname}    AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/action_name    text
  Set To Dictionary  ${DICT}    apname    ${broadcastname}
  AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/action_name
  Sleep   7s
  AppiumLibrary.Click Element    com.android.settings:id/button1
  eclick   //*[contains(@text,"${apname}")]

Onboarding enter password
  [Arguments]   ${appas}
  eclick   com.electrolux.ecp.client.sdk.app.selector:id/text_input_password_toggle
  einput    com.electrolux.ecp.client.sdk.app.selector:id/text_wifi_password    ${appas}
  eclick    ${positiveBtn}

Onboarding
    [Arguments]   ${apname}  ${appas}
    Onboarding choose AP   ${apname} 
    Onboarding enter password   ${appas}

Enrolling
    #Sleep   15s
    eclick    ${positiveBtn}    90
    #AppiumLibrary.Wait Until Element Is Visible   //*[contains(@text,"Appliance already enrolled")]     90   #${positiveBtn}   90
    #Sleep  7s  #wait for update something in the app!!
    #AppiumLibrary.Click Element    ${positiveBtn}

Register
    #Log to console    Wait button 
    AppiumLibrary.Wait Until Element Is Visible      //*[contains(@text,"Enrolling successful")]    90
    #Log to console    Find button, wait 7 sec
    Sleep  7s    #wait for update something in the app!!
    AppiumLibrary.Click Element    ${positiveBtn}
    #Log to console    Click YES
    Find parameter  Preffered Language
    einput   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_pref_language   en-EN
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/button_submit_appliance_details

Delink
    ${state}    Check appliance state
    Run keyword if    '${state}'=='registered'    Delete registered appliance
    ...    ELSE IF    '${state}'=='offline'   Delete offline appliance
    
    #Sleep    5s
    #${emptylist}    Run Keyword And Return Status    Element Should Be Visible  ${applianceEmptyList}
    #Run keyword if    ${emptylist}    Return from keyword    True
    #Sleep    15s
    #${registered}    Run Keyword And Return Status    Element Should Be Visible    ${applianceOnline}
    #Run keyword if    ${registered}    Delete registered appliance
    #...    ELSE    Delete offline appliance

Check appliance state
    Run Keyword And Return Status    Wait Until Element Is Visible   ${applianceEmptyList}     5s
    ${emptylist}    Run Keyword And Return Status    Element Should Be Visible  ${applianceEmptyList}
    Run keyword if    ${emptylist}    Return from keyword    emptylist
    Run Keyword And Return Status    Wait Until Element Is Visible    ${applianceOnline}    5s
    ${registered}     Run Keyword And Return Status    Element Should Be Visible    ${applianceOnline}
    Run keyword if    ${registered}    Return from keyword    registered
    ...    ELSE    Return from keyword    offline

Delete registered appliance
    Choose appliance
    eclick    //android.widget.ImageView[@content-desc="More options"]
    eclick    //*[contains(@text, 'Delete')]
    Return from keyword    emptylist

Delete offline appliance
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/appliance_state_off
    eclick    //*[contains(@text, 'Delete Appliance')]
    Return from keyword    emptylist 

Return
    [Arguments]    ${t}=true
    No operation    
    [Return]    ${t}

Choose appliance
    ${state}    Check appliance state
    Run keyword if    '${state}'=='offline'   Delete offline appliance
    Run keyword if    '${state}'=='emptylist'    Normal provisioning
    Run keyword if    '${state}'=='registered'    eclick    ${applianceOnline}
    Return from keyword    ${state}  

Wait until text   
    [Arguments]   ${text}
    AppiumLibrary.Wait Until Element Is Visible   //*[contains(@text,"${text}")]   60s

Wait until element   
    [Arguments]   ${text}
    AppiumLibrary.Wait Until Element Is Visible   ${text}   60s

Check error
    [Arguments]   ${text}   ${loc}=com.electrolux.ecp.client.sdk.app.selector:id/md_title
    AppiumLibrary.Wait Until Page Contains Element    //*[contains(@text,"Error")]   180
    eclick   ${positiveBtn}    
    Sleep  1s
    #${alerttitle}=   AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/md_title    text
    #${alertcontent}=   AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/md_content    text
    AppiumLibrary.Capture Page Screenshot
    AppiumLibrary.Log Source    DEBUG
    AppiumLibrary.Element Should Contain Text    ${loc}   ${text}
    eclick   ${positiveBtn}

Capture Screen Recording
    ${pass}             Run Keyword And Return Status  AppiumLibrary.Start Screen Recording
    Run Keyword Unless  ${pass}     Log                 Could not start screen recording

End Screen Recording
    Run Keyword And Ignore Error    Remove Screen Recording If Pass

Remove Screen Recording If Pass
    ${filename}                     AppiumLibrary.Stop Screen Recording
    Log    ${filename}  
    #Run Keyword If Test Passed      Remove File     ${filename}
    #Run Keyword If Test Passed      Log             Screen recording not saved because test execution passed.

Scroll Down If Element Not Found
    [Arguments]   ${text}    ${isUpdateDict}
    Swipe By Percent    50    90    50    30
    Run keyword if    '${isUpdateDict}'=='true'    Update dictionary
    Page Should Contain Element  //*[contains(@text,"${text}")]

Find parameter
    [Arguments]   ${text}    ${isUpdateDict}=false
    Run keyword if    '${isUpdateDict}'=='true'    Update dictionary
    BuiltIn.Wait Until Keyword Succeeds    10x    100ms    Scroll Down If Element Not Found   ${text}    ${isUpdateDict}

Update dictionary
    ${src}    Get source
    ${xml}    Parse Xml    ${src}
    ${xml}    Set Variable    ${xml}[0][0][0][0][0][0][2]
    ${params}    XML.Get Child Elements    ${xml}
    FOR    ${param}  IN  @{params}
    ${count}    XML.Get Child Elements  ${param}[0]
    ${count}    Get length    ${count}
    Run keyword if    '${count}'=='3'    Save param  ${param}    
    END

Save param    
    [Arguments]     ${item}    
    ${name}    XML.Get Element Attribute    ${item}[0][0]    text
    ${value}    XML.Get Element Attribute    ${item}[0][2]    text
    Set To Dictionary  ${DICT}    ${name}    ${value}

Fill dictionary
    Wait Until Element Is Visible    ${applianceOnline}    60s
    ${model}    AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/appliance_model    text
    Set To Dictionary  ${DICT}    model    ${model}[7:]
    Choose appliance
    ${pnc}    AppiumLibrary.Get Element Attribute    com.electrolux.ecp.client.sdk.app.selector:id/text_components_count    text
    Set To Dictionary  ${DICT}    pnc    ${pnc}[:9]
    Set To Dictionary  ${DICT}    serial    ${pnc}[-8:]
    Find parameter   noPrnt.Ssid    true
    ${keys}    Get Dictionary Keys    ${INFOS}
    FOR    ${key}    IN    @{keys}
    ${value}    Evaluate    $DICT.get("${INFOS}[${key}]", "unk")
    Log to console  ${key}: ${value}
    END
    AppiumLibrary.Click Element  ${navigateUp}


*** Test Cases ***
Selftest
    Start
    #Choose appliance
    Sleep  5s
    End

*** Comments ***    
    eclick  ${navigateUp}
    Sleep  5s
    Choose appliance
    Find parameter   noPrnt.ExecuteCommand
    eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    eclick    //*[contains(@text,"1 (ON)")]
    eclick    ${positiveBtn}    
    Sleep  20s
    eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    eclick    //*[contains(@text,"0 (OFF)")]
    eclick    ${positiveBtn} 
    Sleep  20s
