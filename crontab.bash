# Market-Data
########################################################################################################################
# get market data from websites
*/5 *          * * *     cd /home/pnl/git/risk_system/scripts/; bash crontab_gen_trade_sym_list.sh
00  0          * * *     cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/; python get_fx_from_website.py
00  8          * * *     cd /home/pnl/git/risk_system/scripts/; bash crontab_update_fx_folder.sh
31 7,10,12,15  * * 1-6   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_szse.sh
04 06          * * 1-6   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_us_stocks.sh
15 11-16       * * 1-5   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_hk_stocks.sh
40 11,16       * * 1-5   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_hkex_options.sh

# get market data from bloomberg
# 31 09,16       * * 1-5   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_ins_itrd_bar.sh
# 59 11,14       * * 1-5   cd /home/pnl/git/risk_system/scripts/; bash crontab_get_ins_itrd_bar.sh

# manual operation send market date extract to someone to help extract price
15 09     * * 1-5   cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/ ; python conv_file_to_blmg_sym trade_sym_list_forbbg.txt > bbg_name.csv; cd /home/pnl/git/risk_system/pnl_calc/send_pnl/; python send_mkt_to_sb.py anthony.poon@cashalgo.com celine.fung@cashalgo.com  ivan.chak@cashalgo.com
31 11,16  * * 1-5   cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/ ; python conv_file_to_blmg_sym trade_sym_list_forbbg.txt > bbg_name.csv; cd /home/pnl/git/risk_system/pnl_calc/send_pnl/; python send_mkt_to_sb.py anthony.poon@cashalgo.com celine.fung@cashalgo.com  ivan.chak@cashalgo.com


# PnL calculation
########################################################################################################################
# 5 mins cutofftime & 4pm change cutofftime for pnl
05 *                * * *        cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime.sh
55 15               * * 1-5      cd /home/pnl/git/risk_system/pnl_calc/; for i in cutofftime_*.csv; do cat /dev/null > $i; done

# 15mins send pnl
0,15,45 09          * * 1-5      cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_full_snapshot.sh sunny.yan@cashalgo.com ivan.chak@cashalgo.com celine.fung@cashalgo.com grace.fan@cashalgo.com ; bash crontab_send_cfmn_of_a_team.sh AST calvin.tsai@cashalgo.com; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh

5-59/15 10-11,14-15 * * 1-5      cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_full_snapshot.sh sunny.yan@cashalgo.com ivan.chak@cashalgo.com celine.fung@cashalgo.com grace.fan@cashalgo.com; bash crontab_send_cfmn_of_a_team.sh AST calvin.tsai@cashalgo.com; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh

5-59/15 16          * * 1-5      cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh  ; sleep 2; bash crontab_send_full_snapshot.sh sunny.yan@cashalgo.com ivan.chak@cashalgo.com celine.fung@cashalgo.com grace.fan@cashalgo.com ; bash crontab_send_cfmn_of_a_team.sh AST calvin.tsai@cashalgo.com; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh


# formal pnl at 9& 12 & 5pm to team and management
30 08               * * 6        cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; bash crontab_send_full_snapshot.sh alfred.ma@cashalgo.com celine.fung@cashalgo.com  ivan.chak@cashalgo.com

#35 09               * * 1-5     cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_summary.sh alfred.ma@cashalgo.com eugene.law@cashalgo.com angela.wong@cashalgo.com ; bash crontab_send_full_snapshot.sh alfred.ma@cashalgo.com celine.fung@cashalgo.com  ivan.chak@cashalgo.com

#05 12               * * 1-5     cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_full.sh celine.fung@cashalgo.com sunny.yan@cashalgo.com ivan.chak@cashalgo.com grace.fan@cashalgo.com ; bash crontab_send_cfmn_of_a_team.sh CJI caesar.she@cashalgo.com isaac.li@cashalgo.com jayden.dai@cashalgo.com; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh

#00 17               * * 1-5     cd /home/pnl/git/risk_system/pnl_calc/; bash calc_pnl_weekly.sh; cd /home/pnl/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh; sleep 2; bash crontab_send_full.sh celine.fung@cashalgo.com sunny.yan@cashalgo.com ivan.chak@cashalgo.com grace.fan@cashalgo.com ; cd /home/pnl/git/risk_system/pnl_calc/send_pnl/; python send_pnl_confirmation_for_real.py f; cd /home/pnl/git/risk_system/scripts/; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh


# sanity check
########################################################################################################################
31   07,10,12,15 * * 1-6   cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/; python auto_insert_204001_into_market_data.py
*    08-17       * * 1-5   cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/; python auto_insert_TR_sym_into_pdt.py > /dev/null 2>&1
*/15 08-17       * * 1-5   cd /home/pnl/git/risk_system/scripts/; bash crontab_send_sanity_check.sh celine.fung@cashalgo.com  ivan.chak@cashalgo.com

# statement: copy statement from 138 and then extract close price to risdb2.market_data_stmt & riskdb2.snapshot_cpnl
08 *             * * *     cd /home/pnl/git/risk_system/pnl_calc/stmt_closing_px_extractor/; bash cp_stmt_from_138.sh
00 17            * * *     cd /home/pnl/git/risk_system/pnl_calc/stmt_closing_px_extractor/; bash update_market_data_stmt_daily.sh
10 01,23         * * *     cd /home/pnl/git/risk_system/pnl_calc/stmt_closing_px_extractor/; python insert_account_value.py ` date --date="-2 day" +\%Y\%m\%d ` rawStmtFiles/; python insert_account_value.py ` date --date="-1 day" +\%Y\%m\%d ` rawStmtFiles/; python insert_account_value.py ` date +\%Y\%m\%d ` rawStmtFiles/ ; python insert_account_value.py ` date --date="-10 day" +\%Y\%m\%d ` rawStmtFiles/


# upload for snapshot openpos
20 01            * * *     cd /home/pnl/git/risk_system/pnl_calc/; bash calc_pnl_weekly.sh


# backup
########################################################################################################################
01 01            * * *     rm -rf /tmp/rf_backup_pnl/*
30 05            * * *     cd /home/pnl/git/risk_system/scripts/; bash crontab_cleanolddata.sh
05 05            * * 7     mysqldump -hlocalhost -uroot -proot riskdb2 --ignore-table=riskdb2.tr > /home/pnl/riskdb2_snapshot_bkup/riskdb2_` date +\%Y\%m\%d_\%H\%M\%S `.sql
35 06            * * 7     rm -f ` find /home/pnl/riskdb2_snapshot_bkup/ | sort | head -n -100 ` ; xz /home/pnl/riskdb2_snapshot_bkup/riskdb2_*.sql
31 03            * * *     xz /home/pnl/git/risk_system/pnl_calc/pnl_bkup/*
32 03            * * *     cd /home/pnl/git/risk_system/pnl_calc/market_data_downloader/data/backup_data/; rm -f ` ls market_price_indep_src_2* | sort | head -n -200 `; rm -f ` ls market_price_indep_src_cumulative_2* | sort | head -n -200 `

# backup REST content(check team trades)
0 6,9,12,17,23   * * 1-5   cd /home/pnl/rest_content_bkup; bash get_rest_content.sh
0 6              * * 1-5   cd /home/pnl/rest_content_bkup/data; ls | sort -n | head -n -300 | xargs rm


# quick rerun after problem
