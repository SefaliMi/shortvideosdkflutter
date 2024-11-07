class Customization {
  final String buyButtonText;
  final String addToCartText;
  final String frontColorBuyBtn;
  final String backgroundColorBuyBtn;

  Customization({
    required this.buyButtonText,
    required this.addToCartText,
    required this.frontColorBuyBtn,
    required this.backgroundColorBuyBtn,
  });

  factory Customization.fromJson(Map<String, dynamic> json) {
    return Customization(
      buyButtonText: json['buy_btn'],
      addToCartText: json['add_to_cart_btn'],
      frontColorBuyBtn: json['front_color_buy_btn'],
      backgroundColorBuyBtn: json['bk_color_buy_btn'],
    );
  }
}
