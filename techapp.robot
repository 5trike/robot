*** Settings ***
Library    BuiltIn
Library    AppiumLibrary

*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub

${PLATFORM_NAME}    Android
#${DEVICE_NAME}    LGLS9935584bd   
${DEVICE_NAME}   4731324a37333098
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
  Login  eluxtester16@gmail.com  Elux123456  NA  LATAM stage  Frigidaire

End
  AppiumLibrary.Close Application
  Sleep  5s

eclick    #Wait and click
  [Arguments]   ${loc}    ${TIMEWAIT}=90
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Click Element    ${loc} 


bclick    #Wait and click
  [Arguments]   ${loc}    ${TIMEWAIT}=90
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Click button    ${loc} 

einput    #Wait, clear and input
  [Arguments]   ${loc}   ${txt}    ${TIMEWAIT}=90
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Clear Text    ${loc}
  AppiumLibrary.Input text    ${loc}    ${txt}  

Login
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
  AppiumLibrary.Click Element  com.electrolux.ecp.client.sdk.app.selector:id/button_login

Onboarding
    [Arguments]   ${apname}  ${appas}
    AppiumLibrary.Wait Until Element Is Visible  com.electrolux.ecp.client.sdk.app.selector:id/text_empty_list
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/fab
    Sleep   2s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/button_onboard_appliance
    Sleep  10s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/action_name
    Sleep   7s
    AppiumLibrary.Click Element    com.android.settings:id/button1
    eclick   //*[contains(@text,"${apname}")]
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/text_input_password_toggle
    einput    com.electrolux.ecp.client.sdk.app.selector:id/text_wifi_password    ${appas}
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Enrolling
    #Sleep   15s
    AppiumLibrary.Wait Until Element Is Visible   com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive   90
    Sleep  7s  #wait for update something in the app!!
    AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Register    
    AppiumLibrary.Wait Until Element Is Visible   com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive    90
    Sleep  7s    #wait for update something in the app!!
    AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    Sleep  2s

    AppiumLibrary.Swipe    500    1700    500    300
    einput   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_pref_language   en-EN
    Sleep   2s
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/button_submit_appliance_details

Deregister
    eclick    //android.widget.ImageView[@content-desc="More options"]
    eclick    //*[contains(@text, 'Delete')]

Choose appliance
    eclick    //*[contains(@text, 's/n')]

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

  Onboarding choose AP
    [Arguments]   ${apname}
    AppiumLibrary.Wait Until Element Is Visible  com.electrolux.ecp.client.sdk.app.selector:id/text_empty_list
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
      Onboarding check AP   ${apname} 
      Onboarding enter password   ${appas}
      

#com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultNegative
#com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive


    






    