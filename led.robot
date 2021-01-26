*** Settings ***
Library  ConsoleDialogs

*** Keywords ***
Check state
    [Arguments]   ${state}
    ${led}     Get Selection From User     Select WI-Fi LED state   ON   BLINKING   OFF
    ${led}=   Set Variable If    '${led}'=='0'   ON    ${led}
    ${led}=   Set Variable If    '${led}'=='1'   BLINKING    ${led}
    ${led}=   Set Variable If    '${led}'=='2'   OFF    ${led}
    Should Be Equal    '${led}'    '${state}'