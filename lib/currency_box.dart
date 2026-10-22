import 'package:flutter/material.dart';

const Map<String, String> currencies = {
  'RUB': 'Российский рубль',
  'USD': 'Доллар США',
  'EUR': 'Евро',
  'CNY': 'Китайский юань',
  'GBP': 'Фунт стерлингов',
  'JPY': 'Японская иена',
  'CHF': 'Швейцарский франк',
  'TRY': 'Турецкая лира',
  'AED': 'Дирхам ОАЭ',
  'VND': 'Вьетнамский донг',
  'THB': 'Тайский бат',
  'IDR': 'Индонезийская рупия',
  'KRW': 'Южнокорейская вона',
  'INR': 'Индийская рупия',
  'EGP': 'Египетский фунт',
  'KZT': 'Казахстанский тенге',
  'BYN': 'Белорусский рубль',
  'UAH': 'Украинская гривна',
  'UZS': 'Узбекский сум',
  'KGS': 'Киргизский сом',
  'AMD': 'Армянский драм',
  'GEL': 'Грузинский лари',
  'AZN': 'Азербайджанский манат',
  'PLN': 'Польский злотый',
  'CZK': 'Чешская крона',
  'CAD': 'Канадский доллар',
  'AUD': 'Австралийский доллар',
  'HKD': 'Гонконгский доллар',
  'SGD': 'Сингапурский доллар',
};

// выбор валюты
class CurrencyBox extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const CurrencyBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          menuMaxHeight: 400, // валют много, пусть листается
          dropdownColor: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(18),
          iconEnabledColor: Colors.orange,
          items: currencies.keys.map((c) {
            return DropdownMenuItem(
              value: c,
              child: Row(
                children: [
                  Text(
                    c,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currencies[c]!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (c) {
            if (c != null) {
              onChanged(c);
            }
          },
        ),
      ),
    );
  }
}