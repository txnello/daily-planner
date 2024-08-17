# Daily Planner

## Introduction
I was watching a YouTube video by a Swedish guy who was developing his own app to launch on the market. At one point, I noticed he was using **a notebook to jot down tasks** for the day:

![kalle-frame](https://github.com/user-attachments/assets/fb7485eb-6410-40a0-a7ac-fc20ba0ddfb3)


I thought it was strange that there wasn't an app that allowed you to take these kinds of notes, so I started looking.

The apps I tried could be grouped into two categories: **apps that require login** (and therefore force the user to create an account) and **apps that contain too many features** beyond what I was actually looking for: **being able to save tasks to complete during the day**.

## Overview
In terms of timing, this project lasted a total of **a few weeks**, from sketching an initial design on paper to publishing it on this site.

Being a personal project, there was no development team, **I personally took care of all phases of the project**.

## Implemented Idea
With the app, you can **set events** on any date in the future, but only view those to be completed on the current date and the following day. This is because some people (like me) prefer to plan the next day the evening before.

**Each task is notified at the time set in the task**, unless it has been marked as completed.

![daily-planner2](https://github.com/user-attachments/assets/4f0fabc0-d769-4b60-8282-bf01a5b980f2)
![daily-planner1](https://github.com/user-attachments/assets/28c7f770-54eb-428b-858c-2b81f0d339e8)

## SQLite
I didn't want to force the user to create a profile to use such a simple application, so I opted to use the smartphone's **local storage**.

This implies that if the user deletes the app, everything that has been saved is lost forever. I don't consider this a blocking problem since **the app was designed to organize a single day**, not as a personal calendar or as a history of tasks completed by a user.

To do this, **SharedPreferences** are usually used, but I didn't want to have to cycle and save all the data every time. For this reason, I opted for an alternative that allows you to **simulate an SQLite database that can be queried directly from the app's code**.

[SQFLITE](https://pub.dev/packages/sqflite)

## Notifications
For notifications, I used the **flutter_local_notifications** package which allows you to **set scheduled notifications** for a certain day at a certain time.
So I just had to set that, when creating the task, this schedule was also created that would show the notification correctly.

[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

## Conclusions
Learning how to best use a phone's internal memory and how to launch notifications without using external services like Firebase or OneSignal **has been very educational and I will keep it in mind**.

[Download it from GitHub!](https://github.com/txnello/daily-planner/raw/main/apk-daily-planner.apk)
