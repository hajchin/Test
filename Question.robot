*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${BROWSER}        Chrome
${PRODUCT_NAME}   iPhone 13

*** Test Cases ***
Search and Combine E-Commerce Results
    Open Lazada Website
    Search for Product    ${PRODUCT_NAME}
    Validate Search Results    Lazada
    ${results_lazada}    Get Lazada Search Results

    Open Shopee Website
    Search for Product    ${PRODUCT_NAME}
    Validate Search Results    Shopee
    ${results_shopee}    Get Shopee Search Results

    Combine and Display Results    ${results_lazada}    ${results_shopee}

*** Keywords ***
Open Lazada Website
    Open Browser    https://www.lazada.com/    ${BROWSER}
    Maximize Browser Window

Open Shopee Website
    Open Browser    https://shopee.com/    ${BROWSER}
    Maximize Browser Window

Search for Product
    [Arguments]    ${product_name}
    Input Text    //*[@id="q"]    ${product_name}
    Click Button    //button[contains(text(),'Search')]

Validate Search Results
    [Arguments]    ${website}
    Wait Until Page Contains Element    //*[@class="c2prKC"]
    ${results}    Get Element Count    //*[@class="c2prKC"]
    Should Be Greater Than    ${results}    0    There are no search results on ${website}

Get Lazada Search Results
    ${results}    Get WebElements    //*[@class="c2prKC"]
    @{output}    Create List
    :FOR    ${result}    IN    @{results}
    \    ${name}    Get Text    ${result.find_element_by_class_name('c16H9d')}
    \    ${price}   Get Text    ${result.find_element_by_class_name('c13VH6')}
    \    ${link}    Get Element Attribute    ${result.find_element_by_class_name('c16H9d')}    href
    \    Append To List    ${output}    [ Lazada, ${name}, ${price}, ${link} ]
    [Return]    ${output}

Get Shopee Search Results
    ${results}    Get WebElements    //*[@class="c2iYAv"]
    @{output}    Create List
    :FOR    ${result}    IN    @{results}
    \    ${name}    Get Text    ${result.find_element_by_class_name('O6wiAW')}
    \    ${price}   Get Text    ${result.find_element_by_class_name('WTFwws')}
    \    ${link}    Get Element Attribute    ${result.find_element_by_class_name('O6wiAW')}    href
    \    Append To List    ${output}    [ Shopee, ${name}, ${price}, ${link} ]
    [Return]    ${output}

Combine and Display Results
    [Arguments]    ${results_lazada}    ${results_shopee}
    ${combined_results}    Extend Lists    ${results_lazada}    ${results_shopee}
    Sort List By Column    ${combined_results}    2    # Sort by price (assuming price is at index 2)
    Log Many    ${combined_results}
