class AIService {
  Future<Map<String, dynamic>> analyzeFace() async {
    // Şimdilik sahte analiz yapıyoruz.
    await Future.delayed(const Duration(seconds: 3));

    return {
      "skinTone": "Açık Buğday",
      "undertone": "Sıcak",
      "skinType": "Karma",
      "faceShape": "Oval",
      "eyeColor": "Ela",
      "hairColor": "Koyu Kahverengi",

      "foundation": {
        "brand": "Maybelline",
        "product": "Fit Me Matte",
        "code": "220 Natural Beige",
      },

      "concealer": {
        "brand": "Maybelline",
        "product": "Fit Me Concealer",
        "code": "20 Sand",
      },

      "blush": {
        "brand": "Rare Beauty",
        "product": "Soft Pinch",
        "code": "Joy",
      },

      "lipstick": {
        "brand": "MAC",
        "product": "Matte Lipstick",
        "code": "Velvet Teddy",
      },
    };
  }
}