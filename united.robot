*** Settings ***
Library     ConsoleDialogs
Library     BuiltIn
Resource    router.robot
Resource    techapp.robot
Resource    buttons.robot
Resource    techapp.robot
Resource    plug.robot
Resource    led.robot

Suite Setup     Suite start
Suite Teardown  Suite end  
Test Setup       Test start   
Test Teardown    Test end

*** Variables ***
${BROWSER}      headlessfirefox    #headlessfirefox         #firefox
${BUTTON_PUSHER}   'servo'        #human    #servo
${LED_WATCHER}    'auto'    #human    #auto
${BLOCKPORT}   0
&{INFOS}    model=model    pnc=pnc    serial=noPrnt.SerialNumber    LinkQuality=noPrnt.LinkQualityIndicator    NiuFirmwareVersion=noPrnt.SwVersion    NiuSWANCversion=noPrnt.NiuSwUpdateCurrentDescription    TechAppVersion=TechAppVersion    MacAddress=noPrnt.MacAddress    apname=apname    
&{DICT}    name=value
${ROUTERAPNAME}    NETGEAR09
${ROUTERAPPWD}    bluephoenix200

*** Keywords ***
Suite start
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    buttons.Start
    techapp.Start
    Total factory reset

Suite end
    No operation 

Test start
    router.Start
    buttons.Release all
    plug.On
    techapp.Start
    
Test end
    Run Keyword if  '${BLOCKPORT}'!='0'    router.block port   0 
    techapp.End
    router.End

Appliance factory reset
    buttons.Press   2   11

Appliance start broadcasting
    buttons.Press   2   7  

Onboarding
    [Arguments]   ${apname}   ${appass}
    Appliance start broadcasting  
    techapp.Onboarding     ${apname}     ${appass}

Total factory reset
    Appliance factory reset
    techapp.Delink

Provisioning
    [Arguments]   ${apname}   ${appass}
    Onboarding   ${apname}   ${appass}
    techapp.Enrolling
    techapp.Register
    ${state}    techapp.Check appliance state
    Log to console    ${state}

*** Test Cases ***
TC-100
    [Documentation]    Provisioning and register appliance
    ...                Expected result: Appliance  provisioning, WiFi led ON
    [Tags]    Provisioning
    Provisioning    ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Fill dictionary
    led.Check state    ON
    Total factory reset

TC-109
    [Documentation]    Provisioning and register appliance using AP with special characters
    ...                Expected result: Appliance  provisioning (check appliance connectivity state), WiFi led ON
    [Tags]    Provisioning    
    Provisioning   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?
    
TC-200
    [Documentation]    Check appliance communicate with the cloud
    ...                Expected result: Appliance  communicate with the cloud, WiFi led ON
    [Tags]    Operate    
    techapp.Choose appliance
    techapp.Find parameter   noPrnt.ExecuteCommand
    techapp.eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    techapp.eclick    //*[contains(@text,"1 (ON)")]
    techapp.eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    techapp.eclick  //android.widget.ImageButton[@content-desc="Navigate up"]  
    techapp.Choose appliance
    techapp.Find parameter   noPrnt.ExecuteCommand
    techapp.eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    techapp.eclick    //*[contains(@text,"0 (OFF)")]
    techapp.eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    techapp.eclick  //android.widget.ImageButton[@content-desc="Navigate up"]  

TC-101
    [Documentation]    Check offboarding
    ...                Expected result: Appliance offboarding, WiFi led OFF
    [Tags]    Provisioning    
    techapp.Check appliance state
    Total factory reset
    led.Check state    OFF

TC-121
    [Documentation]    Onboarding with wrong password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW002
    [Tags]    Onboarding    
    Onboarding     ${ROUTERAPNAME}   WRONG_PASSWORD
    techapp.Check error    Error ECPW002
    led.Check state    OFF


TC-102
    [Documentation]    Onboarding with short password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW008
    [Tags]    Onboarding    
    Onboarding     ${ROUTERAPNAME}   SHORT
    techapp.Check error    Error ECPW008
    led.Check state    OFF

TC-105
    [Documentation]    Enrolling when port 443 is blocked
    ...                Expected result: Appliance not provisioning, WiFi led OFF, Error ECPW103
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}   443
    router.block port   ${BLOCKPORT}
    Onboarding     ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Enrolling
    techapp.Check error    Error ECPW103
    Appliance factory reset
    led.Check state   OFF

TC-103
    [Documentation]    Enrolling appliance with no internet
    ...                Expected result: Appliance  not provisioning, WiFi led OFF, 
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}    65535
    router.block port   ${BLOCKPORT}
    Onboarding     ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Enrolling
    techapp.Check error    Error ECPW108
    Appliance factory reset
    led.Check state    OFF    

TC-106
    [Documentation]    Powercycle during onboarding before enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    Appliance start broadcasting  
    techapp.Onboarding choose AP   ${ROUTERAPNAME}
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    OFF

TC-107
    [Documentation]    Powercycle during onboarding after enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    Onboarding   ${ROUTERAPNAME}   ${ROUTERAPPWD}
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    OFF

TC-108
    [Documentation]    Powercycle in 10 sec after starting enrolling process
    ...                Expected result: Appliance provisioning, WiFi led ON
    [Tags]    Enrolling    
    Onboarding   ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Enrolling
    Sleep  10s
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    ON

TC-110
    [Documentation]    Verify NIU AP mode
    ...                Expected result: Appliance turn on AP (@E_ApplianceType_xxxxxxxxxx), WiFi led blinking
    [Tags]    Onboarding    
    buttons.Press   2    7

TC-111
    [Documentation]    Verify NIU AP mode turn off in 5 min
    ...                Expected result: After 5 min Appliance turn of AP (@E_ApplianceType_xxxxxxxxxx), WiFi led OFF
    [Tags]    Onboarding    
    buttons.Press   2    7

TC-200
    [Documentation]    Powercycle for 10 sec registered appliance and router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    plug.Off
    Sleep  10s
    plug.On
    techapp.Check appliance state
    led.Check state    ON

TC-201
    [Documentation]    Powercycle for 10 min registered appliance adn router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    plug.Off
    Log to console     Wait for 10 min
    Sleep  10m
    plug.On
    techapp.Check appliance state
    led.Check state   ON

TC-104
    [Documentation]    Onboarding with DHCP server is off
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW005
    [Tags]    Onboarding    
    router.Turn off DHCP server
    Sleep    10s
    Onboarding   ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Check error    Error ECPW005
    router.Turn on DHCP server
    led.Check state    OFF

*** Comments ***
#Operate Verify Turbo Refrig. and Turbo Freezer
#Operate Verify Temperature Representation setting
#Operate Verify Temperature Setting for Freezer and Refrigerator
#Operate Verify Ice Maker
#Operate Sabbath Mode
#Operate VCZ cavity setting
#Operate Child Lock
#Operate Compressor
#Operate Water Filter
#Operate Appliance Alert 
#Verify Factory Serialization