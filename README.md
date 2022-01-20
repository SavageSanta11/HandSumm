
# HandSumm

HandSumm is an application that lets you enter the URL of the image and gives a quick summary of the content. It makes use of 2 APIs - OCR API for Postman to retrieve text from the image and AYLIEN Text Analysis API to get a summary of the text. (Made for SigmaHacks 3)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/SavageSanta11/HandSumm.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

To run the project on your browser:
```
flutter run -d chrome
```
## Preview
![Home](https://github.com/SavageSanta11/HandSumm/blob/master/assets/home.png?raw=true)

![Enter URL](https://github.com/SavageSanta11/HandSumm/blob/master/assets/Enter%20URL.png?raw=true)

## Built with
* [Flutter](https://flutter.dev/docs) - The framework used
* [OCRSpace API](https://ocr.space/ocrapi) - The OCR API used to parse images and getting the extracted text results returned in a JSON format.
* [AYLIEN Text Analysis API](https://docs.aylien.com/textapi/#getting-started) - The API used to summarize the text extracted from the image.
