# FIT4FORCE 🛡️📱

> **A Flutter-powered preparation platform for Nigerian military and paramilitary recruitment.**

FIT4FORCE brings **study preparation, physical fitness, progress tracking, community features, and AI-assisted learning** into one mobile experience for people preparing for security-service recruitment.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com/)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)

## 🎯 What it solves

Recruitment preparation is often fragmented across PDFs, social media posts, fitness routines, practice questions, and separate communities. FIT4FORCE brings those workflows together into a single product designed around a candidate's preparation journey.

### Core capabilities

- 📚 **Study preparation** — agency-specific learning materials and preparation content
- 🧠 **AI learning assistant** — personalized assistance for learning and revision
- 💪 **Fitness training** — structured workouts and exercise guidance
- 📈 **Progress tracking** — monitor study and fitness progress
- ⏱️ **Pomodoro focus sessions** — structured study time with breaks
- 🏆 **Achievements** — milestones that encourage consistent preparation
- 👥 **Community** — discussion and peer-support features
- 💳 **Premium experience** — subscription-backed advanced functionality

## 🏛️ Recruitment areas

The product is designed around preparation for organizations including the Nigerian Army, Navy, Air Force, NDA, DSSC/SSC, Police Academy, Fire Service, NSCDC, Customs, Immigration and FRSC.

> **Important:** FIT4FORCE is an independent preparation product. It is not an official government recruitment portal or government agency.

## 🏗️ Architecture

The application follows a feature-oriented Flutter structure intended to keep product areas isolated and maintainable:

```text
lib/
├── core/
│   ├── config/
│   ├── services/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   ├── home/
│   ├── prep/
│   ├── fitness/
│   ├── community/
│   └── ai/
└── shared/
    ├── models/
    ├── services/
    └── widgets/
```

### Technology

| Layer | Technology |
|---|---|
| Mobile | Flutter / Dart |
| Backend | Supabase |
| Authentication & data | Supabase services |
| AI | LLM/API integrations |
| Local/mobile capabilities | Flutter plugins & native Android tooling |
| Version control | Git / GitHub |

## 🔐 Security & configuration

**Never commit secrets to this repository.** API keys, service-role credentials, payment secrets and other environment-specific values should be supplied through secure configuration mechanisms.

The Supabase project URL may be public in a client application, but **privileged service-role keys must never be embedded in a Flutter client or README**.

For local development, use environment/build configuration appropriate to your deployment pipeline and keep secret values outside source control.

## 🚀 Getting started

### Prerequisites

- Flutter SDK 3.24+
- Dart SDK 3.5+
- Android Studio / Android SDK
- Git
- A Supabase project for backend services

### Install

```bash
git clone https://github.com/NehemiahAndrew/FIT4FORCE.git
cd FIT4FORCE
flutter pub get
```

Configure the application using your local environment/build configuration, then run:

```bash
flutter run
```

### Test

```bash
flutter test
```

For integration tests, when available:

```bash
flutter test integration_test/
```

### Release build

```bash
flutter build appbundle --release
```

## 📦 Content organization

FIT4FORCE uses structured content categories for recruitment preparation and fitness material. Keep large media files optimized and avoid committing secrets or unnecessary generated build output.

Example:

```text
assets/
├── images/
│   ├── exercises/
│   └── icons/
└── content/
    ├── nigerian_army/
    ├── navy/
    ├── air_force/
    ├── nda/
    ├── dssc/
    ├── polac/
    ├── fire_service/
    ├── nscdc/
    ├── customs/
    ├── immigration/
    └── frsc/
```

## 🧭 Engineering principles

- **Product first:** build around real user workflows.
- **Security by design:** keep credentials and privileged operations out of the client.
- **Maintainability:** organize features and shared infrastructure clearly.
- **Testability:** make important behavior verifiable.
- **Observability:** make failures diagnosable instead of silent.
- **Accessibility and UX:** technical complexity should stay behind a simple user experience.

## 🗺️ Roadmap

- [ ] Expand automated test coverage
- [ ] Improve offline-first study workflows
- [ ] Expand analytics and progress insights
- [ ] Strengthen CI/CD quality gates
- [ ] Continue improving AI-assisted learning
- [ ] Improve documentation and contributor onboarding

## 👨‍💻 Author

**Nehemiah Andrew**  
Software Engineer • Cybersecurity • AI • Flutter

[GitHub](https://github.com/NehemiahAndrew)

---

**Build. Train. Learn. Prepare.**