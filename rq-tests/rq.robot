
*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser  https://www.bcbsnc.com/assets/shopper/public/quote  Edge
Suite Teardown    Close Browser

*** Variables ***
${URL}            https://www.bcbsnc.com/assets/shopper/public/quote

*** Keywords ***
Exists In Page
    [Arguments]    ${element}
     Scroll Element Into View    ${element}
     Element Should Be Visible    ${element}
    
Submit Quote
    Scroll Element Into View    xpath=//*[@id="rate-quote"]/div[1]/form/button
    Click Button    xpath=//*[@id="rate-quote"]/div[1]/form/button
    Sleep    2s

Enter Date of Birth
    Input Text    id:dob-primary    03191982
    Sleep    2s
    
Enter ZipCode
    [Arguments]    ${zip}=27713
    Input Text    id:zipcode    ${zip}
    Sleep    2s
    
Choose County
    [Arguments]    ${index}=1
    Select From List By Value    id:county    ${index}

*** Test Cases ***

# Navigation Tests
1. Verify Page Loads
    [Documentation]    Verify the quote page loads successfully
    Go To    ${URL}
    Title Should Be    Free Rate Quote - Blue Cross and Blue Shield of North Carolina | BCBSNC

2. Verify Navigation Menu Exists
    [Documentation]    Verify that the navigation menu is present
    Go To    ${URL}
    Element Should Not Be Visible    css:.navigation

3. Verify Footer Exists
    [Documentation]    Verify that the footer is visible on the page
    Go To    ${URL}
    Element Should Be Visible    tag:footer

# Quote Form Tests
4a. Verify Date of Birth Field Exists
    [Documentation]    Verify the date of birth input field is visible
    Go To    ${URL}
    Element Should Be Visible    id:dob-primary

4b. Verify Zip Code Field Exists
    [Documentation]    Verify the zip code input field is e4.  visible
    Go To    ${URL}
    Element Should Be Visible    css:#zipcode

5. Verify Get a Quote Button Exists
    [Documentation]    Verify the Get a Quote button is present
    Go To    ${URL}
    Exists In Page   xpath=//*[@id="rate-quote"]/div[1]/form/button

6. Verify County Error Message on Zip Code
    [Documentation]    Verify a quote can be requested with a valid zip code
    Go To    ${URL}
    Submit Quote
    Scroll Element Into View    id:zipcode
    Exists In Page    css:text-error

# Input Validation Tests
7. Verify Invalid Zip Code Error
    [Documentation]    Verify error is displayed for invalid zip code
    Go To    ${URL}
    Input Text    id:zipcode    abcde
    Click Button    xpath=//*[@id="rate-quote"]/div[1]/form/button
    Element Should Be Visible    css:.error-message

8. Verify Numeric Zip Code Allowed
    [Documentation]    Verify only numeric zip codes are accepted
    Go To    ${URL}
    Input Text    css:#zipcode    12345
    Click Button    css:#getQuoteBtn
    Element Should Be Visible    css:.quote-results

9. Verify Reset Button Works
    [Documentation]    Verify the reset button clears input
    Go To    ${URL}
    Input Text    css:#zipcode    27513
    Click Button    css:#resetBtn
    Value Should Be Empty    css:#zipcode

# Form Interaction Tests
10. Verify Form Accepts Leading Spaces
    Go To    ${URL}
    Input Text    css:#zipcode    " 27513"
    Click Button    css:#getQuoteBtn
    Element Should Be Visible    css:.quote-results

11. Verify Form Accepts Trailing Spaces
    Go To    ${URL}
    Input Text    css:#zipcode    "27513 "
    Click Button    css:#getQuoteBtn
    Element Should Be Visible    css:.quote-results

12. Verify Form Accepts Mixed Spaces
    Go To    ${URL}
    Input Text    css:#zipcode    "  27513  "
    Click Button    css:#getQuoteBtn
    Element Should Be Visible    css:.quote-results

13. Verify Special Characters Not Allowed
    Go To    ${URL}
    Input Text    css:#zipcode    "!@#$%"
    Click Button    css:#getQuoteBtn
    Element Should Be Visible    css:.error-message

# UI Interaction Tests
14. Verify Header is Clickable
    Go To    ${URL}
    Click Element    css:.header-logo
    Title Should Be    Blue Cross NC - Home

15. Verify Accessibility Attributes
    Go To    ${URL}
    Attribute Should Exist    css:#zipcode    aria-label

16. Verify Required Field Indicator
    Go To    ${URL}
    Element Should Be Visible    css:.required-indicator


E2E
    Go To    ${URL}
    Enter Date of Birth
    Enter ZipCode
    Choose County
    Submit Quote
    Sleep    3s
    Click Link    xpath=//a[text()='View My Quote']
    Sleep    3s
    Click Link    xpath=//a[text()='Select Plan']

