import 'package:get/get.dart';

class SubscriptionPlanController extends GetxController {
  var isYearly = false.obs;

  final List<Map<String, dynamic>> _monthlyPlans = [
    {
      'title': 'Starter',
      'subtitle': 'For New Authors',
      'price': '\$9/m',
      'features': [
        '25 Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': false,
    },
    {
      'title': 'Pro',
      'subtitle': 'Most Popular',
      'price': '\$24/m',
      'features': [
        '100 Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': true,
    },
    {
      'title': 'Premium',
      'subtitle': 'Best for Book Organizations',
      'price': '\$49/m',
      'features': [
        'Unlimited Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': false,
    },
  ];

  final List<Map<String, dynamic>> _yearlyPlans = [
    {
      'title': 'Starter',
      'subtitle': 'For New Authors',
      'price': '\$99/yr',
      'features': [
        '25 Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': false,
    },
    {
      'title': 'Pro',
      'subtitle': 'Most Popular',
      'price': '\$249/yr',
      'features': [
        '100 Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': true,
    },
    {
      'title': 'Premium',
      'subtitle': 'Best for Book Organizations',
      'price': '\$499/yr',
      'features': [
        'Unlimited Signature per month',
        'Signed ebooks with message',
        'Approve and reject autograph request',
        'Manage Profile',
        'Email Support',
      ],
      'isMostPopular': false,
    },
  ];

  List<Map<String, dynamic>> get plans =>
      isYearly.value ? _yearlyPlans : _monthlyPlans;

  void setYearly(bool value) {
    isYearly.value = value;
  }
}
