*** Settings ***
Library  SeleniumLibrary
Library  ConsoleDialogs

#Suite Setup  Start

*** Variables ***
${URL_BUTTONS}          http://192.168.1.2/
#${BUTTON_PUSHER}=    'servo'  #'servo' commented rows for the self test
#${BROWSER}=    firefox
#${btnAction}=    'unk'

*** Keywords ***
Start
#    SeleniumLibrary.Open Browser    ${URL_BUTTONS}  	${BROWSER} 
    Sleep  0s

Press
    [Arguments]   ${btnnum}    ${holdsec}=0
    ${btnAction}=    Set Variable  button_${btnnum}_press
    ${holdcorrect}=    Evaluate   ${holdsec}-1   #need 1 sec for operate browser
    ${holdsec}=   Set Variable If    ${BUTTON_PUSHER}=='servo'    ${holdcorrect}    ${holdsec}
    Perform button    ${btnAction}    ${holdsec}
    Sleep    ${holdsec}
    Release   ${btnnum}
    
Release
    [Arguments]   ${btnnum}
    ${btnAction}=    Set Variable  button_${btnnum}_release
    Perform button    ${btnAction}    

Release all
    Release   1
    Release   2
    Release   3

Perform button
    [Arguments]   ${btnAction}    ${holdsec}=0
    Run Keyword If    ${BUTTON_PUSHER}=='servo'    Use servo    ${btnAction}      ${holdsec}
    ...   ELSE    Use muscles   ${btnAction}    ${holdsec}

Use servo
    [Arguments]   ${btnAction}    ${holdsec}=0
    SeleniumLibrary.Go To    ${URL_BUTTONS}
    SeleniumLibrary.Click Element    ${btnAction}
    SeleniumLibrary.Click Element    ${btnAction}


Use muscles
    [Arguments]   ${btnAction}    ${holdsec}
    ConsoleDialogs.Pause Execution  message=Please perform **${btnAction}** and hold **${holdsec}** sec. Hit [Return] to continue.

#*** Test Cases ***
#Press btn1 for 6 sec
#    Press   1    6
#    Press   1    11
    
    