*** Settings ***
Library     ConsoleDialogs
Library     BuiltIn
Resource    router.robot
Resource    techapp.robot
Resource    buttons.robot
Resource    techapp.robot
Resource    plug.robot
Resource    led.robot
Resource    parse.robot

Suite Setup     Suite start
Suite Teardown  Suite end  

Test Setup       Test start   
Test Teardown    Test end

*** Variables ***
${BROWSER}      firefox    #headlessfirefox         #firefox
${BUTTON_PUSHER}   'human'        #manual
${BLOCKPORT}   0
@{INFOS}    noPrnt.ApplianceState    noPrnt.DoorState   noPrnt.SensorTemperature[3]    #apname, model, pnc, serial, Link Quality, NIUX Firmware Version, NIUX SW ANC version

&{DICT}  name=value

*** Keywords ***
Suite start
    Sleep    0
    Set Global Variable    ${dict}    ()
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    router.Start
    buttons.Start   

Suite end
    Sleep    0 
    router.End

Test start
    Sleep     0
    buttons.Release all
    plug.On
    techapp.Start
    
Test end
    Sleep     0
    Run Keyword if  '${BLOCKPORT}'!='0'    router.block port   0 
    techapp.End

Onboarding
    [Arguments]   ${apname}   ${appass}
    buttons.Press   2   7  
    techapp.Onboarding     ${apname}     ${appass}

Deregister
    techapp.Choose appliance
    techapp.Deregister
    buttons.Press    2    11

*** Comments ***
#*** Test Cases ***
TC-100
    [Documentation]    Provisioning and register appliance
    ...                Expected result: Appliance  provisioning, WiFi led ON
    [Tags]    Provisioning
    Onboarding   NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Register
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    led.Check state    ON
    Deregister

TC-109
    [Documentation]    Provisioning and register appliance using AP with special characters
    ...                Expected result: Appliance  provisioning (check appliance connectivity state), WiFi led ON
    [Tags]    Provisioning    
    Onboarding   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?
    techapp.Enrolling
    techapp.Register
    techapp.Wait until element   com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity

TC-200
    [Documentation]    Check appliance communicate with the cloud
    ...                Expected result: Appliance  communicate with the cloud, WiFi led ON
    [Tags]    Operate    
    techapp.Choose appliance
    #buttons.Press    1    0
    techapp.Find parameter   noPrnt.ExecuteCommand
    techapp.eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    techapp.eclick    //*[contains(@text,"1 (ON)")]
    techapp.eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    Sleep  5s
    techapp.Find parameter   noPrnt.ExecuteCommand
    techapp.eclick    //*[contains(@text,"noPrnt.ExecuteCommand")]
    techapp.eclick    //*[contains(@text,"0 (OFF)")]
    techapp.eclick    com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
    techapp.eclick  //android.widget.ImageButton[@content-desc="Navigate up"]  


TC-101
    [Documentation]    Check offboarding
    ...                Expected result: Appliance offboarding, WiFi led OFF
    [Tags]    Provisioning    
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    Deregister
    led.Check state    OFF

TC-121
    [Documentation]    Onboarding with wrong password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW002
    [Tags]    Onboarding    
    Onboarding     NETGEAR09   WRONG_PASSWORD
    techapp.Check error    Error ECPW002
    led.Check state    OFF


TC-102
    [Documentation]    Onboarding with short password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW008
    [Tags]    Onboarding    
    Onboarding     NETGEAR09   SHORT
    techapp.Check error    Error ECPW008
    led.Check state    OFF

TC-105
    [Documentation]    Enrolling when port 443 is blocked
    ...                Expected result: Appliance not provisioning, WiFi led OFF, Error ECPW103
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}   443
    router.block port   ${BLOCKPORT}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW103
    buttons.Press   2   11
    led.Check state   OFF

TC-103
    [Documentation]    Enrolling appliance with no internet
    ...                Expected result: Appliance  not provisioning, WiFi led OFF, 
    [Tags]    Enrolling    
    Set Test Variable   ${BLOCKPORT}    65535
    router.block port   ${BLOCKPORT}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW108
    buttons.Press   2   11
    led.Check state    OFF    

*** Test Cases ***
prsxml
    parse.Source    Source here 
    FOR  ${info}    IN     @{INFOS}
    Log to console    ${info} : ${dict}[${info}]
    #Log to console  ${interesting} ${dict}
    #Try    ${xml}
    END

*** Comments ***
TC-106
    [Documentation]    Powercycle during onboarding before enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    buttons.Press   2   7  
    techapp.Onboarding choose AP   NETGEAR09
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    OFF

TC-107
    [Documentation]    Powercycle during onboarding after enter Wifi credentials
    ...                Expected result: Appliance  not provisioning, AP turn off, WiFi led OFF
    [Tags]    Onboarding    
    Onboarding   NETGEAR09   bluephoenix200
    plug.Off
    Sleep    5s
    plug.On
    led.Check state    OFF

TC-108
    [Documentation]    Powercycle in 10 sec after starting enrolling process
    ...                Expected result: Appliance provisioning, WiFi led ON
    [Tags]    Enrolling    
    Onboarding   NETGEAR09   bluephoenix200
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
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    led.Check state    ON

TC-201
    [Documentation]    Powercycle for 10 min registered appliance adn router
    ...                Expected result: Appliance automatically reconnect, WiFi led ON
    [Tags]    Operate    
    plug.Off
    Log to console     Wait for 10 min
    Sleep  10m
    plug.On
    techapp.Check element    com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    led.Check state   ON

TC-104
    [Documentation]    Onboarding with DHCP server is off
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW005
    [Tags]    Onboarding    
    router.Turn off DHCP server
    Sleep    10s
    Onboarding   NETGEAR09   bluephoenix200
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