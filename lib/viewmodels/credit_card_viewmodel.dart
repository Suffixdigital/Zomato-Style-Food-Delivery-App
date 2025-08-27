import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/credit_card_model.dart';

class CreditCardViewModel {
  List<CreditCardModel> getCreditCards() {
    return [
      CreditCardModel(
        brand: "Master Card",
        last4Digits: " 7873",
        type: "mastercard",
        logoAsset: "assets/images/mastercard.png",
      ),
      CreditCardModel(
        brand: "Paypal",
        last4Digits: " 4672",
        type: "paypal",
        logoAsset: "assets/images/paypal.png",
      ),
      CreditCardModel(
        brand: "Apple Pay",
        last4Digits: " 4672",
        type: "applepay",
        logoAsset: "assets/images/applepay.png",
      ),
      CreditCardModel(
        brand: "Master Card",
        last4Digits: " 7873",
        type: "mastercard",
        logoAsset: "assets/images/mastercard.png",
      ),
      CreditCardModel(
        brand: "Paypal",
        last4Digits: " 4672",
        type: "paypal",
        logoAsset: "assets/images/paypal.png",
      ),
      CreditCardModel(
        brand: "Apple Pay",
        last4Digits: " 4672",
        type: "applepay",
        logoAsset: "assets/images/applepay.png",
      ),
    ];
  }
}

final creditCardViewModelProvider = Provider<CreditCardViewModel>((ref) {
  return CreditCardViewModel();
});

final creditCardListProvider = Provider<List<CreditCardModel>>((ref) {
  final vm = ref.watch(creditCardViewModelProvider);
  return vm.getCreditCards();
});
