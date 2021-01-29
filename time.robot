*** Settings ***
Library    DateTime

*** Keywords ***
Hour Convert
    [Arguments]    ${hour}
    ${hourhex}    Convert to hex    ${hour}
    ${hourhex}    Convert to string     ${hourhex}
    ${hourhex}    Set variable    0${hourhex} 
    Return from keyword     ${hourhex}

Get event
    [Arguments]    ${startincrement}    ${duration}
    ${start} 	Get Current Date 	UTC    increment=00:${startincrement}:00    result_format=datetime    
    ${starthex}    Hour Convert    ${start.hour}
    ${stopincrement}    Evaluate    ${startincrement}+${duration}
    ${stop}    Get Current Date 	UTC    increment=00:${stopincrement}:00    result_format=datetime 
    ${stophex}    Hour Convert    ${stop.hour}
    ${event}    Set variable    \n${starthex}[:2]${start.minute}040201004800${stophex}[:2]${stop.minute}040201004800
    [Return]    ${event} 

*** Test Cases ***
T01
    ${event}    Get event    5    5
   Log to console    ${event} 


    