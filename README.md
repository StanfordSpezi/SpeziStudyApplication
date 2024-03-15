<!--

This source file is part of the StudyApplication based on the Stanford Spezi Template Application project

SPDX-FileCopyrightText: 2023 Stanford University

SPDX-License-Identifier: MIT

-->

# Spezi Study Application

This repository contains the Spezi Study Application.

> [!NOTE]  
> Do you want to download the Spezi Study Application application? You can download it to your iOS device using [TestFlight](https://testflight.apple.com/join/wlseiMRR)!


## Build & Run The Spezi Study Application

The Spezi Study Application uses the [Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem and is based of the [Stanford Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).

Please refer to the [Build And Run a Spezi Template Application-based Application](https://spezi.health/SpeziTemplateApplication/documentation/templateapplication/setup) instructions and other documentation for the [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication) and [Stanford Spezi](https://github.com/StanfordSpezi/Spezi) to learn how to build and run the application using Xcode.


## Firebase Emulator-based Development & Testing

Similar to the [Stanford Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication), the Study Application uses Firebase to handle user authentication, data storage, and automation using cloud functions.

The [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) allows you to replicate a full cloud stack within your development environment.
To load in the development and testing data to test and build the application locally, you need to start the emulator using
```bash
$ firebase emulators:start --import=./firebase
```
at the root of the Spezi Study Application repository.

> [!NOTE]  
> Do you want to learn more about the Stanford Spezi Template Application and how to use, extend, and modify this application? Check out the [Stanford Spezi Template Application documentation](https://stanfordspezi.github.io/SpeziTemplateApplication)


## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterLight.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterDark.png#gh-dark-mode-only)
