*** Settings ***
Library     ConsoleDialogs
Library    Collections
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
&{DICT}    state=unk
${ROUTERAPNAME}    NETGEAR09
${ROUTERAPPWD}    bluephoenix200
${EVENT}    
${EVENTMODE}    0201004800
${SN}    61604241
@{DAYS}    Sunday    Monday    Tuesday    Wednesday    Thursday    Friday    Saturday

*** Keywords ***
Suite start
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    #${isResetneed}     Get Selection From User     Need factory reset   YES   NO
    #router.Start
    #buttons.Release all
    #plug.On
    #techapp.Start
    #Run keyword if     '${isResetneed}'=='YES'    Reset and delink
    
Suite end
    #router.End
    No operation

Test start
    #router.Start
    techapp.Start
    
Test end
    #Run Keyword if  '${BLOCKPORT}'!='0'    router.Block port   0 
    techapp.End
    #router.End

Factory Reset
    buttons.Press   2   11
    Sleep    5s

Start Broadcasting
    buttons.Press   2   6 

Onboarding
    [Arguments]    ${apname}=${ROUTERAPNAME}   ${appass}=${ROUTERAPPWD}
    Start broadcasting  
    techapp.Onboarding     ${apname}     ${appass}

Reset and delink
    Factory reset
    techapp.Delink
    Sleep    5s

Provisioning
    Onboarding
    techapp.Enrolling
    techapp.Register
    techapp.Check appliance state

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
TC-777
    #techapp.Choose appliance
    #techapp.Find parameter   noPrnt.SchedulerEventFriday
    techapp.RadioBtn    noPrnt.ClearSchedule    3 (All)
    FOR    ${i}    IN RANGE    0    3
        #Exit For Loop If    ${i} == 9
        ${ii}    Evaluate    ${i}*2+1
        #Log to console    ${i}
        ${tmp}    techapp.Get event    ${ii}    1
        #Log to console    ${tmp}
        Set global variable    ${EVENT}    ${EVENT}${tmp}
    END
    ${EVENTonce}    techapp.Get event      2    2    05    05
    #techapp.Set event    Once    ${EVENTonce}
    Log to console    ${EVENT}
    FOR     ${day}    IN     @{DAYS}
        Log to console    ${day}
        techapp.Set event    ${day}    ${EVENT}
    END
    #techapp.Set event    Once    ${EVENTonce}
 
*** Comments ***
TC-100
    [Documentation]    Factory reset, provisioning and register appliance
    ...                Expected result: Appliance  provisioning, WiFi led ON
    [Tags]    Provisioning
    Factory Reset
    techapp.Choose appliance    #Provisioning    
    techapp.Fill dictionary
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
    techapp.RadioBtn    noPrnt.ExecuteCommand    1 (On)
    Sleep    3s
    techapp.RadioBtn    noPrnt.ExecuteCommand    0 (Off)

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
    Onboarding    
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
    Onboarding    
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
    Onboarding  
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    OFF

TC-108
    [Documentation]    Powercycle in 10 sec after starting enrolling process
    ...                Expected result: Appliance provisioning, WiFi led ON
    [Tags]    Enrolling    
    Onboarding   
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
    Onboarding  
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