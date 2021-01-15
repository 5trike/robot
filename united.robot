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
${BUTTON_PUSHER}=   'servo'
${blockport}=   0

*** Test Cases ***
TC1
    [Documentation]    Provisioning and register appliance
    ...                Expected result: Appliance  provisioning (check appliance connectivity state), WiFi led ON
    [Tags]    Provisioning    Critical
    Onboarding   NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Register
    techapp.Wait until element   com.electrolux.ecp.client.sdk.app.selector:id/appliance_connectivity
    Deregister
    
TC2
    [Documentation]    Onboarding with wrong password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW002
    [Tags]    Provisioning    Critical
    Onboarding     NETGEAR09   WRONG_PASSWORD
    techapp.Check error    Error ECPW002

TC3
    [Documentation]    Onboarding with short password
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW008
    Onboarding     NETGEAR09   SHORT
    techapp.Check error    Error ECPW008

TC3
    [Documentation]    Provisioning and register appliance with no internet
    ...                Expected result: Appliance  not provisioning, WiFi led OFF, 
    [Tags]    Provisioning    Critical
    Set Test Variable   ${blockport}    65535
    router.block port   ${blockport}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW108

TC4
    [Documentation]    Provisioning when port 443 is blocked
    ...                Expected result: Appliance not provisioning, WiFi led OFF, Error ECPW103
    [Tags]    Provisioning    Critical
    Set Test Variable   ${blockport}   443
    router.block port   ${blockport}
    Onboarding     NETGEAR09   bluephoenix200
    techapp.Enrolling
    techapp.Check error    Error ECPW103

TC5
    [Documentation]    Onboarding with DHCP server is off
    ...                Expected result: Appliance  not provisioning, WiFi led OFF (after 30 sec max), Error ECPW005

    Onboarding   NETGEAR09   bluephoenix200
    techapp.Check error    Error ECPW005

#Special characters
#    Onboarding with buttons   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?
#    techapp.Enrolling
#    techapp.Register
#    #Sleep  60s
#
    
#
#Wrong Network entry 
#    Onboarding with buttons     NETGEAR09-5G   bluephoenix200   #It's not wrong network!!
#    techapp.Enrolling
#    techapp.Register
#    Sleep  60s
#

#



#
#Provisioning during power recycle
#    Onboarding with buttons   NETGEAR09   bluephoenix200
#    Sleep  380s
#
 
    
#Router
#    router.block port   0
#    router.block port   65535
#    router.block port   443
#    router.block port   0  

*** Keywords ***
Suite start
    Set Library Search Order  AppiumLibrary  SeleniumLibrary
    router.Start
    buttons.Start   

Suite end
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



