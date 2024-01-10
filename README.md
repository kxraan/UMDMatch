# umd_match

## The Holy Grail for Single Terps

# Current problems: 

## Problem 1
It was ineeficient to itterate over the user database againand again to find matches and options 

## Solution 1
Created multiple documents to store ids so that we could directly refrence. 
For eg: if the gender prefrence was women, instead of going through all the users and checking if they are female, I made a new doc containing ids of all females and thus becoming easier to refrence it from the main user db

## Problem 2
Getting the features to based on which the matching algorithm will be based

## Problem 3
The app istructure is kind of weird and vague. Need to organize it better for effeciency. It's taking seconds to load a page and show the options.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
