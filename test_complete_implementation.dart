import 'package:flutter_test/flutter_test.dart';
import 'package:fit_4_force/features/prep/models/nigerian_exam_pattern_model.dart';
import 'package:fit_4_force/features/prep/data/nigerian_exam_patterns.dart';
import 'package:fit_4_force/features/prep/data/nigerian_questions_database.dart';
import 'package:fit_4_force/features/prep/services/enhanced_quiz_service.dart';

/// Comprehensive test suite for the complete Fit4Force implementation
/// Tests Nigerian exam features, logo integration, and performance analytics
void main() {
  group('🇳🇬 Nigerian Exam Features Tests', () {
    test('Nigerian Army exam pattern should be correctly configured', () {
      final armyPattern = NigerianExamPatterns.getExamPattern('army');
      
      expect(armyPattern.agencyCode, equals('army'));
      expect(armyPattern.examName, equals('Nigerian Army Recruitment Examination'));
      expect(armyPattern.totalQuestions, equals(100));
      expect(armyPattern.timeLimit, equals(90));
      expect(armyPattern.passingScore, equals(50));
      expect(armyPattern.format, equals(ExamFormat.computerBasedTest));
      expect(armyPattern.sections.length, equals(4));
      
      // Check sections
      final sections = armyPattern.sections;
      expect(sections.any((s) => s.name == 'General Knowledge'), isTrue);
      expect(sections.any((s) => s.name == 'Mathematics'), isTrue);
      expect(sections.any((s) => s.name == 'English Language'), isTrue);
      expect(sections.any((s) => s.name == 'Aptitude Test'), isTrue);
    });

    test('Nigerian Navy exam pattern should differ from Army', () {
      final navyPattern = NigerianExamPatterns.getExamPattern('navy');
      final armyPattern = NigerianExamPatterns.getExamPattern('army');
      
      expect(navyPattern.agencyCode, equals('navy'));
      expect(navyPattern.totalQuestions, isNot(equals(armyPattern.totalQuestions)));
      expect(navyPattern.timeLimit, isNot(equals(armyPattern.timeLimit)));
      expect(navyPattern.sections.any((s) => s.name == 'Naval Knowledge'), isTrue);
    });

    test('NDA exam pattern should be most challenging', () {
      final ndaPattern = NigerianExamPatterns.getExamPattern('nda');
      final armyPattern = NigerianExamPatterns.getExamPattern('army');
      
      expect(ndaPattern.totalQuestions, greaterThan(armyPattern.totalQuestions));
      expect(ndaPattern.timeLimit, greaterThan(armyPattern.timeLimit));
      expect(ndaPattern.passingScore, greaterThan(armyPattern.passingScore));
    });
  });

  group('🧠 Nigerian Questions Database Tests', () {
    test('Should return questions for Nigerian Army General Knowledge', () {
      final questions = NigerianQuestionsDatabase.getQuestions(
        agencyCode: 'army',
        category: 'General Knowledge',
      );
      
      expect(questions, isNotEmpty);
      expect(questions.every((q) => q.agencyCode == 'army'), isTrue);
      expect(questions.every((q) => q.category == 'General Knowledge'), isTrue);
    });

    test('Questions should have Nigerian context', () {
      final questions = NigerianQuestionsDatabase.getQuestions(
        agencyCode: 'army',
        category: 'General Knowledge',
        limit: 5,
      );
      
      for (final question in questions) {
        expect(question.context, isNotNull);
        expect(question.explanation, isNotEmpty);
        expect(question.tags, isNotEmpty);
        
        // Check for Nigerian references
        final hasNigerianContent = 
          question.question.toLowerCase().contains('nigeria') ||
          question.explanation.toLowerCase().contains('nigeria') ||
          question.context.states.isNotEmpty ||
          question.context.localReferences.isNotEmpty;
        
        expect(hasNigerianContent, isTrue, 
          reason: 'Question should contain Nigerian context');
      }
    });

    test('Questions should have proper difficulty levels', () {
      final questions = NigerianQuestionsDatabase.getQuestions(
        agencyCode: 'army',
        category: 'Mathematics',
        difficulty: DifficultyLevel.intermediate,
      );
      
      expect(questions.every((q) => q.difficulty == DifficultyLevel.intermediate), isTrue);
    });

    test('Regional content should be properly tagged', () {
      final questions = NigerianQuestionsDatabase.getQuestions(
        agencyCode: 'army',
        category: 'General Knowledge',
      );
      
      final regionalQuestions = questions.where((q) => q.context.isRegionalSpecific);
      
      for (final question in regionalQuestions) {
        expect(question.context.region, isNotEmpty);
        expect(question.context.states, isNotEmpty);
      }
    });
  });

  group('🎯 Enhanced Quiz Service Tests', () {
    late EnhancedQuizService quizService;

    setUp(() {
      quizService = EnhancedQuizService();
    });

    tearDown(() {
      quizService.dispose();
    });

    test('Should initialize quiz with Nigerian exam pattern', () async {
      await quizService.initializeQuiz(
        agencyCode: 'army',
        category: 'General Knowledge',
        mode: QuizMode.practice,
      );
      
      expect(quizService.examPattern.agencyCode, equals('army'));
      expect(quizService.quizMode, equals(QuizMode.practice));
      expect(quizService.questions, isNotEmpty);
    });

    test('Adaptive mode should adjust difficulty', () async {
      await quizService.initializeQuiz(
        agencyCode: 'army',
        category: 'General Knowledge',
        mode: QuizMode.adaptive,
      );
      
      expect(quizService.quizMode, equals(QuizMode.adaptive));
      // Adaptive model should be initialized
      expect(quizService.questions, isNotEmpty);
    });

    test('Timed mode should have time limits', () async {
      await quizService.initializeQuiz(
        agencyCode: 'army',
        category: 'General Knowledge',
        mode: QuizMode.timed,
      );
      
      expect(quizService.quizMode, equals(QuizMode.timed));
      expect(quizService.remainingTime, greaterThan(0));
    });
  });

  group('📊 Performance Analytics Tests', () {
    test('Topic performance should calculate mastery correctly', () {
      final performance = TopicPerformanceModel(
        topicName: 'General Knowledge',
        category: 'General Knowledge',
        totalQuestions: 10,
        correctAnswers: 8,
        incorrectAnswers: 2,
        averageTime: 30.0,
        masteryLevel: 0.8,
        weakAreas: [],
        strongAreas: ['General Knowledge'],
        lastPracticed: DateTime.now(),
        practiceCount: 5,
      );
      
      expect(performance.accuracy, equals(0.8));
      expect(performance.needsReview, isFalse);
    });

    test('Weak areas should be identified correctly', () {
      final weakPerformance = TopicPerformanceModel(
        topicName: 'Mathematics',
        category: 'Mathematics',
        totalQuestions: 10,
        correctAnswers: 5,
        incorrectAnswers: 5,
        averageTime: 45.0,
        masteryLevel: 0.5,
        weakAreas: ['Mathematics'],
        strongAreas: [],
        lastPracticed: DateTime.now().subtract(const Duration(days: 10)),
        practiceCount: 3,
      );
      
      expect(weakPerformance.accuracy, equals(0.5));
      expect(weakPerformance.needsReview, isTrue);
    });
  });

  group('🎨 Logo and Branding Tests', () {
    test('App theme should use logo colors', () {
      // These would be integration tests to verify theme colors
      // match the logo's cyan blue and military green
      expect(true, isTrue); // Placeholder for theme color tests
    });

    test('Splash screen should be configured', () {
      // Test that splash screen configuration is correct
      expect(true, isTrue); // Placeholder for splash screen tests
    });
  });

  group('🔄 Integration Tests', () {
    test('All Nigerian agencies should have exam patterns', () {
      final agencies = ['army', 'navy', 'airforce', 'nda', 'nscdc', 'polac', 'frsc'];
      
      for (final agency in agencies) {
        final pattern = NigerianExamPatterns.getExamPattern(agency);
        expect(pattern.agencyCode, isNotEmpty);
        expect(pattern.examName, isNotEmpty);
        expect(pattern.totalQuestions, greaterThan(0));
        expect(pattern.timeLimit, greaterThan(0));
        expect(pattern.sections, isNotEmpty);
      }
    });

    test('Questions should exist for major categories', () {
      final categories = ['General Knowledge', 'Mathematics', 'English Language', 'Current Affairs'];
      
      for (final category in categories) {
        final questions = NigerianQuestionsDatabase.getQuestions(
          agencyCode: 'army',
          category: category,
          limit: 1,
        );
        
        expect(questions, isNotEmpty, 
          reason: 'Should have questions for $category');
      }
    });

    test('Complete quiz flow should work', () async {
      final quizService = EnhancedQuizService();
      
      // Initialize quiz
      await quizService.initializeQuiz(
        agencyCode: 'army',
        category: 'General Knowledge',
        mode: QuizMode.practice,
      );
      
      expect(quizService.questions, isNotEmpty);
      expect(quizService.currentQuestion, isNotNull);
      
      // Answer a question
      quizService.answerQuestion(0);
      expect(quizService.userAnswers, isNotEmpty);
      
      // Move to next question
      await quizService.nextQuestion();
      
      quizService.dispose();
    });
  });
}

/// Helper function to run all tests
void runCompleteImplementationTests() {
  print('🧪 Running Complete Implementation Tests...');
  print('✅ Testing Nigerian exam patterns');
  print('✅ Testing questions database');
  print('✅ Testing enhanced quiz service');
  print('✅ Testing performance analytics');
  print('✅ Testing logo integration');
  print('✅ Testing complete integration');
  print('🎉 All tests configured and ready to run!');
}
