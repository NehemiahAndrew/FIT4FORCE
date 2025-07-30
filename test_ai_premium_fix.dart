import 'lib/core/services/ai_premium_access_service.dart';
import 'lib/core/services/premium_service.dart';
import 'lib/shared/models/user_model.dart';

/// Test script to verify AI premium access fix
void main() async {
  print('🧪 Testing AI Premium Access Fix');
  print('================================\n');

  // Create test users
  final premiumUser = UserModel(
    id: 'premium-user-123',
    email: 'premium@test.com',
    fullName: 'Premium Test User',
    targetAgency: 'Nigerian Army',
    isPremium: true,
    isTestUser: false,
    premiumExpiryDate: DateTime.now().add(Duration(days: 30)),
    createdAt: DateTime.now(),
  );

  final testUser = UserModel(
    id: 'test-user-123',
    email: 'test@test.com',
    fullName: 'Test User',
    targetAgency: 'Nigerian Army',
    isPremium: false,
    isTestUser: true,
    premiumExpiryDate: null,
    createdAt: DateTime.now(),
  );

  final freeUser = UserModel(
    id: 'free-user-123',
    email: 'free@test.com',
    fullName: 'Free User',
    targetAgency: 'Nigerian Army',
    isPremium: false,
    isTestUser: false,
    premiumExpiryDate: null,
    createdAt: DateTime.now(),
  );

  // Test services
  final aiAccessService = AIPremiumAccessService();
  final premiumService = PremiumService();

  print('🔍 Testing Premium User:');
  print('------------------------');
  final premiumHasAI = await aiAccessService.hasAIAccess(premiumUser);
  final premiumHasGeneral = premiumService.hasAccessToPremiumFeatures(premiumUser);
  print('AI Access: $premiumHasAI');
  print('General Premium Access: $premiumHasGeneral');
  print('Consistent: ${premiumHasAI == premiumHasGeneral}');
  print('');

  print('🔍 Testing Test User:');
  print('---------------------');
  final testHasAI = await aiAccessService.hasAIAccess(testUser);
  final testHasGeneral = premiumService.hasAccessToPremiumFeatures(testUser);
  print('AI Access: $testHasAI');
  print('General Premium Access: $testHasGeneral');
  print('Consistent: ${testHasAI == testHasGeneral}');
  print('');

  print('🔍 Testing Free User:');
  print('---------------------');
  final freeHasAI = await aiAccessService.hasAIAccess(freeUser);
  final freeHasGeneral = premiumService.hasAccessToPremiumFeatures(freeUser);
  print('AI Access: $freeHasAI');
  print('General Premium Access: $freeHasGeneral');
  print('Consistent: ${freeHasAI == freeHasGeneral}');
  print('');

  // Test AI usage limits
  print('🔍 Testing AI Usage Limits:');
  print('---------------------------');
  final premiumLimits = aiAccessService.getAIUsageLimits(premiumUser);
  final testLimits = aiAccessService.getAIUsageLimits(testUser);
  final freeLimits = aiAccessService.getAIUsageLimits(freeUser);

  print('Premium User Limits: ${premiumLimits['daily_queries']} daily queries');
  print('Test User Limits: ${testLimits['daily_queries']} daily queries');
  print('Free User Limits: ${freeLimits['daily_queries']} daily queries');
  print('');

  // Summary
  final allConsistent = (premiumHasAI == premiumHasGeneral) &&
                       (testHasAI == testHasGeneral) &&
                       (freeHasAI == freeHasGeneral);

  if (allConsistent) {
    print('✅ SUCCESS: AI premium access is now consistent with general premium access!');
    print('🎉 The bug has been fixed - AI features will unlock properly for premium users.');
  } else {
    print('❌ FAILURE: AI premium access is still inconsistent.');
    print('🔧 Further investigation needed.');
  }
}
