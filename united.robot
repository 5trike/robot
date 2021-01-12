*** Settings ***
Resource    router.robot
Resource    techapp.robot

Test Setup       techapp.Start Appium
Test Teardown    techapp.Close Appium

Suite Setup     Suite Start
Suite Teardown  techapp.Close techapp



*** Test Cases ***
Special characters
    techapp.Onboarding   \!@#$%^*()-=_+{}[]|~`:;,.<> ?   \!@#$%^*()-=_+{}[]|~`:;,.<> ?
    techapp.Enrolling
    techapp.Register
    #Sleep  60s

#Block port 443
#    router.block port   443
#    techapp.Onboarding     NETGEAR09   bluephoenix200
#    techapp.Enrolling
#    Sleep    180
#
#Wrong Network entry
#    techapp.Onboarding     NETGEAR09-5G   bluephoenix200
#    techapp.Enrolling
#    techapp.Register
#    Sleep  60s
#
#Short password
#    techapp.Onboarding     NETGEAR09   SHORT
#    Sleep    180
#
#Wrong password
#    techapp.Onboarding     NETGEAR09   WRONG_PASSWORD
#    Sleep    180
#
#No Internet
#    router.block port   65535
#    techapp.Onboarding     NETGEAR09   bluephoenix200
#    techapp.Enrolling
#    Sleep    180
#    #com.electrolux.ecp.client.sdk.app.selector:id/md_title
#    #com.electrolux.ecp.client.sdk.app.selector:id/md_content
#    #com.electrolux.ecp.client.sdk.app.selector:id/md_buttonDefaultPositive
#Full Provisioning
#    techapp.Onboarding   NETGEAR09   bluephoenix200
#    techapp.Enrolling
#    techapp.Register
#    #Sleep  60s
    
#Router
#    router.block port   0
#    router.block port   65535
#    router.block port   443
#    router.block port   0  

*** Keywords ***
Suite Start
    router.block port   0   
    techapp.Open techapp 