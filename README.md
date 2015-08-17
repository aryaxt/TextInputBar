# TextInputBar
A text input bar that is keyboard aware, and resizes its content based on the amount of text

![alt tag](https://raw.githubusercontent.com/aryaxt/TextInputBar/master/textInputBar.png)

Features:
- Text view automatically resizes based on content
- Allows setting max size for text view height
- If the outlet to the scrollView is set, the contentInset is automatically adjusted to ensure that the keyboard isn't cvering the content
- No need to write any setup code

Instruction
- Drag and drop a UIToolbar to IB (or init in code)
- Change its class to TextInputBar
- Pin toolbar to bottom layout guide
- Set the delegate to the viewController (Can be done both in code or IB)
- Set the scrollView outlet if you have one (Can be done both in code or IB)
- Set maximum size of textview (Can be done both in code or IB)
