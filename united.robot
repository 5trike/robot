*** Settings ***
Library  ConsoleDialogs
Library    BuiltIn
Resource    router.robot
Resource    techapp.robot
Resource    buttons.robot
Resource    techapp.robot

Suite Setup     Suite start
Suite Teardown  Suite end  

Test Setup       Test start   
Test Teardown    Test end

*** Variables ***
${BROWSER}      headlessfirefox    #headlessfirefox         #firefox
${BUTTON_PUSHER}   'manual'
${blockport}   0

*** Keywords ***
Suite start
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    Set Global Variable    ${dicter}    ()
    router.Start
    buttons.Start   

Suite end
    Sleep    0 
    router.End

Test start
    buttons.Release all
    techapp.Start
    
Test end
    Run Keyword if  '${blockport}'!='0'    router.block port   0 
    techapp.End

Onboarding
    [Arguments]   ${apname}   ${appass}
    buttons.Press   1   6  
    techapp.Onboarding     ${apname}     ${appass}

Deregister
    techapp.Choose appliance
    techapp.Deregister
    buttons.Press    1    11

*** Comments ***
#*** Test Cases ***
TC-100
    [Documentation]    Provisioning and register appliance
    ...                Expected result: Appliance  provisioning, WiFi led ON
    [Tags]    Provisioning
    Onboarding   NETGEAR09   bluephoenix200
    techapp.Enrolling
    Sleep  10m
    techapp.Register
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Check led state    ON
    Deregister

*** Test Cases ***
TC-109
    [Documentation]    Provisioning and register appliance using AP with special characters
    ...                Expected result: Appliance  provisioning (check appliance connectivity state), WiFi led ON
    [Tags]    Provisioning    
    Onboarding   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?
    techapp.Enrolling
    techapp.Register
    techapp.Wait until element   com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity

TC-200
    [Documentation]    Powercycle for 10 sec registered appliance and router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    ConsoleDialogs.Pause Execution  message=Turn Power OFF Appliance and router. Hit [Return] to continue.
    Log to console     Wait for 10 sec
    Sleep  10s
    ConsoleDialogs.Pause Execution  message=Turn Power ON Appliance and router. Hit [Return] to continue.
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Check led state    ON

TC-200
    [Documentation]    Check appliance communicate with the cloud
    ...                Expected result: Appliance  communicate with the cloud, WiFi led ON
    [Tags]    Operate    
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Choose appliance
    buttons.Press    2    0
    techapp.Find parameter   noPrnt.ExecuteCommand
    techapp.eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    techapp.eclick    //*[contains(@text,"0 (OFF)")]
    techapp.eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    techapp.eclick  //android.widget.ImageButton[@content-desc="Navigate up"]  

*** Comments ***
TC-201
    [Documentation]    Powercycle for 10 min registered appliance adn router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    ConsoleDialogs.Pause Execution  message=Turn Power OFF Appliance and router. Hit [Return] to continue.
    Log to console     Wait for 10 min
    Sleep  10m
    ConsoleDialogs.Pause Execution  message=Turn Power ON Appliance and router. Hit [Return] to continue.
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Check led state    ON

TC-101
    [Documentation]    Check offboarding
    ...                Expected result: Appliance offboarding, WiFi led OFF
    [Tags]    Provisioning    
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    Deregister
    techapp.Check led state    OFF

TC-121
    [Documentation]    Onboarding with wrong password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW002
    [Tags]    Onboarding    
    Onboarding     NETGEAR09   WRONG_PASSWORD
    techapp.Check error    Error ECPW002
    techapp.Check led state    OFF

TC-102
    [Documentation]    Onboarding with short password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW008
    [Tags]    Onboarding    
    Onboarding     NETGEAR09   SHORT
    techapp.Check error    Error ECPW008
    techapp.Check led state    OFF

TC-105
    [Documentation]    Enrolling when port 443 is blocked
    ...                Expected result: Appliance not provisioning, WiFi led OFF, Error ECPW103
    [Tags]    Enrolling    
    Set Test Variable   ${blockport}   443
    router.block port   ${blockport}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW103
    techapp.Check led state    OFF

TC-103
    [Documentation]    Enrolling appliance with no internet
    ...                Expected result: Appliance  not provisioning, WiFi led OFF, 
    [Tags]    Enrolling    
    Set Test Variable   ${blockport}    65535
    router.block port   ${blockport}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW108
    techapp.Check led state    OFF    

TC-104
    [Documentation]    Onboarding with DHCP server is off
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW005
    [Tags]    Onboarding    
    router.Turn off DHCP server
    Sleep  10s
    Onboarding   NETGEAR09   bluephoenix200
    techapp.Check error    Error ECPW005
    router.Turn on DHCP server
    techapp.Check led state    OFF
    ConsoleDialogs.Pause Execution  message=Turn on DHCP. Hit [Return] to continue.

TC-106
    [Documentation]    Powercycle during onboarding before enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    buttons.Press   1   6  
    techapp.Onboarding choose AP   NETGEAR09
    ConsoleDialogs.Pause Execution  message=Turn off appliance power. Hit [Return] to continue.
    techapp.Check led state    OFF

TC-107
    [Documentation]    Powercycle during onboarding after enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    Onboarding   NETGEAR09   bluephoenix200
    ConsoleDialogs.Pause Execution  message=Turn off appliance power. Hit [Return] to continue.
    techapp.Check led state    OFF

TC-108
    [Documentation]    Powercycle in 10 sec after starting enrolling process
    ...                Expected result: Appliance provisioning, WiFi led ON
    [Tags]    Enrolling    
    Onboarding   NETGEAR09   bluephoenix200
    techapp.Enrolling
    Sleep  10s
    ConsoleDialogs.Pause Execution  message=Power cycle for appliance. Hit [Return] to continue.
    techapp.Check led state    ON

TC-200
    [Documentation]    Powercycle for 10 sec registered appliance
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    ConsoleDialogs.Pause Execution  message=Appliance Power off. Hit [Return] to continue.
    Log to console     Wait for 10 sec
    Sleep  10s
    ConsoleDialogs.Pause Execution  message=Appliance Power off. Hit [Return] to continue.
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Check led state    ON

TC-201
    [Documentation]    Powercycle for 10 min registered appliance
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    ConsoleDialogs.Pause Execution  message=Turn appliance Power OFF. Hit [Return] to continue.
    Log to console     Wait for 10 min
    Sleep  10m
    ConsoleDialogs.Pause Execution  message=Turn appliance Power ON. Hit [Return] to continue.
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    techapp.Check led state    ON
    


TC-110
    [Documentation]    Verify NIU AP mode
    ...                Expected result: Appliance turn on AP (@E_ApplianceType_xxxxxxxxxx), WiFi led blinking
    [Tags]    Onboarding    
    buttons.Press   1    6

TC-111
    [Documentation]    Verify NIU AP mode turn off in 5 min
    ...                Expected result: After 5 min Appliance turn of AP (@E_ApplianceType_xxxxxxxxxx), WiFi led OFF
    [Tags]    Onboarding    
    buttons.Press   1    6

*** Comments ***


Provisioning during power recycle
    Onboarding with buttons   NETGEAR09   bluephoenix200
    Sleep  380s

TCop+
    [Documentation]    Verify that registered appliance communicate with the cloud
    ...                Expected result: Turn appliance on/off using appliance UA check that is reflect in the app and vice versa
    [Tags]    Operate    
    buttons.Press   2    1
    techapp.Get value   ???

TCop
    [Documentation]    Get parameters
    ...                Expected result: get values for all parameters
    [Tags]    Operate    
    Set Global Variable    ${t}    0
    techapp.Choose appliance
    techapp.Get value   noPrnt.IceDispenserState  #noPrnt.Ssid
    #Sleep  30

Verify Link Quality
Confirm NIUX Firmware Version
Confirm NIUX SW ANC version
Verify Factory Serialization
Verify PNC number
Confirm Model Number
Confirm Serial Number
Verify Turbo Refrig. and Turbo Freezer
Verify Temperature Representation setting
Verify Temperature Setting for Freezer and Refrigerator
Verify Ice Maker
Sabbath Mode
VCZ cavity setting
Child Lock
Compressor
Water Filter
Appliance Alert 

Wrong Network entry 
    Onboarding with buttons     NETGEAR09-5G   bluephoenix200   #It's not wrong network!!
    techapp.Enrolling
    techapp.Register
    Sleep  60s
