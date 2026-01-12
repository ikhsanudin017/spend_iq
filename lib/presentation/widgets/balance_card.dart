import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/currency.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/account.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.accounts,
  });

  final double balance;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = ResponsiveUtils.screenWidth(context) < 480;
    final padding = isSmallScreen ? 20.0 : 24.0;
    final borderRadius = ResponsiveUtils.borderRadius(context, base: 28);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(70),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 44 : 48,
                height: isSmallScreen ? 44 : 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: isSmallScreen ? 24 : 26,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Saldo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallScreen 
                            ? ResponsiveUtils.fontSize(context, 14) 
                            : null,
                      ),
                    ),
                    Text(
                      accounts.isEmpty
                          ? 'Belum ada akun'
                          : '${accounts.length} akun terhubung',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(210),
                        height: 1.2,
                        fontSize: isSmallScreen 
                            ? ResponsiveUtils.fontSize(context, 12) 
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 18,
                    vertical: isSmallScreen ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    CurrencyUtils.compact(balance),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: isSmallScreen 
                          ? ResponsiveUtils.fontSize(context, 12) 
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
          Text(
            CurrencyUtils.format(balance),
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.4,
              fontSize: isSmallScreen 
                  ? ResponsiveUtils.fontSize(context, 28) 
                  : null,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
          Text(
            'Prediksi cash runway 3 bulan - ${CurrencyUtils.format(balance / 3)} per bulan',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(220),
              height: 1.3,
              fontSize: isSmallScreen 
                  ? ResponsiveUtils.fontSize(context, 13) 
                  : null,
            ),
          ),
          if (accounts.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.spacing(context, base: 20)),
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(context, base: 20),
                ),
              ),
              child: Column(
                children: [
                  ...accounts.map(
                    (account) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(context, base: 8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 40 : 44,
                            height: isSmallScreen ? 40 : 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(84),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                account.bankName.characters.first.toUpperCase(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: isSmallScreen 
                                      ? ResponsiveUtils.fontSize(context, 14) 
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.bankName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen 
                                        ? ResponsiveUtils.fontSize(context, 13) 
                                        : null,
                                  ),
                                ),
                                Text(
                                  account.masked,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withAlpha(210),
                                    height: 1.2,
                                    fontSize: isSmallScreen 
                                        ? ResponsiveUtils.fontSize(context, 11) 
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Text(
                              CurrencyUtils.format(account.balance),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen 
                                    ? ResponsiveUtils.fontSize(context, 13) 
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
