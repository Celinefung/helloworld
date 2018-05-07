# Intro
- There are **three crontab job** needed to be aware because it is sent to Management, uncomment in cronjob when bloomberg is dead, see **Time Set in PNL report**
- Normally if bloomberg monthly limit is not exceed, the crontab job is set to be automatic; if not, do **Manual Operation for market price checking** some checking procedures to make sure the market price is extracted before run manually
 
# Operation Rundown
## Automatic when Bloomberg is working:
- The following cronjob is extracting market price for all symbol, the script is designed to get intraday data, eg. china market end at 11:30, 15:00 ; hk market 12:00, 16:30; K200 specific end at 14:45
- The **symbol** is all in file : *$HOME/git/risk_system/pnl_calc/market_data_downloader/trade_sym_list_forbbg.txt*
- **output**: *$HOME/git/risk_system/pnl_calc/market_data_downloader/itrd_bar_output.csv*
- **crontab_get_ins_itrd_bar.sh** is extract PX_LAST in bloomberg
    
    ```
    30 09,16  * * 1-5     cd $HOME/git/risk_system/scripts/; bash crontab_get_ins_itrd_bar.sh
    00 12,15  * * 1-5     cd $HOME/git/risk_system/scripts/; bash crontab_get_ins_itrd_bar.sh
    ```
    
## Manual when Bloomberg is not working:
1. Check email of Sanity Check 
   * Two information showed: new symbol not in riskdb2.products + open position symbol not in riskdb2.market_data
   * email script `cd $HOME/git/risk_system/scripts/; bash crontab_send_sanity_check.sh @recepient`
   * logic script in `$HOME/git/risk_system/pnl_calc/market_data_downloader/check_products_tbl.py`
   * Find out new symbol and then insert into **riskdb2.products**, eg.
   
     ```
     Number of traded symbols that are NOT specified in riskdb2.products = 1
     SMART_IJH
     ```
   * Find out the open position symbol and then insert into **riskdb2.market_data**, eg.ICEIPE_MME Jun18: open position 2
   
     ```
     Number of traded symbols that are NOT specified in riskdb2.market_data = 1
     ICEIPE_MME Jun18_2
      ```
      
2. If wanto to ask intern or someone to extract and then send `all traded symbol` file and converted bbg name file by email
   * $HOME/git/risk_system/pnl_calc/market_data_downloader/trade_sym_list_forbbg.txt
   
     ```
     cd $HOME/git/risk_system/pnl_calc/market_data_downloader/ ; 
     python conv_file_to_blmg_sym trade_sym_list_forbbg.txt > bbg_name.txt; 
     cd $HOME/git/risk_system/pnl_calc/send_pnl/; python send_mkt_to_sb.py XXX@cashalgo.com XXX@cashalgo.com
     ```
        
3.  Manual Find Market Price and then Insert into riskdb2.market_data table
    * cd ~/git/risk_system/send_warning/import_market_data.csv
    * maunal correct price and paste to `import_market_data.csv`
    * python import_market_data.py


## Time Set in PNL report
- official report
    - Morning 8-9am : Send summary report
    - Noon 12pm     : Send teams detailed pnl + summary report
    - Afternoon 5pm : Send teams detailed pnl + summary report
    
- cronjob is commented when bloomberg is dead, manual check the previous process of market data and then run the following:
```
35   9      * * 1-5   cd $HOME/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_summary.sh alfred.ma@cashalgo.com eugene.law@cashalgo.com angela.wong@cashalgo.com ; bash crontab_send_full_snapshot.sh alfred.ma@cashalgo.com celine.fung@cashalgo.com  ivan.chak@cashalgo.com
17   12     * * 1-5   cd $HOME/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime; sleep 2; bash crontab_send_full.sh celine.fung@cashalgo.com sunny.yan@cashalgo.com ivan.chak@cashalgo.com grace.fan@cashalgo.com ; bash crontab_send_cfmn_of_a_team.sh CJI caesar.she@cashalgo.com isaac.li@cashalgo.com jayden.dai@cashalgo.com ; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh
0    17     * * 1-5   cd $HOME/git/risk_system/pnl_calc/; bash calc_pnl_weekly.sh; cd $HOME/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh ; sleep 2; bash crontab_send_full.sh celine.fung@cashalgo.com sunny.yan@cashalgo.com ivan.chak@cashalgo.com grace.fan@cashalgo.com  ; bash crontab_persist_pnl.sh; bash crontab_send_mtm_px.sh ; sleep 10 ; cd $HOME/git/risk_system/pnl_calc/send_pnl/; python send_pnl_confirmation_for_real.py f
```

# Explanation
- there are three way to explain the program:
1. Market-data
2. PnL calculation
3. Cross checking/Error checking

## Market data distribution
- system get symbol every **5 mins** in 
```
cd $HOME/git/risk_system/scripts/; bash crontab_gen_trade_sym_list.sh
```

- generate three file
```
trade_sym_list_forbbg.txt : bloomberg extraction see above auto and manual way
trade_sym_list_hkstocks.txt : 2800 symbol -> extract from website
trade_sym_list_usstocks.txt : SMART symbol -> extract from website
```

## Automatic extraction from website

- the following script are all extracted from website and then upload to database `riskdb2.market_data`

- **realtime fx rate** in pnl is generated from yahoo finance:
```
cd $HOME/git/risk_system/pnl_calc/market_data_downloader/; python get_fx_from_website.py
cd $HOME/git/risk_system/scripts/; bash crontab_update_fx_folder.sh
```

- **SMART, 2800** are generated from yahoo finance:
```
cd $HOME/git/risk_system/scripts/; bash crontab_get_us_stocks.sh
cd $HOME/git/risk_system/scripts/; bash crontab_get_hk_stocks.sh
```

- **SZE, HKEx options** Price are all extracted from szes & hkex website:
```
cd $HOME/git/risk_system/scripts/; bash crontab_get_szse.sh
cd $HOME/git/risk_system/scripts/; bash crontab_get_hkex_options.sh
```

## Auto Insert Market Data
- The system is designed auto insert new symbol traded price into ```riskdb2.market_data``` table 

- Special symbol for non future,options,stock : `SSE, 2040XX`
```
cd $HOME/git/risk_system/pnl_calc/market_data_downloader/; python auto_insert_204001_into_market_data.py
if there are more symbol to add, add symbol and price to dict `acc_px = {'204001':'100.001','204007':'100.005','204014':'100.01'}`
```

- CDOI traded many new symbol of warrant, so auto insert into riskdb2.products table  
```
cd $HOME/git/risk_system/pnl_calc/market_data_downloader/; python auto_insert_TR_sym_into_pdt.py
```     


## Explanation of Program Workflow
1.  Generate cutofftime file : *$HOME/git/risk_system/pnl_calc/cutofftime.csv*
    * cutoff time 3pm
        - `cd $HOME/git/risk_system/scripts/; bash crontab_getcutofftime.sh`
    * cutoff time 4:30pm
        - `cd $HOME/git/risk_system/pnl_calc/; for i in cutofftime_*.csv; do cat /dev/null > $i; done`
   
2.  Pnl main program : *$HOME/git/risk_system/pnl_calc/pnl_output.csv*
    * `cd $HOME/git/risk_system/scripts/; bash crontab_getcutofftime_calc_pnl.sh earlierintradaycutofftime`
    * output: each date pnl : *$HOME/git/risk_system/pnl_calc/pnl_output/YYYY-MM-DD/*
    
3.  Send pnl email python : *$HOME/git/risk_system/pnl_calc/send_pnl/*
    * only summary report
        - `bash crontab_send_summary.sh` @recepient
    * each team breakdown email + summary report ( they are just the same )
        - Subject of email include snapshot: `bash crontab_send_full_snapshot.sh` @recepient
        - Subject of email include confirmation: `bash crontab_send_full.sh` @recepient

## Error when send Crontab job 
- Error: program didn't generate report in *$HOME/git/risk_system/pnl_calc/pnl_output/YYYY-MM-DD/*
- Run `$HOME/git/risk_system/pnl_calc/calc_pnl.sh`
  - 1.Log contain `key not found: exch,symbol `
        * Insert new symbol to riskdb2.products
  - 2.Log whether contain `MTM price`
        * Add that symbol today market price , still cannot , then insert yesterday market price to riskdb2.market_data

## Checking
- Crontab job checking eg.

```
192.168.91.243 (production) pnl $ ps ux | grep risk_officer_server.py
pnl  7713  12:08  0:01  python risk_officer_server.py --send_sanity_check_report sunny.yan@cashalgo.com
```

- Mysql Checking

```
show processlist
```

# Others
## Pnl add new broker or account
- add new account in `/home/pn/git/risk_system/pnl_calc/chk_stmt_files/checkList.txt`

    
## Riskdb2.snapshot_cpnl & Riskdb2.market_data_stmt Daily Update
- Path: *$HOME/git/risk_system/pnl_calc/stmt_closing_px_extractor/*
1. rawStmtFiles is all broker statements storage directory:
    * `cd $HOME/git/risk_system/pnl_calc/stmt_closing_px_extractor/; bash cp_stmt_from_138.sh`
2. Extract statement account value into ```riskdb2.snapshot_cpnl``` : 
    * `cd $HOME/git/risk_system/pnl_calc/stmt_closing_px_extractor/; bash update_market_data_stmt_daily.sh`
3. Extract each traded symbol close price from statement to ```riskdb2.market_data_stmt``` :
    * `cd $HOME/git/risk_system/pnl_calc/stmt_closing_px_extractor/; python insert_account_value.py '\%Y\%m\%d' rawStmtFiles/`
    
    
## For Risk Officer 
- if team claim they input the trades but didnt show in database, there is backup REST content
- their server list is in : *$HOME/rest_content_bkup/url_list.csv*
- (check team trades): 
```
$HOME/rest_content_bkup/data/CGT_41_YYYYMMDD_HHMM.gz
```
- there maybe reason that server is down 
