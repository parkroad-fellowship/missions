import 'package:app/features/home/missions/cubit/get_mission_expense_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/widgets/add_token/add_token.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ExpensesViewHandset extends StatefulWidget {
  const ExpensesViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<ExpensesViewHandset> createState() => _ExpensesViewHandsetState();
}

class _ExpensesViewHandsetState extends State<ExpensesViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context
        .read<GetMissionExpenseCubit>()
        .getMissionExpense(missionUlid: missionUlid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetMissionExpenseCubit, GetMissionExpenseState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          empty: () => Center(
            child: Text(
              l10n.askMissionDeskToDisburseFunds,
              style: PRFText.theme().headlineSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFApp.theme().kPrimaryColorV2,
                  ),
            ),
          ),
          loaded: (missionExpense) {
            Logger().f(missionExpense.expenses);
            return RefreshIndicator(
              onRefresh: () => context
                  .read<GetMissionExpenseCubit>()
                  .getMissionExpense(missionUlid: missionUlid),
              child: CustomScrollView(
                slivers: [
                  // Start Navigation Bar
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          l10n.summary,
                          style: PRFText.theme().displayLarge?.copyWith(
                                color: PRFApp.theme().kPrimaryColorV2,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Spacer(),
                        BlocBuilder<GetMissionExpenseCubit,
                            GetMissionExpenseState>(
                          builder: (context, state) {
                            return IconButton(
                              icon: state.maybeWhen(
                                orElse: () => const Icon(Icons.refresh),
                                loading: () =>
                                    const CircularProgressIndicator(),
                                loaded: (_) => const Icon(Icons.refresh),
                              ),
                              onPressed: () => context
                                  .read<GetMissionExpenseCubit>()
                                  .getMissionExpense(missionUlid: missionUlid),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.mail),
                          onPressed: () => WoltModalSheet.show<void>(
                            context: context,
                            pageListBuilder: (modalSheetContext) {
                              return [
                                WoltModalSheetPage(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                                  child: SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.8,
                                    child: AddTokenView(
                                      missionExpenseUlid: missionExpense.ulid,
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ).then(
                            (_) {
                              if (context.mounted) {
                                context
                                    .read<GetMissionExpenseCubit>()
                                    .getMissionExpense(
                                      missionUlid: missionUlid,
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(l10n.item)),
                          DataColumn(label: Text(l10n.figure)),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.amountReceived)),
                              DataCell(
                                Text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.amountReceived),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.amountSpent)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.amountSpent),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.balance)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.balance),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.tokenAmount)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.tokenAmount),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.refundCharge)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.refundCharge),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.amountToRefund)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.amountToRefund),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.refundedAmount)),
                              DataCell(
                                _text(
                                  NumberFormat.currency(
                                    locale: 'en_KE',
                                    symbol: 'KES ',
                                  ).format(missionExpense.amountRefunded),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(l10n.fullyRefunded)),
                              DataCell(
                                Text(
                                  missionExpense.isRefunded
                                      ? l10n.yes
                                      : l10n.no,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // End Navigation Bar
                  const SliverToBoxAdapter(child: Divider()),
                  SliverToBoxAdapter(child: SizedBox(height: 48.h)),
                  SliverToBoxAdapter(
                    child: Text(
                      l10n.breakdown,
                      style: PRFText.theme().displayLarge?.copyWith(
                            color: PRFApp.theme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: DataTable(
                      columns: [
                        DataColumn(label: _text(l10n.item)),
                        DataColumn(label: _text(l10n.unitCostAndQty)),
                        DataColumn(label: _text(l10n.totalCost)),
                      ],
                      rows: missionExpense.expenses
                          .map(
                            (expense) => DataRow(
                              cells: [
                                DataCell(Text(expense.expenseCategory!.name)),
                                DataCell(
                                  _text(
                                    '${NumberFormat.currency(
                                      locale: 'en_KE',
                                      symbol: '',
                                      decimalDigits: 0,
                                    ).format(expense.unitCost)} x'
                                    ' ${expense.quantity}',
                                  ),
                                ),
                                DataCell(
                                  _text(
                                    '${NumberFormat.currency(
                                      locale: 'en_KE',
                                      symbol: '',
                                      decimalDigits: 0,
                                    ).format(expense.lineTotal)} \n'
                                    '(${NumberFormat.currency(
                                      decimalDigits: 0,
                                      locale: 'en_KE',
                                      symbol: '',
                                    ).format(expense.charge)})',
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Widget _text(String text) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
  );
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.expense,
    super.key,
  });

  final PRFExpense expense;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [
        SaturateEffect(),
      ],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 60.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(expense.unitCost),
                  style: PRFText.theme().displayLarge?.copyWith(
                        color: PRFApp.theme().kPrimaryColorV2,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16.h),
                Text(expense.confirmationMessage.toString()),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(expense.expenseCategory!.name),
                    Text(
                      '${DateFormat.yMMMMEEEEd().format(expense.createdAt)} '
                      '${DateFormat.jm().format(expense.createdAt)}',
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
