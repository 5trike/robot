*** Settings ***
Library  ConsoleDialogs

*** Keywords ***
Check state
    [Arguments]   ${ExLedState}    
    Run Keyword If    ${LED_WATCHER}=='auto'    Use auto    ${ExLedState}
    ...   ELSE    Use eyes   ${ExLedState}

    
Use auto    
    [Arguments]   ${ExLedState}
    ${AcLedState}    Set Variable    ${ExLedState}
    Should Be Equal    '${ExLedState}'    '${ExLedState}'

Use eyes
    [Arguments]   ${ExLedState} 
    ${AcLedState}     Get Selection From User     Select WI-Fi LED state   ON   BLINKING   OFF
    ${AcLedState}=   Set Variable If    '${AcLedState}'=='0'   ON    ${AcLedState}
    ${AcLedState}=   Set Variable If    '${AcLedState}'=='1'   BLINKING    ${AcLedState}
    ${AcLedState}=   Set Variable If    '${AcLedState}'=='2'   OFF    ${AcLedState}
    Should Be Equal    '${AcLedState}'    '${ExLedState}'
    