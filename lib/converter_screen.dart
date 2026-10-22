import 'package:flutter/material.dart';
import 'converter_state.dart';
import 'currency_box.dart';

const Color bg = Colors.black;
const Color btnColor = Color(0xFF333333);
const Color orange = Colors.orange;
const Color gray = Colors.grey;

class ConverterScreen extends StatefulWidget {
  final ConverterState st;
  const ConverterScreen({super.key, required this.st});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController amountCtrl = TextEditingController(text: '100');

  ConverterState get st => widget.st;

  @override
  void initState() {
    super.initState();
    st.addListener(update);
  }

  @override
  void dispose() {
    st.removeListener(update);
    amountCtrl.dispose();
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  void convert() {
    FocusScope.of(context).unfocus(); // прячем клавиатуру
    st.convert(amountCtrl.text);
  }

  void swap() {
    st.swap();
    if (st.status == Status.success) {
      convert();
    }
  }

  Widget label(String t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
      child: Text(t, style: const TextStyle(fontSize: 18, color: gray)),
    );
  }

  // загрузка / ошибка / результат
  Widget resultBlock() {
    if (st.status == Status.loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: orange)),
      );
    }
    if (st.status == Status.error) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                st.errMsg,
                style: const TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ],
        ),
      );
    }
    if (st.status == Status.success) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Результат', style: TextStyle(fontSize: 16, color: gray)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${st.fmt(st.res)} ${st.resTo}',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${st.fmt(st.amount)} ${st.resFrom} = ${st.fmt(st.res)} ${st.resTo}',
              style: const TextStyle(fontSize: 15, color: gray),
            ),
            Text(
              'Курс: 1 ${st.resFrom} = ${st.fmt(st.rate)} ${st.resTo}',
              style: const TextStyle(fontSize: 15, color: gray),
            ),
            if (st.time != null)
              Text(
                'Обновлён: ${st.timeStr(st.time!)}',
                style: const TextStyle(fontSize: 15, color: gray),
              ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget historyBlock() {
    if (st.history.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'История',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: st.clearHistory,
              child: const Text('Очистить', style: TextStyle(color: orange)),
            ),
          ],
        ),
        for (String h in st.history)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(h, style: const TextStyle(fontSize: 15, color: gray)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool loading = st.status == Status.loading;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Конвертер валют',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              label('Сумма'),
              TextField(
                controller: amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 24, color: Colors.white),
                cursorColor: orange,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: btnColor,
                  hintText: 'Введите сумму',
                  hintStyle: const TextStyle(color: gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => convert(),
              ),
              label('Из'),
              CurrencyBox(value: st.from, onChanged: st.setFrom),
              Center(
                child: IconButton(
                  onPressed: loading ? null : swap,
                  iconSize: 32,
                  color: orange,
                  icon: const Icon(Icons.swap_vert),
                ),
              ),
              CurrencyBox(value: st.to, onChanged: st.setTo),
              const SizedBox(height: 24),
              // кнопка как в калькуляторе
              SizedBox(
                height: 64,
                child: Material(
                  color: loading ? btnColor : orange,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: loading ? null : convert,
                    child: const Center(
                      child: Text(
                        'Конвертировать',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              resultBlock(),
              const SizedBox(height: 24),
              historyBlock(),
            ],
          ),
        ),
      ),
    );
  }
}
