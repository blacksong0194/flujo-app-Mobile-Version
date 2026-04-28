// accounts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/finance_provider.dart';
import '../../services/theme.dart';
import '../../widgets/common/widgets.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);
    final liquid = state.accounts.where((a) => a.type != 'deuda' && a.type != 'prestamo').toList();
    final debts  = state.accounts.where((a) => a.type == 'deuda' || a.type == 'prestamo').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cuentas')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Cuentas: ${liquid.length} activas',
          style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: MetricCard(label: 'Liquido', value: fmtCompact(state.totalLiquid), accent: kBrand, icon: Icons.account_balance_wallet_rounded)),
          const SizedBox(width: 10),
          Expanded(child: MetricCard(label: 'Deudas', value: fmtCompact(state.totalDebt), accent: kRed, icon: Icons.warning_amber_rounded)),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Cuentas activas'),
        if (liquid.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('Sin cuentas activas', style: TextStyle(color: Color(0xFF4A6B8A)))),
          )
        else
          ...liquid.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FCard(
              borderTop: hexColor(a.color),
              child: Row(children: [
                Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: hexColor(a.color).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.account_balance_rounded, color: hexColor(a.color), size: 18)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0))),
                  Text(a.type, style: const TextStyle(fontSize: 11, color: Color(0xFF4A6B8A))),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(fmtCompact(a.balance), style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: a.balance >= 0 ? const Color(0xFFE2E8F0) : const Color(0xFFEF4444))),
                ]),
              ]),
            ),
          )),
        if (debts.isNotEmpty) ...[
          const SizedBox(height: 10),
          const SectionHeader(title: 'Deudas y Obligaciones'),
          ...debts.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FCard(
              borderTop: const Color(0xFFEF4444),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(a.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)))),
                Text(fmtCompact(a.balance), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
              ]),
            ),
          )),
        ],
      ]),
    );
  }
}
