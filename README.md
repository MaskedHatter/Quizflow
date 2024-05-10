# Quizflow (Work in progress)
This if a Flashcard app built with flutter

## Inspiration
This was my first real flutter progect after a ton of youtube videos. And a friend of mine (that i wanted to impress) was complaining about how Anki on ios was not free and I thought to myself, "Hey this will be easy". I had to do a lot of learning with new packages while grounding myself in what I was already familiar with.

## Packages Used
  provider
  flutter_screenutil
  googleapis
  google_sign_in
  firebase_auth
  firebase_core
  hive
  langchain
  langchain_openai
  pinecone
  archive
  sqflite
  file_picker
  path_provider
  animate_do

## Things I Learnt
1. Implementation of state management solutins and MVVM design pattern
2. Using Google API and Firebase for authentication and to access google drive as a cross device means of retrieving created flashcards
3. Implement of hive a NoSQL database to handle local storage of flashcards and their use with custom types
4. Used langchain and pinecone to generate questions from documents picked from the filesystem. I scrapped this feature because the questions created from this were to basic despite my best prompt enginerring attempts

## Interesting things
1. The anki algorithm is relatively complex for how simple the app looks
2. The anki export format .apkg is just a zip file with an sql database inside
3. This sql database is kind of messy and hard to read, Im not sure if that is on purpose
