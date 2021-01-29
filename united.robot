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
${LED_WATCHER}    'human'    #human    #auto
${BLOCKPORT}   0
&{INFOS}    model=model    pnc=pnc    serial=noPrnt.SerialNumber    LinkQuality=noPrnt.LinkQualityIndicator    NiuFirmwareVersion=noPrnt.SwVersion    NiuSWANCversion=noPrnt.NiuSwUpdateCurrentDescription    TechAppVersion=TechAppVersion    MacAddress=noPrnt.MacAddress    apname=apname    
&{DICT}    name=value
${ROUTERAPNAME}    NETGEAR09
${ROUTERAPPWD}    bluephoenix200

*** Keywords ***
Suite start
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    router.Start
    plug.On
    techapp.Start
    Reset and delink

Suite end
    router.End

Test start
    router.Start
    techapp.Start
    
Test end
    Run Keyword if  '${BLOCKPORT}'!='0'    router.Block port   0 
    techapp.End
    router.End

Factory Reset
    buttons.Press   2   11
    Sleep    5s

Start Broadcasting
    buttons.Press   2   6 

Onboarding
    [Arguments]   ${apname}   ${appass}
    Start broadcasting  
    techapp.Onboarding     ${apname}     ${appass}

Reset and delink
    Factory reset
    techapp.Delink
    Sleep    5s

Provisioning
    [Arguments]   ${apname}   ${appass}
    Onboarding   ${apname}   ${appass}
    techapp.Enrolling
    techapp.Register
    ${state}    techapp.Check appliance state
    Return from keyword    ${state}

Initcheck
    Sleep   0
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    router.Start
    plug.On
    techapp.Start
    Reset and delink

Powercycle
    [Arguments]   ${hold}=10s    
    plug.Off
    Sleep    ${hold}
    plug.On

*** Test Cases ***
#Selftest
#    Initcheck

TC-100
    [Documentation]    Provisioning and register appliance
    ...                Expected result: Appliance  provisioning, WiFi led ON
    [Tags]    Provisioning
    Provisioning    ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Fill dictionary
    Log to console     ${state}
    #led.Check state    ON
    Reset and delink

TC-110
    [Documentation]    Verify NIU AP mode
    ...                Expected result: Appliance turn on AP (@E_ApplianceType_xxxxxxxxxx), WiFi led blinking
    [Tags]    Onboarding    
    Log to console    APNAME : ${DICT}[apname] Придумать проверку

TC-109
    [Documentation]    Provisioning and register appliance using AP with special characters
    ...                Expected result: Appliance  provisioning (check appliance connectivity state), WiFi led ON
    [Tags]    Provisioning    
    Provisioning   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?

TC-200
    [Documentation]    Powercycle for 10 sec registered appliance and router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    plug.Off
    Sleep  10s
    plug.On
    techapp.Check appliance state

    #led.Check state    ON

TC-201
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
    Reset and delink
    #led.Check state    OFF

TC-121
    [Documentation]    Onboarding with wrong password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW002
    [Tags]    Onboarding    
    Onboarding     ${ROUTERAPNAME}   WRONG_PASSWORD
    techapp.Check error    Error ECPW002
    #led.Check state    OFF


TC-102
    [Documentation]    Onboarding with short password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW008
    [Tags]    Onboarding    
    Onboarding     ${ROUTERAPNAME}   SHORT
    techapp.Check error    Error ECPW008
    #led.Check state    OFF

TC-105
    [Documentation]    Enrolling when port 443 is blocked
    ...                Expected result: Appliance not provisioning, WiFi led OFF, Error ECPW103
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}   443
    router.block port   ${BLOCKPORT}
    Onboarding     ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Enrolling
    techapp.Check error    Error ECPW103
    Reset and delink
    #led.Check state   OFF

TC-103
    [Documentation]    Enrolling appliance with no internet
    ...                Expected result: Appliance  not provisioning, WiFi led OFF, 
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}    65535
    router.block port   ${BLOCKPORT}
    Onboarding     ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Enrolling
    techapp.Check error    Error ECPW108
    Reset and delink
    #led.Check state    OFF    

TC-106
    [Documentation]    Powercycle during onboarding before enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    Start broadcasting  
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

TC-111
    [Documentation]    Verify NIU AP mode turn off in 5 min
    ...                Expected result: After 5 min Appliance turn of AP (@E_ApplianceType_xxxxxxxxxx), WiFi led OFF
    [Tags]    Onboarding    
    Start Broadcasting

*** Comments ***
TC-210
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
    Powercycle    30s
    Onboarding   ${ROUTERAPNAME}   ${ROUTERAPPWD}
    techapp.Check error    Error ECPW005
    router.Turn on DHCP server
    Powercycle    30s
    led.Check state    OFF

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