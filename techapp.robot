*** Settings ***
Library  BuiltIn
Library    AppiumLibrary
Library   Process

*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub

${PLATFORM_NAME}    Android
#${DEVICE_NAME}    LGLS9935584bd   
${DEVICE_NAME}   4731324a37333098
${Activity_NAME}        com.electrolux.ecp.client.sdk.app.activity.LoginActivity
${PACKAGE_NAME}     com.electrolux.ecp.client.sdk.app.selector
${TIMEWAIT}   60

*** Keywords ***
Start Appium
  Sleep  1s
  #Process.Start Process    appium      stdout=appium_stdout.txt   
  #-a 127.0.0.1 -p 4723  --shell  --session-override

Close Appium
    Sleep  1s

Open techapp
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

Close techapp
  AppiumLibrary.Log Source
  AppiumLibrary.Close Application

eclick    #Wait and click
  [Arguments]   ${loc}     
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Click Element    ${loc} 


bclick    #Wait and click
  [Arguments]   ${loc}     
  AppiumLibrary.Wait Until Element Is Visible   ${loc}    ${TIMEWAIT}
  AppiumLibrary.Click button    ${loc} 

einput    #Wait, clear and input
  [Arguments]   ${loc}   ${txt}  
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
    Sleep  3s
    AppiumLibrary.Click Element At Coordinates    944    1948
    Sleep   1s
    AppiumLibrary.Click Element At Coordinates    944    1611
    Sleep  10s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/action_name
    #eclick    com.android.settings:id/button1
    Sleep   7s
    #AppiumLibrary.Wait Until Element Is Visible    com.android.settings:id/button1
    AppiumLibrary.Click Element    com.android.settings:id/button1
    eclick   //*[contains(@text,"${apname}")]
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/text_input_password_toggle
    einput    com.electrolux.ecp.client.sdk.app.selector:id/text_wifi_password    ${appas}
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive

Enrolling
    Sleep   15s
    eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    #AppiumLibrary.Click Element At Coordinates    897    1150
    #AppiumLibrary.Wait Until Element Is Visible    /hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.TextView[2]
    #AppiumLibrary.Click Element   	/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.TextView[2]
    #AppiumLibrary.Click Element   //*[contains(@text, 'YES')]

Register    
    Sleep  25s
    AppiumLibrary.Wait Until Element Is Visible   com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive    90
    Sleep  7s
    AppiumLibrary.Click Element    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    
    #AppiumLibrary.Wait Until Element Is Visible   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_appliance_type
    #try swipe
    Sleep  2s
    AppiumLibrary.Swipe    500    1700    500    300
    #actions = TouchAction(driver)
    #actions.press(x=, y=).move_to(x=, y=).release().perform()
    einput   com.electrolux.ecp.client.sdk.app.selector:id/edit_text_pref_language   en-EN
    eclick   com.electrolux.ecp.client.sdk.app.selector:id/button_submit_appliance_details






    