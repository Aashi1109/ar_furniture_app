import 'package:flutter/material.dart';

const double kDefaultPadding = 20;
const kVerificationCodeTimeoutSeconds = 30;

// Notifications messages
const cartNotifications = {
  't1': {
    'title': 'Cart',
    'text': 'You have unordered items in cart',
  },
};

const orderNotifications = {
  't1': {
    'title': 'Orders',
    'text': 'Order placed Successfully',
  },
};

const authNotification = {
  't1': {
    'title': 'Profile',
    'text': 'User Profile Data Changed Successfully',
  }
};

const reviewNotification = {
  't1': {'title': 'Review', 'text': 'Added review for product'},
  't2': {
    'title': 'Review',
    'text': 'Edited review successfully',
  }
};

const primaryColor = Color(0xff030A4E);
const secondaryColor = Color(0xff44bde2);
const tertiaryColor = Color(0xfff3f3f3);
